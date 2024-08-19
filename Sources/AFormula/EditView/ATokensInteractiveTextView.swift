import AViewUI
import SwiftUI

@available(iOS 16, macOS 13, tvOS 16, watchOS 9, *)
public struct ATokensInteractiveTextView: View {
    @Binding private var status: ATokenEditStatus

    private func renderToken(token: AToken) -> some View {
        Text(token.toString(rows: [:], functions: [:]))
            .foregroundStyle(token.colorForLightTheme())
    }

    public var body: some View {
        AWrappingStack {
            ForEach(status.tokensBeforeCursor) { token in
                renderToken(token: token)
            }

            AInputCursorView()

            ForEach(status.tokensAfterCursor) { token in
                renderToken(token: token)
            }
        }
    }

    public init(_ status: Binding<ATokenEditStatus>) {
        self._status = status
    }
}
