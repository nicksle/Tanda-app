import SwiftUI

// MARK: - SegmentedControl
// Native iOS segmented control using Picker with .segmented style.
// Automatically gets iOS's liquid glass appearance.
// Generic component that works with any array of tab options.

struct SegmentedControl: View {
    let options: [String]
    @Binding var selectedIndex: Int

    var body: some View {
        Picker("", selection: $selectedIndex) {
            ForEach(options.indices, id: \.self) { index in
                Text(options[index]).tag(index)
            }
        }
        .pickerStyle(.segmented)
    }
}

#Preview("Segmented Control") {
    struct PreviewWrapper: View {
        @State private var selectedIndex = 0
        let options = ["User Agreement", "Privacy Policy"]

        var body: some View {
            VStack(spacing: TANDASpacing.lg) {
                SegmentedControl(options: options, selectedIndex: $selectedIndex)

                Text("Selected: \(options[selectedIndex])")
                    .font(TANDATypography.Paragraph.m)
                    .foregroundStyle(TANDAColors.Text.secondary)
            }
            .padding(TANDASpacing.lg)
        }
    }
    return PreviewWrapper()
}
