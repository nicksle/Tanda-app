import SwiftUI

// MARK: - OnboardingSplash
// 3-slide full-bleed carousel shown on first app launch.
// Swipe or tap to navigate, final slide opens Sign Up Sheet.

struct OnboardingSplash: View {
    @State private var currentSlide = 0
    @State private var showSignUp = false
    @EnvironmentObject var appState: AppState

    private let slides = [
        "Share Funds for Shared Fun",
        "Save Together, Achieve More",
        "Your Goals, Within Reach"
    ]

    var body: some View {
        ZStack {
            // Full-bleed gradient background
            LinearGradient(
                colors: [
                    Color(hex: "#8B5CF6"),  // Purple 500
                    Color(hex: "#A855F7"),  // Purple 400
                    Color(hex: "#F68896"),  // Coral 500
                    Color(hex: "#D946EF"),  // Fuchsia
                    Color(hex: "#31005C")   // Deep Purple 500
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // Content
            VStack(spacing: 0) {
                // Carousel
                TabView(selection: $currentSlide) {
                    ForEach(0..<slides.count, id: \.self) { index in
                        SlideView(headline: slides[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .indexViewStyle(.page(backgroundDisplayMode: .automatic))

                // Button dock (transparent)
                VStack {
                    PrimaryButton("Get Started", kind: .primary, isFullWidth: true) {
                        showSignUp = true
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 16)
            }
        }
        .sheet(isPresented: $showSignUp) {
            SignUpSheet()
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
    }
}

// MARK: - SlideView

struct SlideView: View {
    let headline: String

    var body: some View {
        VStack {
            HStack {
                Text(headline)
                    .font(TANDATypography.Display.m)  // 28pt Bold
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.3), radius: 20, y: 2)
                    .frame(maxWidth: 280, alignment: .leading)

                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.top, 60)  // Below status bar + spacing

            Spacer()
        }
    }
}

// MARK: - Preview

#Preview("OnboardingSplash") {
    OnboardingSplash()
        .environmentObject(AppState())
}
