# Contrary Janus Research License
### Version 1.0 — 2026

---

```
CONTRARY JANUS RESEARCH LICENSE (CJR-1.0)
==========================================

"Where two faces meet, one truth emerges."
```

---

## Preamble

This license governs the use, reproduction, and distribution of the **Contrary: Janus** software, including all compiled binaries, runtime components, documentation, and associated resources (collectively, the "Software").

Contrary: Janus is a closed-source, proprietary software interoperability and protocol research tool. It is engineered to document and demonstrate the relationship between Valve's Steam ownership proof system and Denuvo Anti-Tamper's license validation architecture. The Software routes a cryptographically authenticated Steam ownership proof through a proprietary backend that orchestrates a direct, official Denuvo license negotiation with Denuvo's live servers.

The authors recognize the legal right to reverse engineer software for interoperability and security research purposes under applicable law. This license is structured to ensure compliance with those frameworks while prohibiting harmful, illegal, or commercially exploitative use.

---

## Definitions

- **"Authors"** — the creators and maintainers of the Contrary: Janus project.
- **"You"** — the individual or entity exercising rights under this License.
- **"Software"** — the Contrary: Janus compiled binary, NSIS installer, bundled runtime components, configuration files, and all associated documentation.
- **"Runtime Components"** — the DLL and configuration files deployed by the Software to a game directory as part of the activation pipeline.
- **"Personal Research Use"** — use by an individual, for their own non-commercial study, experimentation, or protocol analysis.
- **"Commercial Use"** — any use that generates direct or indirect monetary compensation, or that is conducted on behalf of a for-profit entity.

---

## Grant of License

Subject to the terms of this License, the Authors grant You a **limited, non-exclusive, non-transferable, revocable** license to install and use the Software's compiled binary solely as described under Permitted Uses.

No rights to the Source Code are granted. Source Code is not distributed under this or any other license.

---

## ✅ Permitted Uses

1. **Personal Research & Education**
   Use and study the Software for personal, non-commercial research, academic study, or educational purposes, including protocol analysis and DRM interoperability documentation.

2. **Security Research**
   Use the Software in good-faith security research or vulnerability disclosure, in compliance with applicable law and the [SECURITY.md](./SECURITY.md) responsible disclosure policy.

3. **Non-Commercial Personal Use**
   Install and use the Software for personal, non-commercial game activation, provided You legitimately own the target game on the Steam account used for authentication.

4. **Private Sharing**
   Share the Software's compiled binary privately with other individuals for research purposes, provided this License is included in full and no fee is charged.

---

## ❌ Prohibited Uses

1. **Commercial Use & Monetization**
   Using the Software or its methodology to operate a paid activation service, charge fees of any kind, or use the Software in any commercial enterprise context — without prior written permission from the Authors.

2. **Paid Distribution**
   Selling, renting, or charging for access to the Software or any Derivative Work.

3. **Circumvention Without Ownership**
   Using the Software to activate games You do not legitimately own a license to on the Steam account used for authentication.

4. **Impersonation**
   Using the Software to impersonate Valve Corporation, Steam services, Denuvo Software Solutions, or any other party; or to engage in phishing, credential harvesting, or account compromise.

5. **Malicious Use**
   Using the Software to deploy malware, gain unauthorized access to third-party systems, or cause harm to any person, system, or service.

6. **Redistribution Without Attribution**
   Redistributing the Software without including this License in full and clear attribution to the Authors.

7. **Reverse Engineering Runtime Components**
   Decompiling, disassembling, or otherwise attempting to derive the implementation of the Runtime Components beyond what is strictly necessary for permitted security research.

---

## Redistribution Requirements

Any redistribution permitted under this License must:

1. Include this License in complete, unmodified form
2. Retain all copyright notices and attribution
3. Clearly indicate any modifications made
4. Not present the distribution as an official Contrary: Janus release without written authorization

---

## Intellectual Property & Third-Party Rights

The Software interacts with third-party platforms and services. This License grants no rights with respect to those parties. You are solely responsible for ensuring Your use complies with their terms.

| Third Party | Applicable Terms |
|---|---|
| Valve Corporation | [Steam Subscriber Agreement](https://store.steampowered.com/subscriber_agreement/) |
| Denuvo Software Solutions GmbH | Denuvo EULA (per-game) |
| Individual game publishers | Respective per-game EULAs |

The Authors do not encourage or condone any use of this Software that violates the Steam Subscriber Agreement, any game publisher's EULA, or applicable law.

---

## Open Source Acknowledgements

Contrary: Janus incorporates the following open source libraries under their respective licenses. Full license texts are embedded in the distributed binary.

| Library | License |
|---|---|
| electron | MIT |
| node-forge | BSD-3-Clause |
| qrcode | MIT |
| axios | MIT |
| electron-log | MIT |
| electron-updater | MIT |
| webpack | MIT |
| js-confuser | MIT |
| javascript-obfuscator | BSD-2-Clause |
| bytenode | MIT |
| @electron/fuses | MIT |
| better-sqlite3 | MIT |

---

## Legal Research Frameworks

The research activities enabled by this Software fall within recognized legal protections:

**European Union**
- **Directive 2009/24/EC, Article 6** — Permits reverse engineering where necessary to achieve interoperability of independently created programs.
- **Directive (EU) 2016/943, Article 3(1)(b)** — Reverse engineering activities conducted on lawfully acquired products are not actionable trade secret misappropriation.

**United States**
- **17 U.S.C. § 1201(f)** — Permits circumvention of technological protection measures for the purpose of achieving interoperability with independently created programs.
- **17 U.S.C. § 1201(j)** — Permits circumvention in the course of good-faith security testing.

Nothing in this License constitutes legal advice. Consult independent legal counsel if You are uncertain about the legality of any specific use in Your jurisdiction.

---

## Disclaimer of Warranty

**THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND NON-INFRINGEMENT.**

The Authors make no warranty that the Software will be uninterrupted, error-free, or that it will produce any particular result. The Authors are not responsible for loss of Steam account access, game library revocation, changes to Denuvo's license endpoint, or any other outcome arising from use of the Software.

---

## Limitation of Liability

To the maximum extent permitted by applicable law, the Authors shall not be liable for any direct, indirect, incidental, special, or consequential damages arising out of or in connection with this License or the use of the Software, even if advised of the possibility of such damages.

---

## Indemnification

You agree to indemnify, defend, and hold harmless the Authors from and against any claims, liabilities, damages, and expenses (including attorneys' fees) arising from Your use of the Software, Your violation of this License, or Your violation of any third-party right or applicable law.

---

## Termination

This License terminates automatically and immediately upon any violation of its terms. Upon termination, You must cease all use and destroy all copies of the Software in Your possession. Sections covering Warranty, Liability, and Indemnification survive termination.

---

## Governing Law

This License is governed by the laws of the jurisdiction in which the primary Authors reside. Any disputes shall be brought exclusively in courts of competent jurisdiction in that territory.

---

## Full License Summary

```
Copyright (c) 2026 Contrary Project Authors

Permission is granted for personal, non-commercial research and study use only.

Commercial use, paid distribution, and use on software You do not
legitimately own are expressly prohibited.

The Software is provided "AS IS" without warranty of any kind.
The Authors accept no liability for any outcome arising from use.

Redistribution requires full attribution and inclusion of this License.
Source Code is not made available under this or any other license.

CONTRARY JANUS RESEARCH LICENSE v1.0
```

---

<p align="center">
  <b>Contrary: Janus</b> — Licensed for Research. Built for Understanding.<br>
  <sub>CJR-1.0 · 2026 · Contrary Project Authors</sub>
</p>
