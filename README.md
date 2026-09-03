<div align="center">

<img src="icon.ico" alt="Contrary Janus Icon" width="128" height="128">

# <span style="color:#47848F">D E N U V O :</span> &nbsp; <span style="color:#ffffff">J A N U S</span>

<br>

**Joint Authentication Node for Unified Steam**

*The ultimate Denuvo activation and management toolkit.*

---

<p align="center">
  <img alt="Platform" src="https://img.shields.io/badge/platform-Windows%20x64-0078D4?style=for-the-badge&logo=windows&logoColor=white">
  <img alt="Electron" src="https://img.shields.io/badge/Electron-41.x-47848F?style=for-the-badge&logo=electron&logoColor=white">
  <img alt="License" src="https://img.shields.io/badge/license-CJR--1.0-dc3545?style=for-the-badge">
  <img alt="Status" src="https://img.shields.io/badge/status-active-28a745?style=for-the-badge">
  <img alt="Build" src="https://img.shields.io/badge/build-secure%20pipeline-success?style=for-the-badge&logo=githubactions&logoColor=white">
</p>

---
</div>

## What Is Contrary: Janus?

**Contrary: Janus** is a closed-source desktop application built on Electron that implements a full **Steam Content Manager (CM) protocol client** for Denuvo Anti-Tamper license research and activation. It authenticates real user sessions against Steam's CM network, extracts cryptographically signed ownership proofs, and routes them through a proprietary backend that orchestrates an official Denuvo license negotiation — producing a valid activation response directly from Denuvo's own servers.

The name **Janus** — the two-faced Roman god of duality and transitions — reflects the tool's dual-role design: an **Activator** that initiates the license pipeline, and a **Leech** that receives and deploys the result. Two faces. One pipeline.

> This project is intended for **software interoperability research and DRM protocol analysis**. It documents how Steam's ownership proof pipeline intersects with Denuvo's license validation architecture.

---

## Features

### 🔐 Authentication
- Password login with full Steam Guard support — email OTP and mobile TOTP
- QR Code login via the official Steam mobile app
- Session persistence — saved accounts survive restarts with one-click re-auth
- Multi-account management — switch, add, or remove saved sessions

### 🎯 Activator
- Connects to Steam's live CM network and requests a cryptographically signed ownership proof for the target game
- Validates the ownership ticket before processing
- Submits the ticket securely to the Contrary backend over a certificate-pinned HTTPS connection
- Receives a backend-issued license reference and converts it to a compact **7-digit share code** for distribution

### 🛰️ Leech
- Accepts a 7-digit code from an Activator
- Resolves the code against the backend
- Auto-detects the target game's installation path by scanning Steam library locations
- Falls back to a manual directory picker with executable heuristics if auto-detection cannot locate the game
- Deploys the **Contrary runtime package** alongside the game executable
- Launches the game directly from the interface

### 📦 How Activation Works

When the Leech deploys the runtime and the game is launched:

```
Game starts
    │
    ▼
Contrary runtime is loaded alongside the game
    │
    ▼
Runtime establishes a secure connection to the Contrary backend
    │
    ▼
Backend pushes the activation payload and contacts
Denuvo's official anti-tamper endpoint:
    → support.codefusion.technology
    │
    ▼
Denuvo's servers process the request through their
official license negotiation protocol and issue
an official activation response
    │
    ▼
Game receives Denuvo's official activated response
and launches normally ✅
```

The Contrary runtime does not patch, crack, or remove Denuvo Anti-Tamper. The game performs its **full, unmodified Denuvo initialization** and receives an **official response from Denuvo's live servers**.

### 📡 Community & Activity
- Real-time activity feed via live server events
- Community hub discovery and channel browsing
- Discord integration in the sidebar

### 📁 History
- Local activation audit log — AppID, game title, and timestamp for every operation
- One-click history clear
---

## Project Structure

```
contrary-janus/
├── src/
│   ├── main.js               # Electron main process — IPC, window, security
│   ├── preload.js            # contextBridge API (narrowly scoped)
│   ├── steam-client.js       # Steam CM client wrapper (steam-user)
│   ├── license-service.js    # Backend HTTP client — ticket post, code resolve
│   ├── contrary-generator.js # DLL deployment + ini encryption
│   ├── game-finder.js        # Steam library scanner + exe heuristics
│   ├── database.js           # Local SQLite activation log
│   ├── security.js           # Anti-debug, integrity, cert pinning, CSP
│   ├── config.js             # Env-baked configuration constants
│   └── updater.js            # electron-updater integration
├── renderer/
│   ├── index.html            # Single-page application shell
│   ├── renderer.js           # All UI logic — panels, IPC, live activity
│   └── style.css             # Dark UI design system
├── resources/
│   └── contrary.dll          # Denuvo integration runtime (bundled)
├── scripts/
│   ├── secure-build.js       # Full build pipeline orchestrator
│   ├── compile-bytecode.js   # Bytenode compilation stage
│   └── flip-fuses.js         # @electron/fuses hardening stage
├── package.json              # NPM manifest + electron-builder config
├── webpack.config.js         # Webpack bundles for main/preload/renderer
├── .env                      # Local dev secrets (not shipped)
├── README.md                 # This file
└── LICENSE.md                # License terms
```

### IPC Channel Map

| Channel | Direction | Purpose |
|---|---|---|
| `steam:login` | Renderer → Main | Password / TOTP / refreshToken login |
| `steam:start-qr` | Renderer → Main | Begin QR logon flow |
| `steam:getProfile` | Renderer → Main | Fetch avatar + display name |
| `steam:get-owned-apps` | Renderer → Main | List Denuvo-protected owned titles |
| `activator:extract-and-post` | Renderer → Main | Extract ticket + POST to VPS |
| `activator:generate-code` | Renderer → Main | Convert SHA-256 hash → 7-digit code |
| `leech:find-game` | Renderer → Main | Auto-locate game by AppID |
| `leech:select-exe` | Renderer → Main | Manual game directory picker |
| `leech:activate` | Renderer → Main | Resolve code + deploy Contrary runtime |
| `leech:launch` | Renderer → Main | Launch game via `spawn` (no shell) |
| `ticket:progress` | Main → Renderer | Real-time status push events |
| `steam:loginError` | Main → Renderer | JWT expiry / auth errors |

---


## Security

Contrary: Janus implements a hardened Electron architecture with security treated as a first-class concern across every layer.

| Layer | Mechanism |
|---|---|
| **Anti-debugger** | Debug flags detected at startup → immediate exit |
| **Environment hardening** | Sensitive Node.js environment variables stripped before any module loads |
| **ASAR integrity** | Archive hash verified at startup; mismatch → hard exit |
| **Preload integrity** | SHA-256 hash of the preload script embedded at build time and verified at every launch |
| **Certificate pinning** | All backend connections pinned to the expected TLS certificate — MITM connections are refused |
| **Renderer isolation** | `contextIsolation: true`, `nodeIntegration: false`, `sandbox: true` — renderer has no system access |
| **Log sanitization** | All log output is scrubbed of sensitive values before being written to disk |
| **Fuse hardening** | Electron binary fuses applied post-build — `RunAsNode` off, `OnlyLoadAppFromAsar` on |

**Build protection pipeline:**

```
Source → Webpack → Obfuscation (Layer 1) → Obfuscation (Layer 2)
      → V8 Bytecode Compilation → Electron Builder → Fuse Hardening
      → Final distributable
```

Source code is never distributed. The final binary contains only V8 bytecode and multi-layer obfuscated output.

---

## Technology Stack

| Category | Technology | Purpose |
|---|---|---|
| **Runtime** | Electron 41.x | Chromium + Node.js desktop shell |
| **Steam** | Steam CM client libraries | Full CM protocol, session management, TOTP |
| **Crypto** | node-forge | RSA, AES, X.509, TLS primitives |
| **HTTP** | axios | Certificate-pinned backend communication |
| **Database** | SQLite | Local activation history |
| **Logging** | electron-log | Sanitized multi-transport logging |
| **Updates** | electron-updater | GitHub Releases auto-update pipeline |
| **Obfuscation** | js-confuser + javascript-obfuscator | Two-layer source protection |
| **Bytecode** | bytenode | V8 bytecode compilation |
| **Bundler** | webpack | Module bundling and tree-shaking |
| **Binary** | @electron/fuses | Post-build binary hardening |

---

## Comparison

| Feature | Contrary: Janus | Manual Setup | Other Tools |
|---|---|---|---|
| Full Steam CM authentication | ✅ | ❌ | ❌ |
| QR + TOTP login | ✅ | ❌ | ❌ |
| Multi-account support | ✅ | ❌ | ❌ |
| Official Denuvo negotiation | ✅ | ❌ | ❌ |
| Auto game detection | ✅ | ❌ | Partial |
| Activation history log | ✅ | ❌ | ❌ |
| Auto-updates | ✅ | ❌ | ❌ |
| GUI | ✅ | ❌ | Partial |
| 3-layer build security | ✅ | N/A | ❌ |
| Windows x64 | ✅ | N/A | Varies |

---

## Installation

Contrary: Janus is **closed-source proprietary software**. The only supported installation method is the official pre-built binary.

1. Go to [**Releases**](../../releases/latest)
2. Download `Contrary_Janus.exe`
3. Run the installer — no administrator rights required
4. Launch from the Start Menu or Desktop shortcut

**Requirements:** Windows 10 1903+ or Windows 11, x64. No additional runtimes needed — everything is bundled.

### Auto-Updates

The app checks for updates automatically on startup. When a new release is available, an in-app notification appears. Click **Update** — the app downloads and restarts with the new version automatically.

---

## Usage

### Step 1 — Authenticate

Open the **Authentication** panel (default on launch). Either select a saved account or log in with credentials. Steam Guard codes and QR login are fully supported. On success, your Steam avatar and username appear in the sidebar.

### Step 2A — Activator

> Requires a Steam account that **legitimately owns** the target game.

1. Go to the **Activator** panel
2. Enter the **AppID** of the game (e.g. `2680010` for The First Berserker: Khazan)
3. Click **Extract & Process** — the ownership ticket is submitted to the backend
4. Click **Generate Code** to produce a **7-digit share code**
5. Share the code with your Leech

### Step 2B — Leech

1. Go to the **Leech** panel
2. Paste the **7-digit code** and enter the **AppID**
3. Click **Activate** — the runtime package is deployed to the game directory automatically
4. Click **Launch** to start the game

### Step 3 — History

All activations are logged locally. The **History** panel shows a full audit log with game title, AppID, and timestamp.

---

## Supported Games

Contrary: Janus maintains an internal database of Denuvo-protected titles. The Activator panel filters your library to show only Denuvo games, preventing accidental operations on unprotected titles.

| Title | AppID |
|---|---|
| Atomfall | 801800 |
| Atomic Heart | 668580 |
| BRAVELY DEFAULT FLYING FAIRY HD Remaster | 2833580 |
| Black Myth: Wukong | 2358720 |
| Borderlands 4 | 1285190 |
| CODE VEIN | 678960 |
| Civilization VII | 1295660 |
| Code Vein II | 2362060 |
| Construction Simulator | 1273400 |
| Crimson Desert | 3321460 |
| DOOM: The Dark Ages | 3017860 |
| DRAGON QUEST VII Reimagined | 2499860 |
| Demon Slayer -Kimetsu no Yaiba- The Hinokami Chronicles | 1490890 |
| Demon Slayer The Hinokami Chronicles | 1490890 |
| Demon Slayer The Hinokami Chronicles 2 | 2928600 |
| Digimon Story Time Stranger | 1984270 |
| Dirt 5 | 1038250 |
| Dragon's Dogma 2 | 2054970 |
| Echoes of Aincrad | 3015350 |
| Etrian Odyssey HD | 1868180 |
| Etrian Odyssey II HD | 1868170 |
| Etrian Odyssey III HD | 1810820 |
| F1 Manager 2024 | 2591280 |
| FAR: Changing Tides | 1570010 |
| FINAL FANTASY TACTICS - The Ivalice Chronicles | 1004640 |
| FINAL FANTASY XV | 2515020 |
| Final Fantasy 15 | 1102340 |
| Football Manager 26 | 3551340 |
| Gotham Knights | 1496790 |
| Handball 17 | 526980 |
| Harry Potter: Quidditch Champions | 2878600 |
| Hatsune Miku: PDMM+ | 707300 |
| Hatsune Miku: Project DIVA Mega Mix+ | 1761390 |
| Hello Kitty Island Adventure | 2495100 |
| Hello Kitty Island Adventures | 2495100 |
| Hogwarts Legacy | 990080 |
| Jurassic World Evolution 2 | 1244460 |
| Jurassic World Evolution 3 | 2958130 |
| Life Is Strange: Reunion | 2624870 |
| Like A Dragon: Gaiden | 1805480 |
| Like A Dragon: Infinite Wealth | 2072450 |
| Like A Dragon: Ishin | 1805480 |
| Like A Dragon: Pirate Yakuza In Hawaii | 3061810 |
| Like a Dragon Gaiden: The Man Who Erased His Name | 2375550 |
| Like a Dragon: Ishin! | 1805480 |
| Lost Judgement | 2058190 |
| Lost Judgment | 2058190 |
| Mafia: The Old Country | 1941540 |
| Marvel's Midnight Suns | 368260 |
| Mega Man Star Force Legacy Collection | 3500390 |
| Metaphor: ReFantazio | 2679460 |
| Metaphor: Refantazio | 2679460 |
| Monster Hunter Stories 3 | 2356560 |
| Monster Hunter Wilds | 2246340 |
| Monster Hunter: Wilds | 2246340 |
| Mortal Kombat 1 | 1971870 |
| NARUTO TO BORUTO: SHINOBI STRIKER | 633230 |
| NBA 2K25 | 2878980 |
| NBA 2K26 | 3472040 |
| OCTOPATH TRAVELER 0 | 3014320 |
| Octopath Traveler 0 | 3014320 |
| PGA TOUR 2K25 | 2385530 |
| PRAGMATA | 3357650 |
| Persona 3 Portable | 1809700 |
| Persona 3 Reload | 2161700 |
| Persona 3 Reload + DLC | 2161700 |
| Persona 4 Arena Ultimax | 1602010 |
| Persona 4 Golden | 1113000 |
| Persona 5 Royal | 1687950 |
| Persona 5 Strikers | 1382330 |
| Persona 5 Tactica | 2254740 |
| Planet Coaster | 493340 |
| Planet Coaster 2 | 2688950 |
| Planet Zoo | 703080 |
| RAIDOU Remastered | 301750 |
| RAIDOU Remastered: The Mystery of the Soulless Army | 2288350 |
| Resident Evil 4 | 2050650 |
| Resident Evil Requiem | 3764200 |
| SHINOBI: Art Of Vengeance | 2361770 |
| Shin Megami Tensei III Nocturne HD Remaster | 1413480 |
| Shin Megami Tensei V: Vengeance | 1875830 |
| Sniper Elite 4 | 312660 |
| Sniper Elite 5 | 1029690 |
| Sniper Elite VR | 752480 |
| Sniper Elite: Resistance | 2169200 |
| Sonic Colors: Ultimate | 2055290 |
| Sonic Frontiers | 1237320 |
| Sonic Origins | 1794960 |
| Sonic Racing: CrossWorlds | 2486820 |
| Sonic Superstars | 2022670 |
| Sonic X Shadow Generations | 2513280 |
| Soul Hackers 2 | 1777620 |
| Stellar Blade | 3489700 |
| Stranded: Alien Dawn | 1324130 |
| Street Fighter 6 | 1364780 |
| Super Robot Wars Y | 1909950 |
| Sword Art Online: Fatal Bullet | 626690 |
| The Bus | 491540 |
| The First Berserker: Khazan | 2680010 |
| Total War: WARHAMMER III | 1142710 |
| Two Point Campus | 1649080 |
| Two Point Museum | 2185060 |
| Undisputed | 1451190 |
| WRC 6 FIA World Rally Championship | 1267540 |
| WRC 7 FIA World Rally Championship | 1267540 |
| Warhammer 40,000: Chaos Gate - Daemonhunters | 1611910 |
| Warhammer Age Of Sigmar | 1337100 |
| Yakuza Kiwami 3 & Dark Ties | 3937550 |
| Yakuza: Like a Dragon | 1235140 |
| Zombie Army 4: Dead War | 694280 |
| eFootball | 674570 |

> The AppID database is updated with each release. Missing a title? Open an issue with the AppID.

---


## Known Limitations

- **Windows x64 only** — Denuvo is a Windows-exclusive DRM system
- The **Activator role requires legitimate Steam ownership** of the target game — Steam CM enforces this cryptographically
- The **Contrary backend is required** for all operations — offline mode is not supported
- Builds without a code-signing certificate will show a Windows SmartScreen prompt on first launch — this is standard OS behavior for unsigned binaries, not a security issue with the application

---

## FAQ

**Q: Does this work without owning the game on Steam?**
A: No. The Activator role requires a Steam account that legitimately owns the target title. Steam's CM network will reject the ownership ticket request for any game not in the account's library.

---

**Q: Does the Leech need to own the game?**
A: No. The Leech only needs the game installed and a valid 7-digit code from an Activator. No Steam account or ownership is required on the receiving machine.

---

**Q: Is an internet connection required?**
A: Yes. The Contrary backend and Denuvo's live servers both require an active connection. Offline mode is not supported.

---

**Q: Is a backend required?**
A: Yes. The Contrary backend is central to the pipeline — it processes the ownership proof and orchestrates the Denuvo negotiation. Without a connection to the backend, no activation can complete.

---

**Q: Why are there two DLL files (`contrary.dll` and `contrary_x64.dll`)?**
A: Some game titles ship both 32-bit and 64-bit executable variants, or use a 32-bit launcher for a 64-bit game process. Both DLLs are deployed to cover both address space configurations. The OS loader picks the architecturally correct one automatically.

---

**Q: Why does Denuvo's `support.codefusion.technology` appear in my firewall logs?**
A: This is expected and correct. The Contrary runtime causes the game to perform its normal Denuvo license check directly with Denuvo's live servers — the same endpoint the game would contact on any normally activated machine. The connection is an official HTTPS request to Denuvo's infrastructure.

---

**Q: Why Bytenode instead of just obfuscation?**
A: Obfuscation transforms source code — it can be deobfuscated with sufficient effort. Bytenode compiles JavaScript to V8 bytecode (`.jsc` files), which cannot be decompiled back to readable source. Combined with the two obfuscation layers applied before bytecode compilation, recovering the original source requires deep V8 internals expertise. The bar is deliberately as high as we can make it.

---

**Q: Does this violate Steam's Terms of Service?**
A: The tool authenticates using official Steam credentials and uses the official Steam CM encrypted app ticket protocol. It does not automate purchases, exploit Steam's backend systems, or violate Steam's rate limits. Individual users are responsible for their compliance with the Steam Subscriber Agreement.

---

**Q: Will my Steam account get banned?**
A: The tool authenticates using standard Steam credentials and does not exploit or abuse Steam's infrastructure. However, use is at your own risk and the authors accept no responsibility for account actions taken by Valve.

---

**Q: The installer shows a SmartScreen warning — is that normal?**
A: Yes. Windows SmartScreen warns on any unsigned binary from an unknown publisher. The warning is a Microsoft OS policy behavior, not an indication of malware. You can proceed past it safely.

---

## Legal Notice

Contrary: Janus is developed as a **software interoperability and security research tool** under principles recognized by:

- **EU Directive 2009/24/EC, Article 6** — Reverse engineering for interoperability
- **17 U.S.C. § 1201(f)** — Circumvention for interoperability purposes
- **17 U.S.C. § 1201(j)** — Security testing exemptions

This tool does not distribute, modify, or reproduce any copyrighted game content. It does not patch or remove Denuvo Anti-Tamper. All Denuvo interactions are performed through Denuvo's official live endpoints using a valid, Steam-authenticated ownership proof.

Users are solely responsible for compliance with applicable law, the Steam Subscriber Agreement, and individual game publishers' EULAs.

---

## License

Copyright © 2026 Contrary Project Authors

Licensed under the **Contrary Janus Research License v1.0 (CJR-1.0)**. See [LICENSE.md](./LICENSE.md) for full terms.

---

<p align="center">
  <i>Built with precision. Deployed with intent.</i><br><br>
  <b>Contrary: Janus</b> — <i>Two faces. One pipeline.</i>
</p>

---

## Special Thanks

We would like to extend our deepest gratitude to the following individuals and projects for their foundational research and contributions to the scene:
- **mr goldberg**
- **drm.steam.run**
- **NotAndreh**
