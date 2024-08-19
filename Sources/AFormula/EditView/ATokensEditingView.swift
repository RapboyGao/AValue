import AViewUI
import SwiftUI

@available(iOS 16, macOS 13, tvOS 16, watchOS 9, *)
public struct ATokensEditingView: View {
    @Binding private var status: ATokenEditStatus

    public var body: some View {
        VStack {
            ATokensInteractiveTextView($status)
                .padding()
            Spacer()
            VStack {
                AValueTypesKeyboardContentView(canInsertLiteral: status.canInsertLiteral) {
                    status.tokensBeforeCursor.append(.init($0))
                }
                Divider()
                ATokenKeyboardOperatorsContentView {
                    status.tokensBeforeCursor.append(.init($0))
                }
                Divider()
                LazyHStack {
                    ATokenManipulationContentView(status: $status)
                }
            }
            .frame(height: 150)
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