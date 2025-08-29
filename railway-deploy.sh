#!/bin/bash

# Railway deployment script for Judge0 with GCC 13 and C++23 support

echo "🚀 Deploying Judge0 with GCC 13 and C++23 support to Railway..."

# Build the custom Judge0 image
echo "📦 Building custom Judge0 image..."
docker build -t judge0-cpp23 .

# Tag for Railway
docker tag judge0-cpp23 railway.app/judge0-cpp23

# Deploy to Railway
echo "🚂 Deploying to Railway..."
railway up

echo "✅ Deployment complete!"
echo "🌐 Your Judge0 instance should be available at your Railway URL"
echo "📝 Update your BeQuant .env.local with:"
echo "   JUDGE0_SELF_HOSTED_URL=https://your-railway-app.railway.app"
