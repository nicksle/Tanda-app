import SwiftUI

// MARK: - Balance Card
// Displays TANDA balance with withdrawal CTA.
// Used on Money page to show available funds.

struct BalanceCard: View {
    let balance: Double
    let onWithdraw: () -> Void

    var body: some View {
        VStack(spacing: TANDASpacing.sm) {
            // Header: TANDA Balance + Info button
            HStack(alignment: .center, spacing: 5) {
                Text("TANDA Balance")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(TANDAColors.Text.secondary)

                Spacer()

                // Info button
                Button(action: {
                    // TODO: Show balance info
                }) {
                    Image(systemName: "info.circle")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(TANDAColors.Brand.black3)
                }
            }

            // Balance amount - display font
            Text("$\(Int(balance))")
                .font(.system(size: 48, weight: .semibold))
                .foregroundStyle(TANDAColors.Text.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 4)

            // Withdraw button
            PrimaryButton("Withdraw", kind: .primary, isFullWidth: true, action: onWithdraw)
        }
        .padding(TANDASpacing.lg)
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: TANDARadius.lg)
                .stroke(TANDAColors.Neutral.n200, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: TANDARadius.lg))
    }
}

#Preview("Balance Card") {
    BalanceCard(
        balance: 500,
        onWithdraw: {
            print("Withdraw tapped")
        }
    )
    .padding()
}
