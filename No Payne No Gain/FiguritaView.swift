import SwiftUI
import PhotosUI

// MARK: - Rarity (earned automatically from AppState)

enum FiguritaRarity: String, CaseIterable, Identifiable {
    case comun, raro, epico, legendario
    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .comun:      return "Común"
        case .raro:       return "Raro"
        case .epico:      return "Épico"
        case .legendario: return "Legendario"
        }
    }

    // Used for card border, rarity label, and bottom-strip first name
    var accentColor: Color {
        switch self {
        case .comun:      return Color(hex: "#8E8E93")
        case .raro:       return Color(hex: "#F0C130")
        case .epico:      return Color(hex: "#CE93D8")
        case .legendario: return Color(hex: "#FFD700")
        }
    }

    // Card background (Panini 2026 palette)
    var cardBackground: Color {
        switch self {
        case .comun:      return Color(hex: "#E8E8E8")
        case .raro:       return Color(hex: "#5BC8C8")
        case .epico:      return Color(hex: "#1A237E")
        case .legendario: return Color(hex: "#0D0D2B")
        }
    }
}

// MARK: - FiguritaView

struct FiguritaView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AppState.self) private var appState

    @AppStorage("fanNumber")         private var fanNumber:   Int    = 0
    @AppStorage("figuritaName")      private var userName:    String = ""
    @AppStorage("figuritaCountry")   private var userCountry: String = ""
    @AppStorage("figuritaBirthDate") private var birthDateISO: String = ""  // "yyyy-MM-dd"
    @AppStorage("figuritaHeight")    private var heightRaw:    String = ""  // raw number, e.g. "1.87"
    @AppStorage("figuritaWeight")    private var weightRaw:    String = ""  // raw number, e.g. "83"

    @State private var selectedItem:  PhotosPickerItem? = nil
    @State private var userImage:     UIImage?          = nil
    @State private var showShareSheet = false
    @State private var renderedImage: UIImage?          = nil
    @State private var isRendering = false

    private enum InputField { case name, country, height, weight }
    @FocusState private var focusedField: InputField?

    // ISO ⇆ display date formatters
    private static let isoFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        f.locale = Locale(identifier: "en_US_POSIX")
        return f
    }()
    private static let displayFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "d-M-yyyy"
        f.locale = Locale(identifier: "en_US_POSIX")
        return f
    }()
    private static let defaultBirthDate = isoFormatter.date(from: "2000-01-01") ?? Date()

    private var birthDateBinding: Binding<Date> {
        Binding(
            get: { Self.isoFormatter.date(from: birthDateISO) ?? Self.defaultBirthDate },
            set: { birthDateISO = Self.isoFormatter.string(from: $0) }
        )
    }

    // Card display strings (units baked in; empty when unset)
    private var birthDateDisplay: String {
        guard !birthDateISO.isEmpty, let d = Self.isoFormatter.date(from: birthDateISO) else { return "" }
        return Self.displayFormatter.string(from: d)
    }
    private var heightDisplay: String {
        let v = heightRaw.trimmingCharacters(in: .whitespaces)
        return v.isEmpty ? "" : "\(v.replacingOccurrences(of: ".", with: ",")) m"
    }
    private var weightDisplay: String {
        let v = weightRaw.trimmingCharacters(in: .whitespaces)
        return v.isEmpty ? "" : "\(v) kg"
    }

    private var rarity: FiguritaRarity {
        let pts    = appState.paynePoints
        let streak = appState.currentStreak
        if pts >= 500 || streak >= 30 { return .legendario }
        if pts >= 200 || streak >= 7  { return .epico }
        if pts >= 50  || streak >= 3  { return .raro }
        return .comun
    }

    private var effectiveFanNumber: Int {
        fanNumber == 0 ? 1_234_567 : fanNumber
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "#070A0D").ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 20) {
                        inputFields
                        cardWithPicker
                        rarityLabel
                        shareButton
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 48)
                }
            }
            .navigationTitle("Crea tu figurita")
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Listo") { dismiss() }
                        .foregroundStyle(Color(hex: "#F0C130"))
                        .fontWeight(.semibold)
                }
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Listo") { focusedField = nil }
                        .fontWeight(.semibold)
                }
            }
            .onChange(of: selectedItem) { _, item in
                Task {
                    if let data = try? await item?.loadTransferable(type: Data.self),
                       let img = UIImage(data: data) {
                        userImage = img
                    }
                }
            }
            .onAppear {
                if fanNumber == 0 {
                    fanNumber = Int.random(in: 1_000_000...9_999_999)
                }
            }
            .sheet(isPresented: $showShareSheet) {
                if let img = renderedImage {
                    ShareSheet(items: [
                        img,
                        "¡Soy parte del Ejército de Tim Payne! 🇳🇿⚽ #NoPayneNoGain #TimPayne timpaynefans.com"
                    ])
                }
            }
        }
    }

    // MARK: Input Fields

    private var inputFields: some View {
        VStack(spacing: 10) {
            HStack(spacing: 10) {
                Image(systemName: "person.fill")
                    .foregroundStyle(Color.white.opacity(0.35))
                    .frame(width: 18)
                TextField("Tu nombre completo", text: $userName)
                    .foregroundStyle(.white)
                    .tint(Color(hex: "#F0C130"))
                    .focused($focusedField, equals: .name)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color(hex: "#1A1A2E"))
            .clipShape(RoundedRectangle(cornerRadius: 12))

            HStack(spacing: 10) {
                Image(systemName: "flag.fill")
                    .foregroundStyle(Color.white.opacity(0.35))
                    .frame(width: 18)
                TextField("Tu país (ej: ARGENTINA)", text: $userCountry)
                    .foregroundStyle(.white)
                    .tint(Color(hex: "#F0C130"))
                    .textInputAutocapitalization(.characters)
                    .focused($focusedField, equals: .country)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color(hex: "#1A1A2E"))
            .clipShape(RoundedRectangle(cornerRadius: 12))

            // Birth date — native iOS roller via compact DatePicker
            HStack(spacing: 10) {
                Image(systemName: "calendar")
                    .foregroundStyle(Color.white.opacity(0.35))
                    .frame(width: 18)
                Text("Fecha de nacimiento")
                    .font(.system(size: 15))
                    .foregroundStyle(birthDateISO.isEmpty ? Color.white.opacity(0.35) : .white)
                Spacer()
                DatePicker("", selection: birthDateBinding, displayedComponents: .date)
                    .labelsHidden()
                    .datePickerStyle(.compact)
                    .tint(Color(hex: "#F0C130"))
                    .environment(\.colorScheme, .dark)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 9)
            .background(Color(hex: "#1A1A2E"))
            .clipShape(RoundedRectangle(cornerRadius: 12))

            // Height + weight — numeric fields with suffix labels
            HStack(spacing: 10) {
                suffixField(icon: "ruler", placeholder: "1,87", text: $heightRaw,
                            suffix: "m", keyboard: .decimalPad, field: .height)
                suffixField(icon: "scalemass.fill", placeholder: "83", text: $weightRaw,
                            suffix: "kg", keyboard: .numberPad, field: .weight)
            }
        }
    }

    private func suffixField(
        icon: String, placeholder: String, text: Binding<String>,
        suffix: String, keyboard: UIKeyboardType, field: InputField
    ) -> some View {
        HStack(spacing: 7) {
            Image(systemName: icon)
                .font(.system(size: 12))
                .foregroundStyle(Color.white.opacity(0.35))
            TextField(placeholder, text: text)
                .font(.system(size: 14))
                .foregroundStyle(.white)
                .tint(Color(hex: "#F0C130"))
                .keyboardType(keyboard)
                .focused($focusedField, equals: field)
            Text(suffix)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(Color.white.opacity(0.4))
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 13)
        .background(Color(hex: "#1A1A2E"))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    // MARK: Card + Picker

    private var cardWithPicker: some View {
        PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
            TiltableFiguritaCard(
                userName: userName.isEmpty ? "TU NOMBRE" : userName,
                userCountry: userCountry.isEmpty ? "FAN ARMY" : userCountry,
                rarity: rarity,
                userImage: userImage,
                fanNumber: effectiveFanNumber,
                birthDate: birthDateDisplay,
                height: heightDisplay,
                weight: weightDisplay
            )
        }
        .buttonStyle(.plain)
        .padding(.top, 16)
    }

    // MARK: Rarity Section

    private static let tierInfo: [(rarity: FiguritaRarity, emoji: String, requirement: String)] = [
        (.comun,      "⚪", "Nivel inicial"),
        (.raro,       "🟡", "50+ puntos o racha de 3 días"),
        (.epico,      "🟣", "200+ puntos o racha de 7 días"),
        (.legendario, "🏆", "500+ puntos o racha de 30 días"),
    ]

    private var rarityLabel: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Rareza: \(rarity.displayName.uppercased())")
                .font(.system(size: 15, weight: .black))
                .foregroundStyle(rarity.accentColor)

            VStack(alignment: .leading, spacing: 8) {
                ForEach(Self.tierInfo, id: \.rarity) { tier in
                    let isCurrent = tier.rarity == rarity
                    HStack(spacing: 8) {
                        Text(tier.emoji)
                            .font(.system(size: 13))
                        Text(tier.rarity.displayName)
                            .font(.system(size: 13, weight: isCurrent ? .bold : .regular))
                            .foregroundStyle(isCurrent ? tier.rarity.accentColor : Color.white.opacity(0.4))
                        Text("— \(tier.requirement)")
                            .font(.system(size: 12, weight: isCurrent ? .semibold : .regular))
                            .foregroundStyle(isCurrent ? Color.white.opacity(0.85) : Color.white.opacity(0.35))
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color(hex: "#12121A"))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    // MARK: Share Button

    private var shareButton: some View {
        Button {
            guard !isRendering else { return }
            isRendering = true
            Task {
                // Give SwiftUI a frame to lay out the card before snapshotting —
                // without this the first render captures a blank (black) frame.
                try? await Task.sleep(for: .milliseconds(300))

                let card = FiguritaCardView(
                    userName: userName.isEmpty ? "TU NOMBRE" : userName,
                    userCountry: userCountry.isEmpty ? "FAN ARMY" : userCountry,
                    rarity: rarity,
                    userImage: userImage,
                    fanNumber: effectiveFanNumber,
                    birthDate: birthDateDisplay,
                    height: heightDisplay,
                    weight: weightDisplay,
                    borderAngle: 0
                )
                .preferredColorScheme(.dark)

                let renderer = ImageRenderer(content: card)
                renderer.scale = UIScreen.main.scale  // crisp @3x on iPhone 13 Pro

                isRendering = false
                if let img = renderer.uiImage {
                    renderedImage = img
                    showShareSheet = true
                }
            }
        } label: {
            HStack {
                Spacer()
                if isRendering {
                    ProgressView()
                        .tint(.black)
                } else {
                    Text("Compartir mi figurita 📤")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(.black)
                }
                Spacer()
            }
            .frame(height: 56)
            .background(Color(hex: "#F0C130"))
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(FiguritaPressScaleStyle())
        .disabled(isRendering)
    }
}

// MARK: - Tiltable Figurita Card

private struct TiltableFiguritaCard: View {
    let userName: String
    let userCountry: String
    let rarity: FiguritaRarity
    let userImage: UIImage?
    let fanNumber: Int
    let birthDate: String
    let height: String
    let weight: String

    @State private var isDragging      = false
    @State private var dragOffset: CGSize = .zero
    @State private var dragStartEpoch: Double = 0
    @State private var dragEndEpoch:   Double = -.infinity
    @State private var motion = MotionManager()
    @State private var cardScale: CGFloat = 0.9

    private static let rainbowColors: [Color] = [.red, .orange, .yellow, .green, .cyan, .blue, .purple, .red]
    private func smoothstep(_ x: Double) -> Double { x * x * (3.0 - 2.0 * x) }

    var body: some View {
        TimelineView(.animation) { ctx in
            let t = ctx.date.timeIntervalSinceReferenceDate

            let idleRotX = cos(t * .pi / 2.75) * 2.0
            let idleRotY = sin(t * .pi / 3.5)  * 4.5
            let idleBob  = CGFloat(sin(t * .pi / 2.75) * 5.0)

            let idleBlend: Double = {
                if isDragging {
                    return 1.0 - smoothstep(min(1.0, (t - dragStartEpoch) / 0.25))
                } else {
                    return smoothstep(min(1.0, max(0.0, (t - dragEndEpoch) / 0.6)))
                }
            }()

            let dragRotX =  Double(dragOffset.height) / 10.0
            let dragRotY = -Double(dragOffset.width)  / 10.0

            let rotX = max(-12, min(12, idleRotX * idleBlend + dragRotX))
            let rotY = max(-12, min(12, idleRotY * idleBlend + dragRotY))
            let bobY = idleBob * CGFloat(idleBlend)

            let (holoX, holoY): (Double, Double) = {
                if motion.isAvailable {
                    let mx = max(-1.0, min(1.0, motion.roll  / (.pi / 4.0)))
                    let my = max(-1.0, min(1.0, motion.pitch / (.pi / 4.0)))
                    return (mx * 0.6 + (rotY / 12.0) * 0.4,
                            my * 0.6 + (rotX / 12.0) * 0.4)
                }
                return (rotY / 8.0, rotX / 8.0)
            }()

            let borderAngle = t * 40.0

            FiguritaCardView(
                userName: userName,
                userCountry: userCountry,
                rarity: rarity,
                userImage: userImage,
                fanNumber: fanNumber,
                birthDate: birthDate,
                height: height,
                weight: weight,
                borderAngle: borderAngle
            )
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
            .overlay {
                if rarity == .legendario {
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(
                            AngularGradient(
                                colors: Self.rainbowColors,
                                center: .center,
                                startAngle: .degrees(borderAngle),
                                endAngle: .degrees(borderAngle + 360)
                            ),
                            lineWidth: 3.5
                        )
                } else {
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(rarity.accentColor.opacity(0.85), lineWidth: 3)
                }
            }
            .shadow(
                color: rarity == .legendario ? Color.purple.opacity(0.45) : rarity.accentColor.opacity(0.35),
                radius: 24, x: 0, y: 10
            )
            .shadow(color: .black.opacity(0.5), radius: 20, x: -rotY * 2.5, y: 14 - rotX * 2)
            .scaleEffect(cardScale)
            .offset(y: bobY)
            .rotation3DEffect(.degrees(rotX), axis: (x: 1, y: 0, z: 0))
            .rotation3DEffect(.degrees(rotY), axis: (x: 0, y: 1, z: 0))
        }
        .frame(width: 335, height: 444)
        .frame(maxWidth: .infinity)
        .gesture(
            // minimumDistance 15 + horizontal-dominance check: vertical swipes
            // fall through to the ScrollView, horizontal/diagonal drags tilt the card.
            DragGesture(minimumDistance: 15)
                .onChanged { value in
                    if !isDragging {
                        guard abs(value.translation.width) > abs(value.translation.height) else { return }
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
                    guard isDragging else { return }
                    isDragging   = false
                    dragEndEpoch = Date().timeIntervalSinceReferenceDate
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                        dragOffset = .zero
                    }
                }
        )
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) { cardScale = 1.0 }
        }
        .onDisappear {
            withAnimation(.none) { cardScale = 0.9 }
            dragOffset   = .zero
            isDragging   = false
            dragEndEpoch = -.infinity
        }
    }
}

// MARK: - FiguritaCardView (Panini World Cup 2026 layout)
// 335×444. Full-bleed photo with overlaid design elements.
// ZStack coordinate space: center at (167.5, 222), origin top-left.

struct FiguritaCardView: View {
    let userName: String
    let userCountry: String
    let rarity: FiguritaRarity
    let userImage: UIImage?
    let fanNumber: Int
    let birthDate: String
    let height: String
    let weight: String
    let borderAngle: Double

    // First 3 chars of country input
    private var code: String {
        String(userCountry.trimmingCharacters(in: .whitespaces).prefix(3)).uppercased()
    }

    // "5-2-1985 | 1,87 m | 83 kg" — empty fields (and their separators) omitted
    private var statsLine: String {
        [birthDate, height, weight]
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
            .joined(separator: " | ")
    }

    // Split "Juan Perez" → ("Juan", "PEREZ"). Single word → ("", "WORD").
    private var nameParts: (first: String, surname: String) {
        let parts = userName.split(separator: " ").map(String.init)
        if parts.count >= 2 {
            return (parts.dropLast().joined(separator: " "), parts.last!.uppercased())
        }
        return ("", userName.uppercased())
    }

    var body: some View {
        ZStack {
            // 1. Card background color
            rarity.cardBackground

            // 2. "26" watermark — large, behind photo, 12% white
            Text("26")
                .font(.system(size: 280, weight: .black))
                .foregroundStyle(.white.opacity(0.12))
                .offset(y: -30)

            // 3. Full-bleed photo / placeholder
            photoLayer

            // 4. Vertical 3-letter country code — absolute bottom-right corner.
            //    38pt black "VEN" → fixedSize ≈ 72w × 45h; after 90° rotation the
            //    rendered glyphs occupy ≈ 45w × 72h around the frame center.
            //    Center (300.5, 392): right edge ≈ 323 (12pt margin), bottom ≈ 428 (16pt above).
            Text(code.isEmpty ? "FAN" : code)
                .font(.system(size: 38, weight: .black))
                .foregroundStyle(.white)
                .shadow(color: .black.opacity(0.7), radius: 3, x: 0, y: 2)
                .fixedSize()
                .rotationEffect(.degrees(90))
                .offset(x: 133, y: 170)

            // 5. Flag circle — directly above the country code, same right margin.
            //    Center (297.5, 322): sits just above the bottom strip.
            ZStack {
                Circle()
                    .fill(.white)
                    .shadow(color: .black.opacity(0.25), radius: 6)
                Text(FiguritaCardView.flagEmoji(for: userCountry))
                    .font(.system(size: 26))
            }
            .frame(width: 52, height: 52)
            .offset(x: 130, y: 100)

            // 6. Top-right competition badge
            VStack {
                HStack {
                    appIconView
                        .padding(.top, 12)
                        .padding(.leading, 12)
                    Spacer()
                    fanBadge
                        .padding(.top, 12)
                        .padding(.trailing, 12)
                }
                Spacer()
            }

            // 7. Bottom dark-gradient strip with name + fan number
            VStack {
                Spacer()
                bottomStrip
            }
        }
        .frame(width: 335, height: 444)
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }

    // MARK: Photo / placeholder

    @ViewBuilder
    private var photoLayer: some View {
        if let img = userImage {
            Image(uiImage: img)
                .resizable()
                .scaledToFill()
                .frame(width: 335, height: 444)
                .clipped()
        } else {
            ZStack {
                LinearGradient(
                    colors: [Color(hex: "#1A2D50"), Color(hex: "#080810")],
                    startPoint: .top,
                    endPoint: .bottom
                )
                VStack(spacing: 14) {
                    Image(systemName: "person.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100)
                        .foregroundStyle(.white.opacity(0.2))
                    Text("Tocar para añadir foto")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.6))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 7)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                }
                .offset(y: -30)
            }
            .frame(width: 335, height: 444)
        }
    }

    // MARK: Top-right badge

    private var fanBadge: some View {
        VStack(spacing: 2) {
            Text("WORLD CUP")
                .font(.system(size: 8, weight: .bold))
                .kerning(0.5)
                .foregroundStyle(.white.opacity(0.85))
            Text("2026")
                .font(.system(size: 14, weight: .black))
                .foregroundStyle(.white)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 10)
        .background(.black.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(.white.opacity(0.2), lineWidth: 0.5)
        )
    }

    // MARK: Bottom strip — dark gradient overlay, 96pt

    private var bottomStrip: some View {
        ZStack {
            LinearGradient(
                colors: [.black.opacity(0), .black.opacity(0.92)],
                startPoint: .top,
                endPoint: .bottom
            )

            VStack(alignment: .leading, spacing: 2) {
                if !nameParts.first.isEmpty {
                    Text(nameParts.first.uppercased())
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(rarity.accentColor)
                        .kerning(2.5)
                }
                Text(nameParts.surname)
                    .font(.system(size: 28, weight: .black))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                if !statsLine.isEmpty {
                    Text(statsLine)
                        .font(.system(size: 10))
                        .foregroundStyle(.white.opacity(0.7))
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                }
                Text("FAN #\(fanNumber)")
                    .font(.system(size: 10))
                    .foregroundStyle(.white.opacity(0.55))
                    .kerning(1.5)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 16)
            .padding(.trailing, 60)  // reserve the right column for the vertical country code
            .padding(.vertical, 10)
        }
        .frame(width: 335, height: 96)
    }

    @ViewBuilder
    private var appIconView: some View {
        if UIImage(named: "AppIcon") != nil {
            Image("AppIcon")
                .resizable()
                .frame(width: 30, height: 30)
                .clipShape(RoundedRectangle(cornerRadius: 7))
                .overlay(
                    RoundedRectangle(cornerRadius: 7)
                        .stroke(.white.opacity(0.4), lineWidth: 1)
                )
        }
    }

    // MARK: Flag emoji lookup

    static func flagEmoji(for country: String) -> String {
        let key = country.uppercased().trimmingCharacters(in: .whitespaces)
        let table: [String: String] = [
            "NEW ZEALAND": "🇳🇿", "NZ":  "🇳🇿",
            "ARGENTINA":   "🇦🇷", "ARG": "🇦🇷",
            "BRAZIL":      "🇧🇷", "BRA": "🇧🇷", "BRASIL":   "🇧🇷",
            "MEXICO":      "🇲🇽", "MEX": "🇲🇽", "MÉXICO":   "🇲🇽",
            "USA":         "🇺🇸", "US":  "🇺🇸", "UNITED STATES": "🇺🇸",
            "FRANCE":      "🇫🇷", "FRA": "🇫🇷",
            "SPAIN":       "🇪🇸", "ESP": "🇪🇸", "ESPAÑA":   "🇪🇸",
            "GERMANY":     "🇩🇪", "GER": "🇩🇪", "ALEMANIA": "🇩🇪",
            "ITALY":       "🇮🇹", "ITA": "🇮🇹", "ITALIA":   "🇮🇹",
            "ENGLAND":     "🏴󠁧󠁢󠁥󠁮󠁧󠁿", "UK":  "🇬🇧", "UNITED KINGDOM": "🇬🇧",
            "CHILE":       "🇨🇱", "CHI": "🇨🇱",
            "COLOMBIA":    "🇨🇴", "COL": "🇨🇴",
            "URUGUAY":     "🇺🇾", "URU": "🇺🇾",
            "VENEZUELA":   "🇻🇪", "VEN": "🇻🇪",
            "PERU":        "🇵🇪", "PER": "🇵🇪", "PERÚ":     "🇵🇪",
            "ECUADOR":     "🇪🇨", "ECU": "🇪🇨",
            "PARAGUAY":    "🇵🇾", "PAR": "🇵🇾",
            "BOLIVIA":     "🇧🇴", "BOL": "🇧🇴",
            "IRAN":        "🇮🇷", "IRI": "🇮🇷",
            "EGYPT":       "🇪🇬", "EGY": "🇪🇬", "EGIPTO":   "🇪🇬",
            "BELGIUM":     "🇧🇪", "BEL": "🇧🇪", "BÉLGICA":  "🇧🇪",
            "PORTUGAL":    "🇵🇹", "POR": "🇵🇹",
            "NETHERLANDS": "🇳🇱", "NED": "🇳🇱", "HOLANDA":  "🇳🇱",
            "JAPAN":       "🇯🇵", "JPN": "🇯🇵", "JAPÓN":    "🇯🇵",
            "SOUTH KOREA": "🇰🇷", "KOR": "🇰🇷",
            "AUSTRALIA":   "🇦🇺", "AUS": "🇦🇺",
            "CANADA":      "🇨🇦", "CAN": "🇨🇦",
            "MOROCCO":     "🇲🇦", "MAR": "🇲🇦", "MARRUECOS":"🇲🇦",
            "SENEGAL":     "🇸🇳", "SEN": "🇸🇳",
            "NIGERIA":     "🇳🇬", "NGA": "🇳🇬",
            "COSTA RICA":  "🇨🇷", "CRC": "🇨🇷",
            "PANAMA":      "🇵🇦", "PAN": "🇵🇦", "PANAMÁ":   "🇵🇦",
            "CUBA":        "🇨🇺", "CUB": "🇨🇺",
        ]
        return table[key] ?? table[String(key.prefix(3))] ?? "🌍"
    }
}

// MARK: - Share Sheet

private struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// MARK: - Button Style

private struct FiguritaPressScaleStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

#Preview {
    FiguritaView()
        .environment(AppState())
}
