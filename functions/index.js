const functions = require("firebase-functions/v2");
const { onRequest } = require("firebase-functions/v2/https");
const admin = require("firebase-admin");
const Stripe = require("stripe");

admin.initializeApp();

const STRIPE_SECRET_KEY = functions.params.defineSecret("STRIPE_SECRET_KEY");
const STRIPE_WEBHOOK_SECRET = functions.params.defineSecret("STRIPE_WEBHOOK_SECRET");

exports.createCheckout = onRequest(
  { cors: true, secrets: [STRIPE_SECRET_KEY] },
  async (req, res) => {
    try {
      const stripe = new Stripe(STRIPE_SECRET_KEY.value());
      const { type, listingId, adId, userId, plan } = req.body || {};

      let amount = 0;
      let name = "PrimeX Payment";

      if (type === "listing_boost") {
        if (!listingId) return res.status(400).json({ error: "Missing listingId" });
        if (plan === "boost_15") {
          amount = 1499;
          name = "PrimeX Listing Boost - 15 Days";
        } else if (plan === "realtor_vehicle_35") {
          amount = 499;
          name = "PrimeX Realtor / Vehicle Listing - 35 Days";
        } else {
          amount = 799;
          name = "PrimeX Listing Boost - 4 Days";
        }
      }

      if (type === "ad_promotion") {
        if (!adId) return res.status(400).json({ error: "Missing adId" });
        amount = 1999;
        name = "PrimeX Homepage Banner Ad";
      }

      if (type === "primex_pro") {
        if (!userId) return res.status(400).json({ error: "Missing userId" });
        amount = 4999;
        name = "PrimeX Pro Membership";
      }

      if (!amount) return res.status(400).json({ error: "Invalid payment type" });

      const session = await stripe.checkout.sessions.create({
        mode: "payment",
        payment_method_types: ["card", "cashapp", "amazon_pay"],
        line_items: [
          {
            price_data: {
              currency: "usd",
              product_data: { name },
              unit_amount: amount,
            },
            quantity: 1,
          },
        ],
        metadata: {
          type: type || "",
          listingId: listingId || "",
          adId: adId || "",
          userId: userId || "",
          plan: plan || "",
        },
        success_url: "https://primex-e522d.web.app/#/payment-success",
        cancel_url: "https://primex-e522d.web.app/#/payment-cancelled",
      });

      res.json({ url: session.url });
    } catch (e) {
      console.error(e);
      res.status(500).json({ error: e.message });
    }
  }
);

exports.stripeWebhook = onRequest(
  { secrets: [STRIPE_SECRET_KEY, STRIPE_WEBHOOK_SECRET] },
  async (req, res) => {
    const stripe = new Stripe(STRIPE_SECRET_KEY.value());
    const sig = req.headers["stripe-signature"];

    let event;
    try {
      event = stripe.webhooks.constructEvent(req.rawBody, sig, STRIPE_WEBHOOK_SECRET.value());
    } catch (err) {
      console.error("Webhook signature failed:", err.message);
      return res.status(400).send(`Webhook Error: ${err.message}`);
    }

    if (event.type === "checkout.session.completed") {
      const session = event.data.object;
      const md = session.metadata || {};
      const db = admin.firestore();

      if (md.type === "listing_boost" && md.listingId) {
        await db.collection("listings").doc(md.listingId).set({
          paymentStatus: "paid",
          status: "active",
          isBoosted: true,
          boostApproved: true,
          boostPending: false,
          boostType: md.plan || "",
          boostedAt: admin.firestore.FieldValue.serverTimestamp(),
          stripeSessionId: session.id,
        }, { merge: true });
      }

      if (md.type === "ad_promotion" && md.adId) {
        await db.collection("ads_promotions").doc(md.adId).set({
          paymentStatus: "paid",
          status: "active",
          showOnHome: true,
          paid: true,
          paidAt: admin.firestore.FieldValue.serverTimestamp(),
          stripeSessionId: session.id,
        }, { merge: true });
      }

      if (md.type === "primex_pro" && md.userId) {
        await db.collection("users").doc(md.userId).set({
          proActive: true,
          proPlan: "PrimeX Pro",
          proPaidAt: admin.firestore.FieldValue.serverTimestamp(),
          stripeSessionId: session.id,
        }, { merge: true });
      }
    }

    res.status(200).send("ok");
  }
);
