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
        VStack(spacing: 0) {
            Text("Add a Photo")
                .font(TANDATypography.Heading.l)
                .foregroundStyle(.white)
                .padding(.bottom, TANDASpacing.xs)

            Text("Help your friends recognize you in circles.")
                .font(TANDATypography.Paragraph.m)
                .foregroundStyle(TANDAColors.Text.secondary)
                .padding(.bottom, TANDASpacing.xl)

            AvatarUpload(initials: initials) {
                withAnimation {
                    hasPhoto.toggle()
                }
            }
            .padding(.bottom, TANDASpacing.xl)

            Spacer()
        }
        .padding(.horizontal, TANDASpacing.lg)
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
            .background(TANDAColors.Neutral.n900)
        }
    }
    return PreviewWrapper()
}
