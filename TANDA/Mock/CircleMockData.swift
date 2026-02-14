import Foundation

// MARK: - Circle Mock Data

extension MockData {

    static let availableCircles: [Circle] = [
        // Circle 1: Pets and House Supplies
        Circle(
            name: "Pets and House Supplies",
            emoji: "🐶",
            description: "Save together for pet supplies and household essentials",
            categories: [.pets, .house],
            startDate: createDate(month: 5, day: 31),
            payoutAmount: 100,
            duration: "8 weeks",
            totalPositions: 5,
            openPositionsCount: 2,
            memberAvatars: Array(feedUsers.prefix(3)), // Deprecated
            availablePositions: [ // Deprecated
                CirclePosition(
                    positionNumber: 3,
                    owner: nil,
                    payoutDate: createDate(month: 6, day: 28),
                    paymentSchedule: []
                ),
                CirclePosition(
                    positionNumber: 5,
                    owner: nil,
                    payoutDate: createDate(month: 7, day: 26),
                    paymentSchedule: []
                )
            ],
            positions: [
                // Position 1 - Filled (Creator)
                CirclePosition(
                    positionNumber: 1,
                    owner: feedUsers[0],
                    payoutDate: createDate(month: 4, day: 16),
                    paymentSchedule: createPaymentSchedule(
                        startDate: createDate(month: 4, day: 16),
                        contributionAmount: 65.25,
                        payoutAmount: 245.00,
                        payoutWeek: 0,
                        totalWeeks: 4
                    )
                ),
                // Position 2 - Filled
                CirclePosition(
                    positionNumber: 2,
                    owner: feedUsers[1],
                    payoutDate: createDate(month: 4, day: 30),
                    paymentSchedule: createPaymentSchedule(
                        startDate: createDate(month: 4, day: 16),
                        contributionAmount: 65.25,
                        payoutAmount: 245.00,
                        payoutWeek: 1,
                        totalWeeks: 4
                    )
                ),
                // Position 3 - Vacant
                CirclePosition(
                    positionNumber: 3,
                    owner: nil,
                    payoutDate: createDate(month: 5, day: 14),
                    paymentSchedule: createPaymentSchedule(
                        startDate: createDate(month: 4, day: 16),
                        contributionAmount: 65.25,
                        payoutAmount: 245.00,
                        payoutWeek: 2,
                        totalWeeks: 4
                    )
                ),
                // Position 4 - Filled
                CirclePosition(
                    positionNumber: 4,
                    owner: feedUsers[2],
                    payoutDate: createDate(month: 5, day: 28),
                    paymentSchedule: createPaymentSchedule(
                        startDate: createDate(month: 4, day: 16),
                        contributionAmount: 65.25,
                        payoutAmount: 245.00,
                        payoutWeek: 3,
                        totalWeeks: 4
                    )
                ),
                // Position 5 - Vacant
                CirclePosition(
                    positionNumber: 5,
                    owner: nil,
                    payoutDate: createDate(month: 6, day: 12),
                    paymentSchedule: createPaymentSchedule(
                        startDate: createDate(month: 4, day: 16),
                        contributionAmount: 65.25,
                        payoutAmount: 245.00,
                        payoutWeek: 4,
                        totalWeeks: 4
                    )
                )
            ],
            status: .available
        ),

        // Circle 2: Cat Funds
        Circle(
            name: "Cat Funds",
            emoji: "🐱",
            description: "Pool funds for cat care and related expenses",
            categories: [.pets, .house, .travel],
            startDate: createDate(month: 5, day: 31),
            payoutAmount: 250,
            duration: "8 weeks",
            totalPositions: 5,
            openPositionsCount: 2,
            memberAvatars: Array(feedUsers.prefix(3)),
            availablePositions: [
                CirclePosition(
                    positionNumber: 2,
                    owner: nil,
                    payoutDate: createDate(month: 5, day: 5),
                    paymentSchedule: []
                ),
                CirclePosition(
                    positionNumber: 5,
                    owner: nil,
                    payoutDate: createDate(month: 5, day: 5),
                    paymentSchedule: []
                )
            ],
            positions: [],  // TODO: Add full positions data
            status: .startingSoon
        ),

        // Circle 3: Housing Stash
        Circle(
            name: "Housing Stash",
            emoji: "🐱",
            description: "Build savings for home improvements and furniture",
            categories: [.pets, .education, .furniture],
            startDate: createDate(month: 5, day: 31),
            payoutAmount: 250,
            duration: "8 weeks",
            totalPositions: 5,
            openPositionsCount: 2,
            memberAvatars: Array(feedUsers.prefix(3)),
            availablePositions: [
                CirclePosition(
                    positionNumber: 3,
                    owner: nil,
                    payoutDate: createDate(month: 5, day: 5),
                    paymentSchedule: []
                ),
                CirclePosition(
                    positionNumber: 5,
                    owner: nil,
                    payoutDate: createDate(month: 5, day: 5),
                    paymentSchedule: []
                )
            ],
            positions: [],  // TODO: Add full positions data
            status: .inProgress
        ),

        // Circle 4: Pets and Stuff
        Circle(
            name: "Pets and Stuff",
            emoji: "🐕",
            description: "Save for pet care and event tickets together",
            categories: [.pets, .house, .liveEvents],
            startDate: createDate(month: 5, day: 31),
            payoutAmount: 250,
            duration: "8 weeks",
            totalPositions: 5,
            openPositionsCount: 2,
            memberAvatars: Array(feedUsers.prefix(3)),
            availablePositions: [
                CirclePosition(
                    positionNumber: 3,
                    owner: nil,
                    payoutDate: createDate(month: 5, day: 5),
                    paymentSchedule: []
                ),
                CirclePosition(
                    positionNumber: 5,
                    owner: nil,
                    payoutDate: createDate(month: 5, day: 5),
                    paymentSchedule: []
                )
            ],
            positions: [],  // TODO: Add full positions data
            status: .available
        ),

        // Circle 5: House Renovations
        Circle(
            name: "House Renovations",
            emoji: "🏡",
            description: "Collaborate to fund your next home renovation project",
            categories: [.pets, .house],
            startDate: createDate(month: 5, day: 31),
            payoutAmount: 250,
            duration: "8 weeks",
            totalPositions: 5,
            openPositionsCount: 2,
            memberAvatars: Array(feedUsers.prefix(3)),
            availablePositions: [
                CirclePosition(
                    positionNumber: 3,
                    owner: nil,
                    payoutDate: createDate(month: 5, day: 5),
                    paymentSchedule: []
                ),
                CirclePosition(
                    positionNumber: 5,
                    owner: nil,
                    payoutDate: createDate(month: 5, day: 5),
                    paymentSchedule: []
                )
            ],
            positions: [],  // TODO: Add full positions data
            status: .startingSoon
        )
    ]

    // Helper function to create dates
    private static func createDate(month: Int, day: Int) -> Date {
        var components = DateComponents()
        components.year = 2024
        components.month = month
        components.day = day
        return Calendar.current.date(from: components) ?? Date()
    }

    // Helper function to create payment schedules
    // Generates a payment schedule for a position showing contributions and payout
    private static func createPaymentSchedule(
        startDate: Date,
        contributionAmount: Double,
        payoutAmount: Double,
        payoutWeek: Int,  // Which week (0-4) this position gets paid
        totalWeeks: Int
    ) -> [PaymentScheduleItem] {
        var schedule: [PaymentScheduleItem] = []
        let calendar = Calendar.current

        for week in 0...totalWeeks {
            let paymentDate = calendar.date(byAdding: .weekOfYear, value: week * 2, to: startDate) ?? startDate

            if week == payoutWeek {
                // This is the payout week for this position
                schedule.append(PaymentScheduleItem(
                    date: paymentDate,
                    type: .payout,
                    amount: payoutAmount
                ))
            } else {
                // This is a contribution week
                schedule.append(PaymentScheduleItem(
                    date: paymentDate,
                    type: .contribution,
                    amount: contributionAmount
                ))
            }
        }

        return schedule
    }
}
