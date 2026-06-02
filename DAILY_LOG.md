# Daily Log — No Payne No Gain

---

## 2026-06-01 (session 3)

### Hermes / dependency debugging
- Diagnosed "private properties are not supported" Hermes error. Initial suspect: `idb` package (pulled in by `@react-native-async-storage/async-storage@3.1.1`). Wrote and deleted `metro.config.js` with transform fix.
- Root fix: reinstalled async-storage via `npx expo install` — Expo SDK 54 pins it to `v2.2.0`, which has no `idb` dependency. Error resolved without metro config change.
- Full `node_modules` + `package-lock.json` clean reinstall.
- Confirmed remaining packages with private class fields (`undici`, `expo-server`, `hosted-git-info`) are build tooling only — not bundled into the app.
- Generated iOS bundle via `expo export` to inspect — found `DOMRectReadOnly` with private fields at line 27098. Source: `react-native/src/private/webapis/dom/geometry/DOMRectReadOnly.js` — RN 0.76's own DOM geometry API. This is fine with the Hermes bundled in a dev build but incompatible with older Expo Go Hermes builds.
- **Decision**: EAS development build required — Expo Go's Hermes predates RN 0.76 private field support.

### Native app setup
- Installed `expo-dev-client@6.0.21`, added to `app.json` plugins.
- Added `AsyncStorage` persistence to `src/lib/gameState.ts` — loads/saves full game state under `nopayne_state`, handles streak gaps across sessions.
- App icon: replaced placeholder (22KB) with real icon (1024×1024 PNG). Stripped alpha channel via `sips` JPEG roundtrip — required for App Store submission.

### Legal pages
- Created four legal HTML pages: `privacy.html`, `terms.html`, `data-compliance.html`, `trademark.html`.
- Style: dark `#0a0a0a` background, `#F0C130` accents, Georgia serif, matching app aesthetic.
- Contact email throughout: `timpaynearmy@gmail.com`.
- Back links go to `/#profile` (not `/`) so users land on the Profile tab.
- Added Vercel clean URL rewrites to `vercel.json` in both `web/` and `dist/`.
- Legal footer added to Profile tab in `web/index.html` — four muted links, wraps on small screens.

### Vercel / deployment issues
- Discovered two Vercel projects: `no-payne-no-gain` (real web app) and accidental `dist` project (Expo web export). Domain `timpaynefans.vercel.app` pointing at wrong project.
- Deployed legal pages to `dist` project by mistake. Need to permanently assign domain to `no-payne-no-gain` via Vercel project settings.

### iOS 26 Liquid Glass UI redesign
- Complete CSS overhaul of `web/index.html` — all cards, nav, modal, inputs, tap button now use glass material system:
  - `backdrop-filter: blur(20px) saturate(180%)`
  - `box-shadow: inset 0 1px 0 rgba(255,255,255,0.15), inset 0 -1px 0 rgba(0,0,0,0.1), 0 8px 32px rgba(0,0,0,0.4)`
  - Specular `::before` gradient highlight on every glass element
  - Hover: `scale(1.01)` + `border-color` shift to `rgba(255,255,255,0.2)`
- Nav: `blur(24px) saturate(200%)`, active tab gets gold pill with border
- Modal: stronger `blur(40px)` on both overlay and card
- Tap button: glass base over gold-tinted dark, spring-back on `:active`
- Inputs: glass with gold focus ring `0 0 0 3px rgba(240,193,48,0.08)`
- Body: radial depth gradients (subtle gold at 30%/20%, white at 70%/80%)
- Panini card untouched

### Tim's Card (Chants tab)
- FIFA Ultimate Team-style gold card generator, top of Chants tab.
- Stats randomise on each generation within defined ranges (PAC 58-72, SHT 12-28, PAS 55-68, DRI 44-62, DEF 61-74, VIR always 99).
- SVG footballer silhouette (hand-built, with ball at feet).
- Meme stats panel: followers (2.1M–2.9M random), goals (always 0), El Scarso approval (always 99%), hair tier (Elite/Legendary/Iconic/Peak).
- Fade-out → regenerate → `cardFadeIn` animation on each new generation.
- Share button copies tweet text to clipboard / uses `navigator.share` on mobile.

### "What % Tim Payne Are You?" Quiz (Hype tab)
- 6-question absurd quiz, one question at a time, at the top of the Hype tab.
- Progress dots (gold = current, faded gold = answered, grey = upcoming).
- Answer click: immediate gold flash on button, all buttons disabled, 180ms fade-out, 380ms state update + re-render with fade-in animation.
- 5 result tiers: 100% / 85% / 67% / 42% / 0% with savage descriptions.
- Result card: big gold percentage, NZ flag, description, Share + Retake buttons.
- Share copies `[pct]% Tim Payne. [desc] 🇳🇿 #NoPayneNoGain timpaynefans.vercel.app`.
- Hash routing fix: `/#profile` back links from legal pages now correctly activate Profile tab on load.

### Git
- Committed all session work in two commits: `ade33f8` (native/deps/legal) and `bfa560c` (UI/features).
- Pushed to `origin/master`.

---

## 2026-06-01

### CLAUDE.md project state update
Updated `CLAUDE.md` with a full project snapshot: both codebases (web + React Native), what's built and working, deploy instructions, and a prioritised what's-next list.

Key findings documented:
- Two navigation approaches co-exist in the Expo app (`App.tsx` uses React Navigation, `app/_layout.tsx` uses Expo Router) — need to reconcile before shipping native
- State is session-only; `AsyncStorage` needed for persistence across app restarts
- EAS is configured but no build has been submitted yet

### Daily log update
Appended this session to `DAILY_LOG.md` and committed both files to `master`.

---

## 2026-06-01 (earlier)

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
