import SwiftUI

// MARK: - Circle Model

struct Circle: Identifiable, Equatable, Hashable {
    let id = UUID()
    let name: String
    let emoji: String
    let description: String
    let categories: [CircleCategory]
    let startDate: Date
    let payoutAmount: Int
    let duration: String // e.g., "8 weeks"
    let totalPositions: Int
    let openPositionsCount: Int
    let memberAvatars: [User] // Users who already joined (deprecated, use positions instead)
    let availablePositions: [CirclePosition] // Only vacant positions (deprecated, use positions instead)
    let positions: [CirclePosition] // All positions (filled and vacant)
    let status: CircleStatus

    var formattedStartDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return "Starts \(formatter.string(from: startDate))"
    }

    var filledPositions: [CirclePosition] {
        positions.filter { $0.owner != nil }
    }

    var vacantPositions: [CirclePosition] {
        positions.filter { $0.owner == nil }
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Circle Category

enum CircleCategory: String, CaseIterable {
    case pets = "Pets"
    case house = "House"
    case travel = "Travel"
    case education = "Education"
    case furniture = "Furniture"
    case liveEvents = "Live Events"
    case cat = "Cat"

    var emoji: String {
        switch self {
        case .pets: return "🐶"
        case .house: return "🏡"
        case .travel: return "✈️"
        case .education: return "🎓"
        case .furniture: return "🛋️"
        case .liveEvents: return "🎪"
        case .cat: return "🐱"
        }
    }
}

// MARK: - Circle Status

enum CircleStatus: String, CaseIterable {
    case startingSoon = "Starting Soon"
    case inProgress = "In Progress"
    case available = "Available"

    var color: Color {
        switch self {
        case .startingSoon: return Color(red: 0/255, green: 122/255, blue: 255/255) // iOS blue
        case .inProgress: return Color(red: 52/255, green: 199/255, blue: 89/255) // iOS green
        case .available: return TANDAColors.Purple.p500 // TANDA purple
        }
    }

    var backgroundColor: Color {
        switch self {
        case .startingSoon: return Color(red: 0/255, green: 122/255, blue: 255/255).opacity(0.1)
        case .inProgress: return Color(red: 52/255, green: 199/255, blue: 89/255).opacity(0.1)
        case .available: return TANDAColors.Purple.p100
        }
    }
}

// MARK: - Circle Position

struct CirclePosition: Identifiable, Equatable, Hashable {
    let id = UUID()
    let positionNumber: Int
    let owner: User? // nil if position is vacant
    let payoutDate: Date
    let paymentSchedule: [PaymentScheduleItem]

    var formattedPayoutDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return "Payout Date: \(formatter.string(from: payoutDate))"
    }

    var isVacant: Bool {
        owner == nil
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Payment Schedule Item

struct PaymentScheduleItem: Identifiable, Equatable, Hashable {
    let id = UUID()
    let date: Date
    let type: PaymentType
    let amount: Double

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }

    var formattedMonth: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        return formatter.string(from: date)
    }

    var formattedDayOfWeek: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date)
    }

    var formattedAmount: String {
        String(format: "$%.2f", amount)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Payment Type

enum PaymentType: Equatable, Hashable {
    case payout
    case contribution

    var displayText: String {
        switch self {
        case .payout: return "Get paid"
        case .contribution: return "You pay"
        }
    }

    var textColor: Color {
        switch self {
        case .payout: return TANDAColors.Feedback.green
        case .contribution: return TANDAColors.Text.secondary
        }
    }

    var backgroundColor: Color {
        switch self {
        case .payout: return TANDAColors.Feedback.green.opacity(0.1)
        case .contribution: return TANDAColors.Neutral.n100
        }
    }
}
