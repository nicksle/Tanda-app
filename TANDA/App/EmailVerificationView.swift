import SwiftUI

// MARK: - EmailVerificationView
// Full screen OTP verification for new account email confirmation.

struct EmailVerificationView: View {
    @State private var otpCode = ""
    @State private var resendCountdown = 60
    @State private var isVerifying = false
    @State private var showCelebration = false
    @State private var emailIconOffset: CGFloat = 0
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var appState: AppState

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            TANDAColors.Neutral.n900.ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundStyle(.white)
                            .frame(width: 44, height: 44)
                    }
                    Spacer()
                }
                .padding(.horizontal, TANDASpacing.md)

                Spacer()

                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            LinearGradient(
                                colors: [TANDAColors.Purple.p500, TANDAColors.Purple.p400],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 72, height: 72)

                    Image(systemName: "envelope.fill")
                        .font(.system(size: 32))
                        .foregroundStyle(.white)
                }
                .offset(y: emailIconOffset)
                .onAppear {
                    withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                        emailIconOffset = -8
                    }
                }
                .padding(.bottom, TANDASpacing.xl)

                Text("Check Your Email")
                    .font(TANDATypography.Heading.l)
                    .foregroundStyle(.white)
                    .padding(.bottom, TANDASpacing.sm)

                Text("We sent a verification code to")
                    .font(TANDATypography.Paragraph.m)
                    .foregroundStyle(TANDAColors.Text.secondary)

                Text(appState.authEmail)
                    .font(TANDATypography.Paragraph.m)
                    .fontWeight(.medium)
                    .foregroundStyle(.white)
                    .padding(.bottom, TANDASpacing.xl)

                TANDAOTPInput(code: $otpCode)
                    .padding(.horizontal, TANDASpacing.lg)
                    .padding(.bottom, TANDASpacing.lg)

                if resendCountdown > 0 {
                    Text("Resend code in \(resendCountdown)s")
                        .font(TANDATypography.Paragraph.s)
                        .foregroundStyle(TANDAColors.Text.tertiary)
                } else {
                    Button("Resend code") { resendCountdown = 60 }
                        .font(TANDATypography.Paragraph.s)
                        .foregroundStyle(TANDAColors.Brand.primary)
                }

                Spacer()

                TANDAButtonDock {
                    TANDAButton(
                        "Verify",
                        kind: .primary,
                        isLoading: isVerifying,
                        isDisabled: otpCode.count < 6,
                        isFullWidth: true
                    ) {
                        isVerifying = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            isVerifying = false
                            showCelebration = true
                        }
                    }
                }
            }
        }
        .onReceive(timer) { _ in
            if resendCountdown > 0 { resendCountdown -= 1 }
        }
        .fullScreenCover(isPresented: $showCelebration) {
            CelebrationView()
        }
    }
}

#Preview("Email Verification") {
    EmailVerificationView()
        .environmentObject({ let s = AppState(); s.authEmail = "test@example.com"; return s }())
}
