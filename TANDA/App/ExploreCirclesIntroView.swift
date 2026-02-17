import SwiftUI

// MARK: - Explore Circles Intro View
// First-time descriptor page explaining TANDA circles before navigating to the circles tab

struct ExploreCirclesIntroView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var appState: AppState
    let onContinue: () -> Void

    var body: some View {
        SheetLayout(
            type: .immersive,
            title: "Discover Circles",
            showLeftAction: false,
            showRightAction: true,
            rightAction: { dismiss() }
        ) {
            ScrollView {
                VStack(spacing: TANDASpacing.xl) {
                    Spacer()
                        .frame(height: TANDASpacing.lg)

                    // Hero icon
                    ZStack {
                        SwiftUI.Circle()
                            .fill(
                                LinearGradient(
                                    colors: [TANDAColors.Purple.p500, TANDAColors.Purple.p400],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 96, height: 96)

                        Image(systemName: "person.3.fill")
                            .font(.system(size: 48))
                            .foregroundStyle(.white)
                    }

                    // Title and description
                    VStack(spacing: TANDASpacing.sm) {
                        Text("Discover TANDA Circles")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundStyle(TANDAColors.Text.primary)

                        Text("Join a community-based savings circle where members contribute together and take turns receiving payouts.")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundStyle(TANDAColors.Text.secondary)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.horizontal, TANDASpacing.lg)

                    // Features list
                    VStack(alignment: .leading, spacing: TANDASpacing.md) {
                        Text("How it works")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(TANDAColors.Text.primary)

                        VStack(spacing: TANDASpacing.sm) {
                            FeatureRow(
                                icon: "circle.grid.3x3.fill",
                                title: "What are circles?",
                                description: "Groups of people who save together and take turns receiving payouts"
                            )

                            FeatureRow(
                                icon: "chart.line.uptrend.xyaxis",
                                title: "Build savings together",
                                description: "Everyone contributes the same amount each cycle"
                            )

                            FeatureRow(
                                icon: "arrow.triangle.2.circlepath",
                                title: "Rotating payouts",
                                description: "Each member receives the full pot in rotation until everyone has received their turn"
                            )

                            FeatureRow(
                                icon: "hand.raised.fill",
                                title: "Choose your position",
                                description: "Pick when you want to receive your payout based on available positions"
                            )
                        }
                    }
                    .padding(TANDASpacing.lg)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(TANDAColors.Neutral.n50)
                    .clipShape(RoundedRectangle(cornerRadius: TANDARadius.xl))
                    .padding(.horizontal, TANDASpacing.lg)

                    // Benefits callout
                    HStack(alignment: .top, spacing: TANDASpacing.sm) {
                        Image(systemName: "sparkles")
                            .font(.system(size: 20))
                            .foregroundStyle(TANDAColors.Purple.p500)

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Safe & Transparent")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(TANDAColors.Text.primary)

                            Text("All contributions and payouts are tracked securely. Join verified circles with trusted community members.")
                                .font(.system(size: 12, weight: .regular))
                                .foregroundStyle(TANDAColors.Text.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    .padding(TANDASpacing.md)
                    .background(TANDAColors.Purple.p100)
                    .clipShape(RoundedRectangle(cornerRadius: TANDARadius.lg))
                    .padding(.horizontal, TANDASpacing.lg)

                    Spacer()
                }
            }
        } footer: {
            PrimaryButtonDock {
                PrimaryButton(
                    "Continue",
                    kind: .primary,
                    isFullWidth: true
                ) {
                    appState.completeCirclesIntro()
                    onContinue()
                    dismiss()
                }
            }
        }
    }
}

// MARK: - Feature Row

private struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(spacing: TANDASpacing.sm) {
            ZStack {
                SwiftUI.Circle()
                    .fill(TANDAColors.Purple.p100)
                    .frame(width: 40, height: 40)

                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundStyle(TANDAColors.Purple.p500)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(TANDAColors.Text.primary)

                Text(description)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundStyle(TANDAColors.Text.secondary)
            }

            Spacer()
        }
    }
}

#Preview("Explore Circles Intro") {
    ExploreCirclesIntroView(onContinue: {})
        .environmentObject(AppState())
}
