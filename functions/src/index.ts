import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();

const CLOUDFLARE_API_URL = "https://api.cloudflare.com/client/v4";

async function fetchCloudflare(accountId: string, token: string, endpoint: string, method: string, body?: any) {
    const res = await fetch(`${CLOUDFLARE_API_URL}/accounts/${accountId}/stream/${endpoint}`, {
        method,
        headers: {
            "Authorization": `Bearer ${token}`,
            "Content-Type": "application/json"
        },
        body: body ? JSON.stringify(body) : undefined
    });
    
    if (!res.ok) {
        const errorText = await res.text();
        throw new Error(`Cloudflare API error: ${res.status} ${errorText}`);
    }
    return res.json();
}

export const createLiveStream = functions.runWith({ secrets: ["CLOUDFLARE_ACCOUNT_ID", "CLOUDFLARE_API_TOKEN"] })
.https.onCall(async (data, context) => {
    if (!context.auth) throw new functions.https.HttpsError("unauthenticated", "Must be logged in.");
    
    const accountId = process.env.CLOUDFLARE_ACCOUNT_ID;
    const token = process.env.CLOUDFLARE_API_TOKEN;
    if (!accountId || !token) throw new functions.https.HttpsError("internal", "Cloudflare secrets missing.");

    const { title, category, privacy } = data;
    
    // 1. Create Live Input in Cloudflare Stream
    const cfData = await fetchCloudflare(accountId, token, "live_inputs", "POST", {
        meta: { name: title, author: context.auth.uid },
        recording: { mode: "automatic" }
    });
    
    const input = cfData.result;
    
    // 2. Create Firestore Document
    const db = admin.firestore();
    const liveRef = db.collection("lives").doc();
    
    // Assuming user data is in users/{uid}
    const userDoc = await db.collection("users").doc(context.auth.uid).get();
    const userData = userDoc.data() || {};
    
    await liveRef.set({
        id: liveRef.id,
        userId: context.auth.uid,
        userName: userData.name || "Unknown",
        userAvatar: userData.avatar || "",
        title: title || "Untitled Stream",
        category: category || "Chatting",
        privacy: privacy || "public",
        status: "preparing",
        viewerCount: 0,
        peakViewers: 0,
        likeCount: 0,
        createdAt: admin.firestore.FieldValue.serverTimestamp()
    });
    
    // 3. Store secrets in subcollection
    await liveRef.collection("private").doc("ingest").set({
        inputUid: input.uid,
        rtmpsUrl: input.rtmps.url,
        streamKey: input.rtmps.streamKey
    });
    
    return {
        liveId: liveRef.id,
        rtmpsUrl: input.rtmps.url,
        streamKey: input.rtmps.streamKey
    };
});

export const confirmLiveStream = functions.runWith({ secrets: ["CLOUDFLARE_ACCOUNT_ID", "CLOUDFLARE_API_TOKEN"] })
.https.onCall(async (data, context) => {
    if (!context.auth) throw new functions.https.HttpsError("unauthenticated", "Must be logged in.");
    
    const { liveId } = data;
    const db = admin.firestore();
    
    const liveDoc = await db.collection("lives").doc(liveId).get();
    if (!liveDoc.exists) throw new functions.https.HttpsError("not-found", "Stream not found");
    if (liveDoc.data()?.userId !== context.auth.uid) throw new functions.https.HttpsError("permission-denied", "Not yours");
    
    const ingestDoc = await db.collection("lives").doc(liveId).collection("private").doc("ingest").get();
    if (!ingestDoc.exists) throw new functions.https.HttpsError("internal", "Ingest info missing");
    
    const inputUid = ingestDoc.data()?.inputUid;
    
    const accountId = process.env.CLOUDFLARE_ACCOUNT_ID!;
    const token = process.env.CLOUDFLARE_API_TOKEN!;
    
    const cfData = await fetchCloudflare(accountId, token, `live_inputs/${inputUid}`, "GET");
    const input = cfData.result;
    
    // Allow optimistic confirm or strict confirm based on CF state
    const playbackUrl = `https://customer-${accountId}.cloudflarestream.com/${input.uid}/manifest/video.m3u8`;
    
    await liveDoc.ref.update({
        status: "live",
        startedAt: admin.firestore.FieldValue.serverTimestamp(),
        playbackUrl: playbackUrl
    });
    
    return { success: true, playbackUrl };
});

export const endLiveStream = functions.https.onCall(async (data, context) => {
    if (!context.auth) throw new functions.https.HttpsError("unauthenticated", "Must be logged in.");
    
    const { liveId } = data;
    const db = admin.firestore();
    
    const liveDoc = await db.collection("lives").doc(liveId).get();
    if (!liveDoc.exists) return { success: false };
    if (liveDoc.data()?.userId !== context.auth.uid) throw new functions.https.HttpsError("permission-denied", "Not yours");
    
    await liveDoc.ref.update({
        status: "ended",
        endedAt: admin.firestore.FieldValue.serverTimestamp()
    });
    
    return { success: true };
});

// Viewer presence triggers
export const onViewerJoin = functions.firestore
.document('lives/{liveId}/viewers/{userId}')
.onCreate(async (snap, context) => {
    const liveRef = admin.firestore().collection('lives').doc(context.params.liveId);
    
    await admin.firestore().runTransaction(async (t) => {
        const doc = await t.get(liveRef);
        if (doc.exists) {
            const data = doc.data()!;
            const newCount = (data.viewerCount || 0) + 1;
            const currentPeak = data.peakViewers || 0;
            t.update(liveRef, {
                viewerCount: newCount,
                peakViewers: Math.max(newCount, currentPeak)
            });
        }
    });
});

export const onViewerLeave = functions.firestore
.document('lives/{liveId}/viewers/{userId}')
.onDelete(async (snap, context) => {
    const liveRef = admin.firestore().collection('lives').doc(context.params.liveId);
    await liveRef.update({
        viewerCount: admin.firestore.FieldValue.increment(-1)
    });
});
