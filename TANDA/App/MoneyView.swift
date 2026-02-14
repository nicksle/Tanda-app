import SwiftUI

// MARK: - Money View
// Main transactions/money page showing TANDA balance and transaction history.
// Follows Home/Circles navigation paradigm.

struct MoneyView: View {
    @EnvironmentObject var appState: AppState

    private var currentUser: User {
        appState.currentUser
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    // Custom large title header
                    HStack {
                        Text("Transactions")
                            .font(.system(size: 34, weight: .bold))
                            .foregroundStyle(TANDAColors.Text.primary)
                        Spacer()
                    }
                    .padding(.horizontal, TANDASpacing.lg)
                    .padding(.top, TANDASpacing.sm)
                    .padding(.bottom, TANDASpacing.md)
                    .background(TANDAColors.Neutral.n50)

                    // Balance Card
                    BalanceCard(
                        balance: MockData.tandaBalance,
                        onWithdraw: {
                            // TODO: Handle withdrawal
                            print("Withdraw tapped")
                        }
                    )
                    .padding(.horizontal, TANDASpacing.lg)
                    .padding(.top, TANDASpacing.md)

                    // Transaction History Section
                    VStack(alignment: .leading, spacing: TANDASpacing.sm) {
                        // Section title
                        Text("Transaction History")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(TANDAColors.Text.primary)
                            .padding(.horizontal, TANDASpacing.lg)
                            .padding(.vertical, TANDASpacing.sm)

                        // Transaction List
                        VStack(spacing: 0) {
                            // "Settled" header
                            Text("Settled")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundStyle(TANDAColors.Brand.black1)
                                .tracking(-0.32)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, TANDASpacing.lg)
                                .padding(.vertical, 8)
                                .background(Color.white)

                            // Transaction rows
                            LazyVStack(spacing: 0) {
                                ForEach(MockData.transactions) { transaction in
                                    TransactionRow(transaction: transaction)
                                }
                            }
                            .background(Color.white)
                        }
                    }
                    .padding(.top, TANDASpacing.lg)
                }
            }
            .background(TANDAColors.Neutral.n50)
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

#Preview("Money View") {
    MoneyView()
        .environmentObject(AppState())
}
