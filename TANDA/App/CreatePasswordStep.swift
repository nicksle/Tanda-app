import SwiftUI

// MARK: - CreatePasswordStep
// Step 1 of onboarding: Create password with strength indicator.

struct CreatePasswordStep: View {
    @Binding var password: String
    @Binding var confirmPassword: String

    var isValid: Bool {
        password.count >= 8 && password == confirmPassword
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: TANDASpacing.xs) {
                Text("Create a Password")
                    .font(TANDATypography.Display.m)
                    .foregroundStyle(TANDAColors.Text.primary)

                Text("Choose a strong password to keep your account secure.")
                    .font(TANDATypography.Paragraph.l)
                    .foregroundStyle(TANDAColors.Text.secondary)
            }
            .padding(.bottom, TANDASpacing.lg)
            .padding(.horizontal, TANDASpacing.sm)

            Input(
                text: $password,
                type: .password,
                label: "Password",
                placeholder: "Create a password"
            )
            .padding(.bottom, TANDASpacing.lg)
            .padding(.horizontal, TANDASpacing.sm)

            Input(
                text: $confirmPassword,
                type: .password,
                label: "Confirm Password",
                placeholder: "Re-enter your password",
                error: passwordMismatchError
            )
            .padding(.horizontal, TANDASpacing.sm)
        }
        .padding(.horizontal, TANDASpacing.md)
    }

    private var passwordMismatchError: String? {
        guard !confirmPassword.isEmpty else { return nil }
        guard password != confirmPassword else { return nil }
        return "Passwords don't match"
    }
}

#Preview("Create Password Step") {
    struct PreviewWrapper: View {
        @State private var password = ""
        @State private var confirmPassword = ""
        var body: some View {
            VStack {
                CreatePasswordStep(password: $password, confirmPassword: $confirmPassword)
                Spacer()
            }
            .padding(.top, TANDASpacing.lg)
        }
    }
    return PreviewWrapper()
}
