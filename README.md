# Roblox Tycoon Systems Portfolio

This repository showcases **modular tycoon systems** developed in Roblox Lua.  
All scripts follow **server-side validation, modular architecture, and best practices**.

## Scripts Included

### 1. Dropper System (`ServerScripts/Dropper.server.lua`)
- Handles money generation for tycoon droppers.
- Features:
  - Server-side validation
  - Cooldown protection per player
  - Attribute-based configuration (DropValue, Cooldown)
  - Reusable across multiple tycoons

### 2. Purchase Handler (`ServerScripts/PurchaseHandler.server.lua`)
- Handles all tycoon purchases.
- Features:
  - Ownership validation
  - Attribute-based item state
  - Anti-exploit (client cannot decide price or purchased state)
  - Scalable to unlimited items or upgrades

### 3. Tycoon Data System (`ServerScripts/TycoonData.server.lua`)
- Persistent data handling with versioned DataStore.
- Features:
  - Safe pcall usage
  - Versioned datastore schema
  - Leaderstats + purchased items
  - BindToClose save handling
  - Expandable for new tycoon features

---
