import SwiftUI

// MARK: - Transaction Row
// List item showing transaction details with avatar, info, and amount.
// Used in Money page transaction history.

struct TransactionRow: View {
    let transaction: Transaction

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 14) {
                // Avatar or system icon
                if let user = transaction.user {
                    // User avatar
                    SwiftUI.Circle()
                        .fill(user.avatarColor)
                        .frame(width: 54, height: 54)
                        .overlay(
                            Text(user.initials)
                                .font(.system(size: 20, weight: .medium))
                                .foregroundStyle(.white)
                        )
                } else {
                    // System icon for payout transactions
                    ZStack {
                        SwiftUI.Circle()
                            .fill(TANDAColors.Brand.white2)
                            .frame(width: 54, height: 54)

                        if let systemIcon = transaction.systemIcon {
                            Image(systemName: systemIcon)
                                .font(.system(size: 20))
                                .foregroundStyle(TANDAColors.Brand.black3)
                        }
                    }
                }

                // Transaction information
                VStack(alignment: .leading, spacing: 2) {
                    Text(transaction.displayName)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(TANDAColors.Brand.black1)
                        .tracking(-0.32)
                        .lineLimit(1)

                    Text("\(transaction.circleEmoji) \(transaction.circleName)")
                        .font(.system(size: 13, weight: .regular))
                        .foregroundStyle(TANDAColors.Brand.black2)
                        .tracking(-0.13)
                        .lineLimit(1)

                    Text(transaction.formattedDate)
                        .font(.system(size: 13, weight: .regular))
                        .foregroundStyle(TANDAColors.Brand.black2)
                        .tracking(-0.13)
                }

                Spacer()

                // Amount and status
                VStack(alignment: .trailing, spacing: 2) {
                    Text(transaction.formattedAmount)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(transaction.type == .received ? TANDAColors.Brand.successGreen : TANDAColors.Brand.black1)
                        .tracking(-0.32)

                    Text(transaction.status.rawValue)
                        .font(.system(size: 13, weight: .regular))
                        .foregroundStyle(TANDAColors.Brand.black2)
                        .tracking(-0.13)
                }
            }
            .padding(.vertical, 12)
            .padding(.horizontal, TANDASpacing.lg)

            // Divider
            Divider()
                .background(TANDAColors.Brand.white3)
        }
        .background(Color.white)
    }
}

#Preview("Transaction Row - Received") {
    VStack(spacing: 0) {
        TransactionRow(
            transaction: Transaction(
                user: User(name: "Marisa Garcia"),
                circleName: "Summer Vacation",
                circleEmoji: "☀️",
                date: Date(),
                amount: 25,
                type: .received,
                status: .settled
            )
        )
        TransactionRow(
            transaction: Transaction(
                user: nil,
                circleName: "Summer Vacation",
                circleEmoji: "☀️",
                date: Date(),
                amount: 100,
                type: .payout,
                status: .settled,
                systemIcon: "building.columns"
            )
        )
    }
}
