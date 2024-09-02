import AViewUI
import SwiftUI

@available(iOS 16, macOS 13, tvOS 16, watchOS 9, *)
public struct ATokensEditingView: View {
    @Binding private var status: ATokenEditStatus
    @FocusState private var isTextfieldFocused: Bool

    private func renderToken(_ bindToken: Binding<AToken>) -> some View {
        ATokenMenu(bindToken) {
            status.delete(bindToken.wrappedValue)
        } cursorToLeft: {
            status.setCursor(toBefore: bindToken.wrappedValue)
        } cursorToRight: {
            status.setCursor(toAfter: bindToken.wrappedValue)
        }
    }

    public var body: some View {
        AWrappingStack {
            ForEach($status.tokensBeforeCursor) { bindToken in
                renderToken(bindToken)
            }
            Text(status.numberInputString)

            TextField("", text: .constant(""))
                .aKeyboardView { _ in
                    ATokensEditingKeyboard($status)
                        .frame(height: 200)
                }
                .focused($isTextfieldFocused)
                .frame(width: 2)
            ForEach($status.tokensAfterCursor) { bindToken in
                renderToken(bindToken)
            }
        }
        .font(.system(size: 24))
        .onAppear {
            isTextfieldFocused = true
        }
        .onTapGesture {
            isTextfieldFocused = true
        }
    }

    public init(_ status: Binding<ATokenEditStatus>) {
        self._status = status
    }
}

@available(iOS 16, macOS 13, tvOS 16, watchOS 9, *)
private struct Example: View {
    @State private var status: ATokenEditStatus = .init(formula: .p(30 - 4.5) / 50)

    var body: some View {
        ATokensEditingView($status)
    }
}

@available(iOS 16, macOS 13, tvOS 16, watchOS 9, *)
#Preview {
    Example()
}
