import SwiftUI
import PhotosUI

// MARK: - Image Upload Card
// Reusable component for uploading images (ID photos, selfies, etc.)
// Shows placeholder with upload icon, allows selection from camera/library, and displays preview

struct ImageUploadCard: View {
    let title: String
    let subtitle: String?
    @Binding var image: UIImage?

    @State private var showImagePicker = false
    @State private var imageSelection: PhotosPickerItem?

    init(title: String, subtitle: String? = nil, image: Binding<UIImage?>) {
        self.title = title
        self.subtitle = subtitle
        self._image = image
    }

    var body: some View {
        VStack(alignment: .leading, spacing: TANDASpacing.sm) {
            // Title and subtitle
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(TANDAColors.Text.primary)

                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundStyle(TANDAColors.Text.tertiary)
                }
            }

            // Upload area
            if let image = image {
                // Image preview
                ZStack(alignment: .topTrailing) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: TANDARadius.lg))

                    // Remove button
                    Button {
                        withAnimation {
                            self.image = nil
                        }
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(.white)
                            .background(
                                SwiftUI.Circle()
                                    .fill(Color.black.opacity(0.5))
                                    .frame(width: 24, height: 24)
                            )
                    }
                    .padding(TANDASpacing.sm)
                }
            } else {
                // Upload placeholder
                PhotosPicker(selection: $imageSelection, matching: .images) {
                    VStack(spacing: TANDASpacing.md) {
                        ZStack {
                            SwiftUI.Circle()
                                .fill(TANDAColors.Purple.p100)
                                .frame(width: 56, height: 56)

                            Image(systemName: "camera.fill")
                                .font(.system(size: 24))
                                .foregroundStyle(TANDAColors.Purple.p500)
                        }

                        VStack(spacing: 4) {
                            Text("Tap to upload")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(TANDAColors.Text.primary)

                            Text("Take a photo or choose from library")
                                .font(.system(size: 14, weight: .regular))
                                .foregroundStyle(TANDAColors.Text.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 200)
                    .background(TANDAColors.Neutral.n50)
                    .clipShape(RoundedRectangle(cornerRadius: TANDARadius.lg))
                    .overlay(
                        RoundedRectangle(cornerRadius: TANDARadius.lg)
                            .stroke(style: StrokeStyle(lineWidth: 2, dash: [8, 8]))
                            .foregroundStyle(TANDAColors.Neutral.n300)
                    )
                }
            }
        }
        .onChange(of: imageSelection) { _, newValue in
            Task {
                if let data = try? await newValue?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    withAnimation {
                        image = uiImage
                    }
                }
            }
        }
    }
}

#Preview("Image Upload Card") {
    @Previewable @State var image: UIImage? = nil

    VStack(spacing: TANDASpacing.lg) {
        ImageUploadCard(
            title: "Front of ID",
            subtitle: "Upload the front of your driver's license",
            image: $image
        )

        ImageUploadCard(
            title: "Selfie",
            subtitle: "Take a clear selfie for verification",
            image: $image
        )
    }
    .padding(TANDASpacing.lg)
    .background(Color.white)
}
