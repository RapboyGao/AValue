import AViewUI
import SwiftUI

@available(iOS 16, macOS 13, tvOS 16, watchOS 9, *)
public struct ATokensInteractiveView: View {
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

@available(iOS 16, macOS 13, tvOS 16, watchOS 9, *)
private struct Example: View {
    @State private var status: ATokenEditStatus = .init(formula: .p(30 - 4.5) / 50)

    var body: some View {
        VStack {
            ATokensInteractiveView($status)
            Spacer()
            VStack {
                ATokenKeyboardOperatorsContentView {
                    status.tokensBeforeCursor.append(.init($0))
                }
                Divider()
                LazyHStack {
                    ATokenManipulationContentView(status: $status)
                }
            }
            .frame(height: 100)
        }
    }
}

@available(iOS 16, macOS 13, tvOS 16, watchOS 9, *)
#Preview {
    Example()
}
