import SwiftUI

// MARK: - Category Tag
// Small pill component showing category emoji + name (e.g., "🐶 Pets")

struct CategoryTag: View {
    let category: CircleCategory

    var body: some View {
        HStack(spacing: 4) {
            Text(category.emoji)
                .font(.system(size: 12))

            Text(category.rawValue)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(TANDAColors.Text.secondary)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(TANDAColors.Neutral.n100)
        .clipShape(RoundedRectangle(cornerRadius: 100))
    }
}

#Preview("Category Tags") {
    VStack(spacing: TANDASpacing.sm) {
        HStack(spacing: TANDASpacing.xs) {
            CategoryTag(category: .pets)
            CategoryTag(category: .house)
            CategoryTag(category: .travel)
        }

        HStack(spacing: TANDASpacing.xs) {
            CategoryTag(category: .education)
            CategoryTag(category: .furniture)
            CategoryTag(category: .liveEvents)
        }
    }
    .padding()
}
