import SwiftUI

// MARK: - ProgressBar
// Segmented horizontal progress indicator for multi-step flows.

struct ProgressBar: View {
    let totalSteps: Int
    let currentStep: Int
    var showShimmer: Bool = true

    @State private var shimmerOffset: CGFloat = -1.0
    @State private var animatingStep: Int?
    @State private var scaleX: CGFloat = 0

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
                        .overlay {
                            if isActive && showShimmer {
                                GeometryReader { geo in
                                    LinearGradient(
                                        colors: [
                                            .clear,
                                            .white.opacity(0.6),
                                            .clear
                                        ],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                    .frame(width: geo.size.width * 0.5)
                                    .offset(x: (shimmerOffset + 1) * geo.size.width * 0.5 - geo.size.width * 0.25)
                                }
                                .clipShape(RoundedRectangle(cornerRadius: 2))
                            }
                        }
                        .scaleEffect(
                            x: (stepNumber == animatingStep) ? scaleX : 1.0,
                            anchor: .leading
                        )
                        .frame(width: segmentWidth, height: 4)
                }
            }
        }
        .frame(height: 4)
        .onAppear {
            if showShimmer {
                withAnimation(
                    .linear(duration: 1.5)
                    .repeatForever(autoreverses: false)
                ) {
                    shimmerOffset = 1.0
                }
            }
        }
        .onChange(of: currentStep) { _, newStep in
            animatingStep = newStep
            scaleX = 0
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                scaleX = 1.0
            }

            // Restart shimmer animation for new active step
            if showShimmer {
                shimmerOffset = -1.0
                withAnimation(
                    .linear(duration: 1.5)
                    .repeatForever(autoreverses: false)
                ) {
                    shimmerOffset = 1.0
                }
            }
        }
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
        ProgressBar(totalSteps: 4, currentStep: 1)
        ProgressBar(totalSteps: 4, currentStep: 2)
        ProgressBar(totalSteps: 4, currentStep: 3)
        ProgressBar(totalSteps: 4, currentStep: 4)
    }
    .padding(.horizontal, 24)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
}
