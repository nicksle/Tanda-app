import SwiftUI

// MARK: - Join Circle Sheet
// Interactive half-sheet for joining a circle.
// Collapsed: Shows open positions count, position indicators, and "Join Circle" CTA
// Expanded: Shows position navigation, details, and "Join Position X" CTA

struct JoinCircleSheet: View {
    let circle: Circle
    let onJoinPosition: (CirclePosition) -> Void
    @Binding var isExpanded: Bool

    @State private var selectedPositionIndex: Int = 0

    private var selectedPosition: CirclePosition? {
        guard !circle.availablePositions.isEmpty,
              selectedPositionIndex < circle.availablePositions.count else {
            return nil
        }
        return circle.availablePositions[selectedPositionIndex]
    }

    var body: some View {
        VStack(alignment: .leading, spacing: TANDASpacing.md) {
            // Position indicators
            HStack(spacing: 12) {
                ForEach(Array(circle.availablePositions.enumerated()), id: \.element.id) { index, position in
                    PositionCircleIndicator(
                        positionNumber: position.positionNumber,
                        isSelected: isExpanded && index == selectedPositionIndex,
                        action: {
                            if isExpanded {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    selectedPositionIndex = index
                                }
                            }
                        }
                    )
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, TANDASpacing.lg)

            // CTA Button
            if let position = selectedPosition {
                PrimaryButton(
                    isExpanded ? "Join Position \(position.positionNumber)" : "Join Circle",
                    kind: .primary,
                    isFullWidth: true
                ) {
                    if isExpanded {
                        onJoinPosition(position)
                    } else {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            isExpanded = true
                        }
                    }
                }
                .padding(.horizontal, TANDASpacing.lg)
            }
        }
        .padding(.bottom, TANDASpacing.lg)
        .padding(.top, TANDASpacing.lg)
        .frame(maxWidth: .infinity)
        .frame(minHeight: 140)
    }
}

#Preview("Join Circle Sheet") {
    @Previewable @State var isExpanded = false

    Color.black.ignoresSafeArea()
        .sheet(isPresented: .constant(true)) {
            JoinCircleSheet(
                circle: Circle(
                    name: "Summer Vacation",
                    emoji: "☀️",
                    description: "Save together for your dream summer getaway",
                    categories: [.travel],
                    startDate: Date(),
                    payoutAmount: 500,
                    duration: "8 weeks",
                    totalPositions: 8,
                    openPositionsCount: 3,
                    memberAvatars: [],
                    availablePositions: [
                        CirclePosition(positionNumber: 3, owner: nil, payoutDate: Date(), paymentSchedule: []),
                        CirclePosition(positionNumber: 5, owner: nil, payoutDate: Date(), paymentSchedule: []),
                        CirclePosition(positionNumber: 7, owner: nil, payoutDate: Date(), paymentSchedule: [])
                    ],
                    positions: [],
                    status: .available
                ),
                onJoinPosition: { position in
                    print("Joined position \(position.positionNumber)")
                },
                isExpanded: $isExpanded
            )
            .presentationDetents(
                [.height(140), .medium],
                selection: Binding(
                    get: { isExpanded ? .medium : .height(140) },
                    set: { isExpanded = ($0 == .medium) }
                )
            )
            .presentationBackground(.thinMaterial)
            .presentationBackgroundInteraction(.enabled(upThrough: .height(140)))
            .interactiveDismissDisabled()
        }
}
