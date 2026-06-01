@AGENTS.md

# No Payne No Gain — Project State

Fan app for Tim Payne, NZ right back who went viral at the 2026 FIFA World Cup after Argentine influencer El Scarso found him with 4,715 Instagram followers and asked the internet to follow him. He hit 2.5M followers in 48 hours.

Live at: **https://timpaynefans.vercel.app**

---

## Two codebases

### 1. Web app — `web/index.html` (LIVE, production)
Single-file vanilla HTML/JS/CSS app deployed to Vercel. This is what users actually see.

- **Deploy**: `cd web && vercel --prod`, then `vercel alias <url> timpaynefans.vercel.app`
- **Vercel project**: `no-payne-no-gain` (linked in `web/.vercel/project.json`)
- **Assets**: `web/tim.png` (Panini card photo), `web/vercel.json`

**Features built:**
- Panini sticker card hero with shine-on-hover animation, links to Tim's Instagram
- Tap-for-Tim button with emoji particle burst and live global counter (starts at 4,715, scales with taps × 347)
- 4-tab nav: Hype / Missions / Chants / Profile
- 5 daily missions with progress bars and Payne Points
- 12-badge collection (common → rare → epic → legendary) with unlock modal
- Chant generator (name + country fills one of 4 templates) + browsable carousel
- 30-day streak tracker
- OG meta tags (`og:image`, `og:image:width`, `og:image:height`) for social sharing previews

**Design tokens**: Phoenix yellow `#F0C130`, dark bg `#070A0D`, Playfair Display + DM Sans + Oswald

### 2. React Native app — repo root (built, not yet deployed)
Expo SDK 54 / React Native 0.76.9 app. Mirrors the web app feature-for-feature but as a proper native app.

**Structure:**
```
App.tsx                        # Entry point (React Navigation)
app/_layout.tsx                # Expo Router layout (alternative entry)
app/(tabs)/_layout.tsx         # Tab navigator via Expo Router
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
    gameState.ts               # State logic
  constants/
    gameData.ts                # CHANTS, BADGES, MISSIONS, TIM_FACTS
    theme.ts                   # Colors, Fonts constants
```

**Config**: `app.json` (bundle ID: `com.nopayne.nogain`), `eas.json` (EAS build configured)

**Fonts**: `@expo-google-fonts/playfair-display`, `@expo-google-fonts/dm-sans`

**Note**: There are two navigation approaches in the repo — `App.tsx` uses React Navigation directly, `app/_layout.tsx` uses Expo Router. These need to be reconciled before shipping the native app.

---

## What's next

- [ ] Reconcile dual navigation: choose Expo Router (`app/`) or React Navigation (`App.tsx`) — not both
- [ ] Add `AsyncStorage` or `expo-secure-store` for persistent state (taps, streak, badges survive app restarts)
- [ ] EAS build + TestFlight submission for iOS
- [ ] Push notification for daily streak reminder
- [ ] Share sheet for chant cards (styled image, not just text)
- [ ] Link the native app's tap counter to the web app's global count (need a backend — Supabase or simple KV)
