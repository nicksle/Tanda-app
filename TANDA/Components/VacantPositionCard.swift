import SwiftUI

// MARK: - Vacant Position Card
// Card for displaying a vacant position in a circle.
// Shows empty state with join button and payment schedule.

struct VacantPositionCard: View {
    let position: CirclePosition
    let onJoinTapped: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            // Vacant position section
            HStack(spacing: TANDASpacing.sm) {
                // Empty avatar with plus icon
                ZStack {
                    SwiftUI.Circle()
                        .fill(TANDAColors.Neutral.n200)
                        .frame(width: 40, height: 40)

                    Image(systemName: "plus")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(TANDAColors.Text.tertiary)
                }

                // Position info
                VStack(alignment: .leading, spacing: 2) {
                    Text("Position \(position.positionNumber)")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(TANDAColors.Text.primary)

                    Text("This position is vacant")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(TANDAColors.Text.secondary)
                }

                Spacer()
            }
            .padding(TANDASpacing.md)

            // Join button
            Button {
                onJoinTapped()
            } label: {
                Text("Join this circle")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(TANDAColors.Purple.p500)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, TANDASpacing.xs)
                    .background(TANDAColors.Purple.p100)
                    .clipShape(RoundedRectangle(cornerRadius: TANDARadius.sm))
            }
            .padding(.horizontal, TANDASpacing.md)
            .padding(.bottom, TANDASpacing.md)

            // Divider
            Divider()
                .padding(.horizontal, TANDASpacing.md)

            // Payment schedule section (expandable)
            PaymentScheduleSection(paymentSchedule: position.paymentSchedule)
                .padding(TANDASpacing.md)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(TANDAColors.Surface.primary)
        .clipShape(RoundedRectangle(cornerRadius: TANDARadius.lg))
    }
}

#Preview("Vacant Position Card") {
    let calendar = Calendar.current
    let now = Date()

    let sampleSchedule = [
        PaymentScheduleItem(
            date: calendar.date(byAdding: .day, value: 14, to: now)!,
            type: .contribution,
            amount: 65.25
        ),
        PaymentScheduleItem(
            date: calendar.date(byAdding: .day, value: 28, to: now)!,
            type: .payout,
            amount: 245.00
        ),
        PaymentScheduleItem(
            date: calendar.date(byAdding: .day, value: 42, to: now)!,
            type: .contribution,
            amount: 65.25
        )
    ]

    VStack(spacing: TANDASpacing.sm) {
        VacantPositionCard(
            position: CirclePosition(
                positionNumber: 2,
                owner: nil,
                payoutDate: calendar.date(byAdding: .day, value: 28, to: now)!,
                paymentSchedule: sampleSchedule
            ),
            onJoinTapped: {
                print("Join position 2")
            }
        )

        VacantPositionCard(
            position: CirclePosition(
                positionNumber: 3,
                owner: nil,
                payoutDate: calendar.date(byAdding: .day, value: 42, to: now)!,
                paymentSchedule: sampleSchedule
            ),
            onJoinTapped: {
                print("Join position 3")
            }
        )
    }
    .padding(TANDASpacing.lg)
    .background(TANDAColors.Neutral.n50)
}
