import SwiftUI
import AuthenticationServices

// MARK: - SignUpSheet
// Half sheet presenting account creation options.

struct SignUpSheet: View {
    @State private var email = ""
    @State private var isLoading = false
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var appState: AppState

    var onNewAccount: ((String) -> Void)? = nil
    var onExistingAccount: ((String) -> Void)? = nil

    private var isValidEmail: Bool {
        email.contains("@") && email.contains(".")
    }

    var body: some View {
        VStack(spacing: 0) {
            Text("Create Account")
                .font(TANDATypography.Heading.l)
                .padding(.bottom, 6)

            Text("Enter your email to get started")
                .font(TANDATypography.Paragraph.m)
                .foregroundStyle(.secondary)
                .padding(.bottom, 24)

            TANDAInput(
                text: $email,
                label: "Email",
                placeholder: "name@example.com"
            )
            .padding(.bottom, 16)

            TANDAButton(
                isLoading ? "Checking..." : "Continue",
                kind: .primary,
                isLoading: isLoading,
                isDisabled: !isValidEmail,
                isFullWidth: true
            ) {
                handleContinue()
            }
            .padding(.bottom, 20)

            TANDADivider(label: "or continue with")
                .padding(.bottom, 20)

            SignInWithAppleButton(.continue) { request in
                request.requestedScopes = [.email, .fullName]
            } onCompletion: { result in
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

            TANDAAuthButton(provider: .google) {
                dismiss()
                appState.completeOnboarding()
            }
            .padding(.bottom, 20)

            HStack(spacing: 4) {
                Text("Already have an account?")
                    .foregroundStyle(.secondary)
                Button("Sign in") {
                    handleSignIn()
                }
                .foregroundStyle(TANDAColors.Purple.p500)
            }
            .font(TANDATypography.Paragraph.s)
        }
        .padding(.horizontal, 24)
        .padding(.top, 12)
        .padding(.bottom, 40)
    }

    private func handleContinue() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isLoading = false
            if let onNewAccount = onNewAccount {
                onNewAccount(email)
            } else {
                dismiss()
                appState.completeOnboarding()
            }
        }
    }

    private func handleSignIn() {
        if let onExistingAccount = onExistingAccount, isValidEmail {
            onExistingAccount(email)
        } else {
            dismiss()
            appState.completeOnboarding()
        }
    }
}

#Preview("SignUpSheet") {
    Color.black.ignoresSafeArea()
        .sheet(isPresented: .constant(true)) {
            SignUpSheet()
                .environmentObject(AppState())
                .presentationDetents([.medium])
        }
}
