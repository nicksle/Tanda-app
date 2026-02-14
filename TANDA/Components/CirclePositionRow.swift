import SwiftUI

// MARK: - Circle Position Row
// Shows position number, payout date, and Join button

struct CirclePositionRow: View {
    let position: CirclePosition
    let onJoin: () -> Void

    var body: some View {
        HStack(spacing: TANDASpacing.md) {
            // Position number circle
            ZStack {
                SwiftUI.Circle()
                    .fill(TANDAColors.Purple.p100)
                    .frame(width: 40, height: 40)

                Text("\(position.positionNumber)")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(TANDAColors.Purple.p500)
            }

            // Position info
            VStack(alignment: .leading, spacing: 2) {
                Text("Position \(position.positionNumber)")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(TANDAColors.Text.primary)

                Text(position.formattedPayoutDate)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(TANDAColors.Text.secondary)
            }

            Spacer()

            // Join button
            Button(action: onJoin) {
                Text("Join")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .background(TANDAColors.Neutral.n900)
                    .clipShape(RoundedRectangle(cornerRadius: 100))
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, TANDASpacing.sm)
    }
}

#Preview("Circle Position Row") {
    VStack(spacing: 0) {
        CirclePositionRow(
            position: CirclePosition(
                positionNumber: 3,
                owner: nil,
                payoutDate: Calendar.current.date(from: DateComponents(year: 2024, month: 6, day: 28))!,
                paymentSchedule: []
            ),
            onJoin: { print("Join tapped") }
        )

        Divider()
            .background(TANDAColors.Neutral.n100)

        CirclePositionRow(
            position: CirclePosition(
                positionNumber: 5,
                owner: nil,
                payoutDate: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 26))!,
                paymentSchedule: []
            ),
            onJoin: { print("Join tapped") }
        )
    }
    .padding()
    .background(Color.white)
}
