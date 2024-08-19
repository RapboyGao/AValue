import AValue
import AViewUI
import SwiftUI

private let keyboardLine1: [AToken.Content] = [
    .leftParenthesis,
    .rightParenthesis,
    .plus, .minusOrNegative,
    .asterisk, .divide,
    .remainder,
    .power,
    .comma,
    .absolute,
]

private let keyboardLine2: [AToken.Content] = [
    .greaterThan,
    .lessThan,
    .greaterThanOrEqual,
    .lessThanOrEqual,
    .equal,
    .and,
    .or,
    .not,
    .questionMark,
    .colon,
]

@available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
public struct ATokenKeyboardOperatorsContentView: View {
    var handle: (AToken.Content) -> Void

    @ViewBuilder
    private func render(content: AToken.Content) -> some View {}

    @ViewBuilder
    private func renderOperators(_ array: [AToken.Content]) -> some View {
        LazyHStack {
            ForEach(array, id: \.self) { content in
                AKeyButton(cornerRadius: 4) {
                    handle(content)
                } content: {
                    Text(content.description)
                        .font(.system(size: 15))
                }
                .frame(width: 30, height: 30)
            }
        }
    }

    public var body: some View {
        renderOperators(keyboardLine1)
        Divider()
        renderOperators(keyboardLine2)
    }

    public init(handle: @escaping (AToken.Content) -> Void) {
        self.handle = handle
    }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
#Preview {
    LazyVStack {
        ATokenKeyboardOperatorsContentView {
            print($0)
        }
    }
}
