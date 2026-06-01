# Daily Log — No Payne No Gain

---

## 2026-06-01

### OG Image meta tags
Added Open Graph image tags to `web/index.html` for social sharing previews when the app URL is pasted into Twitter, iMessage, WhatsApp, etc.

- `og:image` — Wellington Phoenix official headshot of Tim Payne (hosted on wellingtonphoenix.com)
- `og:image:width` — 1200
- `og:image:height` — 900

### Production deploy + alias
Deployed `web/` to Vercel production and re-aliased to **timpaynefans.vercel.app**.

- Deployment: `no-payne-no-gain-fx2ls5t0m-andrestglezcs-projects.vercel.app`
- Alias: https://timpaynefans.vercel.app

### GitHub
Committed and pushed `web/index.html` changes to `master` (commit `ed9e8a3`).

---

## 2026-05-31

### Project bootstrapped
Built the full **No Payne No Gain** fan web app from scratch — a single-file vanilla HTML/JS/CSS app celebrating Tim Payne, New Zealand's least-known 2026 FIFA World Cup player who went viral overnight.

**App structure:**
- 4-tab navigation: Hype, Missions, Chants, Profile
- Persistent state (session-scoped)

**Hype tab:**
- Panini-style sticker card hero (Oswald font, gold border, shine-on-hover animation, links to Tim's Instagram)
- Live global supporter counter (starts at 4,715, scales with taps)
- Tap-for-Tim button with particle burst on tap
- Stats row (today's taps, streak, points)
- Rotating fan chants with share button
- Tim facts grid and origin story

**Missions tab:**
- 5 daily missions with progress bars and Payne Points rewards
- 30-day streak tracker

**Chants tab:**
- Personal chant generator (name + country → fills one of 4 templates)
- Browsable fan chant carousel with share

**Profile tab:**
- 12-badge collection (common → rare → epic → legendary)
- Badge unlock modal with animation
- Links to Tim's Instagram and El Scarso

**Design:**
- Wellington Phoenix color scheme — Phoenix yellow `#F0C130`, dark background `#070A0D`
- Playfair Display (italic serif) + DM Sans + Oswald
- Mobile-first, max-width 430px

### Assets + config
- `web/tim.png` — Tim Payne photo used inside the Panini card
- `web/vercel.json` — Vercel project config
- `web/.gitignore`
- `panini-card.png` — static preview image of the card (used in README)
- `README.md` — project overview with hero image and setup instructions

### Deploy
Initial deploy to Vercel and alias to **timpaynefans.vercel.app**.
