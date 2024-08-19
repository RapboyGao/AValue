import Foundation

public struct ATokenEditStatus: Hashable, Sendable, Codable {
    var tokensBeforeCursor: [AToken]
    var tokensAfterCursor: [AToken]

    var cursorPosition: Int {
        get {
            tokensBeforeCursor.count
        }
        set {
            // 确保 newValue 在有效范围内
            let totalTokens = tokensBeforeCursor + tokensAfterCursor
            let validNewValue = min(max(newValue, 0), totalTokens.count)

            let newTokensBeforeCursor = Array(totalTokens.prefix(validNewValue))
            let newTokensAfterCursor = Array(totalTokens.dropFirst(validNewValue))

            tokensBeforeCursor = newTokensBeforeCursor
            tokensAfterCursor = newTokensAfterCursor
        }
    }

    public init(formula: AFormula) {
        tokensBeforeCursor = formula.toTokens()
        tokensAfterCursor = []
    }
}
