import SwiftUI

// MARK: - SkeletonLoadingView
// Loading screen with skeleton placeholders shown while app initializes after onboarding.

struct SkeletonLoadingView: View {
    @State private var shimmerOffset: CGFloat = -1

    var body: some View {
        PageView {
            // Header skeleton
            VStack(alignment: .leading, spacing: TANDASpacing.xs) {
                SkeletonBox(width: 180, height: 32)
                SkeletonBox(width: 240, height: 20)
            }
        } body: {
            VStack(spacing: TANDASpacing.lg) {
                // Stats cards
                HStack(spacing: TANDASpacing.sm) {
                    VStack(alignment: .leading, spacing: TANDASpacing.xs) {
                        SkeletonBox(width: 80, height: 14)
                        SkeletonBox(width: 40, height: 28)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(TANDASpacing.md)
                    .background(TANDAColors.Neutral.n50)
                    .clipShape(RoundedRectangle(cornerRadius: TANDARadius.lg))

                    VStack(alignment: .leading, spacing: TANDASpacing.xs) {
                        SkeletonBox(width: 70, height: 14)
                        SkeletonBox(width: 50, height: 28)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(TANDASpacing.md)
                    .background(TANDAColors.Neutral.n50)
                    .clipShape(RoundedRectangle(cornerRadius: TANDARadius.lg))
                }

                // Circles section
                VStack(alignment: .leading, spacing: TANDASpacing.sm + 4) {
                    SkeletonBox(width: 120, height: 24)

                    ForEach(0..<3, id: \.self) { _ in
                        HStack(spacing: TANDASpacing.sm + 4) {
                            SkeletonBox(width: 48, height: 48)
                                .clipShape(RoundedRectangle(cornerRadius: TANDARadius.md))

                            VStack(alignment: .leading, spacing: 4) {
                                SkeletonBox(width: 140, height: 18)
                                SkeletonBox(width: 100, height: 14)
                            }

                            Spacer()

                            VStack(alignment: .trailing, spacing: 4) {
                                SkeletonBox(width: 50, height: 16)
                                SkeletonBox(width: 30, height: 12)
                            }
                        }
                        .padding(TANDASpacing.sm + 4)
                        .background(TANDAColors.Neutral.n0)
                        .clipShape(RoundedRectangle(cornerRadius: TANDARadius.lg))
                        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
                    }
                }

                // Recent activity section
                VStack(alignment: .leading, spacing: TANDASpacing.sm + 4) {
                    SkeletonBox(width: 140, height: 24)

                    ForEach(0..<3, id: \.self) { _ in
                        HStack(spacing: TANDASpacing.sm + 4) {
                            SkeletonBox(width: 40, height: 40)
                                .clipShape(SwiftUI.Circle())

                            VStack(alignment: .leading, spacing: 4) {
                                SkeletonBox(width: 120, height: 16)
                                SkeletonBox(width: 90, height: 14)
                            }

                            Spacer()

                            VStack(alignment: .trailing, spacing: 4) {
                                SkeletonBox(width: 50, height: 16)
                                SkeletonBox(width: 40, height: 12)
                            }
                        }
                        .padding(.vertical, TANDASpacing.sm)
                    }
                }
            }
            .padding(.top, TANDASpacing.md)
        }
        .onAppear {
            withAnimation(
                Animation.linear(duration: 1.5)
                    .repeatForever(autoreverses: false)
            ) {
                shimmerOffset = 1
            }
        }
        .environment(\.shimmerOffset, shimmerOffset)
    }
}

// MARK: - SkeletonBox

struct SkeletonBox: View {
    let width: CGFloat
    let height: CGFloat
    @Environment(\.shimmerOffset) private var shimmerOffset

    var body: some View {
        RoundedRectangle(cornerRadius: 6)
            .fill(TANDAColors.Neutral.n100)
            .frame(width: width, height: height)
            .overlay(
                GeometryReader { geometry in
                    RoundedRectangle(cornerRadius: 6)
                        .fill(
                            LinearGradient(
                                colors: [
                                    .clear,
                                    TANDAColors.Neutral.n0.opacity(0.6),
                                    .clear
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .offset(x: shimmerOffset * geometry.size.width)
                }
            )
            .clipped()
    }
}

// MARK: - Environment Key for Shimmer

private struct ShimmerOffsetKey: EnvironmentKey {
    static let defaultValue: CGFloat = -1
}

extension EnvironmentValues {
    var shimmerOffset: CGFloat {
        get { self[ShimmerOffsetKey.self] }
        set { self[ShimmerOffsetKey.self] = newValue }
    }
}

#Preview("Skeleton Loading") {
    SkeletonLoadingView()
}
