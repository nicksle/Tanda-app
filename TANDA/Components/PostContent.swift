import SwiftUI

// MARK: - PostContent
// Post body content: text and optional image.

struct PostContent: View {
    let content: String
    let imageURL: String?

    var body: some View {
        VStack(alignment: .leading, spacing: TANDASpacing.md) {  // 16px
            // Text content
            if !content.isEmpty {
                Text(content)
                    .font(TANDATypography.Paragraph.m)  // 16px Book
                    .foregroundStyle(TANDAColors.Brand.black1)
                    .lineSpacing(4)  // Line height 20 - font size 16 = 4
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            // Optional image
            if imageURL != nil {
                // For now, use a placeholder
                // TODO: AsyncImage with real URLs
                Rectangle()
                    .fill(TANDAColors.Neutral.n200)
                    .aspectRatio(1.0, contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .overlay(
                        VStack(spacing: 8) {
                            Image(systemName: "photo")
                                .font(.system(size: 32))
                                .foregroundStyle(TANDAColors.Neutral.n400)
                            Text("Image placeholder")
                                .font(TANDATypography.Label.s)
                                .foregroundStyle(TANDAColors.Neutral.n500)
                        }
                    )
            }
        }
    }
}

#Preview("Post Content") {
    VStack(spacing: 24) {
        PostContent(
            content: "I was able to get some new wheels for my bike!!",
            imageURL: "bike_image.jpg"
        )
        .frame(width: 297)

        PostContent(
            content: "Just a text post without an image. This is a longer post to test how it looks with multiple lines of content.",
            imageURL: nil
        )
        .frame(width: 297)
    }
    .padding()
    .background(TANDAColors.Neutral.n0)
}
