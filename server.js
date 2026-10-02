const express = require("express");
const path = require("path");

const app = express();
const PORT = 3000;

let requestCount = 0;

// Serve static files
app.use(express.static(path.join(__dirname, "public")));

// Dashboard API
app.get("/api/dashboard", (req, res) => {
    requestCount++;
    res.setHeader("Cache-Control", "no-store, no-cache, must-revalidate, private");

    // Environment variable se padho (Helm se pass karenge)
    const currentEnv = process.env.APP_ENV || "UNKNOWN";

    res.json({
        application: "EKS Microservice",
        version: "2.0.0 (Helm Multi-Env)",
        environment: currentEnv,                    // STAGING or PRODUCTION
        status: "Running",
        docker: "Helm Managed",
        requests: requestCount,
        time: new Date().toLocaleString(),
        services: [
            { name: "Application", status: "Healthy" },
            { name: "API Gateway", status: "Healthy" },
            { name: "EKS Helm Release", status: "Healthy" }
        ]
    });
});

// Health Check
app.get("/api/health", (req, res) => {
    res.json({
        status: "UP",
        message: "Application is healthy and running on EKS via Helm",
        timestamp: new Date().toLocaleString()
    });
});

// Start Server
app.listen(PORT, () => {
    console.log(`🚀 DevOps Dashboard running at http://localhost:${PORT}`);
});