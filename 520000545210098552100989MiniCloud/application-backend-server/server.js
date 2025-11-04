import express from "express";
import { jwtVerify, createRemoteJWKSet } from "jose";

const app = express();
const PORT = process.env.PORT || 8081;

const ISSUER   = process.env.OIDC_ISSUER   || "http://authentication-identity-server:8080/realms/master";
const AUDIENCE = process.env.OIDC_AUDIENCE || "myapp";
const JWKS_URI = `${ISSUER}/protocol/openid-connect/certs`;
const JWKS = createRemoteJWKSet(new URL(JWKS_URI));

app.get("/hello", (_req, res) => {
  res.json({ message: "Hello from App Server (Node.js)!" });
});

app.get("/secure", async (req, res) => {
  const auth = req.headers["authorization"] || "";
  if (!auth.startsWith("Bearer ")) return res.status(401).json({ error: "Missing Bearer token" });
  const token = auth.slice("Bearer ".length);
  try {
    const { payload } = await jwtVerify(token, JWKS, { issuer: ISSUER, audience: AUDIENCE });
    res.json({ message: "Secure OK", user: payload.preferred_username });
  } catch (e) {
    res.status(401).json({ error: String(e) });
  }
});

app.listen(PORT, "0.0.0.0", () => console.log(`✅ Node.js App running on port ${PORT}`));
