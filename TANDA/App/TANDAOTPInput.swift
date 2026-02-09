import SwiftUI

// MARK: - TANDAOTPInput
// 6-digit code entry for email verification.

struct TANDAOTPInput: View {
    @Binding var code: String
    var onComplete: ((String) -> Void)? = nil

    @FocusState private var isFocused: Bool
    private let digitCount = 6

    var body: some View {
        ZStack {
            TextField("", text: $code)
                .keyboardType(.numberPad)
                .textContentType(.oneTimeCode)
                .focused($isFocused)
                .opacity(0)
                .onChange(of: code) { oldValue, newValue in
                    let filtered = String(newValue.filter { $0.isNumber }.prefix(digitCount))
                    if filtered != newValue {
                        code = filtered
                    }
                    if filtered.count == digitCount {
                        onComplete?(filtered)
                    }
                }

            HStack(spacing: TANDASpacing.sm) {
                ForEach(0..<digitCount, id: \.self) { index in
                    digitBox(at: index)
                }
            }
            .onTapGesture {
                isFocused = true
            }
        }
        .onAppear {
            isFocused = true
        }
    }

    private func digitBox(at index: Int) -> some View {
        let digit = getDigit(at: index)
        let isCurrentIndex = code.count == index
        let isFilled = index < code.count

        return ZStack {
            RoundedRectangle(cornerRadius: TANDARadius.md)
                .fill(TANDAColors.Neutral.n800)
                .overlay(
                    RoundedRectangle(cornerRadius: TANDARadius.md)
                        .stroke(
                            borderColor(isFilled: isFilled, isCurrentIndex: isCurrentIndex),
                            lineWidth: (isCurrentIndex && isFocused) ? 2 : 1
                        )
                )

            if let digit = digit {
                Text(digit)
                    .font(TANDATypography.Heading.l)
                    .foregroundStyle(TANDAColors.Text.primary)
            }
        }
        .frame(width: 44, height: 56)
    }

    private func getDigit(at index: Int) -> String? {
        guard index < code.count else { return nil }
        let digitIndex = code.index(code.startIndex, offsetBy: index)
        return String(code[digitIndex])
    }

    private func borderColor(isFilled: Bool, isCurrentIndex: Bool) -> Color {
        if isFilled || (isCurrentIndex && isFocused) {
            return TANDAColors.Brand.primary
        }
        return TANDAColors.Neutral.n700
    }
}

#Preview("OTP Input") {
    struct PreviewWrapper: View {
        @State private var code = ""
        var body: some View {
            TANDAOTPInput(code: $code)
                .padding(24)
                .background(TANDAColors.Neutral.n900)
        }
    }
    return PreviewWrapper()
}
