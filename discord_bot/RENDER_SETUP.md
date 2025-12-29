# 🚀 Deploy no Render - Guia Completo

## ✅ Pré-requisitos

1. **Conta no Render** - criar em [render.com](https://render.com)
2. **Discord Bot Token** - de [discord.com/developers](https://discord.com/developers)
3. **GitHub** - fazer push do código (Render puxa de lá)

## 📋 Passo a Passo

### 1️⃣ Preparar Repositório Git

```bash
cd discord_bot
git init
git add .
git commit -m "Discord Bot - Ready for Render"
git branch -M main
git remote add origin https://github.com/seu-usuario/seu-repo.git
git push -u origin main
```

### 2️⃣ Acessar Render Dashboard

1. Vá para [https://dashboard.render.com](https://dashboard.render.com)
2. Clique em **"New +"** → **"Web Service"**

### 3️⃣ Conectar Repositório GitHub

1. Selecione **"Connect repository"**
2. Autorize seu GitHub
3. Escolha o repositório com o bot
4. Clique em **"Connect"**

### 4️⃣ Configurar Web Service

Preencha os campos:

| Campo | Valor |
|-------|-------|
| **Name** | `discord-bot` |
| **Runtime** | `Elixir` (deve detectar automaticamente) |
| **Root Directory** | `discord_bot` ← ⚠️ IMPORTANTE: Como o bot está em subdiretório |
| **Build Command** | `./build.sh` |
| **Start Command** | `_build/prod/rel/discord_bot/bin/discord_bot start` |
| **Environment** | `Production` |
| **Plan** | `Free` (ou pago se quiser sempre ativo) |

### 5️⃣ Adicionar Variáveis de Ambiente

Clique em **"Environment"** e adicione:

```
DISCORD_TOKEN = seu_discord_token_aqui
```

### 6️⃣ Deploy!

Clique em **"Create Web Service"** e espere:
- ⏳ Build vai levar ~2-3 minutos
- 🚀 Bot conecta ao Discord automaticamente
- ✅ Logs aparecem em tempo real

## 🔗 Verificar se está Online

Depois do deploy, seu bot estará online no Discord! Teste com:

- `/ping` - Deve responder com latência e uptime
- `/help` - Mostra todos os comandos

## 📊 Status e Logs

No dashboard Render:
- Clique no seu serviço → **"Logs"**
- Procure por `[info] READY` (bot conectado ✅)
- Erros aparecerão em vermelho

## ⚙️ Configuração Avançada

### Aumentar Memória (se necessário)
- No dashboard, vá para **"Settings"**
- Mude de "Free" para "Starter" ($7/mês) ou superior
- Free pode reiniciar após inatividade

### Builds Frequentes
- Cada `git push` dispara novo build automaticamente
- Pode ser desativado em **"Settings"** → **"Deploy"**

### Monitoramento 24h
Plano Free reinicia após 15 min de inatividade.
Para 24h sempre ligado:
- Upgrade para plano pago ($7+/mês)
- Ou crie um "ping" externo (pingdom.com)

## 🐛 Troubleshooting

### Bot não conecta ao Discord
1. Verifique `DISCORD_TOKEN` nos logs
2. Teste token localmente: `DISCORD_TOKEN=xxx mix run`
3. Regenere token em Discord Developer Portal

### Build falha
1. Verifique `build.sh` está com permissão executável
2. Erro "module not found" = dependência faltando em `mix.exs`
3. Veja logs completos na aba "Logs"

### Comandos não funcionam
1. Bot precisa de permissão no servidor Discord
2. Verifique se bot está no servidor
3. Tente `/help` para confirmar que está respondendo

## 📈 Próximas Melhorias

Depois que estiver rodando:
- [ ] Adicionar mais slash commands
- [ ] Conectar banco de dados PostgreSQL (Render oferece 1 grátis)
- [ ] Setup CI/CD com GitHub Actions
- [ ] Monitoramento com Sentry ou LogRocket

## 💡 Dicas Importantes

1. **Sempre faça git push antes de fazer deploy** - Render puxa de lá
2. **Variaçoes `mix.exs` são compiladas em tempo de build** - mudanças ali precisam novo build
3. **Free tier = 0.5GB RAM** - é suficiente para um bot simples
4. **Logs aparecem em tempo real** - útil pra debug

---

Qualquer erro? Veja os logs completos no dashboard Render! 📋
