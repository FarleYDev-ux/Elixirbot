#!/usr/bin/env bash
set -o errexit

echo "📦 Instalando dependências Elixir..."
mix deps.get --only prod

echo "🔨 Compilando projeto..."
MIX_ENV=prod mix compile

echo "📦 Buildando release..."
MIX_ENV=prod mix release --overwrite

echo "✅ Build concluído!"
