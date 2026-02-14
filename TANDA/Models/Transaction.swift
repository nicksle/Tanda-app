import Foundation

// MARK: - Transaction Model
// Represents a financial transaction in TANDA (received payment, sent payment, or payout).

struct Transaction: Identifiable, Equatable {
    let id: UUID
    let user: User?  // Nil for system transactions (payouts, etc.)
    let circleName: String
    let circleEmoji: String
    let date: Date
    let amount: Double
    let type: TransactionType
    let status: TransactionStatus
    let systemIcon: String?  // SF Symbol for payout/system transactions (e.g., "building.columns")

    init(
        id: UUID = UUID(),
        user: User? = nil,
        circleName: String,
        circleEmoji: String,
        date: Date,
        amount: Double,
        type: TransactionType,
        status: TransactionStatus,
        systemIcon: String? = nil
    ) {
        self.id = id
        self.user = user
        self.circleName = circleName
        self.circleEmoji = circleEmoji
        self.date = date
        self.amount = amount
        self.type = type
        self.status = status
        self.systemIcon = systemIcon
    }

    // Formatted date string (e.g., "June 21, 2024")
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter.string(from: date)
    }

    // Formatted amount string (e.g., "+$25" or "-$100")
    var formattedAmount: String {
        let prefix = type == .received ? "+" : "-"
        return "\(prefix)$\(Int(abs(amount)))"
    }

    // Display name (user name or system transaction name)
    var displayName: String {
        user?.name ?? "Payout - Transfer to Bank"
    }
}

// MARK: - Transaction Type

enum TransactionType {
    case received  // Incoming payment from circle member
    case sent      // Outgoing payment to circle member
    case payout    // Withdrawal to bank account
}

// MARK: - Transaction Status

enum TransactionStatus: String {
    case settled = "Settled"
    case pending = "Pending"
    case failed = "Failed"
}
