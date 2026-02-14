import SwiftUI

// MARK: - Position Circle Indicator
// Dashed-border circle showing available position number.
// Used in JoinCircleSheet to display and navigate between positions.

struct PositionCircleIndicator: View {
    let positionNumber: Int
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                // Glass background circle
                SwiftUI.Circle()
                    .fill(.ultraThinMaterial)
                    .frame(width: 48, height: 48)

                // Tint overlay for selected state
                if isSelected {
                    SwiftUI.Circle()
                        .fill(TANDAColors.Purple.p500.opacity(0.15))
                        .frame(width: 48, height: 48)
                }

                // Dashed border
                SwiftUI.Circle()
                    .stroke(
                        isSelected ? TANDAColors.Purple.p500 : TANDAColors.Neutral.n400,
                        style: StrokeStyle(lineWidth: 2, dash: [4, 4])
                    )
                    .frame(width: 48, height: 48)

                // Position number
                Text("\(positionNumber)")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(isSelected ? TANDAColors.Purple.p500 : TANDAColors.Brand.black1)
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview("Position Circle Indicators") {
    HStack(spacing: 12) {
        PositionCircleIndicator(positionNumber: 3, isSelected: true, action: {})
        PositionCircleIndicator(positionNumber: 5, isSelected: false, action: {})
        PositionCircleIndicator(positionNumber: 7, isSelected: false, action: {})
    }
    .padding()
    .background(Color.white)
}
