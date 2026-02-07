#!/bin/bash

# Frictionless Start Script for Personal LLM Council

echo "=================================================="
echo "   Starting Your Personal LLM Council"
echo "=================================================="

# 1. Check for .env file or Environment Variable
if [ -z "$OPENROUTER_API_KEY" ]; then
    if [ -f .env ]; then
        export $(cat .env | xargs)
    fi

    if [ -z "$OPENROUTER_API_KEY" ]; then
        echo "⚠️  No .env file found and OPENROUTER_API_KEY not set!"
        echo "Creating .env template for you..."
        echo "OPENROUTER_API_KEY=your_key_here" > .env
        echo ""
        echo "❌ PLEASE EDIT .env AND ADD YOUR OPENROUTER API KEY."
        echo "   OR set the OPENROUTER_API_KEY environment variable (e.g. in Codespaces Secrets)."
        echo "Then run this script again."
        exit 1
    fi
else
    echo "✅ OPENROUTER_API_KEY found in environment."
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
