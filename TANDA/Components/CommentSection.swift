import SwiftUI

// MARK: - CommentSection
// Comment list + "Add a comment..." input for a post.

struct CommentSection: View {
    let comments: [Comment]
    let onAddCommentTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Display existing comments
            ForEach(comments) { comment in
                CommentRow(comment: comment)
            }

            // "Add a comment..." CTA
            Button(action: onAddCommentTap) {
                Text("Add a comment...")
                    .font(TANDATypography.Paragraph.s)  // 13px Book
                    .foregroundStyle(TANDAColors.Brand.black2)  // #66666E
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 4)
            }
            .buttonStyle(.plain)
        }
    }
}

// MARK: - Comment Row

struct CommentRow: View {
    let comment: Comment

    var body: some View {
        Text(attributedComment)
            .font(TANDATypography.Paragraph.s)  // 13px
            .foregroundStyle(TANDAColors.Brand.black1)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 4)
    }

    private var attributedComment: AttributedString {
        var result = AttributedString()

        // User name (Medium)
        var nameString = AttributedString(comment.user.name)
        nameString.font = Font.custom("PostGrotesk-Medium", size: 13)
        result.append(nameString)

        result.append(AttributedString("    "))  // Spacing from Figma

        // Comment text (Book/Regular)
        var textString = AttributedString(comment.text)
        textString.font = Font.custom("PostGrotesk-Book", size: 13)
        result.append(textString)

        return result
    }
}

#Preview("Comment Section") {
    let comments = [
        Comment(
            user: User(name: "Nick Le"),
            text: "Can't wait to get that schmoney. And more text to make this a two line comment"
        ),
        Comment(
            user: User(name: "Trevor Pels"),
            text: "Wow nice!"
        )
    ]

    VStack(spacing: 0) {
        CommentSection(
            comments: comments,
            onAddCommentTap: {}
        )
        .padding(.horizontal, 24)

        Spacer()
    }
    .frame(width: 393)
    .background(TANDAColors.Neutral.n0)
}
