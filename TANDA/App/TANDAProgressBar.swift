import SwiftUI

// MARK: - TANDAProgressBar
// Segmented horizontal progress indicator for multi-step flows.

struct TANDAProgressBar: View {
    let totalSteps: Int
    let currentStep: Int
    var showShimmer: Bool = true

    @State private var shimmerOffset: CGFloat = -1.0

    var body: some View {
        GeometryReader { geometry in
            let segmentWidth = (geometry.size.width - CGFloat(totalSteps - 1) * TANDASpacing.xs) / CGFloat(totalSteps)

            HStack(spacing: TANDASpacing.xs) {
                ForEach(0..<totalSteps, id: \.self) { index in
                    let stepNumber = index + 1
                    let isCompleted = stepNumber < currentStep
                    let isActive = stepNumber == currentStep

                    RoundedRectangle(cornerRadius: 2)
                        .fill(segmentColor(isCompleted: isCompleted, isActive: isActive))
                        .frame(width: segmentWidth, height: 4)
                }
            }
        }
        .frame(height: 4)
    }

    private func segmentColor(isCompleted: Bool, isActive: Bool) -> Color {
        if isCompleted || isActive {
            return TANDAColors.Brand.primary
        }
        return TANDAColors.Neutral.n700
    }
}

#Preview("Progress Bar") {
    VStack(spacing: 32) {
        TANDAProgressBar(totalSteps: 4, currentStep: 1)
        TANDAProgressBar(totalSteps: 4, currentStep: 2)
        TANDAProgressBar(totalSteps: 4, currentStep: 3)
        TANDAProgressBar(totalSteps: 4, currentStep: 4)
    }
    .padding(.horizontal, 24)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(TANDAColors.Neutral.n900)
}
