import SwiftUI

// MARK: - PhotoStep
// Step 4 of onboarding: Optional profile photo upload.

struct PhotoStep: View {
    @Binding var hasPhoto: Bool
    let firstName: String
    let lastName: String
    var onComplete: () -> Void

    private var initials: String? {
        guard hasPhoto else { return nil }
        let first = firstName.first.map { String($0).uppercased() } ?? ""
        let last = lastName.first.map { String($0).uppercased() } ?? ""
        return first + last
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            AvatarUpload(initials: initials) {
                withAnimation {
                    hasPhoto.toggle()
                }
            }
            .padding(.bottom, TANDASpacing.lg)
            .padding(.horizontal, TANDASpacing.sm)

            VStack(alignment: .leading, spacing: TANDASpacing.xs) {
                Text("Add a Photo")
                    .font(TANDATypography.Display.m)
                    .foregroundStyle(TANDAColors.Text.primary)

                Text("Help your friends recognize you in circles.")
                    .font(TANDATypography.Paragraph.l)
                    .foregroundStyle(TANDAColors.Text.secondary)
            }
            .padding(.horizontal, TANDASpacing.sm)
        }
        .padding(.horizontal, TANDASpacing.md)
    }
}

#Preview("Photo Step") {
    struct PreviewWrapper: View {
        @State private var hasPhoto = false
        var body: some View {
            VStack {
                PhotoStep(hasPhoto: $hasPhoto, firstName: "Sarah", lastName: "Johnson") { }
            }
            .padding(.top, TANDASpacing.lg)
        }
    }
    return PreviewWrapper()
}
