import SwiftUI

// MARK: - Circle Card
// Complete card component showing circle details, categories, and available positions

struct CircleCard: View {
    let circle: Circle
    let onJoinPosition: (CirclePosition) -> Void
    let onAddToCircle: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: TANDASpacing.md) {
            // Header: Plus button + categories
            HStack(spacing: TANDASpacing.sm) {
                Button(action: onAddToCircle) {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(TANDAColors.Text.secondary)
                        .frame(width: 32, height: 32)
                        .background(TANDAColors.Neutral.n100)
                        .clipShape(SwiftUI.Circle())
                }
                .buttonStyle(.plain)

                // Category tags
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(circle.categories, id: \.self) { category in
                            CategoryTag(category: category)
                        }
                    }
                }
            }

            // Circle name + emoji
            HStack(spacing: TANDASpacing.sm) {
                Text(circle.emoji)
                    .font(.system(size: 32))

                Text(circle.name)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(TANDAColors.Text.primary)
            }

            // Start date
            Text(circle.formattedStartDate)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(TANDAColors.Text.secondary)

            // Info boxes (payout, duration)
            HStack(spacing: TANDASpacing.sm) {
                InfoBox(label: "Payout", value: "$\(circle.payoutAmount)")
                InfoBox(label: "Duration", value: circle.duration)
            }

            // Open positions header
            HStack(spacing: TANDASpacing.xs) {
                Text("\(circle.openPositionsCount) open positions")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(TANDAColors.Text.primary)

                // Member avatars
                if !circle.memberAvatars.isEmpty {
                    AvatarStack(users: circle.memberAvatars)
                }
            }

            // Available positions
            VStack(spacing: 0) {
                ForEach(Array(circle.availablePositions.enumerated()), id: \.element.id) { index, position in
                    CirclePositionRow(
                        position: position,
                        onJoin: { onJoinPosition(position) }
                    )

                    // Divider between positions (not after last one)
                    if index < circle.availablePositions.count - 1 {
                        Divider()
                            .background(TANDAColors.Neutral.n100)
                    }
                }
            }
        }
        .padding(TANDASpacing.md)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: TANDARadius.lg))
        .shadow(color: .black.opacity(0.06), radius: 8, y: 2)
    }
}

// MARK: - Info Box
// Small labeled box showing payout or duration info

struct InfoBox: View {
    let label: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(TANDAColors.Text.secondary)

            Text(value)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(TANDAColors.Text.primary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(TANDASpacing.sm)
        .background(TANDAColors.Neutral.n50)
        .clipShape(RoundedRectangle(cornerRadius: TANDARadius.md))
    }
}

#Preview("Circle Card") {
    ScrollView {
        VStack(spacing: TANDASpacing.md) {
            CircleCard(
                circle: MockData.availableCircles[0],
                onJoinPosition: { position in
                    print("Join position \(position.positionNumber)")
                },
                onAddToCircle: {
                    print("Add to circle tapped")
                }
            )

            CircleCard(
                circle: MockData.availableCircles[1],
                onJoinPosition: { position in
                    print("Join position \(position.positionNumber)")
                },
                onAddToCircle: {
                    print("Add to circle tapped")
                }
            )
        }
        .padding()
        .background(TANDAColors.Neutral.n50)
    }
}
