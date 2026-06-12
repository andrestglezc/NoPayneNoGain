import SwiftUI

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

enum NameValidator {
    private static let blocklist: Set<String> = [
        "fuck", "shit", "bitch", "asshole", "cunt", "dick", "cock", "pussy",
        "nigger", "nigga", "faggot", "whore", "bastard", "prick",
        "puta", "puto", "mierda", "coño", "pendejo", "cabron", "cabrón",
        "marica", "culo", "verga", "joder", "hdp",
    ]
    static func isValid(_ name: String) -> Bool {
        let t = name.trimmingCharacters(in: .whitespaces)
        guard t.count >= 2 && t.count <= 20 else { return false }
        guard t.rangeOfCharacter(from: .letters) != nil else { return false }
        let lower = t.lowercased()
        return !blocklist.contains(where: { lower.contains($0) })
    }
}
