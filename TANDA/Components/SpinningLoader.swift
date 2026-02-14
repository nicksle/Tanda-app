import SwiftUI

// MARK: - SpinningLoader
// Smooth circular spinner with two-color design and gentle bezier curve animation.
// Used for button loading states.

struct SpinningLoader: View {
    let size: CGFloat
    let foregroundColor: Color
    let backgroundColor: Color

    @State private var isAnimating = false

    init(size: CGFloat = 20, foregroundColor: Color, backgroundColor: Color? = nil) {
        self.size = size
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor ?? foregroundColor.opacity(0.2)
    }

    var body: some View {
        ZStack {
            // Background circle
            SwiftUI.Circle()
                .stroke(backgroundColor, lineWidth: 2)
                .frame(width: size, height: size)

            // Foreground spinning arc
            SwiftUI.Circle()
                .trim(from: 0, to: 0.75)
                .stroke(
                    foregroundColor,
                    style: StrokeStyle(
                        lineWidth: 2,
                        lineCap: .round
                    )
                )
                .frame(width: size, height: size)
                .rotationEffect(.degrees(isAnimating ? 360 : 0))
                .animation(
                    Animation.easeInOut(duration: 1.0)
                        .repeatForever(autoreverses: false),
                    value: isAnimating
                )
        }
        .onAppear {
            isAnimating = true
        }
    }
}

#Preview("Spinning Loader") {
    VStack(spacing: 32) {
        SpinningLoader(size: 20, foregroundColor: .white, backgroundColor: .white.opacity(0.2))
            .padding()
            .background(TANDAColors.Purple.p500)
            .clipShape(RoundedRectangle(cornerRadius: 8))

        SpinningLoader(size: 20, foregroundColor: TANDAColors.Neutral.n900, backgroundColor: TANDAColors.Neutral.n900.opacity(0.2))
            .padding()
            .background(TANDAColors.Neutral.n100)
            .clipShape(RoundedRectangle(cornerRadius: 8))

        SpinningLoader(size: 24, foregroundColor: TANDAColors.Purple.p500)
    }
    .padding()
}
