import express from "express";
import { jwtVerify, createRemoteJWKSet } from "jose";
import { readFileSync } from "fs";

const app = express();
const PORT = process.env.PORT || 8081;

app.get("/hello", (_req, res) => {
  res.json({ message: "Hello from App Server (Node.js)!" });
});

app.get("/student", (_req, res) => {
  try {
    const data = readFileSync("./students.json", "utf8");
    const students = JSON.parse(data);
    res.json({
      success: true,
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

app.listen(PORT, "0.0.0.0", () =>
  console.log(`✅ Node.js App running on port ${PORT}`)
);
