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
                    // Onboarding carousel
                    OnboardingCarousel()
                        .padding(.top, TANDASpacing.sm)

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

// MARK: - Onboarding Carousel

private struct OnboardingCarousel: View {
    @State private var currentPage: Int = 0

    private let cards: [OnboardingCardData] = [
        OnboardingCardData(
            emoji: "🎯",
            title: "Create Your Circle",
            description: "Start or join a savings circle with friends and reach your financial goals together",
            ctaText: "Get Started"
        ),
        OnboardingCardData(
            emoji: "💰",
            title: "Save Together",
            description: "Everyone contributes regularly and takes turns receiving the full payout each cycle",
            ctaText: "Learn More"
        ),
        OnboardingCardData(
            emoji: "📊",
            title: "Track Progress",
            description: "Stay on top of payments, view schedules, and see your circle's activity in real-time",
            ctaText: "Explore"
        ),
        OnboardingCardData(
            emoji: "🎉",
            title: "Get Your Payout",
            description: "Receive your full payout when it's your turn and celebrate reaching your savings goal",
            ctaText: "Join a Circle"
        )
    ]

    var body: some View {
        VStack(spacing: TANDASpacing.md) {
            // Horizontal scrolling carousel
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: TANDASpacing.md) {
                        ForEach(Array(cards.enumerated()), id: \.offset) { index, card in
                            OnboardingCarouselCard(
                                emoji: card.emoji,
                                title: card.title,
                                description: card.description,
                                ctaText: card.ctaText,
                                onCTATapped: {
                                    print("CTA \(index) tapped")
                                }
                            )
                            .id(index)
                        }
                    }
                    .padding(.horizontal, TANDASpacing.lg)
                }
            }
            .frame(height: 280)

            // Page indicators
            HStack(spacing: 8) {
                ForEach(0..<cards.count, id: \.self) { index in
                    SwiftUI.Circle()
                        .fill(index == currentPage ? TANDAColors.Purple.p500 : TANDAColors.Neutral.n300)
                        .frame(width: 8, height: 8)
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: currentPage)
                }
            }
            .padding(.bottom, TANDASpacing.xs)
        }
        .padding(.vertical, TANDASpacing.md)
    }
}

private struct OnboardingCardData {
    let emoji: String
    let title: String
    let description: String
    let ctaText: String
}

private struct OnboardingCarouselCard: View {
    let emoji: String
    let title: String
    let description: String
    let ctaText: String
    let onCTATapped: () -> Void

    var body: some View {
        VStack(spacing: TANDASpacing.lg) {
            Spacer()

            // Emoji/Icon
            Text(emoji)
                .font(.system(size: 64))

            // Title
            Text(title)
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(TANDAColors.Text.primary)
                .multilineTextAlignment(.center)

            // Description
            Text(description)
                .font(.system(size: 15, weight: .regular))
                .foregroundStyle(TANDAColors.Text.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(3)

            Spacer()

            // CTA Button
            PrimaryButton(
                ctaText,
                kind: .primary,
                isFullWidth: true
            ) {
                onCTATapped()
            }
        }
        .padding(TANDASpacing.lg)
        .frame(width: UIScreen.main.bounds.width - (TANDASpacing.lg * 2))
        .frame(height: 280)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: TANDARadius.xl))
        .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 4)
    }
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
