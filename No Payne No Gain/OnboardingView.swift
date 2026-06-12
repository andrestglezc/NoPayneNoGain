import SwiftUI

// MARK: - Root

struct OnboardingView: View {
    @Environment(AppState.self) private var appState
    @State private var currentPage = 0
    @State private var fanName = ""

    var body: some View {
        ZStack {
            Color(hex: "#070A0D").ignoresSafeArea()

            TabView(selection: $currentPage) {
                OnboardingPage1(currentPage: $currentPage)
                    .tag(0)
                OnboardingPage2(currentPage: $currentPage)
                    .tag(1)
                OnboardingPage3(currentPage: $currentPage)
                    .tag(2)
                OnboardingPage4(fanName: $fanName, onComplete: complete)
                    .tag(3)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
    }

    private func complete() {
        appState.fanName = fanName.trimmingCharacters(in: .whitespaces)
        appState.hasSeenOnboarding = true
    }
}

// MARK: - Shared: page dots (4 screens)

private struct PageDots: View {
    let current: Int
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<4, id: \.self) { i in
                Circle()
                    .fill(i == current
                          ? Color(hex: "#F0C130")
                          : Color.white.opacity(0.25))
                    .frame(width: i == current ? 8 : 6,
                           height: i == current ? 8 : 6)
                    .animation(.easeInOut(duration: 0.2), value: current)
            }
        }
    }
}

// MARK: - Screen 1: La Historia

private struct OnboardingPage1: View {
    @Binding var currentPage: Int
    @State private var shimmerShifted = false
    @State private var hasAppeared = false

    private var gradientStart: UnitPoint {
        shimmerShifted ? UnitPoint(x: 0.2, y: 0.0) : UnitPoint(x: -0.3, y: 0.5)
    }
    private var gradientEnd: UnitPoint {
        shimmerShifted ? UnitPoint(x: 1.2, y: 1.0) : UnitPoint(x: 1.0, y: 0.5)
    }

    var body: some View {
        ZStack {
            Color(hex: "#070A0D").ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                Text("⚡")
                    .font(.system(size: 80))
                    .padding(.bottom, 28)

                Text("De desconocido al\nfavorito del Mundial")
                    .font(.system(size: 40, weight: .black))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.7)
                    .padding(.horizontal, 28)
                    .padding(.bottom, 16)

                Text("Un influencer argentino lo spotteó.\nEl internet explotó.")
                    .font(.system(size: 16))
                    .foregroundColor(.white.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .lineLimit(4)
                    .padding(.horizontal, 32)
                    .padding(.bottom, 40)

                VStack(spacing: 0) {
                    HStack {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("ANTES")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(Color(hex: "#F0C130"))
                                .kerning(1.2)
                            Text("4.715 seguidores")
                                .font(.system(size: 28, weight: .black))
                                .foregroundColor(.white)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 20)

                    Rectangle()
                        .fill(Color.white.opacity(0.08))
                        .frame(height: 1)

                    HStack {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("DESPUÉS")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(Color(hex: "#F0C130"))
                                .kerning(1.2)
                            Text("5M+ seguidores")
                                .font(.system(size: 28, weight: .black))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.red, .orange, .yellow, .green, .blue, .purple],
                                        startPoint: gradientStart,
                                        endPoint: gradientEnd
                                    )
                                )
                                .animation(
                                    .linear(duration: 2).repeatForever(autoreverses: true),
                                    value: shimmerShifted
                                )
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 20)
                }
                .background(Color(hex: "#12121A"))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color(hex: "#F0C130"), lineWidth: 1)
                )
                .padding(.horizontal, 24)

                Spacer()
            }

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    PageDots(current: 0)
                    Spacer()
                }
                .overlay(alignment: .trailing) {
                    Button {
                        withAnimation(.easeInOut(duration: 0.35)) { currentPage = 1 }
                    } label: {
                        Text("Siguiente →")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .padding(.trailing, 28)
                }
                .padding(.bottom, 56)
            }
        }
        .onAppear {
            guard !hasAppeared else { return }
            hasAppeared = true
            shimmerShifted = true
        }
    }
}

// MARK: - Screen 2: Tu Cuartel General

private struct OnboardingPage2: View {
    @Binding var currentPage: Int
    @State private var cardsVisible = [false, false, false, false, false]
    @State private var hasAppeared = false

    private let features: [(String, String, String)] = [
        ("🃏", "Crea tu figurita",   "Tu propia carta holográfica del Mundial"),
        ("🧠", "Quiz",               "70+ preguntas sobre Tim y los All Whites"),
        ("🎯", "Predicciones",       "Adiviná los resultados de Nueva Zelanda"),
        ("🎵", "Cantos",             "14 cantos + generador de hits"),
        ("🔥", "Rachas y logros",    "Volvé cada día y subí de rango"),
    ]

    var body: some View {
        ZStack {
            Color(hex: "#070A0D").ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                Text("Todo lo que\npodés hacer")
                    .font(.system(size: 36, weight: .black))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 28)
                    .padding(.bottom, 32)

                VStack(spacing: 10) {
                    ForEach(features.indices, id: \.self) { i in
                        HStack(spacing: 14) {
                            Text(features[i].0)
                                .font(.system(size: 24))
                                .frame(width: 40)
                            VStack(alignment: .leading, spacing: 3) {
                                Text(features[i].1)
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundColor(.white)
                                Text(features[i].2)
                                    .font(.system(size: 12))
                                    .foregroundColor(.white.opacity(0.5))
                            }
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .background(Color(hex: "#12121A"))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .offset(y: cardsVisible[i] ? 0 : 28)
                        .opacity(cardsVisible[i] ? 1 : 0)
                    }
                }
                .padding(.horizontal, 24)

                Spacer()
            }

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    PageDots(current: 1)
                    Spacer()
                }
                .overlay(alignment: .trailing) {
                    Button {
                        withAnimation(.easeInOut(duration: 0.35)) { currentPage = 2 }
                    } label: {
                        Text("Siguiente →")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .padding(.trailing, 28)
                }
                .padding(.bottom, 56)
            }
        }
        .onAppear {
            guard !hasAppeared else { return }
            hasAppeared = true
            for i in features.indices {
                withAnimation(.easeOut(duration: 0.45).delay(Double(i) * 0.12 + 0.15)) {
                    cardsVisible[i] = true
                }
            }
        }
    }
}

// MARK: - Screen 3: Figurita Showcase

private struct OnboardingPage3: View {
    @Binding var currentPage: Int

    var body: some View {
        ZStack {
            Color(hex: "#070A0D").ignoresSafeArea()

            // Radial gold glow behind card
            RadialGradient(
                colors: [Color(hex: "#F0C130").opacity(0.08), .clear],
                center: .center,
                startRadius: 0,
                endRadius: 180
            )
            .frame(width: 360, height: 360)

            VStack(spacing: 0) {
                Spacer()

                Text("Tu propia figurita\ndel Mundial")
                    .font(.system(size: 36, weight: .black))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 28)
                    .padding(.bottom, 28)

                // Idle-floating showcase card using FiguritaCardView (non-private)
                TimelineView(.animation) { ctx in
                    let t = ctx.date.timeIntervalSinceReferenceDate
                    let rotX = cos(t * .pi / 2.75) * 2.0
                    let rotY = sin(t * .pi / 3.5)  * 4.5
                    let bobY = CGFloat(sin(t * .pi / 2.75) * 4.0)

                    FiguritaCardView(
                        userName: "FAN LEGENDARIO",
                        userCountry: "ARGENTINA",
                        rarity: .legendario,
                        userImage: nil,
                        fanNumber: 1_000_001,
                        birthDate: "", height: "", weight: "",
                        borderAngle: t * 40.0
                    )
                    .frame(width: 335, height: 444)
                    .scaleEffect(CGFloat(280.0 / 335.0))
                    .frame(width: 280, height: 371)
                    .offset(y: bobY)
                    .rotation3DEffect(.degrees(rotX), axis: (x: 1, y: 0, z: 0))
                    .rotation3DEffect(.degrees(rotY), axis: (x: 0, y: 1, z: 0))
                }
                .frame(width: 280, height: 371)

                Text("Subí tu foto. Elegí tu país. Conseguí tu rareza.")
                    .font(.system(size: 15))
                    .foregroundColor(.white.opacity(0.55))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .padding(.top, 24)

                Spacer()
            }

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    PageDots(current: 2)
                    Spacer()
                }
                .overlay(alignment: .trailing) {
                    Button {
                        withAnimation(.easeInOut(duration: 0.35)) { currentPage = 3 }
                    } label: {
                        Text("Siguiente →")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .padding(.trailing, 28)
                }
                .padding(.bottom, 56)
            }
        }
    }
}

// MARK: - Screen 4: Elegí tu nombre

private struct OnboardingPage4: View {
    @Binding var fanName: String
    let onComplete: () -> Void
    @FocusState private var fieldFocused: Bool

    private var canProceed: Bool {
        NameValidator.isValid(fanName.trimmingCharacters(in: .whitespaces))
    }

    var body: some View {
        ZStack {
            Color(hex: "#070A0D").ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                Text("¿Cómo te llamás?")
                    .font(.system(size: 36, weight: .black))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 28)
                    .padding(.bottom, 12)

                Text("Así vas a aparecer en el ejército de Tim.")
                    .font(.system(size: 15))
                    .foregroundColor(.white.opacity(0.55))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .padding(.bottom, 36)

                TextField("", text: $fanName, prompt:
                    Text("Tu nombre o apodo")
                        .foregroundColor(.white.opacity(0.3))
                )
                .font(.system(size: 18))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
                .padding(.vertical, 18)
                .background(Color(hex: "#12121A"))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(hex: "#F0C130"), lineWidth: 1.5)
                )
                .padding(.horizontal, 28)
                .focused($fieldFocused)
                .submitLabel(.done)
                .onSubmit { if canProceed { onComplete() } }

                Button {
                    fanName = ""
                    onComplete()
                } label: {
                    Text("Saltar")
                        .font(.system(size: 13))
                        .foregroundColor(.white.opacity(0.35))
                }
                .padding(.top, 20)

                Spacer()
            }

            VStack {
                Spacer()
                PageDots(current: 3)
                    .padding(.bottom, 20)
                Button(action: onComplete) {
                    Text("Unirme al ejército 🔥")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color(hex: "#F0C130"))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .opacity(canProceed ? 1 : 0.5)
                .disabled(!canProceed)
                .padding(.horizontal, 24)
                .padding(.bottom, 48)
            }
        }
        .onTapGesture { fieldFocused = false }
    }
}
