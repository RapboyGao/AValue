import AViewUI
import SwiftUI

@available(iOS 16, macOS 13, tvOS 16, watchOS 9, *)
public struct ATokensInteractiveView: View {
    @State private var status: ATokenEditStatus = .init(formula: (20 + 50 / 40) * 30)

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
}

@available(iOS 16, macOS 13, tvOS 16, watchOS 9, *)
#Preview {
    ATokensInteractiveView()
}
