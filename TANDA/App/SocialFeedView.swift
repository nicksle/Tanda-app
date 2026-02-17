import SwiftUI

// MARK: - SocialFeedView
// Main social feed screen showing posts from circles and members.

struct SocialFeedView: View {
    @EnvironmentObject var appState: AppState
    @State private var showingCommentInput: Post? = nil
    @State private var selectedCarouselVariation: OnboardingVariation = .standard
    @State private var scrollOffset: CGFloat = 0
    @State private var showKYCFlow = false
    @State private var showCirclesIntro = false

    private var currentUser: User {
        appState.currentUser
    }

    // Calculate opacity and scale for title based on scroll
    private var titleOpacity: Double {
        max(0, min(1, 1 - (scrollOffset / 80)))
    }

    private var titleScale: Double {
        max(0.85, min(1, 1 - (scrollOffset / 400)))
    }

    // Calculate opacity for frosted header (inverse of title)
    private var headerOpacity: Double {
        max(0, min(1, scrollOffset / 80))
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 0) {
                    // Scroll position tracker
                    GeometryReader { geometry in
                        Color.clear.preference(
                            key: ScrollOffsetPreferenceKey.self,
                            value: geometry.frame(in: .named("scroll")).origin.y
                        )
                    }
                    .frame(height: 0)

                    // Custom large title header with animation
                    HStack {
                        Text("Home")
                            .font(.system(size: 34, weight: .bold))
                            .foregroundStyle(TANDAColors.Text.primary)
                        Spacer()
                    }
                    .padding(.horizontal, TANDASpacing.lg)
                    .padding(.top, TANDASpacing.sm)
                    .padding(.bottom, TANDASpacing.md)
                    .background(TANDAColors.Neutral.n50)
                    .opacity(titleOpacity)
                    .scaleEffect(titleScale, anchor: .leading)

                    // Debug: Carousel variation picker (only visible in debug builds)
                    #if DEBUG
                    VStack(spacing: TANDASpacing.xs) {
                        Text("Debug: Carousel Variation")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundStyle(TANDAColors.Text.tertiary)

                        Picker("Carousel Style", selection: $selectedCarouselVariation) {
                            Text("Standard").tag(OnboardingVariation.standard)
                            Text("Progress").tag(OnboardingVariation.progressBar)
                            Text("Timeline").tag(OnboardingVariation.timeline)
                        }
                        .pickerStyle(.segmented)
                    }
                    .padding(.horizontal, TANDASpacing.lg)
                    .padding(.bottom, TANDASpacing.md)
                    #endif

                    // "Get Started" section title
                    Text("Get Started")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(TANDAColors.Text.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, TANDASpacing.lg)
                        .padding(.bottom, TANDASpacing.xs)

                    // Onboarding carousel
                    OnboardingCarouselContainer(
                        selectedVariation: selectedCarouselVariation,
                        onCTATapped: { index in
                            handleCarouselCTA(index)
                        }
                    )
                    .padding(.bottom, TANDASpacing.md)

                    // Feed posts
                    ForEach(appState.posts) { post in
                        PostCard(
                            post: post,
                            currentUser: currentUser,
                            onLikeTap: {
                                appState.toggleLike(on: post)
                            },
                            onCommentTap: {
                                showingCommentInput = post
                            }
                        )
                        .padding(.horizontal, TANDASpacing.lg)
                    }
                }
            }
            .coordinateSpace(name: "scroll")
            .background(TANDAColors.Neutral.n50)
            .overlay(alignment: .top) {
                // Frosted glass header that floats on top when scrolling
                VStack(spacing: 0) {
                    HStack {
                        Text("Home")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(TANDAColors.Text.primary)
                        Spacer()
                    }
                    .padding(.horizontal, TANDASpacing.lg)
                    .padding(.vertical, TANDASpacing.sm)
                }
                .background(.ultraThinMaterial)
                .opacity(headerOpacity)
            }
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                scrollOffset = value
            }
            .toolbar(.hidden, for: .navigationBar)
        }
        .sheet(item: $showingCommentInput) { post in
            AddCommentSheet(
                post: post,
                currentUser: currentUser,
                onAddComment: { text in
                    appState.addComment(to: post, text: text)
                    showingCommentInput = nil
                }
            )
        }
        .fullScreenCover(isPresented: $showKYCFlow) {
            KYCVerificationView()
                .environmentObject(appState)
        }
        .fullScreenCover(isPresented: $showCirclesIntro) {
            ExploreCirclesIntroView(onContinue: {
                // Navigate to circles tab after intro
                appState.selectedTab = .circles
            })
            .environmentObject(appState)
        }
    }

    // MARK: - Helper Functions

    private func handleCarouselCTA(_ index: Int) {
        // Index 0 is "Explore TANDA Circles"
        if index == 0 {
            if appState.hasSeenCirclesIntro {
                // If already seen intro, navigate directly to circles tab
                appState.selectedTab = .circles
            } else {
                // Show intro first
                showCirclesIntro = true
            }
        }
        // Index 2 is "Verify Identity" (third item in onboardingSteps array)
        else if index == 2 {
            showKYCFlow = true
        } else {
            print("CTA \(index) tapped")
            // TODO: Handle other carousel CTAs
        }
    }
}

// MARK: - Add Comment Sheet

struct AddCommentSheet: View {
    let post: Post
    let currentUser: User
    let onAddComment: (String) -> Void

    @State private var commentText: String = ""
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: TANDASpacing.md) {
                // Post preview
                VStack(alignment: .leading, spacing: TANDASpacing.xs) {
                    Text(post.user.name)
                        .font(TANDATypography.Label.m)
                        .foregroundStyle(TANDAColors.Brand.black1)

                    Text(post.content)
                        .font(TANDATypography.Paragraph.s)
                        .foregroundStyle(TANDAColors.Brand.black2)
                        .lineLimit(2)
                }
                .padding(TANDASpacing.md)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(TANDAColors.Neutral.n50)
                .clipShape(RoundedRectangle(cornerRadius: TANDARadius.md))

                // Comment input
                TextEditor(text: $commentText)
                    .font(TANDATypography.Paragraph.m)
                    .foregroundStyle(TANDAColors.Brand.black1)
                    .frame(height: 100)
                    .padding(TANDASpacing.sm)
                    .background(TANDAColors.Neutral.n50)
                    .clipShape(RoundedRectangle(cornerRadius: TANDARadius.md))

                Spacer()
            }
            .padding(TANDASpacing.lg)
            .navigationTitle("Add Comment")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Comment") {
                        onAddComment(commentText)
                    }
                    .disabled(commentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}

// MARK: - Onboarding Carousel Variations

enum OnboardingVariation {
    case standard
    case progressBar
    case timeline
}

// Shared onboarding step data
private struct OnboardingStep {
    let emoji: String
    let title: String
    let description: String
    let ctaText: String
}

private let onboardingSteps: [OnboardingStep] = [
    OnboardingStep(
        emoji: "🔍",
        title: "Explore TANDA Circles",
        description: "Browse and discover savings circles that match your financial goals and interests",
        ctaText: "Browse Circles"
    ),
    OnboardingStep(
        emoji: "🏦",
        title: "Link Bank Account",
        description: "Securely connect your bank account for seamless contributions and payouts",
        ctaText: "Link Account"
    ),
    OnboardingStep(
        emoji: "✓",
        title: "Verify Identity",
        description: "Quick verification process to keep your account and money safe",
        ctaText: "Get Verified"
    ),
    OnboardingStep(
        emoji: "🎉",
        title: "Join Your First Circle",
        description: "Start saving together with your community and reach your goals faster",
        ctaText: "Join Now"
    )
]

// MARK: - Carousel Container

private struct OnboardingCarouselContainer: View {
    let selectedVariation: OnboardingVariation
    let onCTATapped: (Int) -> Void

    var body: some View {
        switch selectedVariation {
        case .standard:
            StandardCarousel(onCTATapped: onCTATapped)
        case .progressBar:
            ProgressBarCarousel()
        case .timeline:
            TimelineCarousel()
        }
    }
}

// MARK: - Variation 1: Standard Paginated Carousel

private struct StandardCarousel: View {
    @State private var currentPage: Int = 0
    let onCTATapped: (Int) -> Void

    var body: some View {
        VStack(spacing: 0) {
            // Paginated carousel using TabView
            TabView(selection: $currentPage) {
                ForEach(Array(onboardingSteps.enumerated()), id: \.offset) { index, step in
                    StandardCarouselCard(
                        emoji: step.emoji,
                        title: step.title,
                        description: step.description,
                        ctaText: step.ctaText,
                        onCTATapped: {
                            onCTATapped(index)
                        }
                    )
                    .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 280)

            // Page indicators
            HStack(spacing: 8) {
                ForEach(0..<onboardingSteps.count, id: \.self) { index in
                    SwiftUI.Circle()
                        .fill(index == currentPage ? TANDAColors.Purple.p500 : TANDAColors.Neutral.n300)
                        .frame(width: 8, height: 8)
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: currentPage)
                }
            }
        }
    }
}

private struct StandardCarouselCard: View {
    let emoji: String
    let title: String
    let description: String
    let ctaText: String
    let onCTATapped: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: TANDASpacing.md) {
            // Top section: emoji circle + title
            HStack(spacing: 12) {
                // Emoji in circle
                ZStack {
                    SwiftUI.Circle()
                        .fill(TANDAColors.Purple.p100)
                        .frame(width: 56, height: 56)

                    Text(emoji)
                        .font(.system(size: 28))
                }

                // Title
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(TANDAColors.Text.primary)

                    Text("Get Started")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(TANDAColors.Text.tertiary)
                }

                Spacer()
            }

            // Description
            Text(description)
                .font(.system(size: 15, weight: .regular))
                .foregroundStyle(TANDAColors.Text.secondary)
                .lineLimit(3)
                .frame(maxWidth: .infinity, alignment: .leading)

            // Button - secondary, small size
            PrimaryButton(
                ctaText,
                kind: .secondary,
                size: .small,
                isFullWidth: false
            ) {
                onCTATapped()
            }
        }
        .padding(TANDASpacing.lg)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: TANDARadius.xl))
        .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 2)
        .padding(.horizontal, TANDASpacing.md)
    }
}

// MARK: - Variation 2: Progress Bar Carousel

private struct ProgressBarCarousel: View {
    @State private var currentStep: Int = 0

    private var step: OnboardingStep {
        onboardingSteps[currentStep]
    }

    var body: some View {
        VStack(spacing: TANDASpacing.lg) {
            // Progress bar
            HStack(spacing: 4) {
                ForEach(0..<onboardingSteps.count, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(index <= currentStep ? TANDAColors.Purple.p500 : TANDAColors.Neutral.n200)
                        .frame(height: 4)
                }
            }
            .padding(.horizontal, TANDASpacing.lg)

            // Step indicator text
            Text("Step \(currentStep + 1) of \(onboardingSteps.count)")
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(TANDAColors.Text.secondary)

            // Content card
            VStack(spacing: TANDASpacing.md) {
                Text(step.emoji)
                    .font(.system(size: 56))

                Text(step.title)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(TANDAColors.Text.primary)
                    .multilineTextAlignment(.center)

                Text(step.description)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(TANDAColors.Text.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .padding(TANDASpacing.lg)
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: TANDARadius.xl))
            .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 4)
            .padding(.horizontal, TANDASpacing.lg)

            // Navigation buttons
            HStack(spacing: TANDASpacing.md) {
                if currentStep > 0 {
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            currentStep -= 1
                        }
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(TANDAColors.Text.secondary)
                        .padding(.horizontal, TANDASpacing.md)
                        .padding(.vertical, TANDASpacing.sm)
                        .background(TANDAColors.Neutral.n100)
                        .clipShape(RoundedRectangle(cornerRadius: TANDARadius.md))
                    }
                }

                Spacer()

                PrimaryButton(
                    currentStep < onboardingSteps.count - 1 ? "Next" : step.ctaText,
                    kind: .secondary,
                    size: .small,
                    isFullWidth: false
                ) {
                    if currentStep < onboardingSteps.count - 1 {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            currentStep += 1
                        }
                    } else {
                        print("Final CTA tapped")
                    }
                }
            }
            .padding(.horizontal, TANDASpacing.lg)
        }
        .padding(.vertical, TANDASpacing.md)
    }
}

// MARK: - Variation 3: Vertical Timeline Carousel

private struct TimelineCarousel: View {
    @State private var currentStep: Int = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(Array(onboardingSteps.enumerated()), id: \.offset) { index, step in
                HStack(alignment: .top, spacing: TANDASpacing.md) {
                    // Timeline indicator
                    VStack(spacing: 0) {
                        // Circle indicator
                        ZStack {
                            SwiftUI.Circle()
                                .stroke(TANDAColors.Purple.p500, lineWidth: 2)
                                .frame(width: 32, height: 32)

                            if index <= currentStep {
                                SwiftUI.Circle()
                                    .fill(TANDAColors.Purple.p500)
                                    .frame(width: 16, height: 16)
                            } else {
                                Text("\(index + 1)")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundStyle(TANDAColors.Text.secondary)
                            }
                        }

                        // Connecting line
                        if index < onboardingSteps.count - 1 {
                            Rectangle()
                                .fill(index < currentStep ? TANDAColors.Purple.p500 : TANDAColors.Neutral.n200)
                                .frame(width: 2)
                                .frame(minHeight: 60)
                        }
                    }

                    // Step content
                    VStack(alignment: .leading, spacing: TANDASpacing.xs) {
                        HStack {
                            Text(step.emoji)
                                .font(.system(size: 24))

                            Text(step.title)
                                .font(.system(size: 16, weight: .bold))
                                .foregroundStyle(TANDAColors.Text.primary)
                        }

                        Text(step.description)
                            .font(.system(size: 13, weight: .regular))
                            .foregroundStyle(TANDAColors.Text.secondary)
                            .lineLimit(2)

                        if index == currentStep {
                            PrimaryButton(
                                step.ctaText,
                                kind: .secondary,
                                size: .small,
                                isFullWidth: false
                            ) {
                                if currentStep < onboardingSteps.count - 1 {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        currentStep += 1
                                    }
                                } else {
                                    print("Final step CTA tapped")
                                }
                            }
                            .padding(.top, TANDASpacing.xs)
                        }
                    }
                }
                .padding(TANDASpacing.lg)
                .background(
                    Group {
                        if index == currentStep {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.ultraThinMaterial)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(
                                            LinearGradient(
                                                colors: [
                                                    TANDAColors.Purple.p500.opacity(0.05),
                                                    TANDAColors.Purple.p400.opacity(0.03)
                                                ],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                )
                        }
                    }
                )
                .overlay(
                    Group {
                        if index == currentStep {
                            RoundedRectangle(cornerRadius: 12)
                                .strokeBorder(
                                    LinearGradient(
                                        colors: [
                                            TANDAColors.Purple.p500.opacity(0.6),
                                            TANDAColors.Purple.p400.opacity(0.4),
                                            TANDAColors.Purple.p300.opacity(0.3)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 2
                                )
                                .padding(4)
                        }
                    }
                )
                .shadow(
                    color: index == currentStep ? TANDAColors.Purple.p500.opacity(0.2) : .clear,
                    radius: 12,
                    x: 0,
                    y: 4
                )
                .padding(.bottom, TANDASpacing.md)
            }
        }
        .padding(TANDASpacing.lg)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: TANDARadius.xl))
        .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 4)
        .padding(.horizontal, TANDASpacing.lg)
        .padding(.vertical, TANDASpacing.md)
    }
}

// MARK: - Scroll Offset Preference Key

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

#Preview("Social Feed") {
    SocialFeedView()
        .environmentObject(AppState())
}
