import Foundation

public struct ATokenEditStatus: Hashable, Sendable, Codable {
    var tokensBeforeCursor: [AToken] // 光标前的token数组
    var tokensAfterCursor: [AToken] // 光标后的token数组

    // 判断是否可以插入字面量
    var canInsertLiteral: Bool {
        return tokensBeforeCursor.last?.content.canBeFollowedByLiteral() ??
            tokensAfterCursor.first?.content.canBePrefixedByLiteral() ??
            true
    }

    // 将光标移动到某个token之前
    mutating func setCursor(toBefore someToken: AToken) {
        setCursor(to: someToken, placeCursorAfter: false)
    }

    // 将光标移动到某个token之后
    mutating func setCursor(toAfter someToken: AToken) {
        setCursor(to: someToken, placeCursorAfter: true)
    }

    mutating func delete(_ someToken: AToken) {
        var beforeCursor = [AToken]() // 用于存储光标之前的token
        var afterCursor = [AToken]() // 用于存储光标之后的token
        var found = false
        let idToCompare = someToken.id

        // 遍历所有的token，找到指定的token，并根据光标位置进行分组
        for token in tokensBeforeCursor + tokensAfterCursor {
            if token.id == idToCompare {
                found = true
            } else if found {
                afterCursor.append(token)
            } else {
                beforeCursor.append(token)
            }
        }

        tokensBeforeCursor = beforeCursor
        tokensAfterCursor = afterCursor
    }

    // 根据参数设置光标位置，placeCursorAfter为true时光标放在token之后
    private mutating func setCursor(to someToken: AToken, placeCursorAfter: Bool) {
        var beforeCursor = [AToken]() // 用于存储光标之前的token
        var afterCursor = [AToken]() // 用于存储光标之后的token
        var found = false
        let idToCompare = someToken.id

        // 遍历所有的token，找到指定的token，并根据光标位置进行分组
        for token in tokensBeforeCursor + tokensAfterCursor {
            if token.id == idToCompare {
                found = true
                if placeCursorAfter {
                    beforeCursor.append(token)
                } else {
                    afterCursor.append(token)
                }
            } else if found {
                afterCursor.append(token)
            } else {
                beforeCursor.append(token)
            }
        }

        tokensBeforeCursor = beforeCursor
        tokensAfterCursor = afterCursor
    }

    mutating func insert(_ newToken: AToken.Content) {
        tokensBeforeCursor.append(AToken(newToken))
    }

    // 尝试删除光标左侧的一个token
    mutating func tryDeleteLeft() {
        guard !tokensBeforeCursor.isEmpty else { return }
        tokensBeforeCursor.removeLast()
    }

    // 尝试删除光标右侧的一个token
    mutating func tryDeleteRight() {
        guard !tokensAfterCursor.isEmpty else { return }
        tokensAfterCursor.removeFirst()
    }

    // 尝试将光标左移一位
    mutating func tryMoveLeft() {
        guard let token = tokensBeforeCursor.popLast() else { return }
        tokensAfterCursor.insert(token, at: 0)
    }

    // 尝试将光标右移一位
    mutating func tryMoveRight() {
        guard let token = tokensAfterCursor.first else { return }
        tokensAfterCursor.removeFirst()
        tokensBeforeCursor.append(token)
    }

    // 根据给定的公式初始化状态，初始状态光标在最后
    public init(formula: AFormula) {
        tokensBeforeCursor = formula.toTokens()
        tokensAfterCursor = []
    }
}
