import Foundation

public struct ATokenEditStatus: Hashable, Sendable, Codable {
    var tokensBeforeCursor: [AToken]
    var tokensAfterCursor: [AToken]

//    var cursorPosition: Int {
//        get {
//            tokensBeforeCursor.count
//        }
//        set {
//            // 确保 newValue 在有效范围内
//            let totalTokens = tokensBeforeCursor + tokensAfterCursor
//            let validNewValue = min(max(newValue, 0), totalTokens.count)
//
//            let newTokensBeforeCursor = Array(totalTokens.prefix(validNewValue))
//            let newTokensAfterCursor = Array(totalTokens.dropFirst(validNewValue))
//
//            tokensBeforeCursor = newTokensBeforeCursor
//            tokensAfterCursor = newTokensAfterCursor
//        }
//    }

    var canInsertLiteral: Bool {
        tokensBeforeCursor.last?.content.canBeFollowedByLiteral() ??
            tokensAfterCursor.first?.content.canBePrefixedByLiteral() ??
            true
    }

    mutating func setCursor(toBefore someToken: AToken) {
        var beforeCursor = [AToken]()
        var afterCursor = [AToken]()
        var isTokenFound = false
        let idToCompare = someToken.id
        for aToken in tokensBeforeCursor {
            if aToken.id == idToCompare { isTokenFound = true }
            if isTokenFound {
                afterCursor.append(aToken)
            } else {
                beforeCursor.append(aToken)
            }
        }
        for aToken in tokensAfterCursor {
            if aToken.id == idToCompare { isTokenFound = true }
            if isTokenFound {
                afterCursor.append(aToken)
            } else {
                beforeCursor.append(aToken)
            }
        }
        tokensBeforeCursor = beforeCursor
        tokensAfterCursor = afterCursor
    }

    mutating func setCursor(toAfter someToken: AToken) {
        var beforeCursor = [AToken]()
        var afterCursor = [AToken]()
        var isTokenFound = false
        let idToCompare = someToken.id
        for aToken in tokensBeforeCursor {
            if isTokenFound {
                afterCursor.append(aToken)
            } else {
                beforeCursor.append(aToken)
            }
            if aToken.id == idToCompare { isTokenFound = true }
        }
        for aToken in tokensAfterCursor {
            if isTokenFound {
                afterCursor.append(aToken)
            } else {
                beforeCursor.append(aToken)
            }
            if aToken.id == idToCompare { isTokenFound = true }
        }
        tokensBeforeCursor = beforeCursor
        tokensAfterCursor = afterCursor
    }

    mutating func tryDeleteLeft() {
        guard !tokensBeforeCursor.isEmpty else { return }
        tokensBeforeCursor.removeLast()
    }

    mutating func tryDeleteRight() {
        guard !tokensAfterCursor.isEmpty else { return }
        tokensBeforeCursor.removeFirst()
    }

    mutating func tryMoveLeft() {
        guard !tokensBeforeCursor.isEmpty else { return }
        let token = tokensBeforeCursor.removeLast()
        tokensAfterCursor = [token] + tokensAfterCursor
    }

    mutating func tryMoveRight() {
        guard !tokensAfterCursor.isEmpty else { return }
        let token = tokensAfterCursor.removeFirst()
        tokensBeforeCursor.append(token)
    }

    public init(formula: AFormula) {
        tokensBeforeCursor = formula.toTokens()
        tokensAfterCursor = []
    }
}
