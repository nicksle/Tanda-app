import SwiftUI

// MARK: - TANDAAvatarUpload
// Circular avatar placeholder with badge for profile photo upload.

struct TANDAAvatarUpload: View {
    let initials: String?
    var onTap: (() -> Void)? = nil

    private let avatarSize: CGFloat = 120
    private let badgeSize: CGFloat = 36

    var body: some View {
        Button {
            onTap?()
        } label: {
            ZStack(alignment: .bottomTrailing) {
                Circle()
                    .fill(avatarBackground)
                    .frame(width: avatarSize, height: avatarSize)
                    .overlay { avatarContent }

                ZStack {
                    Circle()
                        .fill(TANDAColors.Brand.primary)
                        .frame(width: badgeSize, height: badgeSize)
                        .overlay(
                            Circle().stroke(TANDAColors.Neutral.n900, lineWidth: 3)
                        )

                    Image(systemName: initials != nil ? "pencil" : "plus")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                }
                .offset(x: 4, y: 4)
            }
        }
        .buttonStyle(.plain)
    }

    private var avatarBackground: some ShapeStyle {
        if initials != nil {
            return AnyShapeStyle(
                LinearGradient(
                    colors: [TANDAColors.Purple.p500, TANDAColors.Secondary.coral],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
        } else {
            return AnyShapeStyle(TANDAColors.Neutral.n800)
        }
    }

    @ViewBuilder
    private var avatarContent: some View {
        if let initials = initials {
            Text(initials)
                .font(TANDATypography.Display.m)
                .foregroundStyle(.white)
        } else {
            Image(systemName: "person.fill")
                .font(.system(size: 40))
                .foregroundStyle(TANDAColors.Neutral.n500)
        }
    }
}

#Preview("Avatar Upload") {
    VStack(spacing: 48) {
        TANDAAvatarUpload(initials: nil)
        TANDAAvatarUpload(initials: "SJ")
    }
    .padding(24)
    .background(TANDAColors.Neutral.n900)
}
