import SwiftUI

// MARK: - Models

private struct Mission: Identifiable {
    let id: Int
    let emoji: String
    let title: String
    let description: String
    let points: Int
}

private let allMissions: [Mission] = [
    Mission(id: 0, emoji: "📤", title: "Corre la Voz",    description: "Compartí un canto del ejército", points: 25),
    Mission(id: 1, emoji: "🎵", title: "Ensayo del Coro", description: "Explorá 3 cantos de fans",        points: 15),
    Mission(id: 2, emoji: "🔥", title: "Fan Constante",   description: "Mantené una racha de 3 días",     points: 50),
]

private struct MatchInfo: Identifiable {
    let id: Int
    let flagOpponent: String
    let nameOpponent: String
    let dateLabel: String
    let venue: String
    let kickoff: Date
}

private let allMatches: [MatchInfo] = {
    func makeDate(year: Int, month: Int, day: Int, hour: Int, tz: String) -> Date {
        var c = DateComponents()
        c.year = year; c.month = month; c.day = day; c.hour = hour; c.minute = 0
        c.timeZone = TimeZone(identifier: tz)
        return Calendar.current.date(from: c) ?? .distantFuture
    }
    return [
        MatchInfo(id: 1, flagOpponent: "🇮🇷", nameOpponent: "Iran",
                  dateLabel: "Tue 16 Jun at 19:00",
                  venue: "SoFi Stadium, Los Angeles",
                  kickoff: makeDate(year: 2026, month: 6, day: 16, hour: 19, tz: "America/Los_Angeles")),
        MatchInfo(id: 2, flagOpponent: "🇪🇬", nameOpponent: "Egypt",
                  dateLabel: "Sun 21 Jun at 16:00",
                  venue: "BC Place, Vancouver",
                  kickoff: makeDate(year: 2026, month: 6, day: 21, hour: 16, tz: "America/Vancouver")),
        MatchInfo(id: 3, flagOpponent: "🇧🇪", nameOpponent: "Belgium",
                  dateLabel: "Fri 26 Jun at 16:00",
                  venue: "BC Place, Vancouver",
                  kickoff: makeDate(year: 2026, month: 6, day: 26, hour: 16, tz: "America/Vancouver")),
    ]
}()

// MARK: - Main View

struct MisionesView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "#070A0D").ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 28) {
                        PredictionsSection()
                        PredictoresCard()
                        DailyMissionsSection()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }
            }
            .navigationTitle("Misiones 🎯")
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }
}

// MARK: - Section 1: Predictions

private struct PredictionsSection: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Predicciones del Partido")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(.white)
                Text("Predicí los 3 partidos del Grupo G · 50pts por acierto")
                    .font(.system(size: 13))
                    .foregroundStyle(Color.white.opacity(0.5))
            }

            ForEach(allMatches) { match in
                MatchCard(
                    match: match,
                    savedPrediction: prediction(for: match.id),
                    onSave: { str in save(str, for: match.id) }
                )
            }
        }
    }

    private func prediction(for id: Int) -> String {
        switch id {
        case 1: return appState.predictionsMatch1
        case 2: return appState.predictionsMatch2
        case 3: return appState.predictionsMatch3
        default: return ""
        }
    }

    private func save(_ str: String, for id: Int) {
        switch id {
        case 1: appState.predictionsMatch1 = str
        case 2: appState.predictionsMatch2 = str
        case 3: appState.predictionsMatch3 = str
        default: break
        }
        appState.predictionScore = [
            appState.predictionsMatch1,
            appState.predictionsMatch2,
            appState.predictionsMatch3,
        ].filter { !$0.isEmpty }.count * 4
    }
}

// MARK: - Match Card

private struct MatchCard: View {
    let match: MatchInfo
    let savedPrediction: String
    let onSave: (String) -> Void

    @State private var resultado: String = ""
    @State private var titular: String   = ""
    @State private var anota: String     = ""
    @State private var mvp: String       = ""

    private var isConfirmed: Bool { !savedPrediction.isEmpty }
    private var allSelected: Bool { !resultado.isEmpty && !titular.isEmpty && !anota.isEmpty && !mvp.isEmpty }
    private var parsed: [String]  { savedPrediction.components(separatedBy: "|") }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Title row
            HStack(alignment: .top) {
                Text("NZ 🇳🇿  vs  \(match.flagOpponent) \(match.nameOpponent)")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
                Spacer()
                if isConfirmed {
                    Text("✓ Confirmadas")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(.green)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.green.opacity(0.12))
                        .clipShape(Capsule())
                }
            }

            // Date + venue
            Text("\(match.dateLabel) · \(match.venue)")
                .font(.system(size: 12))
                .foregroundStyle(Color.white.opacity(0.45))

            if isConfirmed {
                confirmedContent
            } else {
                pendingContent
            }
        }
        .padding(16)
        .background(Color(hex: "#12121A"))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    isConfirmed ? Color.green.opacity(0.3) : Color.white.opacity(0.07),
                    lineWidth: 1
                )
        )
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isConfirmed)
    }

    // MARK: State B — confirmed read-only rows

    private var confirmedContent: some View {
        VStack(alignment: .leading, spacing: 7) {
            if parsed.count == 4 {
                confirmedRow("Resultado",     value: parsed[0])
                confirmedRow("¿Tim titular?", value: parsed[1])
                confirmedRow("¿Tim anota?",   value: parsed[2])
                confirmedRow("¿Tim MVP?",     value: parsed[3])
            }
        }
        .padding(.top, 4)
    }

    private func confirmedRow(_ label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 13))
                .foregroundStyle(Color.white.opacity(0.45))
            Spacer()
            Text(value)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(Color.white.opacity(0.8))
        }
    }

    // MARK: State A — pending predictions

    private var pendingContent: some View {
        VStack(alignment: .leading, spacing: 14) {
            TimelineView(.everyMinute) { ctx in
                Text(countdown(to: match.kickoff, from: ctx.date))
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color(hex: "#F0C130"))
            }

            Text("Haz tus predicciones:")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(Color.white.opacity(0.45))

            pillGroup(label: "Resultado del partido",
                      options: ["Victoria NZ", "Empate", "Derrota NZ"],
                      selected: resultado) { resultado = $0 }

            pillGroup(label: "¿Tim sale de titular?",
                      options: ["Sí, es titular", "Calienta el banco"],
                      selected: titular) { titular = $0 }

            pillGroup(label: "¿Tim anota?",
                      options: ["Tim anota 🎉", "0 goles (clásico Tim)"],
                      selected: anota) { anota = $0 }

            pillGroup(label: "¿Tim MVP del partido?",
                      options: ["Tim Payne 🇳🇿", "Alguien más"],
                      selected: mvp) { mvp = $0 }

            confirmButton
        }
    }

    private func pillGroup(
        label: String,
        options: [String],
        selected: String,
        onSelect: @escaping (String) -> Void
    ) -> some View {
        VStack(alignment: .leading, spacing: 7) {
            Text(label)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(Color.white.opacity(0.45))
            PillsFlowLayout(spacing: 7) {
                ForEach(options, id: \.self) { option in
                    Button { onSelect(option) } label: {
                        Text(option)
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(selected == option ? Color(hex: "#070A0D") : .white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(selected == option ? Color(hex: "#F0C130") : Color.white.opacity(0.1))
                            .clipShape(Capsule())
                    }
                    .buttonStyle(PillButtonStyle())
                }
            }
        }
    }

    private var confirmButton: some View {
        Button {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            onSave("\(resultado)|\(titular)|\(anota)|\(mvp)")
        } label: {
            Text(allSelected ? "Confirmar predicciones 🔒" : "Respondé las 4 para confirmar")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(allSelected ? Color(hex: "#070A0D") : Color.white.opacity(0.3))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(allSelected ? Color(hex: "#F0C130") : Color.white.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .animation(.easeInOut(duration: 0.2), value: allSelected)
        }
        .disabled(!allSelected)
        .buttonStyle(PillButtonStyle())
        .padding(.top, 4)
    }

    private func countdown(to date: Date, from now: Date) -> String {
        let diff = date.timeIntervalSince(now)
        guard diff > 0 else { return "¡Ya empezó!" }
        let s = Int(diff)
        let d = s / 86400, h = (s % 86400) / 3600, m = (s % 3600) / 60
        if d > 0 { return "Empieza en \(d)d \(h)h \(m)m" }
        if h > 0 { return "Empieza en \(h)h \(m)m" }
        return "Empieza en \(m)m"
    }
}

// MARK: - Section 2: Predictores

private struct PredictoresCard: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        VStack(spacing: 14) {
            Text("Mejores Predictores 🏆")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)

            VStack(spacing: 5) {
                HStack(alignment: .lastTextBaseline, spacing: 6) {
                    Text("\(appState.predictionScore)")
                        .font(.system(size: 56, weight: .black))
                        .foregroundStyle(Color(hex: "#F0C130"))
                    Text("/ 12")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundStyle(Color.white.opacity(0.35))
                }
                Text("Tu puntaje de predicciones hasta ahora")
                    .font(.system(size: 13))
                    .foregroundStyle(Color.white.opacity(0.5))
                    .multilineTextAlignment(.center)
                Text("Ranking completo próximamente — ¡compartí tu puntaje!")
                    .font(.system(size: 12))
                    .foregroundStyle(Color.white.opacity(0.3))
                    .multilineTextAlignment(.center)
                    .padding(.top, 2)
            }
            .frame(maxWidth: .infinity)

            ShareLink(item: "Llevo \(appState.predictionScore)/12 en predicciones del Grupo G 🇳🇿 ¿Le ganás a mi puntaje? timpaynefans.com #NoPayneNoGain") {
                Text("Compartir mi puntaje")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(Color(hex: "#070A0D"))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color(hex: "#F0C130"))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .padding(18)
        .background(Color(hex: "#12121A"))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

// MARK: - Section 3: Daily Missions

private struct DailyMissionsSection: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Misiones Diarias")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(.white)
                Text("\(completedCount)/3 completadas · \(earnedPoints) Payne Points")
                    .font(.system(size: 13))
                    .foregroundStyle(Color.white.opacity(0.5))
            }

            StreakBanner(streak: appState.currentStreak)

            ForEach(allMissions) { mission in
                MissionCard(
                    mission: mission,
                    isDone: isCompleted(mission),
                    onComplete: { complete(mission) }
                )
                .sensoryFeedback(.success, trigger: isCompleted(mission))
            }
        }
        .onAppear { autoCheck() }
    }

    private var completedCount: Int { allMissions.filter { isCompleted($0) }.count }
    private var earnedPoints: Int   { allMissions.filter { isCompleted($0) }.map { $0.points }.reduce(0, +) }

    private func isCompleted(_ m: Mission) -> Bool { (appState.missionsCompleted >> m.id) & 1 == 1 }

    private func complete(_ m: Mission) {
        guard !isCompleted(m) else { return }
        appState.missionsCompleted |= (1 << m.id)
        appState.paynePoints += m.points
    }

    private func autoCheck() {
        if appState.currentStreak >= 3 { complete(allMissions[2]) }
    }
}

// MARK: - Streak Banner

private struct StreakBanner: View {
    let streak: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                Text("🔥").font(.system(size: 26))
                VStack(alignment: .leading, spacing: 3) {
                    Text("\(streak) días de racha")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.white)
                    Text("Volvé mañana para mantenerla")
                        .font(.system(size: 12))
                        .foregroundStyle(Color.white.opacity(0.5))
                }
                Spacer()
            }
            GeometryReader { geo in
                let progress = min(1.0, Double(streak) / 7.0)
                ZStack(alignment: .leading) {
                    Capsule().fill(Color.white.opacity(0.08))
                    Capsule()
                        .fill(Color(hex: "#F0C130").opacity(0.7))
                        .frame(width: geo.size.width * progress)
                }
            }
            .frame(height: 3)
        }
        .padding(16)
        .background(Color(hex: "#F0C130").opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(hex: "#F0C130").opacity(0.2), lineWidth: 1)
        )
    }
}

// MARK: - Mission Card

private struct MissionCard: View {
    let mission: Mission
    let isDone: Bool
    let onComplete: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 14) {
                Text(mission.emoji).font(.system(size: 28))
                VStack(alignment: .leading, spacing: 3) {
                    Text(mission.title)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(isDone ? Color(hex: "#F0C130") : .white)
                    Text(mission.description)
                        .font(.system(size: 13))
                        .foregroundStyle(Color.white.opacity(0.5))
                }
                Spacer()
                Text("+\(mission.points)")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(Color(hex: "#F0C130"))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color(hex: "#F0C130").opacity(0.12))
                    .clipShape(Capsule())
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4).fill(Color.white.opacity(0.08))
                    RoundedRectangle(cornerRadius: 4)
                        .fill(isDone ? Color(hex: "#F0C130") : Color.white.opacity(0.25))
                        .frame(width: isDone ? geo.size.width : 0)
                        .animation(.easeOut(duration: 0.5), value: isDone)
                }
            }
            .frame(height: 4)

            if isDone {
                HStack {
                    Image(systemName: "checkmark.circle.fill").foregroundStyle(Color(hex: "#F0C130"))
                    Text("Completada")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(Color(hex: "#F0C130"))
                    Spacer()
                }
            } else {
                Button(action: onComplete) {
                    Text("Completar misión")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Color(hex: "#070A0D"))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 11)
                        .background(Color(hex: "#F0C130"))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
        }
        .padding(16)
        .background(isDone ? Color(hex: "#F0C130").opacity(0.06) : Color(hex: "#12121A"))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isDone ? Color(hex: "#F0C130").opacity(0.3) : Color.clear, lineWidth: 1.5)
        )
    }
}

// MARK: - Pills Flow Layout

private struct PillsFlowLayout: Layout {
    var spacing: CGFloat = 8

    private struct RowData {
        var items: [(Int, CGSize)] = []
        var maxHeight: CGFloat = 0
    }

    private func computeRows(subviews: Subviews, width: CGFloat) -> [RowData] {
        var rows: [RowData] = []
        var current = RowData()
        var x: CGFloat = 0
        for (i, sub) in subviews.enumerated() {
            let s = sub.sizeThatFits(.unspecified)
            if !current.items.isEmpty && x + s.width > width {
                rows.append(current)
                current = RowData(); x = 0
            }
            current.items.append((i, s))
            current.maxHeight = max(current.maxHeight, s.height)
            x += s.width + spacing
        }
        if !current.items.isEmpty { rows.append(current) }
        return rows
    }

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = proposal.width ?? .infinity
        let rows = computeRows(subviews: subviews, width: width)
        let h = rows.map { $0.maxHeight }.reduce(0, +) + max(0, CGFloat(rows.count - 1)) * spacing
        return CGSize(width: width, height: h)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let rows = computeRows(subviews: subviews, width: bounds.width)
        var y = bounds.minY
        for row in rows {
            var x = bounds.minX
            for (idx, sz) in row.items {
                subviews[idx].place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(sz))
                x += sz.width + spacing
            }
            y += row.maxHeight + spacing
        }
    }
}

// MARK: - Pill Button Style

private struct PillButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

#Preview {
    MisionesView()
        .environment(AppState())
}
