import express from "express";
import { jwtVerify, createRemoteJWKSet } from "jose";
import { readFileSync } from "fs";
import mysql from "mysql2/promise";

const app = express();
const PORT = process.env.PORT || 8081;

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

app.listen(PORT, "0.0.0.0", () =>
  console.log(`✅ Node.js App running on port ${PORT}`)
);
