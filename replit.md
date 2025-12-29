# Discord Bot - Elixir

## Overview

This is a Discord bot application built with Elixir using the Nostrum library. The project provides a foundation for creating Discord bots with features like REST API interactions, voice support, and caching of Discord data. The application follows Elixir/OTP conventions and is designed to leverage Erlang's concurrency model for handling Discord events.

## User Preferences

Preferred communication style: Simple, everyday language.

## System Architecture

### Core Framework
- **Language**: Elixir running on the Erlang VM (BEAM)
- **Discord Integration**: Nostrum library (~> 0.10) handles all Discord API communication including REST API calls, WebSocket connections for real-time events, and voice functionality

### Application Structure
The project follows standard Elixir/Mix project conventions:
- `discord_bot/` - Main application directory
- `deps/` - External dependencies managed by Mix

### Key Architectural Decisions

**Nostrum for Discord API**
- Provides clean REST API implementation with automatic rate limiting
- Supports multi-node distribution for scaling
- Includes local caching of Discord data with query support
- Handles voice data transmission

**Hot-Code Upgrades Support**
- Castle/Forecastle libraries enable runtime hot-code upgrades
- Useful for deploying updates without disconnecting from Discord

**JSON Processing**
- Jason library used for high-performance JSON encoding/decoding
- Critical for Discord API communication which uses JSON payloads

### OTP Design
The application is structured as an OTP application, allowing:
- Supervised process trees for fault tolerance
- Event-driven architecture for handling Discord events
- Concurrent handling of multiple Discord interactions

## External Dependencies

### Discord API
- **Nostrum** - Primary Discord library handling WebSocket connections, REST API, and Discord data structures
- Requires a Discord bot token configured in `config/config.exs`

### Supporting Libraries
- **Jason** - Fast JSON parser/generator for API communication
- **Certifi** - CA certificate bundle for secure HTTPS connections to Discord
- **MIME** - MIME type handling for file uploads and attachments

### Build/Deployment
- **Castle** - Runtime support for hot-code upgrades
- **Forecastle** - Build-time support for release generation with upgrade capability

### Configuration Requirements
The bot requires:
- Discord bot token (from Discord Developer Portal)
- Configuration file at `config/config.exs`