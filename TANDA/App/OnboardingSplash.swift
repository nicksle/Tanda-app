import SwiftUI

// MARK: - OnboardingSplash
// 3-slide full-bleed carousel shown on first app launch.

struct OnboardingSplash: View {
    @State private var currentSlide = 0
    @State private var showSignUp = false
    @State private var showEmailVerification = false
    @State private var showPasswordLogin = false
    @EnvironmentObject var appState: AppState

    private let slides = [
        "Share Funds for Shared Fun",
        "Save Together, Achieve More",
        "Your Goals, Within Reach"
    ]

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(hex: "#8B5CF6"),
                    Color(hex: "#A855F7"),
                    Color(hex: "#F68896"),
                    Color(hex: "#D946EF"),
                    Color(hex: "#31005C")
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                TabView(selection: $currentSlide) {
                    ForEach(0..<slides.count, id: \.self) { index in
                        SlideView(headline: slides[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .indexViewStyle(.page(backgroundDisplayMode: .automatic))

                VStack {
                    TANDAButton("Get Started", kind: .primary, isFullWidth: true) {
                        showSignUp = true
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 16)
            }
        }
        .sheet(isPresented: $showSignUp) {
            SignUpSheet(
                onNewAccount: { email in
                    appState.authEmail = email
                    showSignUp = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        showEmailVerification = true
                    }
                },
                onExistingAccount: { email in
                    appState.authEmail = email
                    showSignUp = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        showPasswordLogin = true
                    }
                }
            )
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $showPasswordLogin) {
            PasswordLoginSheet()
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
        .fullScreenCover(isPresented: $showEmailVerification) {
            EmailVerificationView()
        }
    }
}

struct SlideView: View {
    let headline: String

    var body: some View {
        VStack {
            HStack {
                Text(headline)
                    .font(TANDATypography.Display.m)
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.3), radius: 20, y: 2)
                    .frame(maxWidth: 280, alignment: .leading)
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.top, 60)
            Spacer()
        }
    }
}

#Preview("OnboardingSplash") {
    OnboardingSplash()
        .environmentObject(AppState())
}
