import SwiftUI

// MARK: - SelectionCard
// Reusable card component for multiple-choice selections.
// Displays with checkmark when selected.

struct SelectionCard: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: TANDASpacing.md) {
                // Checkmark circle
                ZStack {
                    SwiftUI.Circle()
                        .stroke(isSelected ? TANDAColors.Brand.primary : TANDAColors.Neutral.n300, lineWidth: 2)
                        .frame(width: 24, height: 24)

                    if isSelected {
                        SwiftUI.Circle()
                            .fill(TANDAColors.Brand.primary)
                            .frame(width: 24, height: 24)

                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(.white)
                    }
                }

                // Title
                Text(title)
                    .font(TANDATypography.Paragraph.l)
                    .foregroundStyle(TANDAColors.Text.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(TANDASpacing.md)
            .background(
                RoundedRectangle(cornerRadius: TANDARadius.md)
                    .fill(isSelected ? TANDAColors.Brand.primary.opacity(0.05) : TANDAColors.Surface.secondary)
            )
            .overlay(
                RoundedRectangle(cornerRadius: TANDARadius.md)
                    .stroke(isSelected ? TANDAColors.Brand.primary : TANDAColors.Neutral.n200, lineWidth: isSelected ? 2 : 1)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview("Selection Card") {
    VStack(spacing: TANDASpacing.md) {
        SelectionCard(title: "Save for a specific goal", isSelected: false) { }
        SelectionCard(title: "Build an emergency fund", isSelected: true) { }
        SelectionCard(title: "Save with friends/family", isSelected: false) { }
    }
    .padding(TANDASpacing.lg)
}
