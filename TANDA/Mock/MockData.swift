import SwiftUI

// MARK: - Mock Data
// Realistic fake data for the demo prototype.
// All data is hardcoded for speed — no persistence needed.

// MARK: - User

struct MockUser: Identifiable {
    let id = UUID()
    let firstName: String
    let lastName: String
    let email: String
    let avatarColor: Color
    let initials: String
    
    var fullName: String { "\(firstName) \(lastName)" }
}

// MARK: - Circle

struct MockCircle: Identifiable {
    let id = UUID()
    let name: String
    let emoji: String
    let memberCount: Int
    let totalPool: Double
    let contributionAmount: Double
    let frequency: String
    let nextPayout: String
    let nextPayoutMember: String
    let members: [MockUser]
    let progress: Double // 0...1
    let isActive: Bool
}

// MARK: - Transaction

struct MockTransaction: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let amount: Double
    let isCredit: Bool
    let date: String
    let circleEmoji: String
}

// MARK: - Sample Data

struct MockData {
    
    // MARK: Current User
    static let currentUser = MockUser(
        firstName: "Sarah",
        lastName: "Johnson",
        email: "sarah@example.com",
        avatarColor: TANDAColors.Purple.p500,
        initials: "SJ"
    )
    
    // MARK: Members
    static let members: [MockUser] = [
        currentUser,
        MockUser(firstName: "David", lastName: "Chen", email: "david@example.com",
                 avatarColor: TANDAColors.Secondary.coral, initials: "DC"),
        MockUser(firstName: "Amara", lastName: "Osei", email: "amara@example.com",
                 avatarColor: TANDAColors.Secondary.violet, initials: "AO"),
        MockUser(firstName: "Marcus", lastName: "Rivera", email: "marcus@example.com",
                 avatarColor: TANDAColors.Secondary.orange, initials: "MR"),
        MockUser(firstName: "Priya", lastName: "Patel", email: "priya@example.com",
                 avatarColor: TANDAColors.Feedback.blue, initials: "PP"),
        MockUser(firstName: "James", lastName: "Kim", email: "james@example.com",
                 avatarColor: TANDAColors.Feedback.green, initials: "JK"),
    ]
    
    // MARK: Circles
    static let circles: [MockCircle] = [
        MockCircle(
            name: "Family Fund",
            emoji: "👨‍👩‍👧‍👦",
            memberCount: 6,
            totalPool: 3000,
            contributionAmount: 500,
            frequency: "Monthly",
            nextPayout: "Feb 15",
            nextPayoutMember: "David Chen",
            members: Array(members.prefix(6)),
            progress: 0.65,
            isActive: true
        ),
        MockCircle(
            name: "Girls Trip",
            emoji: "✈️",
            memberCount: 4,
            totalPool: 1200,
            contributionAmount: 300,
            frequency: "Bi-weekly",
            nextPayout: "Feb 22",
            nextPayoutMember: "Amara Osei",
            members: [members[0], members[2], members[4], members[1]],
            progress: 0.4,
            isActive: true
        ),
        MockCircle(
            name: "Emergency Fund",
            emoji: "🛡️",
            memberCount: 3,
            totalPool: 900,
            contributionAmount: 100,
            frequency: "Weekly",
            nextPayout: "Feb 10",
            nextPayoutMember: "You",
            members: [members[0], members[3], members[5]],
            progress: 0.85,
            isActive: true
        ),
    ]
    
    // MARK: Transactions
    static let recentTransactions: [MockTransaction] = [
        MockTransaction(title: "Family Fund", subtitle: "Contribution sent",
                        amount: 500, isCredit: false, date: "Today", circleEmoji: "👨‍👩‍👧‍👦"),
        MockTransaction(title: "Emergency Fund", subtitle: "Payout received",
                        amount: 900, isCredit: true, date: "Yesterday", circleEmoji: "🛡️"),
        MockTransaction(title: "Girls Trip", subtitle: "Contribution sent",
                        amount: 300, isCredit: false, date: "Feb 1", circleEmoji: "✈️"),
        MockTransaction(title: "Family Fund", subtitle: "Payout received",
                        amount: 3000, isCredit: true, date: "Jan 28", circleEmoji: "👨‍👩‍👧‍👦"),
    ]
    
    // MARK: Summary
    static let totalSaved: Double = 4750
    static let activeCircleCount: Int = 3
    static let nextPayoutAmount: Double = 900
    static let nextPayoutDate: String = "Feb 10"
}
