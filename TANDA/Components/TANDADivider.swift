import SwiftUI

// MARK: - TANDADivider
// Horizontal divider with optional centered label.
// Used for separating sections, especially in sign-up/auth flows.

struct TANDADivider: View {
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
        TANDADivider(label: "or continue with")
        TANDADivider(label: "or")
    }
    .padding(TANDASpacing.lg)
}

#Preview("Without Label") {
    TANDADivider()
        .padding(TANDASpacing.lg)
}
