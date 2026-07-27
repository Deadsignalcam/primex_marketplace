const admin = require("firebase-admin");
admin.initializeApp({ projectId: "primex-e522d" });

async function run() {
  const email = "rosariogonzalezrosalind@gmail.com";
  const user = await admin.auth().getUserByEmail(email);

  await admin.firestore().collection("users").doc(user.uid).set({
    uid: user.uid,
    email: email,
    role: "admin",
    isAdmin: true,
    isOwner: true,
    status: "active",
    proActive: true,
    updatedAt: admin.firestore.FieldValue.serverTimestamp()
  }, { merge: true });

  console.log("ADMIN FIXED:", email, user.uid);
}

run().catch((e) => {
  console.error(e);
  process.exit(1);
});
