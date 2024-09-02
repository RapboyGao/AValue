import AViewUI
import SwiftUI

@available(iOS 16, macOS 13, tvOS 16, watchOS 9, *)
public struct ATokensEditingKeyboard: View {
    @Binding private var status: ATokenEditStatus

    public var body: some View {
        AKeyboardBackgroundView { width in
            KeyBoardSpaceAroundStack(columns: 11, rowSpace: 5, columnSpace: 5) {
                ATokenNumberInputKeyboardContent(status: $status)
                ATokenKeyboardOperatorsContentView { newToken in
                    status.insert(newToken)
                }
                ATokenManipulationContentView(status: $status)
                AValueTypesKeyboardContentView(canInsertLiteral: status.canInsertOtherLiterals) { newToken in
                    status.insert(newToken)
                }
            }
            .frame(width: width)
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
            .frame(height: 300)
    }
}

@available(iOS 16, macOS 13, tvOS 16, watchOS 9, *)
#Preview {
    Example()
}
