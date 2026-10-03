<div align="center">

<img src="icon.ico" alt="Contrary Janus Icon" width="128" height="128">

# <span style="color:#47848F">C O N T R A R Y :</span> &nbsp; <span style="color:#ffffff">J A N U S</span>

<br>

**Joint Authentication Node for Unified Steam & Ubisoft Connect**

*The ultimate multi-platform Denuvo activation and management toolkit.*

---

<p align="center">
  <a href="https://github.com/Contrary7/Dnvo-Janus"><img alt="Stars" src="https://img.shields.io/github/stars/Contrary7/Dnvo-Janus?style=flat-square&logo=github&color=ffb703"></a>
  <img alt="Platform" src="https://img.shields.io/badge/Platform-Windows%20x64-0078D4?style=flat-square&logo=windows&logoColor=white">
  <img alt="Rust" src="https://img.shields.io/badge/Rust-Tauri%20v2-B7410E?style=flat-square&logo=rust&logoColor=white">
  <img alt="Size" src="https://img.shields.io/badge/Size-~17MB%20portable-47848F?style=flat-square">
  <img alt="License" src="https://img.shields.io/badge/License-CJR--1.0-dc3545?style=flat-square">
  <img alt="Status" src="https://img.shields.io/badge/Status-Active-28a745?style=flat-square">
  <img alt="Build" src="https://img.shields.io/badge/Build-Secure%20Pipeline-success?style=flat-square&logo=githubactions&logoColor=white">
</p>

---
</div>

## 💡 What Is Contrary: Janus?

**Contrary: Janus** is a closed-source desktop application built natively in **Rust and Tauri** that implements a full multi-platform DRM research toolkit. It authenticates real user sessions against **Steam's CM network** and **Ubisoft Connect**, extracts cryptographically signed ownership proofs, and securely orchestrates an official Denuvo license negotiation — producing a valid activation response directly from Denuvo's own servers.

The name **Janus** — the two-faced Roman god of duality and transitions — reflects the tool's dual-role design: an **Activator** that initiates the license pipeline, and a **Leech** that receives and deploys the result. Two faces. One pipeline.

> This project is intended for **software interoperability research and DRM protocol analysis**. It documents how Steam and Ubisoft ownership proof pipelines intersect with Denuvo's license validation architecture.

---

## ⚡ Quick Start & Installation

Contrary: Janus is **closed-source proprietary software**. The only supported installation method is the official pre-built binary.

**Prerequisites:**
- **Windows 10 (1903+) or Windows 11, x64**
- **Node.js v18+** (Janus will warn you on launch if it's missing)
- **Steam / Ubisoft Connect** installed
- **Active internet connection**

**Installation:**
1. Go to [**Releases**](../../releases/latest)
2. Download `Dnvo Janus.exe`
3. Place it anywhere you like (Desktop, USB, etc.)
4. Double-click to run — that's it!

> **Note**: The `Dnvo Janus.exe` is fully portable. No installation, no admin rights, no setup wizard. **Everything is bundled inside the single `.exe` file (~17MB).**

### Auto-Updates
The app checks for updates automatically on startup. When a new release is available, an in-app notification appears. Click **Update** — the app downloads the new portable binary, swaps itself out, and restarts automatically.

---

## 🧭 Usage Guide

### 🔍 Step 0 — Find Your Game ID
Before doing anything, you need the correct numeric ID for your target game.

**🟦 Steam Games — Get the AppID from SteamDB**
1. Go to **[https://steamdb.info/](https://steamdb.info/)**
2. Use the search bar at the top to search for your game by name
3. Click the game from the results
4. The **AppID** is the number shown in the URL and on the page — e.g. `2246340` for Monster Hunter Wilds

**🟠 Ubisoft Games — Get the Uplay ID**
1. Go to the **[Haoose/UPLAY_GAME_ID](https://github.com/Haoose/UPLAY_GAME_ID)** repository
2. Search the list (`Ctrl+F`) for your game by name
3. The number next to the game name is the **Uplay Game ID** — use this in Janus

> ⚙️ **EA Pipeline — Coming Soon!** EA App authentication support is currently in development.

---

### 🔐 Step 1 — Authenticate
Open **Dnvo Janus.exe**. The **Authentication** panel loads by default.

**For Steam:**
- Enter your **Steam username and password** and click Login
- If prompted, enter your **Steam Guard code** (email or mobile authenticator), OR click **QR Login** and scan the code.
- On success, your Steam avatar and username appear in the top sidebar.

**For Ubisoft:**
- Switch to the **Ubisoft** tab in the Authentication panel
- Enter your **Ubisoft/Uplay email and password** and click Login
- Complete any 2FA if prompted.

> 💾 Accounts are saved locally. On future launches, just click your saved account — no need to re-enter credentials.

---

### 🎯 Step 2A — Activator (You own the game on Steam/Ubisoft)
> ⚠️ Requires an account that **legitimately owns** the target game. The network enforces this cryptographically.

1. Go to the **Activator** panel. Your Denuvo-protected owned games are shown automatically — select one, or type the ID manually.
2. Click **Extract & Process** — Janus connects to the platform, grabs the ownership proof, and prepares the activation payload.
3. Wait for the confirmation, then click **Generate Code** to produce a **7-digit share code**.
4. Share the code with the person running the Leech.

---

### 🛰️ Step 2B — Leech (You received a code, game is installed)
> The Leech does **not** need to own the game or have an account logged in.

1. Go to the **Leech** panel.
2. Paste the **7-digit code** you received from the Activator.
3. Enter the target **AppID / Game ID**.
4. Click **Activate** — Janus auto-detects the game folder and deploys the native validation bridge.
5. Click **Launch** to start the game directly from Janus!

---

### 📁 Step 3 — Check History
Every activation is logged locally. The **History** panel shows a full audit log: game title, AppID, platform, and timestamp. You can clear it at any time with one click.

---

## 🔐 Core Features & Workflow

- **Steam Pipelines**: Password login, Steam Guard OTP/TOTP, QR Code login
- **Ubisoft Pipelines**: Native demuxing and license exchange
- **Session Persistence**: Multi-account management, one-click re-auth
- **Auto-Detection**: Scans Steam library paths to find installed games automatically

### How Activation Works
When the Leech deploys the runtime and the game is launched:

```
Game starts
    │
    ▼
Native validation bridge is loaded alongside the game
    │
    ▼
Runtime establishes a secure connection for validation
    │
    ▼
Runtime pushes the activation payload and contacts
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
*The native validation bridge does not patch, crack, or remove Denuvo Anti-Tamper. The game performs its full, unmodified Denuvo initialization.*

---

## 🎮 Supported Games Database

Contrary: Janus maintains an internal database of Denuvo-protected titles. The Activator panel filters your library to show only Denuvo games, preventing accidental operations on unprotected titles.

<details>
<summary><b>Click to expand the full list of verified Steam titles (82 Games)</b></summary>

<br>

| Title | AppID |
|---|---|
| ACE COMBAT 8: WINGS OF THEVE | 2288340 |
| Atomfall | 801800 |
| Black Myth: Wukong | 2358720 |
| Borderlands® 4 | 1285190 |
| Construction Simulator | 1273400 |
| Crimson Desert | 3321460 |
| Dead Space | 1693980 |
| Demon Slayer -Kimetsu no Yaiba- The Hinokami Chronicles | 1490890 |
| Demon Slayer -Kimetsu no Yaiba- The Hinokami Chronicles 2 | 2928600 |
| DIRT 5 | 1038250 |
| Echoes of Aincrad | 2244210 |
| F1® 25 | 3059520 |
| F1® Manager 2024 | 2591280 |
| FAR: Changing Tides | 1570010 |
| Fernbus Simulator | 427100 |
| Football Manager 26 | 3551340 |
| Hatsune Miku: Project DIVA Mega Mix+ | 1761390 |
| Hello Kitty Island Adventure | 2495100 |
| Hogwarts Legacy | 990080 |
| Judgment | 2058180 |
| Jurassic World Evolution 3 | 2958130 |
| LEGO® Batman™: Legacy of the Dark Knight | 2215200 |
| Life is Strange: Reunion | 2624870 |
| Like a Dragon Gaiden: The Man Who Erased His Name | 2375550 |
| Like a Dragon: Infinite Wealth | 2072450 |
| Like a Dragon: Ishin! | 1805480 |
| Like a Dragon: Pirate Yakuza in Hawaii | 3061810 |
| Lost Judgment | 2058190 |
| Mafia: The Old Country | 1941540 |
| Maneater | 629820 |
| Marvel's Midnight Suns | 368260 |
| METAL GEAR SOLID V: THE PHANTOM PAIN | 287700 |
| Metaphor: ReFantazio | 2679460 |
| Middle-earth™: Shadow of War™ | 356190 |
| Monster Hunter Stories 3: Twisted Reflection | 2852190 |
| Monster Hunter Wilds | 2246340 |
| Mortal Kombat 1 | 1971870 |
| Onimusha: Way of the Sword | 2638890 |
| Persona 3 Portable | 1809700 |
| Persona 3 Reload | 2161700 |
| Persona 4 Arena Ultimax | 1602010 |
| Persona 4 Golden | 1113000 |
| Persona 5 Royal | 1687950 |
| Persona 5 Strikers | 1382330 |
| Persona 5 Tactica | 2254740 |
| Planet Coaster 2 | 2688950 |
| Planet Zoo | 703080 |
| PRAGMATA | 3357650 |
| RAIDOU Remastered: The Mystery of the Soulless Army | 2288350 |
| Resident Evil Requiem | 3764200 |
| Shin Megami Tensei III Nocturne HD Remaster | 1413480 |
| Shin Megami Tensei V: Vengeance | 1875830 |
| SHINOBI: Art of Vengeance | 2361770 |
| Sid Meier's Civilization VII | 1295660 |
| Sniper Elite 4 | 312660 |
| Sniper Elite 5 | 1029690 |
| Sniper Elite: Resistance | 2169200 |
| Sonic Forces | 637100 |
| Sonic Frontiers | 1237320 |
| Sonic Origins Plus | 1794960 |
| Sonic Racing: CrossWorlds | 2486820 |
| Sonic Superstars | 2022670 |
| SONIC X SHADOW GENERATIONS | 2513280 |
| Soul Hackers 2 | 1777620 |
| Stellar Blade™ | 3489700 |
| Street Fighter™ 6 | 1364780 |
| Suicide Squad: Kill the Justice League | 315210 |
| Sword Art Online: Fatal Bullet | 626690 |
| The Adventures of Elliot: The Millennium Tales | 3483510 |
| The Bus | 491540 |
| Total War: THREE KINGDOMS | 779340 |
| Total War: WARHAMMER | 364360 |
| Total War: WARHAMMER II | 594570 |
| Total War: WARHAMMER III | 1142710 |
| Two Point Museum | 2185060 |
| Undisputed | 1451190 |
| Valkyria Chronicles 4 Complete Edition | 790820 |
| Warhammer 40,000: Chaos Gate - Daemonhunters | 1611910 |
| Warhammer Age of Sigmar: Realms of Ruin | 1844380 |
| WWE 2K26 | 3717070 |
| Yakuza Kiwami 3 & Dark Ties | 3937550 |
| Yakuza: Like a Dragon | 1235140 |

> The AppID database is updated with each release. Missing a title? Open an issue with the AppID.

</details>

<details>
<summary><b>Click to expand the list of verified Ubisoft titles (7 Games)</b></summary>

<br>

| Title | Uplay ID |
|---|---|
| Assassin's Creed Black Flag Resynced | 66088 |
| Assassin's Creed Shadows | 1081 |
| Avatar: Frontiers of Pandora | 4740 |
| Far Cry 6 | 5266 |
| Prince of Persia The Lost Crown | 6145 |
| Star Wars Outlaws | 17903 |
| Tom Clancy's Ghost Recon® Wildlands | 1771 |

> Have you tested others? Let us know so we can add them to the verified list!

</details>

---


## ❓ FAQ & Limitations

- **Windows x64 only** — Denuvo is a Windows-exclusive DRM system.
- The **Activator role requires legitimate ownership** of the target game — the platform network enforces this cryptographically.
- **Live license validation is required** for all operations — offline mode is not supported.

**Q: Does the Leech need to own the game?**
A: No. The Leech only needs the game installed and a valid 7-digit code from an Activator. No account ownership is required on the receiving machine.

**Q: Why are there two DLL files (`contrary.dll` and `contrary_x64.dll`)?**
A: Some game titles ship both 32-bit and 64-bit executable variants, or use a 32-bit launcher for a 64-bit game process. Both DLLs are deployed to cover both configurations.

**Q: Why does Denuvo's `support.codefusion.technology` appear in my firewall logs?**
A: This is expected and correct. The game performs its normal Denuvo license check directly with Denuvo's live servers — the same endpoint the game contacts on any normally activated machine.

**Q: Does this violate Steam/Ubisoft Terms of Service?**
A: The tool authenticates using official credentials and uses official encrypted ticket protocols. It does not automate purchases or exploit backend systems. Individual users are responsible for their compliance with subscriber agreements.

**Q: The executable shows a SmartScreen warning — is that normal?**
A: Yes. Windows SmartScreen warns on unsigned binaries from unknown publishers. The warning is a Microsoft OS policy behavior, not an indication of malware.

---

## ⭐ Star & Support

If you find this toolkit or our DRM research valuable, please consider giving this repository a **Star ⭐**! It helps boost visibility and signals interest for future updates (like the upcoming EA pipeline).

Found a bug or need an AppID added? [Open an Issue](../../issues) on the repository.

---

## ⚖️ Legal Notice

Contrary: Janus is developed as a **software interoperability and security research tool** under principles recognized by:

- **EU Directive 2009/24/EC, Article 6** — Reverse engineering for interoperability
- **17 U.S.C. § 1201(f)** — Circumvention for interoperability purposes
- **17 U.S.C. § 1201(j)** — Security testing exemptions

This tool does not distribute, modify, or reproduce any copyrighted game content. It does not patch or remove Denuvo Anti-Tamper. All interactions are performed through official live endpoints using valid ownership proofs. Users are solely responsible for compliance with applicable laws and EULAs.

---

## 📜 License & Credits

Copyright © 2026 Contrary Project Authors
Licensed under the **Contrary Janus Research License v1.0 (CJR-1.0)**. See [LICENSE.md](./LICENSE.md) for full terms.

**Special Thanks**
We would like to extend our deepest gratitude to the following individuals and projects for their foundational research and contributions to the scene:
- **mr goldberg**
- **drm.steam.run**
- **NotAndreh**
- **DoctorMcKay**
- **YoobieRE**
