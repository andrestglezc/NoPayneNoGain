import SwiftUI

// MARK: - Daily missions (earned via real in-app events, never tapped)

struct DailyMission: Identifiable {
    let id: Int          // bit index in AppState.missionsCompleted
    let emoji: String
    let title: String
    let description: String
    let points: Int
}

let dailyMissions: [DailyMission] = [
    DailyMission(id: 0, emoji: "🧠", title: "Cerebrito",       description: "Completá un quiz",           points: 25),
    DailyMission(id: 1, emoji: "🎯", title: "Visionario",      description: "Confirmá una predicción",    points: 25),
    DailyMission(id: 2, emoji: "🎵", title: "Ensayo del Coro", description: "Generá tu canto",            points: 15),
    DailyMission(id: 3, emoji: "📤", title: "Corre la Voz",    description: "Compartí algo del ejército", points: 25),
]

@Observable
class AppState {
    var totalTaps: Int = UserDefaults.standard.integer(forKey: "totalTaps") {
        didSet { UserDefaults.standard.set(totalTaps, forKey: "totalTaps") }
    }
    var currentStreak: Int = UserDefaults.standard.integer(forKey: "currentStreak") {
        didSet { UserDefaults.standard.set(currentStreak, forKey: "currentStreak") }
    }
    var lastOpenDate: String = UserDefaults.standard.string(forKey: "lastOpenDate") ?? "" {
        didSet { UserDefaults.standard.set(lastOpenDate, forKey: "lastOpenDate") }
    }
    var firstLaunchDate: String = UserDefaults.standard.string(forKey: "firstLaunchDate") ?? "" {
        didSet { UserDefaults.standard.set(firstLaunchDate, forKey: "firstLaunchDate") }
    }
    var paynePoints: Int = UserDefaults.standard.integer(forKey: "paynePoints") {
        didSet { UserDefaults.standard.set(paynePoints, forKey: "paynePoints") }
    }
    var chantsGenerated: Int = UserDefaults.standard.integer(forKey: "chantsGenerated") {
        didSet { UserDefaults.standard.set(chantsGenerated, forKey: "chantsGenerated") }
    }
    var chantsShared: Int = UserDefaults.standard.integer(forKey: "chantsShared") {
        didSet { UserDefaults.standard.set(chantsShared, forKey: "chantsShared") }
    }
    var missionsCompleted: Int = UserDefaults.standard.integer(forKey: "missionsCompleted") {
        didSet { UserDefaults.standard.set(missionsCompleted, forKey: "missionsCompleted") }
    }
    var quizBestScore: Int = UserDefaults.standard.integer(forKey: "quizBestScore") {
        didSet { UserDefaults.standard.set(quizBestScore, forKey: "quizBestScore") }
    }
    var unlockedBadges: String = UserDefaults.standard.string(forKey: "unlockedBadges") ?? "day1" {
        didSet { UserDefaults.standard.set(unlockedBadges, forKey: "unlockedBadges") }
    }
    var predictionsMatch1: String = UserDefaults.standard.string(forKey: "predictionsMatch1") ?? "" {
        didSet { UserDefaults.standard.set(predictionsMatch1, forKey: "predictionsMatch1") }
    }
    var predictionsMatch2: String = UserDefaults.standard.string(forKey: "predictionsMatch2") ?? "" {
        didSet { UserDefaults.standard.set(predictionsMatch2, forKey: "predictionsMatch2") }
    }
    var predictionsMatch3: String = UserDefaults.standard.string(forKey: "predictionsMatch3") ?? "" {
        didSet { UserDefaults.standard.set(predictionsMatch3, forKey: "predictionsMatch3") }
    }
    var predictionScore: Int = UserDefaults.standard.integer(forKey: "predictionScore") {
        didSet { UserDefaults.standard.set(predictionScore, forKey: "predictionScore") }
    }
    var hasSeenOnboarding: Bool = UserDefaults.standard.bool(forKey: "hasSeenOnboarding") {
        didSet { UserDefaults.standard.set(hasSeenOnboarding, forKey: "hasSeenOnboarding") }
    }
    var fanName: String = UserDefaults.standard.string(forKey: "fanName") ?? "" {
        didSet { UserDefaults.standard.set(fanName, forKey: "fanName") }
    }
    var lastMissionDate: Date = UserDefaults.standard.object(forKey: "lastMissionDate") as? Date ?? .distantPast {
        didSet { UserDefaults.standard.set(lastMissionDate, forKey: "lastMissionDate") }
    }

    init() {
        resetMissionsIfNeeded()
    }

    func resetMissionsIfNeeded() {
        guard !Calendar.current.isDateInToday(lastMissionDate) else { return }
        missionsCompleted = 0
        lastMissionDate = Date()
    }

    func markMissionCompleted(_ id: Int) {
        resetMissionsIfNeeded()
        guard (missionsCompleted >> id) & 1 == 0 else { return }
        missionsCompleted |= (1 << id)
        if let mission = dailyMissions.first(where: { $0.id == id }) {
            paynePoints += mission.points
        }
    }

    func checkAndUpdateStreak() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let today = formatter.string(from: Date())

        if firstLaunchDate.isEmpty { firstLaunchDate = today }

        guard !lastOpenDate.isEmpty else {
            lastOpenDate = today
            currentStreak = 1
            return
        }

        if lastOpenDate == today { return }

        let yesterday = formatter.string(
            from: Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        )

        currentStreak = (lastOpenDate == yesterday) ? currentStreak + 1 : 1
        lastOpenDate = today
    }
}
