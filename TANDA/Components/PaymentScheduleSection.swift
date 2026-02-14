import SwiftUI

// MARK: - Payment Schedule Section
// Collapsible section showing the payment schedule for a position.
// Header: "Contributions and payout schedule" with chevron to expand/collapse
// Content: Horizontal scrolling carousel of PaymentDateCard components

struct PaymentScheduleSection: View {
    let paymentSchedule: [PaymentScheduleItem]
    @State private var isExpanded: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: TANDASpacing.sm) {
            // Header with chevron
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack {
                    Text("Contributions and payout schedule")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(TANDAColors.Text.primary)

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(TANDAColors.Text.tertiary)
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                }
            }
            .buttonStyle(.plain)

            // Payment schedule carousel (only when expanded)
            if isExpanded {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: TANDASpacing.sm) {
                        ForEach(paymentSchedule) { item in
                            PaymentDateCard(paymentItem: item)
                        }
                    }
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }
}

#Preview("Payment Schedule Section") {
    let calendar = Calendar.current
    let now = Date()

    let sampleSchedule = [
        PaymentScheduleItem(
            date: calendar.date(byAdding: .day, value: 0, to: now)!,
            type: .payout,
            amount: 245.00
        ),
        PaymentScheduleItem(
            date: calendar.date(byAdding: .day, value: 14, to: now)!,
            type: .contribution,
            amount: 65.25
        ),
        PaymentScheduleItem(
            date: calendar.date(byAdding: .day, value: 28, to: now)!,
            type: .contribution,
            amount: 65.25
        ),
        PaymentScheduleItem(
            date: calendar.date(byAdding: .day, value: 42, to: now)!,
            type: .contribution,
            amount: 65.25
        )
    ]

    VStack(spacing: TANDASpacing.lg) {
        PaymentScheduleSection(paymentSchedule: sampleSchedule)
    }
    .padding(TANDASpacing.lg)
    .background(TANDAColors.Neutral.n50)
}
