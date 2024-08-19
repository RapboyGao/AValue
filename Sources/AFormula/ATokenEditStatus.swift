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

    mutating func setCursor(toBefore someToken: AToken) {
        if let index = (tokensBeforeCursor + tokensAfterCursor).firstIndex(of: someToken) {
            cursorPosition = index
        }
    }

    mutating func setCursor(toAfter someToken: AToken) {
        if let index = (tokensBeforeCursor + tokensAfterCursor).firstIndex(of: someToken) {
            cursorPosition = index + 1
        }
    }

    mutating func tryDeleteLeft() {
        guard !tokensBeforeCursor.isEmpty else { return }
        tokensBeforeCursor.removeLast()
    }

    mutating func tryDeleteRight() {
        guard !tokensAfterCursor.isEmpty else { return }
        tokensBeforeCursor.removeFirst()
    }

    public init(formula: AFormula) {
        tokensBeforeCursor = formula.toTokens()
        tokensAfterCursor = []
    }
}
