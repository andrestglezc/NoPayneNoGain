import SwiftUI

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

    func checkAndUpdateStreak() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let today = formatter.string(from: Date())

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
