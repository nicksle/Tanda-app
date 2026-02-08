import SwiftUI
import AuthenticationServices

// MARK: - SignUpSheet
// Half sheet presenting account creation options.
// Email input + Apple/Google sign-in buttons.

struct SignUpSheet: View {
    @State private var email = ""
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var appState: AppState

    private var isValidEmail: Bool {
        email.contains("@") && email.contains(".")
    }

    var body: some View {
        VStack(spacing: 0) {
            // Title
            Text("Create Account")
                .font(TANDATypography.Heading.l)
                .padding(.bottom, 6)

            // Subtitle
            Text("Enter your email to get started")
                .font(TANDATypography.Paragraph.m)
                .foregroundStyle(.secondary)
                .padding(.bottom, 24)

            // Email Input
            TANDAInput(
                text: $email,
                label: "Email",
                placeholder: "name@example.com"
            )
            .padding(.bottom, 16)

            // Continue Button
            TANDAButton("Continue", kind: .primary, isFullWidth: true) {
                // TODO: Navigate to email verification
                dismiss()
                appState.completeOnboarding()
            }
            .disabled(!isValidEmail)
            .opacity(isValidEmail ? 1.0 : 0.5)
            .padding(.bottom, 20)

            // Divider
            TANDADivider(label: "or continue with")
                .padding(.bottom, 20)

            // Apple Sign In
            SignInWithAppleButton(.continue) { request in
                request.requestedScopes = [.email, .fullName]
            } onCompletion: { result in
                // TODO: Handle Apple sign in
                switch result {
                case .success:
                    dismiss()
                    appState.completeOnboarding()
                case .failure(let error):
                    print("Apple sign in failed: \(error)")
                }
            }
            .signInWithAppleButtonStyle(.white)
            .frame(height: 56)
            .clipShape(Capsule())
            .padding(.bottom, 12)

            // Google Sign In
            TANDAAuthButton(provider: .google) {
                // TODO: Handle Google sign in
                dismiss()
                appState.completeOnboarding()
            }
            .padding(.bottom, 20)

            // Sign In Link
            HStack(spacing: 4) {
                Text("Already have an account?")
                    .foregroundStyle(.secondary)
                Button("Sign in") {
                    // TODO: Switch to sign in mode
                    dismiss()
                    appState.completeOnboarding()
                }
                .foregroundStyle(TANDAColors.Purple.p500)
            }
            .font(TANDATypography.Paragraph.s)
        }
        .padding(.horizontal, 24)
        .padding(.top, 12)
        .padding(.bottom, 40)
    }
}

// MARK: - Preview

#Preview("SignUpSheet") {
    Color.black
        .ignoresSafeArea()
        .sheet(isPresented: .constant(true)) {
            SignUpSheet()
                .environmentObject(AppState())
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
}
