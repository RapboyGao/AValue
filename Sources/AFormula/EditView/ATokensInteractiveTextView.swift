import AViewUI
import SwiftUI

@available(iOS 16, macOS 13, tvOS 16, watchOS 9, *)
public struct ATokensInteractiveTextView: View {
    @Binding private var status: ATokenEditStatus

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

            AInputCursorView()

            ForEach($status.tokensAfterCursor) { bindToken in
                renderToken(bindToken)
            }
        }
    }

    public init(_ status: Binding<ATokenEditStatus>) {
        self._status = status
    }
}
