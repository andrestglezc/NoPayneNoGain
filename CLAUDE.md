# No Payne No Gain — iOS Native (SwiftUI)

## Status: Native iOS 26 rebuild, 5 days to NZ vs Iran (June 16)

## Done
- 5-tab structure: Quiz / Hype / Misiones / Cantos / Perfil
- Quiz hub: 7 categories, 70+ questions, featured + 2-col grid
- Quiz game (neo-brutalism redesign): top bar with live ⚽ score counter, chunky gold progress bar, left-aligned bold question, 4 bright A/B/C/D answer blocks (pink/green/gold/blue, 72pt, hard offset shadow, press scale, correct pulses green + others dim 40%), confetti on correct (CAEmitterLayer), red X on wrong, 3s/1.2s advance, tab bar hidden, haptics. Result card: X/5 + tiered headline (¡PERFECTO!→¡Seguí practicando!), ShareLink + Intentar de nuevo
- Hype: native SwiftUI Panini card 335×444 (photo + banners + FIFA badge), holographic with CoreMotion device-tilt shine, graceful time-based idle float (TimelineView), drag tilt with seamless resume, "Conoce a Tim Payne" section, La Leyenda stats grid, rainbow 5M+ counter, IG CTA
- Misiones: 3 match prediction cards (Iran/Egypt/Belgium) with live countdowns, confirm flow, persisted picks, Mejores Predictores score card with ShareLink, Misiones Diarias with streak banner
- Cantos: rhyming chant generator + 14 fan chants, fully dark theme (#070A0D bg, #12121A cards, gold generate button)
- Figurita (KILLER FEATURE): "Crea tu figurita personalizada" — user makes their own holo Panini card (PhotosPicker photo, name, country, birthdate, height, weight, auto-earned rarity Común→Legendario), exports/shares via ImageRenderer. Entry point in Perfil. (FiguritaView.swift)
- Perfil (redesigned): Figurita CTA banner, FanIdentityCard with fan rank (Hincha→Leyenda), badge collection, Follow Tim card, about + legal
- AppState: @Observable + UserDefaults persistence
- Global dark nav/tab bar appearance (#070A0D)
- Assets: tim-photo (1x/2x/3x), panini-card (legacy), app icon
- Extensions.swift: shared Color(hex:) helper

## TODO
- (all four prior TODOs done: Quiz redesign, Figurita, Perfil redesign, app icon)
- Commit the Figurita + Perfil + Quiz/Cantos work (still uncommitted as of June 11)
- QA full app on device before June 16

## Key technical notes
- Zero external dependencies — pure SwiftUI + CoreMotion + CAEmitterLayer
- Idle card motion is TimelineView time-based (sin/cos), NOT repeatForever — prevents jump-on-release
- Bundle ID: com.nopayne.nogain, Team 7YH8CW7T2X
- ascAppId: 6778185257 (App Store Connect, listing created)
- Xcode 26.5, iOS 26 target, iPhone 13 Pro test device
