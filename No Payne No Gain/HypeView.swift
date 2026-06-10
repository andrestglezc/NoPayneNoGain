import SwiftUI
import CoreMotion

// MARK: - HypeView

struct HypeView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "#070A0D").ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 24) {
                        TiltablePaniniCard()
                        TitleSection()
                        OriginStoryCard()
                        LaLeyendaSection()
                        FollowerCounterCard()
                        CTAButton()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle("Hype")
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }
}

// MARK: - Panini Card (holographic + time-based idle float + drag tilt)

private struct TiltablePaniniCard: View {
    // Drag state
    @State private var isDragging    = false
    @State private var dragOffset: CGSize = .zero
    // Absolute timestamps for smooth blend-in / blend-out
    @State private var dragStartEpoch: Double = 0
    @State private var dragEndEpoch:   Double = -.infinity  // far past → blend = 1 at launch
    // CoreMotion holographic shine
    @State private var motion = MotionManager()
    // Entrance
    @State private var cardScale: CGFloat = 0.9

    // Smoothstep easing for the idle blend factor
    private func smoothstep(_ x: Double) -> Double { x * x * (3.0 - 2.0 * x) }

    var body: some View {
        TimelineView(.animation) { ctx in
            let t = ctx.date.timeIntervalSinceReferenceDate

            // ── Continuous idle rotation (always running, absolute-time sine waves) ──
            let idleRotX = cos(t * .pi / 2.75) * 2.0  // ~5.5 s period
            let idleRotY = sin(t * .pi / 3.5)  * 4.5  // 7 s period
            let idleBob  = CGFloat(sin(t * .pi / 2.75) * 5.0)  // 5.5 s period

            // ── Blend factor: idle fades OUT over 0.25 s when drag starts,
            //                  fades IN over 0.6 s after drag ends ──────────
            let idleBlend: Double = {
                if isDragging {
                    let e = min(1.0, (t - dragStartEpoch) / 0.25)
                    return 1.0 - smoothstep(e)
                } else {
                    let e = min(1.0, max(0.0, (t - dragEndEpoch) / 0.6))
                    return smoothstep(e)
                }
            }()

            // ── Drag contribution ─────────────────────────────────────────────────
            let dragRotX =  Double(dragOffset.height) / 10.0
            let dragRotY = -Double(dragOffset.width)  / 10.0

            // ── Final rotation (blend idle + drag, clamped ±12°) ─────────────────
            let rotX = max(-12, min(12, idleRotX * idleBlend + dragRotX))
            let rotY = max(-12, min(12, idleRotY * idleBlend + dragRotY))
            let bobY = idleBob * CGFloat(idleBlend)

            // ── Holographic shine: device motion (60%) + card tilt (40%) ───────
            let (holoX, holoY): (Double, Double) = {
                if motion.isAvailable {
                    let mx = max(-1.0, min(1.0, motion.roll  / (.pi / 4.0)))
                    let my = max(-1.0, min(1.0, motion.pitch / (.pi / 4.0)))
                    return (mx * 0.6 + (rotY / 12.0) * 0.4,
                            my * 0.6 + (rotX / 12.0) * 0.4)
                }
                return (rotY / 8.0, rotX / 8.0)  // fallback: tilt-only
            }()

            PaniniCardView()
                .overlay {
                    LinearGradient(
                        colors: [.red, .orange, .yellow, .green, .cyan, .blue, .purple],
                        startPoint: UnitPoint(x: 0.5 - holoX, y: 0.5 - holoY),
                        endPoint:   UnitPoint(x: 0.5 + holoX, y: 0.5 + holoY)
                    )
                    .opacity(0.45)
                    .blendMode(.overlay)
                }
                .overlay {
                    LinearGradient(
                        colors: [.purple, .blue, .cyan, .green, .yellow, .orange, .red],
                        startPoint: UnitPoint(x: 0.5 - holoY, y: 0.5 + holoX),
                        endPoint:   UnitPoint(x: 0.5 + holoY, y: 0.5 - holoX)
                    )
                    .opacity(0.20)
                    .blendMode(.colorDodge)
                }
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .compositingGroup()
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color(hex: "#8a6d12"), lineWidth: 3)
                )
                .shadow(color: .black.opacity(0.6), radius: 28, x: -rotY * 2.5, y: 14 - rotX * 2)
                .scaleEffect(cardScale)
                .offset(y: bobY)
                .rotation3DEffect(.degrees(rotX), axis: (x: 1, y: 0, z: 0))
                .rotation3DEffect(.degrees(rotY), axis: (x: 0, y: 1, z: 0))
        }
        // Fixed card size, centered horizontally
        .frame(width: 335, height: 444)
        .frame(maxWidth: .infinity)
        .gesture(
            DragGesture()
                .onChanged { value in
                    if !isDragging {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        isDragging     = true
                        dragStartEpoch = Date().timeIntervalSinceReferenceDate
                    }
                    dragOffset = CGSize(
                        width:  max(-120, min(120, value.translation.width)),
                        height: max(-120, min(120, value.translation.height))
                    )
                }
                .onEnded { _ in
                    isDragging    = false
                    dragEndEpoch  = Date().timeIntervalSinceReferenceDate
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                        dragOffset = .zero
                    }
                }
        )
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                cardScale = 1.0
            }
        }
        .onDisappear {
            // Reset scale so re-entrance replays on tab return
            withAnimation(.none) { cardScale = 0.9 }
            dragOffset    = .zero
            isDragging    = false
            dragEndEpoch  = -.infinity  // idle resumes immediately on re-appear
        }
    }
}

// MARK: - Panini Card (native SwiftUI)
// Fixed layout: 335 × 444 pt.  Heights: banner 36 + divider 2 + photo 326 + bottom 80 = 444.

private struct PaniniCardView: View {
    var body: some View {
        ZStack(alignment: .topTrailing) {
            LinearGradient(
                colors: [Color(hex: "#F0C130"), Color(hex: "#C49A1A")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            VStack(spacing: 0) {
                topBanner                          // 36 pt
                Rectangle()
                    .fill(Color(hex: "#8a6d12"))
                    .frame(width: 335, height: 2)  // 2 pt
                photoArea                          // 326 pt
                bottomBanner                       // 80 pt  →  total 444 pt
            }

            fifaBadge
                .padding(.top, 12)
                .padding(.trailing, 12)
        }
        .frame(width: 335, height: 444)
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }

    // MARK: Top banner — 335 × 36

    private var topBanner: some View {
        Text("NEW ZEALAND")
            .font(.system(size: 13, weight: .bold))
            .kerning(4)
            .textCase(.uppercase)
            .foregroundStyle(.black)
            .frame(width: 335, height: 36)
            .background(Color(hex: "#C9920A").opacity(0.55))
    }

    // MARK: Photo area — 335 × 326

    private var photoArea: some View {
        ZStack {
            playerPhoto                            // fills 335 × 326, clipped

            Text("TIM PAYNE")                      // watermark on top
                .font(.system(size: 80, weight: .black))
                .foregroundStyle(.white.opacity(0.15))
                .rotationEffect(.degrees(-18))
                .lineLimit(1)
                .fixedSize()
                .allowsHitTesting(false)
        }
        .frame(width: 335, height: 326)
        .clipped()
    }

    @ViewBuilder
    private var playerPhoto: some View {
        if UIImage(named: "tim-photo") != nil {
            Image("tim-photo")
                .resizable()
                .scaledToFill()
                .frame(width: 335, height: 326)
                .clipped()
        } else {
            ZStack {
                LinearGradient(
                    colors: [Color(hex: "#1A2D50"), Color(hex: "#080810")],
                    startPoint: .top,
                    endPoint: .bottom
                )
                Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150)
                    .foregroundStyle(Color.white.opacity(0.18))
            }
            .frame(width: 335, height: 326)
        }
    }

    // MARK: Bottom banner — 335 × 80
    // Black rounded rect (319 × 60) centered in the 335 × 80 container.

    private var bottomBanner: some View {
        VStack(spacing: 4) {
            Text("TIM PAYNE")
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(Color(hex: "#F0C130"))
            Text("#6 · RIGHT BACK")
                .font(.system(size: 12))
                .kerning(2)
                .foregroundStyle(.white.opacity(0.6))
        }
        .frame(width: 319, height: 60)
        .background(Color(hex: "#0D0D0D"))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .frame(width: 335, height: 80)
    }

    // MARK: FIFA badge — 64 × 90, inset 12 pt from top-right

    private var fifaBadge: some View {
        VStack(spacing: 3) {
            Text("FIFA")
                .font(.system(size: 13, weight: .black))
                .kerning(1)
                .foregroundStyle(Color(hex: "#F0C130"))
            Text("WORLD")
                .font(.system(size: 10, weight: .bold))
                .kerning(0.8)
                .foregroundStyle(Color(hex: "#F0C130"))
            Text("CUP")
                .font(.system(size: 10, weight: .bold))
                .kerning(0.8)
                .foregroundStyle(Color(hex: "#F0C130"))
            Text("2026")
                .font(.system(size: 14, weight: .black))
                .foregroundStyle(Color(hex: "#F0C130"))
        }
        .frame(width: 64, height: 90)
        .background(Color(hex: "#1A1A2E"))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

// MARK: - Title Section

private struct TitleSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("⚽ FIFA World Cup 2026")
                .font(.system(size: 11, weight: .semibold))
                .kerning(1.5)
                .textCase(.uppercase)
                .foregroundStyle(Color.white.opacity(0.4))

            Text("Conoce a Tim Payne")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.white)

            (Text("El jugador de la Copa · ")
                .foregroundStyle(Color.white.opacity(0.55))
            + Text("All Whites")
                .foregroundStyle(Color(hex: "#F0C130"))
            + Text(" · Grupo G")
                .foregroundStyle(Color.white.opacity(0.55)))
            .font(.system(size: 15, weight: .medium))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Origin Story Card

private struct OriginStoryCard: View {
    private let story = """
El influencer argentino El Scarso buscó en todos los planteles del World Cup al jugador menos conocido. Encontró a Tim Payne — un lateral derecho de Wellington con 4.715 seguidores en Instagram.

Le pidió a internet que lo siguiera. En menos de 48 horas, Tim llegó a 2,5 millones. Las marcas aparecieron. Se escribió una canción. Se imprimieron remeras en Buenos Aires.

Tim le mandó un DM a El Scarso: "Me preguntaba por qué mis redes explotaban."
"""

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Cómo empezó")
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(.white)

            Text(story)
                .font(.system(size: 15))
                .foregroundStyle(Color.white.opacity(0.72))
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)

            Text("No Payne, No Gain. 🏆")
                .font(.system(size: 16, weight: .semibold))
                .italic()
                .foregroundStyle(Color(hex: "#00A859"))
        }
        .padding(20)
        .background(Color(hex: "#12121A"))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

// MARK: - La Leyenda Section

private let leyendaItems: [(emoji: String, value: String, label: String)] = [
    ("🏆", "World Cup 2026",      "TORNEO"),
    ("🏟️", "Wellington Phoenix", "CLUB"),
    ("🌍", "G",                   "GRUPO"),
    ("⚡", "Lateral derecho",     "POSICIÓN"),
    ("🇳🇿", "New Zealand",       "NACIÓN"),
    ("🚀", "5M+ fans",            "PICO"),
]

private struct LaLeyendaSection: View {
    @State private var appeared = false

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("La Leyenda")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(.white)

            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 3),
                spacing: 10
            ) {
                ForEach(Array(leyendaItems.enumerated()), id: \.offset) { index, item in
                    LeyendaCard(emoji: item.emoji, value: item.value, label: item.label)
                        .opacity(appeared ? 1 : 0)
                        .offset(y: appeared ? 0 : 18)
                        .animation(
                            .spring(response: 0.5, dampingFraction: 0.7)
                                .delay(Double(index) * 0.05),
                            value: appeared
                        )
                }
            }
        }
        .onAppear { appeared = true }
    }
}

private struct LeyendaCard: View {
    let emoji: String
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 6) {
            Text(emoji)
                .font(.system(size: 22))
            Text(value)
                .font(.system(size: 11, weight: .bold))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.75)
            Text(label)
                .font(.system(size: 8, weight: .semibold))
                .kerning(0.8)
                .foregroundStyle(Color.white.opacity(0.38))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .padding(.horizontal, 6)
        .background(Color(hex: "#12121A"))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

// MARK: - Follower Counter Card (rainbow shimmer)

private struct FollowerCounterCard: View {
    @State private var shimmerShifted = false

    private var gradientStart: UnitPoint {
        shimmerShifted ? UnitPoint(x: 0.2, y: 0.0) : UnitPoint(x: -0.3, y: 0.5)
    }
    private var gradientEnd: UnitPoint {
        shimmerShifted ? UnitPoint(x: 1.2, y: 1.0) : UnitPoint(x: 1.0,  y: 0.5)
    }

    var body: some View {
        VStack(spacing: 8) {
            Text("El Ejército de Tim — Seguidores en Instagram")
                .font(.system(size: 10, weight: .semibold))
                .kerning(1.2)
                .textCase(.uppercase)
                .foregroundStyle(Color.white.opacity(0.4))
                .multilineTextAlignment(.center)

            Text("5M+")
                .font(.system(size: 72, weight: .black))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.red, .orange, .yellow, .green, .blue, .purple],
                        startPoint: gradientStart,
                        endPoint: gradientEnd
                    )
                )
                .animation(.linear(duration: 2).repeatForever(autoreverses: true), value: shimmerShifted)

            Text("y subiendo 🚀")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 28)
        .padding(.horizontal, 20)
        .background(Color(hex: "#12121A"))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .onAppear { shimmerShifted = true }
    }
}

// MARK: - CTA Button

private struct CTAButton: View {
    @Environment(\.openURL) private var openURL

    var body: some View {
        VStack(spacing: 10) {
            Button {
                openURL(URL(string: "https://www.instagram.com/timpayne__/")!)
            } label: {
                HStack {
                    Spacer()
                    Text("Seguir a Tim en Instagram →")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(.black)
                    Spacer()
                }
                .frame(height: 56)
                .background(Color(hex: "#F0C130"))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .buttonStyle(PressScaleButtonStyle())

            Text("¿Todavía no lo seguís? Únete a 5M+ de fans.")
                .font(.system(size: 12))
                .foregroundStyle(Color.white.opacity(0.38))
                .multilineTextAlignment(.center)
        }
    }
}

private struct PressScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

// MARK: - Motion

@Observable
final class MotionManager {
    private(set) var roll:        Double = 0
    private(set) var pitch:       Double = 0
    private(set) var isAvailable: Bool   = false
    private let cm = CMMotionManager()

    init() {
        isAvailable = cm.isDeviceMotionAvailable
        guard isAvailable else { return }
        cm.deviceMotionUpdateInterval = 1.0 / 60.0
        cm.startDeviceMotionUpdates(to: .main) { [weak self] data, _ in
            guard let self, let data else { return }
            self.roll  = self.roll  * 0.85 + data.attitude.roll  * 0.15
            self.pitch = self.pitch * 0.85 + data.attitude.pitch * 0.15
        }
    }

    deinit { cm.stopDeviceMotionUpdates() }
}

// MARK: - Color helper

extension Color {
    init(hex: String) {
        let h = hex.trimmingCharacters(in: CharacterSet(charactersIn: "#"))
        var rgb: UInt64 = 0
        Scanner(string: h).scanHexInt64(&rgb)
        let r = Double((rgb >> 16) & 0xFF) / 255
        let g = Double((rgb >> 8)  & 0xFF) / 255
        let b = Double(rgb         & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}

#Preview {
    HypeView()
}
