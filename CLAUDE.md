# No Payne No Gain — iOS Native (SwiftUI)

## Status: Native iOS 26 rebuild, 6 days to NZ vs Iran (June 16)

## Done
- 5-tab structure: Quiz / Hype / Misiones / Cantos / Perfil
- Quiz: 7 categories, 70+ questions, confetti on correct (CAEmitterLayer burst), red X on wrong, tab bar hidden during quiz, centered layout
- Hype: native SwiftUI Panini card 335×444 (photo + banners + FIFA badge), holographic with CoreMotion device-tilt shine, graceful time-based idle float (TimelineView), drag tilt with seamless resume, "Conoce a Tim Payne" section, La Leyenda stats grid, rainbow 5M+ counter, IG CTA
- Misiones: 3 match prediction cards (Iran/Egypt/Belgium) with live countdowns, confirm flow, persisted picks, Mejores Predictores score card with ShareLink, Misiones Diarias with streak banner
- Cantos: rhyming chant generator + 14 fan chants, dark theme
- AppState: @Observable + UserDefaults persistence
- Global dark nav/tab bar appearance (#070A0D)
- Assets: tim-photo (1x/2x/3x), panini-card (legacy)

## TODO Tomorrow
1. Redesign Quiz section with proper cards (visual upgrade)
2. KILLER FEATURE: "Crea tu figurita personalizada" — user makes their own holo Panini card (their photo via PhotosPicker, name, country flag, FAN # number), reuses PaniniCardView engine, exports/shares as image (ImageRenderer). Entry point in Perfil.
3. Redesign Perfil section
4. Add app icon to Assets.xcassets (Andrés has it ready)

## Key technical notes
- Zero external dependencies — pure SwiftUI + CoreMotion + CAEmitterLayer
- Idle card motion is TimelineView time-based (sin/cos), NOT repeatForever — prevents jump-on-release
- Bundle ID: com.nopayne.nogain, Team 7YH8CW7T2X
- ascAppId: 6778185257 (App Store Connect, listing created)
- Xcode 26.5, iOS 26 target, iPhone 13 Pro test device
