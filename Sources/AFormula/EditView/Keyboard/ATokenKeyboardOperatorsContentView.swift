import AValue
import AViewUI
import SwiftUI

private let keyboardLine0: [AToken.Content] = [
    .leftParenthesis,
    .rightParenthesis,
    .comma,
    .absolute,
    .questionMark,
    .colon,
]

private let keyboardLine1: [AToken.Content] = [
    .plus, .minus,
    .asterisk, .divide,
    .remainder,
    .power,
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
]

@available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
public struct ATokenKeyboardOperatorsContentView: View {
    var handle: (AToken.Content) -> Void

    @ViewBuilder
    private func renderOperators(_ array: [AToken.Content]) -> some View {
        ForEach(array, id: \.self) { content in
            AKeyButton(cornerRadius: 4) {
                handle(content)
            } content: {
                Text(content.description)
                    .font(.system(size: 20))
            }
            .frame(width: 50, height: 50)
        }
    }

    public var body: some View {
        renderOperators(keyboardLine0)
        renderOperators(keyboardLine1)
        renderOperators(keyboardLine2)
    }

    public init(handle: @escaping (AToken.Content) -> Void) {
        self.handle = handle
    }
}
