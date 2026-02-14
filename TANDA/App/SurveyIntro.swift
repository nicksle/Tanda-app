import SwiftUI

// MARK: - SurveyIntro
// Introduction page for user segmentation survey.
// Displays user's profile picture and welcome message.

struct SurveyIntro: View {
    let firstName: String
    let hasPhoto: Bool

    private var initials: String {
        let first = firstName.first.map { String($0).uppercased() } ?? ""
        return first
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Profile Picture
            ZStack {
                SwiftUI.Circle()
                    .fill(hasPhoto ? TANDAColors.Brand.primary : TANDAColors.Neutral.n100)
                    .frame(width: 48, height: 48)

                if hasPhoto {
                    Text(initials)
                        .font(TANDATypography.Heading.m)
                        .foregroundStyle(.white)
                } else {
                    Image(systemName: "person.fill")
                        .font(.system(size: 20))
                        .foregroundStyle(TANDAColors.Neutral.n500)
                }
            }
            .padding(.bottom, TANDASpacing.md)

            // Welcome Text
            VStack(alignment: .leading, spacing: TANDASpacing.xs) {
                Text("Welcome \(firstName)!")
                    .font(TANDATypography.Display.m)
                    .foregroundStyle(TANDAColors.Text.primary)

                Text("To get started, let us know your financial goals so we can provide the best experience for you.")
                    .font(TANDATypography.Paragraph.l)
                    .foregroundStyle(TANDAColors.Text.secondary)
            }
            .padding(.horizontal, TANDASpacing.sm)
        }
        .padding(.horizontal, TANDASpacing.md)
    }
}

#Preview("Survey Intro") {
    VStack {
        SurveyIntro(firstName: "Sarah", hasPhoto: true)
        Spacer()
    }
    .padding(.top, TANDASpacing.lg)
}
