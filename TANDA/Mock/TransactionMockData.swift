import Foundation

// MARK: - Transaction Mock Data

extension MockData {

    // Users for transactions (matching Figma design)
    static let transactionUsers: [User] = [
        User(name: "Marisa Garcia"),
        User(name: "Anima Arush"),
        User(name: "Alexis Demi"),
        User(name: "Joe Mantasi"),
    ]

    // Sample transactions for Money page
    static let transactions: [Transaction] = [
        // Received transactions from circle members
        Transaction(
            user: transactionUsers[0],
            circleName: "Summer Vacation",
            circleEmoji: "☀️",
            date: createDate(month: 6, day: 21),
            amount: 25,
            type: .received,
            status: .settled
        ),
        Transaction(
            user: transactionUsers[1],
            circleName: "Summer Vacation",
            circleEmoji: "☀️",
            date: createDate(month: 6, day: 21),
            amount: 25,
            type: .received,
            status: .settled
        ),
        Transaction(
            user: transactionUsers[2],
            circleName: "Summer Vacation",
            circleEmoji: "☀️",
            date: createDate(month: 6, day: 21),
            amount: 25,
            type: .received,
            status: .settled
        ),
        Transaction(
            user: transactionUsers[3],
            circleName: "Summer Vacation",
            circleEmoji: "☀️",
            date: createDate(month: 6, day: 21),
            amount: 25,
            type: .received,
            status: .settled
        ),

        // Payout transaction (system transaction, no user)
        Transaction(
            user: nil,
            circleName: "Summer Vacation",
            circleEmoji: "☀️",
            date: createDate(month: 6, day: 21),
            amount: 100,
            type: .payout,
            status: .settled,
            systemIcon: "building.columns"
        ),
    ]

    // Current TANDA balance
    static let tandaBalance: Double = 500

    // Helper function to create dates
    private static func createDate(month: Int, day: Int) -> Date {
        var components = DateComponents()
        components.year = 2024
        components.month = month
        components.day = day
        return Calendar.current.date(from: components) ?? Date()
    }
}
