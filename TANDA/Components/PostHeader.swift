import SwiftUI

// MARK: - PostHeader
// Header section for a post showing user info, timestamp, and visibility.

struct PostHeader: View {
    let post: Post

    var body: some View {
        HStack(alignment: .top, spacing: TANDASpacing.sm) {  // 8px
            // User avatar (40px)
            ZStack {
                SwiftUI.Circle()
                    .fill(post.user.avatarColor)
                    .frame(width: 40, height: 40)

                if post.user.avatarURL != nil {
                    // TODO: AsyncImage when we have real URLs
                    SwiftUI.Circle()
                        .fill(post.user.avatarColor)
                        .frame(width: 40, height: 40)
                } else {
                    Text(post.user.initials)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.white)
                }
            }

            // Content
            VStack(alignment: .leading, spacing: 0) {
                // Name + action description
                Text(attributedTitle)
                    .font(TANDATypography.Paragraph.m)  // 16px
                    .foregroundStyle(TANDAColors.Brand.black1)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)

                // Timestamp + visibility
                HStack(spacing: TANDASpacing.sm) {  // 8px
                    Text(post.timeAgo)
                        .font(TANDATypography.Paragraph.s)  // 13px Book
                        .foregroundStyle(TANDAColors.Brand.black3)

                    Text("•")
                        .font(TANDATypography.Paragraph.s)
                        .foregroundStyle(TANDAColors.Brand.black3)

                    HStack(spacing: 2) {
                        Image(systemName: post.visibility.iconName)
                            .font(.system(size: 13, weight: .light))
                            .foregroundStyle(TANDAColors.Brand.black3)

                        Text(post.visibility.rawValue)
                            .font(TANDATypography.Paragraph.s)  // 13px Book
                            .foregroundStyle(TANDAColors.Brand.black3)
                    }
                }
            }
        }
    }

    // Attributed string with bold name + regular action description
    private var attributedTitle: AttributedString {
        var result = AttributedString()

        // User name (Medium weight)
        var nameString = AttributedString(post.user.name)
        nameString.font = Font.custom("PostGrotesk-Medium", size: 16)
        result.append(nameString)

        result.append(AttributedString(" "))

        // Action description (Book/Regular weight)
        var actionString = AttributedString(post.actionDescription)
        actionString.font = Font.custom("PostGrotesk-Book", size: 16)
        result.append(actionString)

        // Circle name if present (Medium weight)
        if let circleName = post.circleName {
            result.append(AttributedString(" "))
            var circleString = AttributedString(circleName)
            circleString.font = Font.custom("PostGrotesk-Medium", size: 16)
            result.append(circleString)
        }

        return result
    }
}

#Preview("Post Header") {
    VStack(spacing: 24) {
        PostHeader(
            post: Post(
                user: User(name: "Nick Le"),
                content: "",
                circleName: "Bike Parts"
            )
        )

        PostHeader(
            post: Post(
                user: User(name: "Trevor Pels"),
                content: "",
                visibility: .private
            )
        )
    }
    .padding()
    .background(TANDAColors.Neutral.n0)
}
