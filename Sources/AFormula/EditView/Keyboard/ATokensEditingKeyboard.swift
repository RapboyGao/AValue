import AViewUI
import SwiftUI

@available(iOS 16, macOS 13, tvOS 16, watchOS 9, *)
public struct ATokensEditingKeyboard: View {
    @Binding private var status: ATokenEditStatus

    public var body: some View {
        VStack(alignment: .center) {
            AWrappingStack(vSpacing: 10, hSpacing: 10) {
                AValueTypesKeyboardContentView(canInsertLiteral: status.canInsertLiteral) {
                    status.tokensBeforeCursor.append(.init($0))
                }
            }
            AWrappingStack(vSpacing: 10, hSpacing: 10) {
                ATokenKeyboardOperatorsContentView {
                    status.tokensBeforeCursor.append(.init($0))
                }
                ATokenManipulationContentView(status: $status)
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
        ATokensEditingKeyboard($status)
            .padding()
    }
}

@available(iOS 16, macOS 13, tvOS 16, watchOS 9, *)
#Preview {
    Example()
}
