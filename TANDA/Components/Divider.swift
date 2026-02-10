import SwiftUI

// MARK: - Divider
// Horizontal divider with optional centered label.
// Used for separating sections, especially in sign-up/auth flows.

struct Divider: View {
    var label: String? = nil

    var body: some View {
        HStack(spacing: TANDASpacing.md) {
            Rectangle()
                .fill(TANDAColors.border)
                .frame(height: 1)

            if let label {
                Text(label)
                    .font(TANDATypography.Label.s)
                    .foregroundStyle(TANDAColors.Neutral.n500)

                Rectangle()
                    .fill(TANDAColors.border)
                    .frame(height: 1)
            }
        }
    }
}

// MARK: - Preview

#Preview("With Label") {
    VStack(spacing: TANDASpacing.xl) {
        Divider(label: "or continue with")
        Divider(label: "or")
    }
    .padding(TANDASpacing.lg)
}

#Preview("Without Label") {
    Divider()
        .padding(TANDASpacing.lg)
}
