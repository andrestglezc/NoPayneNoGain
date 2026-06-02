@AGENTS.md

# No Payne No Gain — Project State

Fan app for Tim Payne, NZ right back who went viral at the 2026 FIFA World Cup after Argentine influencer El Scarso found him with 4,715 Instagram followers and asked the internet to follow him. He hit 2.5M followers in 48 hours.

Live at: **https://timpaynefans.vercel.app**

---

## Two codebases

### 1. Web app — `web/index.html` (LIVE, production)
Single-file vanilla HTML/JS/CSS app deployed to Vercel. This is what users actually see.

- **Deploy**: `cd web && vercel --prod`, then `vercel alias <url> timpaynefans.vercel.app`
- **Vercel project**: `no-payne-no-gain` (`prj_Ek6yzmcyVRo2qPFkI9NErI3LBsXq`, linked in `web/.vercel/project.json`)
- **Assets**: `web/tim.png` (Panini card photo), `web/vercel.json` (clean URL rewrites for legal pages)

**Features built:**
- **iOS 26 Liquid Glass UI** — all cards, nav, modal, inputs, tap button use `backdrop-filter: blur(20px) saturate(180%)` with specular `::before` highlights and spring hover transitions. Body has radial gold/white depth gradient.
- Panini sticker card hero with shine-on-hover animation, links to Tim's Instagram
- Tap-for-Tim button with emoji particle burst and live global counter (starts at 4,715, scales with taps × 347)
- 4-tab nav with gold pill active indicator: Hype / Missions / Chants / Profile
- **"What % Tim Payne Are You?" quiz** (Hype tab, top) — 6-question absurd quiz, one question at a time with progress dots, gold flash on answer, fade transition, result card with shareable percentage + savage description
- **Tim's Card** (Chants tab, top) — FIFA Ultimate Team-style gold card generator, randomised stats (PAC/SHT/PAS/DRI/DEF/VIR + meme stats), SVG footballer silhouette, fade-out/in on regenerate, share tweet button
- 5 daily missions with progress bars and Payne Points
- 12-badge collection (common → rare → epic → legendary) with unlock modal
- Chant generator (name + country fills one of 4 templates) + browsable carousel
- 30-day streak tracker
- OG meta tags for social sharing previews
- **Legal pages**: `/privacy`, `/terms`, `/data-compliance`, `/trademark` — dark glass HTML pages with Vercel clean URL rewrites. Contact: timpaynearmy@gmail.com
- Legal footer links in Profile tab
- `/#profile` hash routing — back links from legal pages land on Profile tab

**Design tokens**: Phoenix yellow `#F0C130`, dark bg `#070A0D`, Playfair Display + DM Sans + Oswald

**⚠️ Vercel domain situation**: There are two Vercel projects — `no-payne-no-gain` (the real web app, `web/`) and a stale `dist` project created accidentally. The `timpaynefans.vercel.app` alias needs to point to `no-payne-no-gain`. Run `vercel alias <latest-no-payne-url> timpaynefans.vercel.app` from `web/` after each deploy, or fix the alias permanently in Vercel project settings.

---

### 2. React Native app — repo root (built, not yet deployed)
Expo SDK 54 / React Native 0.76.9 app. Mirrors the web app feature-for-feature but as a proper native app.

**Structure:**
```
App.tsx                        # Entry point (React Navigation) — not reconciled yet
app/_layout.tsx                # Expo Router layout (alternative entry)
app/(tabs)/_layout.tsx         # Tab navigator via Expo Router
app/(tabs)/index.tsx           # Hype screen
app/(tabs)/missions.tsx        # Missions screen
app/(tabs)/chants.tsx          # Chants screen
app/(tabs)/profile.tsx         # Profile screen
src/
  screens/
    HypeScreen.tsx
    MissionsScreen.tsx
    ChantsScreen.tsx
    ProfileScreen.tsx
  components/
    BadgeModal.tsx
  hooks/
    useGameContext.tsx          # Game state context (GameProvider + useGame)
  lib/
    gameState.ts               # State logic + AsyncStorage persistence
  constants/
    gameData.ts                # CHANTS, BADGES, MISSIONS, TIM_FACTS
    theme.ts                   # Colors, Fonts constants
```

**Config**: `app.json` (bundle ID: `com.nopayne.nogain`), `eas.json` (EAS build configured)

**Fonts**: `@expo-google-fonts/playfair-display`, `@expo-google-fonts/dm-sans`

**Dependencies**: `@react-native-async-storage/async-storage@2.2.0` (Expo SDK 54 compatible — do NOT upgrade to v3.x, it pulls in `idb` which uses private class fields unsupported by Hermes). `expo-dev-client@6.0.21` installed.

**App icon**: `assets/icon.png` — 1024×1024 PNG, alpha channel stripped (required for App Store).

**AsyncStorage persistence**: `src/lib/gameState.ts` now loads/saves full game state from AsyncStorage under key `nopayne_state`. Streak logic handles gaps between sessions.

**⚠️ Navigation**: Two navigation approaches co-exist — `App.tsx` (React Navigation) and `app/_layout.tsx` (Expo Router). Must reconcile before shipping. Expo Router is the right choice for SDK 54.

**EAS**: Configured in `eas.json`. `development` profile uses `developmentClient: true` and `distribution: internal`. To build: `eas build --platform ios --profile development` (requires Apple credentials + device UDID registration).

**Hermes note**: RN 0.76.9 ships `react-native/src/private/webapis/dom/geometry/DOMRectReadOnly.js` with private class fields. This is fine with the bundled Hermes in a dev build. Do not use Expo Go — use an EAS dev build.

---

## What's next

### Native app
- [ ] Reconcile dual navigation: delete `App.tsx`, commit to Expo Router (`app/`)
- [ ] EAS build + install on device via TestFlight or direct IPA
- [ ] Push notification for daily streak reminder
- [ ] Share sheet for chant cards (styled image, not just text)
- [ ] Link native tap counter to web global count (need backend — Supabase or simple KV)
- [ ] Add Tim's Card + quiz to native app (parity with web)

### Web app
- [ ] Fix `timpaynefans.vercel.app` domain to permanently point to the `no-payne-no-gain` Vercel project (remove from `dist` project, add in `no-payne-no-gain` project settings)
- [ ] Deploy latest web changes (liquid glass UI, Tim's Card, quiz, legal pages)
- [ ] Backend for real global tap counter (currently client-side approximation)
