import SwiftUI

// MARK: - Payment Date Card
// Individual card showing a single payment date in the schedule carousel.
// Shows date, type (payout/contribution), and amount.
// Based on old Figma design - 96×144pt card.

struct PaymentDateCard: View {
    let paymentItem: PaymentScheduleItem

    var body: some View {
        VStack(spacing: 0) {
            // Date section
            VStack(spacing: TANDASpacing.xs) {
                // Day of week
                Text(paymentItem.formattedDayOfWeek)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(TANDAColors.Text.tertiary)
                    .padding(.top, TANDASpacing.sm)

                // Date number (large)
                Text(paymentItem.formattedDate)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(TANDAColors.Text.primary)
                    .padding(.top, 4)

                // Month
                Text(paymentItem.formattedMonth)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundStyle(TANDAColors.Text.secondary)
            }
            .frame(width: 80, height: 80)
            .padding(TANDASpacing.sm)

            // Payment info section
            VStack(spacing: 4) {
                // Action text ("Get paid" or "You pay")
                Text(paymentItem.type.displayText)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(paymentItem.type.textColor)

                // Amount
                Text(paymentItem.formattedAmount)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(paymentItem.type.textColor)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, TANDASpacing.sm)
            .background(paymentItem.type.backgroundColor)
        }
        .frame(width: 96, height: 144)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: TANDARadius.md))
        .overlay(
            RoundedRectangle(cornerRadius: TANDARadius.md)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
    }
}

#Preview("Payment Date Cards") {
    let calendar = Calendar.current
    let now = Date()

    HStack(spacing: TANDASpacing.sm) {
        // Payout card
        PaymentDateCard(
            paymentItem: PaymentScheduleItem(
                date: calendar.date(byAdding: .day, value: 14, to: now)!,
                type: .payout,
                amount: 245.00
            )
        )

        // Contribution card
        PaymentDateCard(
            paymentItem: PaymentScheduleItem(
                date: calendar.date(byAdding: .day, value: 28, to: now)!,
                type: .contribution,
                amount: 65.25
            )
        )
    }
    .padding(TANDASpacing.lg)
    .background(TANDAColors.Neutral.n50)
}
