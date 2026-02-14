import SwiftUI

// MARK: - Circles View
// Main circles discovery view with tabs, filters, and circle cards

struct CirclesView: View {
    @State private var selectedTabIndex: Int = 1  // 0 = My Circles, 1 = Join a Circle
    @State private var selectedFilter: CircleFilter = .recommended

    private let tabOptions = ["My Circles", "Join a Circle"]

    var filteredCircles: [Circle] {
        // TODO: Implement actual filtering logic
        // For now, just return all circles
        MockData.availableCircles
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    // Content based on selected tab
                    if selectedTabIndex == 0 {
                        // Placeholder for My Circles
                        VStack(spacing: TANDASpacing.md) {
                            Spacer()

                            Image(systemName: "circle.dotted")
                                .font(.system(size: 64))
                                .foregroundStyle(TANDAColors.Purple.p200)

                            Text("No circles yet")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(TANDAColors.Text.secondary)

                            Text("Join your first circle to get started")
                                .font(.system(size: 14, weight: .regular))
                                .foregroundStyle(TANDAColors.Text.tertiary)

                            Spacer()
                        }
                        .frame(maxWidth: .infinity, minHeight: 500)
                        .background(TANDAColors.Neutral.n50)
                    } else {
                        // Circle cards list
                        LazyVStack(spacing: TANDASpacing.md) {
                            ForEach(filteredCircles) { circle in
                                NavigationLink(value: circle) {
                                    CircleCard(
                                        circle: circle,
                                        onJoinPosition: { position in
                                            print("Join position \(position.positionNumber) in \(circle.name)")
                                        },
                                        onAddToCircle: {
                                            print("Add \(circle.name) to my circles")
                                        }
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, TANDASpacing.lg)
                        .padding(.vertical, TANDASpacing.md)
                        .background(TANDAColors.Neutral.n50)
                    }
                }
            }
            .safeAreaInset(edge: .top, spacing: 0) {
                // Sticky filter section below nav bar
                HStack(spacing: TANDASpacing.xs) {
                    FilterPill(
                        title: "Recommended",
                        isSelected: selectedFilter == .recommended,
                        action: { selectedFilter = .recommended }
                    )

                    FilterPill(
                        title: "All",
                        isSelected: selectedFilter == .all,
                        action: { selectedFilter = .all }
                    )

                    Spacer()

                    // Results count
                    Text("\(filteredCircles.count) results")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(TANDAColors.Text.secondary)
                }
                .padding(.horizontal, TANDASpacing.lg)
                .padding(.vertical, TANDASpacing.sm)
                .background(Color.white)
            }
            .navigationTitle("Circles")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    // Segmented control in toolbar - always visible
                    SegmentedControl(options: tabOptions, selectedIndex: $selectedTabIndex)
                }
            }
            .navigationDestination(for: Circle.self) { circle in
                CircleDetailView(circle: circle)
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing),
                        removal: .move(edge: .trailing)
                    ))
            }
        }
    }
}

// MARK: - Circle Filter

enum CircleFilter {
    case recommended
    case all
}

// MARK: - Filter Pill

struct FilterPill: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(isSelected ? TANDAColors.Purple.p500 : TANDAColors.Text.secondary)
                .padding(.horizontal, TANDASpacing.sm)
                .padding(.vertical, 6)
                .background(isSelected ? TANDAColors.Purple.p100 : TANDAColors.Neutral.n50)
                .clipShape(RoundedRectangle(cornerRadius: 100))
        }
        .buttonStyle(.plain)
    }
}

#Preview("Circles View") {
    CirclesView()
}
