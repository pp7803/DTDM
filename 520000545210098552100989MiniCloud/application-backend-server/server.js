import express from "express";
import { jwtVerify, createRemoteJWKSet } from "jose";
import { readFileSync } from "fs";
import mysql from "mysql2/promise";

const app = express();
const PORT = process.env.PORT || 8081;

// Keycloak configuration - Support multiple issuer URLs
const ALLOWED_ISSUERS = [
  "http://localhost:8081/realms/realm_520000545210098552100989",
  "http://authentication-identity-server:8080/realms/realm_520000545210098552100989",
];

// Map external issuer to internal JWKS endpoint
const ISSUER_JWKS_MAP = {
  "http://localhost:8081/realms/realm_520000545210098552100989":
    "http://authentication-identity-server:8080/realms/realm_520000545210098552100989/protocol/openid-connect/certs",
  "http://authentication-identity-server:8080/realms/realm_520000545210098552100989":
    "http://authentication-identity-server:8080/realms/realm_520000545210098552100989/protocol/openid-connect/certs",
};

// Cache for JWKS by issuer
const jwksCache = new Map();

function getJWKS(issuer) {
  if (!jwksCache.has(issuer)) {
    // Use mapped JWKS URI for external issuers
    const jwksUri =
      ISSUER_JWKS_MAP[issuer] || `${issuer}/protocol/openid-connect/certs`;
    console.log(`Loading JWKS from: ${jwksUri}`);
    jwksCache.set(issuer, createRemoteJWKSet(new URL(jwksUri)));
  }
  return jwksCache.get(issuer);
}

// JWT verification middleware
async function verifyToken(req, res, next) {
  try {
    const authHeader = req.headers.authorization;

    if (!authHeader || !authHeader.startsWith("Bearer ")) {
      return res.status(401).json({
        error: "Missing Bearer token",
        message: "Authorization header must be in format: Bearer <token>",
      });
    }

    const token = authHeader.substring(7); // Remove "Bearer " prefix

    // Decode token to get issuer (without verification first)
    const parts = token.split(".");
    if (parts.length !== 3) {
      throw new Error("Invalid JWT format");
    }

    const payload = JSON.parse(Buffer.from(parts[1], "base64").toString());
    const tokenIssuer = payload.iss;

    // Check if issuer is allowed
    if (!ALLOWED_ISSUERS.includes(tokenIssuer)) {
      throw new Error(`Issuer ${tokenIssuer} not allowed`);
    }

    // Get JWKS for the token's issuer
    const JWKS = getJWKS(tokenIssuer);

    // Verify JWT with Keycloak's public key
    // Note: Skip audience validation as Keycloak tokens may have "account" or client_id as audience
    const { payload: verifiedPayload } = await jwtVerify(token, JWKS, {
      issuer: tokenIssuer,
      // Don't validate audience - accept any from Keycloak
    });

    // Attach user info to request
    req.user = {
      sub: verifiedPayload.sub,
      username: verifiedPayload.preferred_username,
      email: verifiedPayload.email,
      name: verifiedPayload.name,
      issuer: tokenIssuer,
    };

    next();
  } catch (error) {
    console.error("JWT verification failed:", error.message);
    return res.status(401).json({
      error: "Invalid token",
      message: error.message,
    });
  }
}

// Create MySQL connection pool
const pool = mysql.createPool({
  host: process.env.DB_HOST || "relational-database-server",
  user: process.env.DB_USER || "root",
  password: process.env.DB_PASSWORD || "root",
  database: process.env.DB_NAME || "studentdb",
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0,
});

app.get("/hello", (_req, res) => {
  res.json({ message: "Hello from App Server (Node.js)!" });
});

app.get("/student", (_req, res) => {
  try {
    const data = readFileSync("./students.json", "utf8");
    const students = JSON.parse(data);
    res.json({
      success: true,
      source: "json-file",
      count: students.length,
      data: students,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: "Failed to read student data",
      message: error.message,
    });
  }
});

app.get("/students/db", async (_req, res) => {
  try {
    const [rows] = await pool.query("SELECT * FROM students ORDER BY gpa DESC");
    res.json({
      success: true,
      source: "database",
      count: rows.length,
      data: rows,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: "Failed to query database",
      message: error.message,
    });
  }
});

// Protected endpoint - requires valid JWT token
app.get("/secure", verifyToken, (req, res) => {
  res.json({
    message: "Secure endpoint accessed successfully! 🔐",
    user: req.user.username,
    email: req.user.email,
    name: req.user.name,
    authenticated: true,
    timestamp: new Date().toISOString(),
  });
});

app.listen(PORT, "0.0.0.0", () =>
  console.log(`✅ Node.js App running on port ${PORT}`)
);
