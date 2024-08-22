import AValue
import AViewUI
import SwiftUI

private let allKeyboardKeys: [AToken.Content] = [
    .plus, .minus,
    .asterisk, .divide,
    .leftParenthesis,
    .rightParenthesis,
    .comma,
    .absolute,    
    .remainder,
    .power,
    .questionMark,
    .colon,
    .or,
    .not,
    .greaterThan,
    .lessThan,
    .greaterThanOrEqual,
    .lessThanOrEqual,
    .equal,
    .and,
]

@available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
public struct ATokenKeyboardOperatorsContentView: View {
    var handle: (AToken.Content) -> Void

    @ViewBuilder
    private func renderOperators(_ array: [AToken.Content]) -> some View {
        ForEach(array, id: \.self) { content in
            AKeyButtonWithZoom(cornerRadius: 4) {
                handle(content)
            } content: {
                Text(content.description)
                    .font(.system(size: 20))
            }
        }
    }

    public var body: some View {
        renderOperators(allKeyboardKeys)
    }

    public init(handle: @escaping (AToken.Content) -> Void) {
        self.handle = handle
    }
}
