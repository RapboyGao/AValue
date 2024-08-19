import AValue
import AViewUI
import SwiftUI

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public struct AValueTypesKeyboardContentView: View {
    var handle: (AToken.Content) -> Void
    var canInsertLiteral: Bool

    public var body: some View {
        ScrollView(.horizontal) {
            LazyHStack {
                ForEach(AValueType.allCases) {
                    ASpecificValueTypeButtonView(valueType: $0, handle: handle)
                        .opacity(canInsertLiteral ? 1 : 0.7)
                        .disabled(!canInsertLiteral)
                }
            }
        }
        .padding(.horizontal)
    }

    public init(canInsertLiteral: Bool, handle: @escaping (AToken.Content) -> Void) {
        self.canInsertLiteral = canInsertLiteral
        self.handle = handle
    }
}
