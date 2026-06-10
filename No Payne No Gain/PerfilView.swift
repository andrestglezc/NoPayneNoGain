import SwiftUI

// MARK: - Badge model

enum BadgeRarity: String {
    case common, rare, epic, legendary

    var label: String { rawValue.uppercased() }

    var color: Color {
        switch self {
        case .common:    return Color.white
        case .rare:      return Color(hex: "#F0C130")
        case .epic:      return Color(hex: "#9F7AEA")
        case .legendary: return Color(hex: "#FFD700")
        }
    }
}

struct AppBadge: Identifiable {
    let id: String
    let emoji: String
    let name: String
    let description: String
    let rarity: BadgeRarity
}

let allBadges: [AppBadge] = [
    AppBadge(id: "day1",          emoji: "🏟️", name: "Fan del Día 1",       description: "Acá desde el principio",        rarity: .rare),
    AppBadge(id: "polyglot",      emoji: "🇦🇷", name: "Políglota",           description: "Generó un canto",               rarity: .common),
    AppBadge(id: "streak3",       emoji: "🔥", name: "En Llamas",            description: "Racha de 3 días",               rarity: .common),
    AppBadge(id: "sharer",        emoji: "📢", name: "El Scarso Jr",         description: "Compartió 5 cantos",            rarity: .rare),
    AppBadge(id: "streak7",       emoji: "💎", name: "Sin Días Libres",      description: "Racha de 7 días",               rarity: .rare),
    AppBadge(id: "epic_fan",      emoji: "🏆", name: "Creyente Absoluto",    description: "Racha de 14 días",              rarity: .epic),
    AppBadge(id: "completionist", emoji: "✅", name: "Completista",          description: "Todas las misiones hechas",     rarity: .epic),
    AppBadge(id: "legendary",     emoji: "👑", name: "Fan Legendario",       description: "Racha de 30 días",              rarity: .legendary),
]

// MARK: - View

struct PerfilView: View {
    @Environment(AppState.self) private var appState

    private var unlockedSet: Set<String> {
        Set(appState.unlockedBadges.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) })
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "#070A0D").ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 20) {
                        StatsGrid(appState: appState)
                        BadgesSection(unlockedSet: unlockedSet)
                        LinksCard()
                        AboutCard()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }
            }
            .navigationTitle("Perfil 👤")
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }
}

// MARK: - Stats Grid

private struct StatsGrid: View {
    let appState: AppState

    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 12) {
            StatCell(emoji: "⭐", value: "\(appState.paynePoints)", label: "Puntos")
            StatCell(emoji: "🔥", value: "\(appState.currentStreak)d", label: "Racha")
            StatCell(emoji: "🏆", value: "\(appState.quizBestScore)/5", label: "Mejor Quiz")
            StatCell(emoji: "📤", value: "\(appState.chantsShared)", label: "Compartidos")
            StatCell(emoji: "🎵", value: "\(appState.chantsGenerated)", label: "Cantos")
            StatCell(emoji: "🎯", value: "\(appState.missionsCompleted.nonzeroBitCount)", label: "Misiones")
        }
    }
}

private struct StatCell: View {
    let emoji: String
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 5) {
            Text(emoji).font(.system(size: 22))
            Text(value)
                .font(.system(size: 18, weight: .black))
                .foregroundStyle(.white)
            Text(label)
                .font(.system(size: 10, weight: .semibold))
                .foregroundStyle(Color.white.opacity(0.4))
                .textCase(.uppercase)
                .kerning(0.5)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(Color(hex: "#1A1A2E"))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

// MARK: - Badges Section

private struct BadgesSection: View {
    let unlockedSet: Set<String>

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Insignias")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.white)
                Spacer()
                Text("\(unlockedSet.count)/\(allBadges.count)")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.white.opacity(0.4))
            }

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 4), spacing: 10) {
                ForEach(allBadges) { badge in
                    BadgeCell(badge: badge, isUnlocked: unlockedSet.contains(badge.id))
                }
            }

            RarityLegend()
        }
    }
}

private struct BadgeCell: View {
    let badge: AppBadge
    let isUnlocked: Bool

    var body: some View {
        VStack(spacing: 4) {
            Text(isUnlocked ? badge.emoji : "🔒")
                .font(.system(size: 26))
                .opacity(isUnlocked ? 1 : 0.3)
            Text(badge.name)
                .font(.system(size: 7.5, weight: .semibold))
                .foregroundStyle(isUnlocked ? badge.rarity.color : Color.white.opacity(0.3))
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
            Text(badge.rarity.label.prefix(3))
                .font(.system(size: 7, weight: .bold))
                .kerning(0.8)
                .foregroundStyle(isUnlocked ? badge.rarity.color.opacity(0.7) : Color.white.opacity(0.2))
        }
        .padding(8)
        .frame(maxWidth: .infinity)
        .background(
            isUnlocked
                ? badge.rarity.color.opacity(0.08)
                : Color(hex: "#1A1A2E")
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(
                    isUnlocked ? badge.rarity.color.opacity(0.3) : Color.clear,
                    lineWidth: 1
                )
        )
    }
}

private struct RarityLegend: View {
    private let entries: [(String, BadgeRarity)] = [
        ("Common", .common), ("Rare", .rare), ("Epic", .epic), ("Legendary", .legendary)
    ]

    var body: some View {
        HStack(spacing: 16) {
            ForEach(entries, id: \.0) { label, rarity in
                HStack(spacing: 5) {
                    Circle()
                        .fill(rarity.color)
                        .frame(width: 6, height: 6)
                    Text(label)
                        .font(.system(size: 10))
                        .foregroundStyle(rarity.color)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.top, 2)
    }
}

// MARK: - Links Card

private struct LinksCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Seguir a Tim")
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(.white)

            Link(destination: URL(string: "https://www.instagram.com/timpayne__")!) {
                HStack {
                    Text("📸  Instagram — @timpayne__")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Color(hex: "#F0C130"))
                    Spacer()
                    Image(systemName: "arrow.up.right")
                        .font(.system(size: 12))
                        .foregroundStyle(Color(hex: "#F0C130").opacity(0.6))
                }
            }

            Link(destination: URL(string: "https://www.instagram.com/elscarso")!) {
                HStack {
                    Text("🇦🇷  El Scarso — @elscarso")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Color(hex: "#F0C130"))
                    Spacer()
                    Image(systemName: "arrow.up.right")
                        .font(.system(size: 12))
                        .foregroundStyle(Color(hex: "#F0C130").opacity(0.6))
                }
            }
        }
        .padding(18)
        .background(Color(hex: "#1A1A2E"))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

// MARK: - About Card

private struct AboutCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Acerca de")
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(.white)
            Text("App de fans no oficial. Sin afiliación con FIFA, Wellington Phoenix ni Tim Payne. Hecha con amor por fans, para fans.")
                .font(.system(size: 13))
                .foregroundStyle(Color.white.opacity(0.4))
                .lineSpacing(2)
            Text("v1.0.0 · No Payne, No Gain 🇳🇿")
                .font(.system(size: 11))
                .foregroundStyle(Color.white.opacity(0.2))
        }
        .padding(18)
        .background(Color(hex: "#1A1A2E"))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    PerfilView()
        .environment(AppState())
}
