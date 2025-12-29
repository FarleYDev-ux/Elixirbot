# 🚀 Guia de Deployment - Shardcloud

## Requisitos

- Shardcloud account
- Discord Bot Token (gerado em https://discord.com/developers/applications)

## Passos de Deploy

### 1. Preparar o Bot Localmente

```bash
cd discord_bot
mix deps.get
DISCORD_TOKEN=seu_token mix run --no-halt
```

### 2. Fazer Deploy no Shardcloud

1. Crie uma conta em **shardcloud.app**
2. Crie um novo bot e selecione **Elixir** como linguagem
3. Configure o **Procfile**:
   ```
   worker: cd discord_bot && mix ecto.create 2>/dev/null; mix run --no-halt
   ```
4. Configure variáveis de ambiente:
   - `DISCORD_TOKEN`: Seu Discord Bot Token

### 3. Verificar Deployment

Após fazer deploy:
1. Vá para o seu servidor Discord
2. Use o comando `/ping` para verificar se o bot está online
3. Teste os outros comandos: `/dailyreward`, `/balance`, `/help`

## Variáveis de Ambiente

```env
DISCORD_TOKEN=your_token_here
```

## Arquitetura do Bot

- **Linguagem**: Elixir 1.18
- **Framework Discord**: Nostrum 0.10
- **Armazenamento**: Stateless (sem banco de dados)
- **Tipo**: Worker (executado continuamente)

## Comandos Disponíveis

- `/ping` - Mostra latência e uptime do bot
- `/dailyreward` - Coleta recompensa diária (R$ 30)
- `/balance` - Mostra saldo total
- `/help` - Lista todos os comandos

## Troubleshooting

### Bot não conecta
- Verifique se `DISCORD_TOKEN` está configurado corretamente
- Teste o token localmente antes de fazer deploy

### Comando não responde
- Verifique se o bot tem permissão para enviar mensagens no servidor
- Revise os logs no Shardcloud

### Performance
- O bot é otimizado para Elixir com concorrência máxima
- Usa cache em memória para dados do usuário
- Sem I/O de banco de dados para máxima performance

## Notas

- Bot é **stateless**: dados de recompensas são resetados quando o bot reinicia
- Para persistência, adicione banco de dados (PostgreSQL)
- Bot usa purple do Elixir (#7F4DB0) nos embeds
