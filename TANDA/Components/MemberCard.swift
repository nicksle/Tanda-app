import SwiftUI

// MARK: - Member Card
// Individual frosted glass card for displaying a circle member.
// Shows member profile (tappable) and payment schedule (expandable).

struct MemberCard: View {
    let position: CirclePosition

    private var member: User? {
        position.owner
    }

    var body: some View {
        VStack(spacing: 0) {
            // Member profile section (tappable)
            NavigationLink {
                // TODO: Navigate to member profile view
                if let member = member {
                    PlaceholderProfileView(memberName: member.name)
                }
            } label: {
                HStack(spacing: TANDASpacing.sm) {
                    // Avatar
                    if let member = member {
                        ZStack {
                            SwiftUI.Circle()
                                .fill(member.avatarColor)
                                .frame(width: 40, height: 40)

                            Text(member.initials)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundStyle(.white)
                        }

                        // Name
                        Text(member.name)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(TANDAColors.Text.primary)
                    }

                    Spacer()

                    // Position badge
                    Text("Position \(position.positionNumber)")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(TANDAColors.Text.secondary)
                        .padding(.horizontal, TANDASpacing.xs)
                        .padding(.vertical, 4)
                        .background(TANDAColors.Neutral.n100)
                        .clipShape(Capsule())
                }
                .padding(TANDASpacing.md)
            }
            .buttonStyle(.plain)

            // Divider
            Divider()
                .padding(.horizontal, TANDASpacing.md)

            // Payment schedule section (expandable, non-clickable)
            PaymentScheduleSection(paymentSchedule: position.paymentSchedule)
                .padding(TANDASpacing.md)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(TANDAColors.Surface.primary)
        .clipShape(RoundedRectangle(cornerRadius: TANDARadius.lg))
    }
}

// MARK: - Placeholder Profile View
// Temporary placeholder for member profile detail page.

struct PlaceholderProfileView: View {
    let memberName: String

    var body: some View {
        VStack(spacing: TANDASpacing.xl) {
            Spacer()

            Image(systemName: "person.circle.fill")
                .font(.system(size: 80))
                .foregroundStyle(TANDAColors.Purple.p500.opacity(0.3))

            Text(memberName)
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(TANDAColors.Text.primary)

            Text("Profile coming soon")
                .font(.system(size: 16, weight: .regular))
                .foregroundStyle(TANDAColors.Text.tertiary)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(TANDAColors.Neutral.n50)
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview("Member Card") {
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
        )
    ]

    NavigationStack {
        VStack(spacing: TANDASpacing.sm) {
            MemberCard(
                position: CirclePosition(
                    positionNumber: 1,
                    owner: User(name: "John Doe"),
                    payoutDate: now,
                    paymentSchedule: sampleSchedule
                )
            )

            MemberCard(
                position: CirclePosition(
                    positionNumber: 2,
                    owner: User(name: "Jane Smith"),
                    payoutDate: calendar.date(byAdding: .day, value: 14, to: now)!,
                    paymentSchedule: sampleSchedule
                )
            )
        }
        .padding(TANDASpacing.lg)
        .background(TANDAColors.Neutral.n50)
    }
}
