import SwiftUI

// MARK: - PasswordStrengthBar
// Visual indicator showing password strength.

struct PasswordStrengthBar: View {
    let password: String

    enum Strength: Int {
        case none = 0
        case weak = 1
        case medium = 2
        case strong = 3

        var label: String {
            switch self {
            case .none: return ""
            case .weak: return "Weak"
            case .medium: return "Medium"
            case .strong: return "Strong"
            }
        }

        var color: Color {
            switch self {
            case .none: return TANDAColors.Neutral.n700
            case .weak: return TANDAColors.Feedback.red
            case .medium: return TANDAColors.Feedback.yellow
            case .strong: return TANDAColors.Feedback.green
            }
        }
    }

    private var strength: Strength {
        guard !password.isEmpty else { return .none }
        var score = 0
        if password.count >= 8 { score += 1 }
        if password.rangeOfCharacter(from: .uppercaseLetters) != nil { score += 1 }
        let numbersAndSymbols = CharacterSet.decimalDigits.union(CharacterSet.punctuationCharacters).union(CharacterSet.symbols)
        if password.unicodeScalars.contains(where: { numbersAndSymbols.contains($0) }) { score += 1 }
        return Strength(rawValue: score) ?? .none
    }

    var body: some View {
        VStack(alignment: .leading, spacing: TANDASpacing.xs) {
            GeometryReader { geometry in
                let segmentWidth = (geometry.size.width - 2 * TANDASpacing.xs) / 3
                HStack(spacing: TANDASpacing.xs) {
                    ForEach(0..<3, id: \.self) { index in
                        RoundedRectangle(cornerRadius: 2)
                            .fill(index < strength.rawValue ? strength.color : TANDAColors.Neutral.n700)
                            .frame(width: segmentWidth, height: 4)
                    }
                }
            }
            .frame(height: 4)

            if strength != .none {
                Text(strength.label)
                    .font(TANDATypography.Label.xs)
                    .foregroundStyle(strength.color)
            }
        }
    }
}

#Preview("Password Strength") {
    VStack(spacing: 24) {
        PasswordStrengthBar(password: "")
        PasswordStrengthBar(password: "abc")
        PasswordStrengthBar(password: "Abcdefgh")
        PasswordStrengthBar(password: "Abcdefgh1!")
    }
    .padding(24)
    .background(TANDAColors.Neutral.n900)
}
