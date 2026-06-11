import SwiftUI

// MARK: - Badge model

enum BadgeRarity: String {
    case common, rare, epic, legendary

    var label: String { rawValue.uppercased() }
    var abbrev: String { String(label.prefix(3)) }   // COM / RAR / EPI / LEG

    var color: Color {
        switch self {
        case .common:    return Color.white
        case .rare:      return Color(hex: "#F0C130")
        case .epic:      return Color(hex: "#9B59B6")
        case .legendary: return Color(hex: "#F0C130")
        }
    }

    var glows: Bool { self == .legendary }
}

struct AppBadge: Identifiable {
    let id: String
    let emoji: String
    let name: String
    let rarity: BadgeRarity
}

// Display order per spec.
let allBadges: [AppBadge] = [
    AppBadge(id: "sharer",        emoji: "📢", name: "El Scarso Jr",    rarity: .rare),
    AppBadge(id: "streak3",       emoji: "🔥", name: "En Llamas",        rarity: .common),
    AppBadge(id: "streak7",       emoji: "💎", name: "Sin Días Libres",  rarity: .rare),
    AppBadge(id: "polyglot",      emoji: "🇦🇷", name: "Políglota",        rarity: .common),
    AppBadge(id: "day1",          emoji: "🏟️", name: "Fan del Día 1",    rarity: .rare),
    AppBadge(id: "legendary",     emoji: "👑", name: "Fan Legendario",   rarity: .legendary),
    AppBadge(id: "epic_fan",      emoji: "🏆", name: "Creyente Absoluto", rarity: .epic),
    AppBadge(id: "completionist", emoji: "✅", name: "Completista",       rarity: .epic),
]

// MARK: - Fan rank

struct FanRank {
    let title: String
    let emoji: String
    let color: Color
}

func fanRank(for points: Int) -> FanRank {
    switch points {
    case ..<50:      return FanRank(title: "Hincha",   emoji: "",   color: Color(hex: "#8E8E93"))
    case 50..<200:   return FanRank(title: "Fanático", emoji: "⚡", color: .white)
    case 200..<500:  return FanRank(title: "Ejército", emoji: "🔥", color: Color(hex: "#F0C130"))
    default:         return FanRank(title: "Leyenda",  emoji: "👑", color: Color(hex: "#9B59B6"))
    }
}

// MARK: - View

struct PerfilView: View {
    @Environment(AppState.self) private var appState
    @AppStorage("fanNumber") private var fanNumber: Int = 0
    @State private var showFigurita = false

    private var unlockedSet: Set<String> {
        Set(appState.unlockedBadges
            .components(separatedBy: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty })
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "#070A0D").ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 24) {
                        FiguritaCTABanner { showFigurita = true }
                        FanIdentityCard(appState: appState, fanNumber: fanNumber, unlockedCount: unlockedSet.count)
                        BadgesCollection(unlockedSet: unlockedSet)
                        FollowTimCard()
                        AboutCard()
                        LegalLinks()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }
            }
            .navigationTitle("Tu Perfil 👤")
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .sheet(isPresented: $showFigurita) {
                FiguritaView()
            }
        }
    }
}

// MARK: - Section 1 · Figurita CTA

private struct FiguritaCTABanner: View {
    let action: () -> Void
    @State private var shimmer = false

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Text("🃏 Crea tu figurita personalizada")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer(minLength: 8)
                ZStack {
                    Circle().fill(Color(hex: "#070A0D").opacity(0.85))
                    Text("→")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(Color(hex: "#F0C130"))
                }
                .frame(width: 38, height: 38)
            }
            .padding(.horizontal, 20)
            .frame(height: 80)
            .frame(maxWidth: .infinity)
            .background(
                LinearGradient(
                    colors: [Color(hex: "#F0C130"), Color(hex: "#C49A1A"), Color(hex: "#F0C130")],
                    startPoint: shimmer ? UnitPoint(x: 0.6, y: 0.0) : UnitPoint(x: -0.6, y: 0.5),
                    endPoint:   shimmer ? UnitPoint(x: 1.6, y: 1.0) : UnitPoint(x: 0.6, y: 0.5)
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(PerfilPressStyle())
        .onAppear {
            withAnimation(.linear(duration: 2.5).repeatForever(autoreverses: true)) {
                shimmer = true
            }
        }
    }
}

// MARK: - Section 2 · Fan Identity

private struct FanIdentityCard: View {
    let appState: AppState
    let fanNumber: Int
    let unlockedCount: Int

    @State private var appeared = false

    private var fanNumberText: String {
        fanNumber == 0 ? "FAN #———————" : String(format: "FAN #%07d", fanNumber)
    }

    private var stats: [(emoji: String, value: String, label: String)] {
        [
            ("⭐", "\(appState.paynePoints)",                        "PUNTOS"),
            ("🔥", "\(appState.currentStreak)d",                     "RACHA"),
            ("📤", "\(appState.chantsShared)",                       "COMPARTIDOS"),
            ("🏆", "\(unlockedCount)/8",                             "INSIGNIAS"),
            ("📅", shortDate(appState.firstLaunchDate),              "DESDE"),
            ("🧩", "\(appState.missionsCompleted.nonzeroBitCount)",  "MISIONES"),
        ]
    }

    var body: some View {
        let rank = fanRank(for: appState.paynePoints)

        VStack(spacing: 16) {
            Text(fanNumberText)
                .font(.system(size: 12, weight: .semibold))
                .kerning(1.5)
                .foregroundStyle(Color.white.opacity(0.35))

            VStack(spacing: 4) {
                HStack(spacing: 8) {
                    if !rank.emoji.isEmpty {
                        Text(rank.emoji).font(.system(size: 30))
                    }
                    Text(rank.title)
                        .font(.system(size: 34, weight: .black))
                        .foregroundStyle(rank.color)
                }
                Text("El Ejército de Tim Payne")
                    .font(.system(size: 13))
                    .foregroundStyle(Color.white.opacity(0.4))
            }

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 3), spacing: 10) {
                ForEach(Array(stats.enumerated()), id: \.offset) { index, stat in
                    PerfilStatCell(emoji: stat.emoji, value: stat.value, label: stat.label,
                                   index: index, appeared: appeared)
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(Color(hex: "#12121A"))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .onAppear { appeared = true }
    }

    private func shortDate(_ iso: String) -> String {
        guard !iso.isEmpty else { return "—" }
        let inF = DateFormatter()
        inF.dateFormat = "yyyy-MM-dd"
        inF.locale = Locale(identifier: "en_US_POSIX")
        guard let d = inF.date(from: iso) else { return "—" }
        let outF = DateFormatter()
        outF.dateFormat = "dd-MMM"
        outF.locale = Locale(identifier: "es")
        return outF.string(from: d)
    }
}

private struct PerfilStatCell: View {
    let emoji: String
    let value: String
    let label: String
    let index: Int
    let appeared: Bool

    var body: some View {
        VStack(spacing: 5) {
            Text(emoji).font(.system(size: 22))
            Text(value)
                .font(.system(size: 18, weight: .black))
                .foregroundStyle(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.55)
            Text(label)
                .font(.system(size: 9, weight: .semibold))
                .foregroundStyle(Color.white.opacity(0.4))
                .kerning(0.5)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .padding(.horizontal, 4)
        .background(Color(hex: "#1A1A2E"))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 16)
        .animation(.spring(response: 0.5, dampingFraction: 0.75).delay(Double(index) * 0.05), value: appeared)
    }
}

// MARK: - Section 3 · Badges Collection

private struct BadgesCollection: View {
    let unlockedSet: Set<String>

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Colección de Insignias")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(.white)
            Text("\(unlockedSet.count) de 8 desbloqueadas")
                .font(.system(size: 13))
                .foregroundStyle(Color.white.opacity(0.4))

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 4), spacing: 10) {
                ForEach(allBadges) { badge in
                    BadgeCell(badge: badge, isUnlocked: unlockedSet.contains(badge.id))
                }
            }

            RarityLegend()
                .padding(.top, 2)
        }
    }
}

private struct BadgeCell: View {
    let badge: AppBadge
    let isUnlocked: Bool

    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                Text(badge.emoji)
                    .font(.system(size: 26))
                    .grayscale(isUnlocked ? 0 : 1)
                if !isUnlocked {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(.white)
                }
            }
            Text(badge.name)
                .font(.system(size: 7.5, weight: .semibold))
                .foregroundStyle(isUnlocked ? badge.rarity.color : Color.white.opacity(0.4))
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
            Text(badge.rarity.abbrev)
                .font(.system(size: 7, weight: .bold))
                .kerning(0.8)
                .foregroundStyle(isUnlocked ? badge.rarity.color.opacity(0.75) : Color.white.opacity(0.25))
        }
        .padding(8)
        .frame(maxWidth: .infinity)
        .frame(height: 84)
        .background(isUnlocked ? badge.rarity.color.opacity(0.08) : Color(hex: "#1A1A2E"))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(
                    isUnlocked ? badge.rarity.color.opacity(0.55) : Color.white.opacity(0.08),
                    lineWidth: 1
                )
        )
        .shadow(
            color: (isUnlocked && badge.rarity.glows) ? badge.rarity.color.opacity(0.5) : .clear,
            radius: 8
        )
        .opacity(isUnlocked ? 1 : 0.3)
    }
}

private struct RarityLegend: View {
    private let entries: [(String, BadgeRarity)] = [
        ("COMMON", .common), ("RARE", .rare), ("EPIC", .epic), ("LEGENDARY", .legendary)
    ]

    var body: some View {
        HStack(spacing: 14) {
            ForEach(entries, id: \.0) { label, rarity in
                HStack(spacing: 5) {
                    Circle()
                        .fill(rarity.color)
                        .frame(width: 7, height: 7)
                    Text(label)
                        .font(.system(size: 9, weight: .semibold))
                        .foregroundStyle(rarity.color)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

// MARK: - Section 4 · Seguir a Tim

private struct FollowTimCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Seguir a Tim")
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(.white)

            linkRow(label: "📸  Instagram — @timpayne__",
                    url: "https://instagram.com/timpayne__")
            linkRow(label: "🇦🇷  El Scarso — @elscarso",
                    url: "https://instagram.com/elscarso")
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(hex: "#12121A"))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func linkRow(label: String, url: String) -> some View {
        Link(destination: URL(string: url)!) {
            HStack {
                Text(label)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color(hex: "#F0C130"))
                Spacer()
                Image(systemName: "arrow.up.right")
                    .font(.system(size: 12))
                    .foregroundStyle(Color(hex: "#F0C130").opacity(0.6))
            }
        }
    }
}

// MARK: - Section 5 · Acerca de

private struct AboutCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Acerca de")
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(.white)
            Text("App de fans no oficial. Sin afiliación con FIFA, Wellington Phoenix ni Tim Payne. Hecha con amor por fans, para fans.")
                .font(.system(size: 13))
                .foregroundStyle(Color.white.opacity(0.4))
                .lineSpacing(2)
            Text("v1.0.0 · No Payne, No Gain 🇳🇿")
                .font(.system(size: 11))
                .foregroundStyle(Color.white.opacity(0.25))
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(hex: "#12121A"))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

// MARK: - Section 6 · Legal Links

private struct LegalLinks: View {
    private let links: [(String, String)] = [
        ("Política de Privacidad",  "https://timpaynefans.com/privacy"),
        ("Términos",                "https://timpaynefans.com/terms"),
        ("Datos y Cumplimiento",    "https://timpaynefans.com/data-compliance"),
        ("Marcas y Propiedad",      "https://timpaynefans.com/trademark"),
    ]

    var body: some View {
        VStack(spacing: 10) {
            ForEach(links, id: \.0) { label, url in
                Link(destination: URL(string: url)!) {
                    Text(label)
                        .font(.system(size: 12))
                        .foregroundStyle(Color.white.opacity(0.35))
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 4)
        .padding(.bottom, 12)
    }
}

// MARK: - Button style

private struct PerfilPressStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

#Preview {
    PerfilView()
        .environment(AppState())
}
