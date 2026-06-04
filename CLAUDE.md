@AGENTS.md

# No Payne No Gain — Project State

Fan app for Tim Payne, NZ right back who went viral at the 2026 FIFA World Cup after Argentine influencer El Scarso found him with 4,715 Instagram followers and asked the internet to follow him. He hit 4.7M followers.

Live at: **https://timpaynefans.com** (custom domain, aliased to `no-payne-no-gain` Vercel project)

---

## Two codebases

### 1. Web app — `web/index.html` (LIVE, production)
Single-file vanilla HTML/JS/CSS app deployed to Vercel. This is what users actually see.

- **Deploy**: ALWAYS `cd web && vercel --prod` — must run from `web/` directory, NOT project root
- **Vercel project**: `no-payne-no-gain` (`prj_Ek6yzmcyVRo2qPFkI9NErI3LBsXq`, linked in `web/.vercel/project.json`)
- **Domain**: `timpaynefans.com` — permanently aliased. No manual alias step needed after deploy.
- **Assets**: `web/tim.png`, `web/vercel.json`, `web/images/` (category + onboarding images), `web/og-image.png`

**Features built:**
- **Light mode design** — `#F5F4F0` background, white cards, `#F0C130` gold accent, Playfair Display + DM Sans + Oswald
- Panini sticker card hero with shine-on-hover animation, links to Tim's Instagram
- **5-tab nav** (Quiz / Hype / Misiones / Cantos / Perfil) with Font Awesome icons
- **Quiz hub** (Quiz tab, first) — featured card with animated gold glow + floating particles; 6 category cards with real background images (single-column, 16:9, top-image + bottom-text layout); 35-question main bank + 6×10 category banks; 5 random questions per session; correct/wrong animations (confetti, ✕ overlay, combo badge, "+1" float); result card with shareable percentage
- **Match Predictions** (top of Misiones tab) — 3 NZ Group G matches, 4 questions each, 50pts per correct, lock mechanic, countdown timer, leaderboard card
- Daily missions with progress bars and Payne Points
- 8-badge collection with unlock modal
- Chant generator + browsable carousel
- 30-day streak tracker
- Instagram follower card (rainbow gradient "4.7M+")
- **Onboarding flow** — 3 slides, first-visit only (`localStorage: onboarding_seen`), full-screen gradient backgrounds (pink→magenta, navy, pink→coral), real images (`onboard1/2/3.png`), crossfade transitions, scroll lock, notch/Dynamic Island safe area, button-only navigation
- **Legal pages**: `/privacy`, `/terms`, `/data-compliance`, `/trademark`
- **OG image**: `web/og-image.html` (1200×630 screenshot source), `web/og-image.png` (deployed asset)
- **Security**: CSP headers, X-Frame-Options, X-Content-Type-Options, Referrer-Policy, Permissions-Policy in `web/vercel.json`; `escapeHtml()` on chant generator inputs; `.vercel/` in `.gitignore`

**All UI in Argentine/LATAM Spanish** — "vos" form, proper nouns preserved (Tim Payne, El Scarso, Wellington Phoenix, FIFA, etc.)

**Design tokens**: Gold `#F0C130`, dark gold `#C8960C`, light bg `#F5F4F0`, dark `#0A0A0A`, Playfair Display + DM Sans + Oswald

**web/images/ assets:**
- `mundial_2026_graphic.png`, `tim_payne_lore.png`, `name_that_boot_compressed.jpg`, `best_in_the_world_compressed.jpg`, `name_the_match_ball_compressed.jpg`, `football_iq_compressed.jpg` — category card backgrounds
- `hero_card.jpg` — (unused, replaced by animated gradient on featured card)
- `onboard1.png`, `onboard2.png`, `onboard3.png` — onboarding slide illustrations (600×600)
- `og-image.png` — OG social share image (1200×630)

**⚠️ Deploy from `web/` only**: Running `vercel --prod` from project root deploys the wrong directory (61 files vs 16). Always `cd web && vercel --prod`.

---

### 2. React Native app — repo root (built, not yet deployed)
Expo SDK 54 / React Native 0.76.9 app. Not actively developed this session — web is the focus.

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
  screens/ components/ hooks/ lib/ constants/
```

**Config**: `app.json` (bundle ID: `com.nopayne.nogain`), `eas.json`

**⚠️ Navigation**: Two approaches co-exist (`App.tsx` React Navigation + `app/_layout.tsx` Expo Router). Must reconcile before shipping.

**Dependencies**: `@react-native-async-storage/async-storage@2.2.0` — do NOT upgrade to v3.x (Hermes incompatible).

---

## What's next

### Web app
- [ ] Backend for real global tap/follower counter (currently static)
- [ ] Real match results — update `NZ_MATCHES[].result` after each Group G game to unlock prediction scoring
- [ ] Screenshot `web/og-image.html` at 1200×630 and redeploy if OG image needs refresh
- [ ] Add `lang="es"` consistency check across legal pages

### Native app
- [ ] Reconcile dual navigation: delete `App.tsx`, commit to Expo Router (`app/`)
- [ ] EAS build + install on device via TestFlight or direct IPA
- [ ] Bring native app to parity with web (quiz hub, predictions, Spanish UI, onboarding)
