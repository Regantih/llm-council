#!/bin/bash

# Frictionless Start Script for Personal LLM Council

echo "=================================================="
echo "   Starting Your Personal LLM Council"
echo "=================================================="

# 1. Check for .env file
if [ ! -f .env ]; then
    echo "⚠️  No .env file found!"
    echo "Creating one for you..."
    echo "OPENROUTER_API_KEY=your_key_here" > .env
    echo ""
    echo "❌ PLEASE EDIT .env AND ADD YOUR OPENROUTER API KEY."
    echo "Then run this script again."
    exit 1
fi

# 2. Check for uv (Python package manager)
if ! command -v uv &> /dev/null; then
    echo "📦 'uv' not found. Installing via official standalone script..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    
    # Add to path for this session
    export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"
    
    if ! command -v uv &> /dev/null; then
        echo "❌ Failed to install uv automatically. Please install it manually: curl -LsSf https://astral.sh/uv/install.sh | sh"
        exit 1
    fi
fi

# 3. separate terminals? No, we use background processes like start.sh
echo "🔄 Syncing Python dependencies..."
uv sync

# 4. Check Frontend dependencies
if [ ! -d "frontend/node_modules" ]; then
    echo "📦 Installing Frontend dependencies (this happens once)..."
    cd frontend
    npm install
    cd ..
fi

# 5. Launch
echo "🚀 Launching Council..."
./start.sh
