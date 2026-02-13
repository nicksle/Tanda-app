import SwiftUI

// MARK: - Circle Detail View
// Detail page for a specific circle with tabbed interface (Members, Activity).

struct CircleDetailView: View {
    let circle: Circle
    @State private var selectedTab: DetailTab = .members
    @State private var isSheetExpanded: Bool = false

    enum DetailTab: String, CaseIterable {
        case members = "Members"
        case activity = "Activity"

        var tabOptions: [String] {
            DetailTab.allCases.map { $0.rawValue }
        }
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                // Circle header section
                CircleHeaderSection(circle: circle)

                // Tab content with sticky header
                Section {
                    switch selectedTab {
                    case .members:
                        MembersTab(circle: circle)
                    case .activity:
                        ActivityTab(circle: circle)
                    }
                } header: {
                    // Segmented control - becomes sticky when scrolled to top
                    SegmentedControl(
                        options: DetailTab.allCases.map { $0.rawValue },
                        selectedIndex: Binding(
                            get: { DetailTab.allCases.firstIndex(of: selectedTab) ?? 0 },
                            set: { selectedTab = DetailTab.allCases[$0] }
                        )
                    )
                    .padding(.horizontal, TANDASpacing.lg)
                    .padding(.vertical, TANDASpacing.md)
                    .background(Color.white.opacity(0.95))
                }
            }
            .padding(.bottom, 160) // Add padding for the sheet
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [TANDAColors.Neutral.n50, Color.white]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
        .sheet(isPresented: .constant(true)) {
            JoinCircleSheet(
                circle: circle,
                onJoinPosition: { position in
                    // TODO: Handle join position action
                    print("Joined position \(position.positionNumber)")
                },
                isExpanded: $isSheetExpanded
            )
            .presentationDetents(
                [.height(140), .medium],
                selection: Binding(
                    get: { isSheetExpanded ? .medium : .height(140) },
                    set: { isSheetExpanded = ($0 == .medium) }
                )
            )
            .presentationBackground(.thinMaterial)
            .presentationBackgroundInteraction(.enabled(upThrough: .height(140)))
            .interactiveDismissDisabled()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .transaction { transaction in
            transaction.animation = .spring(response: 0.2, dampingFraction: 0.9)
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                StatusPill(status: circle.status)
            }

            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button {
                        // TODO: Share circle
                    } label: {
                        Label("Share Circle", systemImage: "square.and.arrow.up")
                    }

                    Button {
                        // TODO: Invite friends
                    } label: {
                        Label("Invite Friends", systemImage: "person.badge.plus")
                    }

                    Divider()

                    Button {
                        // TODO: Report issue
                    } label: {
                        Label("Report Issue", systemImage: "exclamationmark.triangle")
                    }

                    Button(role: .destructive) {
                        // TODO: Leave circle
                    } label: {
                        Label("Leave Circle", systemImage: "rectangle.portrait.and.arrow.right")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 20, weight: .regular))
                        .foregroundStyle(TANDAColors.Brand.black3)
                }
            }
        }
    }
}

// MARK: - Circle Header Section

struct CircleHeaderSection: View {
    let circle: Circle

    var body: some View {
        VStack(spacing: TANDASpacing.md) {
            // Emoji in circle (centered)
            ZStack {
                SwiftUI.Circle()
                    .fill(Color.white)
                    .frame(width: 120, height: 120)
                    .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)

                Text(circle.emoji)
                    .font(.system(size: 56))
            }

            // Position indicator circles
            HStack(spacing: -8) {
                if !circle.positions.isEmpty {
                    // Use full positions data if available
                    ForEach(circle.positions) { position in
                        if let owner = position.owner {
                            // Filled position: show avatar
                            ZStack {
                                SwiftUI.Circle()
                                    .fill(owner.avatarColor)
                                    .frame(width: 40, height: 40)

                                Text(owner.initials)
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(.white)
                            }
                        } else {
                            // Vacant position: show number with dashed border
                            ZStack {
                                SwiftUI.Circle()
                                    .stroke(style: StrokeStyle(lineWidth: 1.5, dash: [3, 3]))
                                    .foregroundStyle(TANDAColors.Neutral.n400)
                                    .frame(width: 40, height: 40)

                                Text("\(position.positionNumber)")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(TANDAColors.Text.secondary)
                            }
                        }
                    }
                } else {
                    // Fallback: show generic circles based on totalPositions
                    ForEach(0..<circle.totalPositions, id: \.self) { index in
                        if index < (circle.totalPositions - circle.openPositionsCount) {
                            // Filled - use generic avatar from memberAvatars if available
                            if index < circle.memberAvatars.count {
                                let member = circle.memberAvatars[index]
                                ZStack {
                                    SwiftUI.Circle()
                                        .fill(member.avatarColor)
                                        .frame(width: 40, height: 40)

                                    Text(member.initials)
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundStyle(.white)
                                }
                            } else {
                                SwiftUI.Circle()
                                    .fill(TANDAColors.Purple.p500)
                                    .frame(width: 40, height: 40)
                            }
                        } else {
                            // Vacant - show position number with dashed border
                            ZStack {
                                SwiftUI.Circle()
                                    .stroke(style: StrokeStyle(lineWidth: 1.5, dash: [3, 3]))
                                    .foregroundStyle(TANDAColors.Neutral.n400)
                                    .frame(width: 40, height: 40)

                                Text("\(index + 1)")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(TANDAColors.Text.secondary)
                            }
                        }
                    }
                }
            }
            .offset(y: -32)

            // Circle name (centered)
            Text(circle.name)
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(TANDAColors.Text.primary)
                .padding(.top, -32)

            // 2×2 Metrics Grid
            VStack(spacing: TANDASpacing.sm) {
                // Row 1: Start Date | Payout
                HStack(spacing: TANDASpacing.sm) {
                    InfoItem(label: "Start Date", value: circle.formattedStartDate)
                        .frame(maxWidth: .infinity)

                    InfoItem(label: "Payout", value: "$\(circle.payoutAmount)")
                        .frame(maxWidth: .infinity)
                }

                // Row 2: Duration | Members
                HStack(spacing: TANDASpacing.sm) {
                    InfoItem(label: "Duration", value: circle.duration)
                        .frame(maxWidth: .infinity)

                    InfoItem(label: "Members", value: "\(circle.totalPositions - circle.openPositionsCount)/\(circle.totalPositions)")
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(.horizontal, TANDASpacing.lg)
        .padding(.top, TANDASpacing.sm)
        .padding(.bottom, TANDASpacing.lg)
    }
}

struct InfoItem: View {
    let label: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(TANDAColors.Text.tertiary)

            Text(value)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(TANDAColors.Text.primary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(TANDASpacing.md)
        .background(TANDAColors.Surface.primary)
        .clipShape(RoundedRectangle(cornerRadius: TANDARadius.lg))
    }
}

// MARK: - Members Tab

struct MembersTab: View {
    let circle: Circle

    var body: some View {
        VStack(alignment: .leading, spacing: TANDASpacing.sm) {
            Text("Positions (\(circle.filledPositions.count)/\(circle.totalPositions))")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(TANDAColors.Text.primary)
                .padding(.horizontal, TANDASpacing.lg)

            LazyVStack(spacing: TANDASpacing.sm) {
                if circle.positions.isEmpty {
                    // Fallback for circles without position data
                    ForEach(Array(circle.memberAvatars.enumerated()), id: \.element.id) { index, member in
                        HStack(spacing: TANDASpacing.sm) {
                            ZStack {
                                SwiftUI.Circle()
                                    .fill(member.avatarColor)
                                    .frame(width: 40, height: 40)

                                Text(member.initials)
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundStyle(.white)
                            }

                            Text(member.name)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundStyle(TANDAColors.Text.primary)

                            Spacer()

                            Text("Position \(index + 1)")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundStyle(TANDAColors.Text.secondary)
                                .padding(.horizontal, TANDASpacing.xs)
                                .padding(.vertical, 4)
                                .background(TANDAColors.Neutral.n100)
                                .clipShape(Capsule())
                        }
                        .padding(TANDASpacing.md)
                        .background(TANDAColors.Surface.primary)
                        .clipShape(RoundedRectangle(cornerRadius: TANDARadius.lg))
                    }
                } else {
                    ForEach(circle.positions) { position in
                        if position.isVacant {
                            VacantPositionCard(
                                position: position,
                                onJoinTapped: {
                                    // TODO: Handle join position action
                                    print("Join position \(position.positionNumber)")
                                }
                            )
                        } else {
                            MemberCard(position: position)
                        }
                    }
                }
            }
            .padding(.horizontal, TANDASpacing.lg)
        }
        .padding(.vertical, TANDASpacing.md)
    }
}

// MARK: - Activity Tab

struct ActivityTab: View {
    let circle: Circle

    var body: some View {
        VStack(spacing: TANDASpacing.md) {
            Spacer()

            Image(systemName: "bubble.left.and.bubble.right")
                .font(.system(size: 64))
                .foregroundStyle(TANDAColors.Purple.p200)

            Text("No activity yet")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(TANDAColors.Text.secondary)

            Text("Activity and updates will appear here")
                .font(.system(size: 14, weight: .regular))
                .foregroundStyle(TANDAColors.Text.tertiary)

            Spacer()
        }
        .frame(maxWidth: .infinity, minHeight: 400)
    }
}

#Preview("Circle Detail") {
    NavigationStack {
        CircleDetailView(circle: MockData.availableCircles[0])
    }
}
