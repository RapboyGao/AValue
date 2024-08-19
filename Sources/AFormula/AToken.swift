import AValue
import Foundation
import SwiftUI

public struct AToken: Identifiable, Hashable, Sendable, Codable, CustomStringConvertible {
    public let id: Int
    /// 在第几个括号内
    public var level: Int
    public var content: Content

    public init(_ content: Content) {
        self.id = .random(in: .min ... .max)
        self.content = content
        self.level = 0
    }

    public var description: String {
        content.description
    }

    func toString(rows rowNamesDict: [Int: String], functions functionNamesDict: [Int: String]) -> String {
        content.toString(rows: rowNamesDict, functions: functionNamesDict)
    }
}

// MARK: - Token

public extension AToken {
    enum Content: Hashable, Sendable, Codable, CustomStringConvertible {
        /// 左括号
        case leftParenthesis
        /// 右括号
        case rightParenthesis
        /// 函数，带括号
        case functionWithLeftParenthesis(id: Int)
        /// 逗号，在function中使用
        case comma

        // 各种类型数据
        case value(AValue)
        // 代表某个row
        case row(id: Int)
        // 各种运算法
        case plus
        case minus
        case asterisk
        case divide
        case remainder
        case power
        case greaterThan, lessThan, greaterThanOrEqual, lessThanOrEqual, equal
        case and, or, not
        case absolute
        case questionMark
        case colon
    }
}

// MARK: - toString

public extension AToken.Content {
    var description: String {
        switch self {
        case .leftParenthesis:
            return "("
        case .rightParenthesis:
            return ")"
        case .functionWithLeftParenthesis:
            return "??("
        case .comma:
            return ", "
        case .value(let value):
            return value.description
        case .row:
            return "??"
        case .plus:
            return "+"
        case .minus:
            return "-"
        case .asterisk:
            return "×"
        case .divide:
            return "÷"
        case .remainder:
            return "%"
        case .power:
            return "^"
        case .greaterThan:
            return ">"
        case .lessThan:
            return "<"
        case .greaterThanOrEqual:
            return "≥"
        case .lessThanOrEqual:
            return "≤"
        case .equal:
            return "="
        case .and:
            return "&"
        case .or:
            return "or"
        case .not:
            return "!"
        case .absolute:
            return "|"
        case .questionMark:
            return "?"
        case .colon:
            return ":"
        }
    }

    func canBeFollowedByLiteral() -> Bool {
        switch self {
        case .leftParenthesis, .functionWithLeftParenthesis, .comma:
            return true
        case .rightParenthesis, .value, .row:
            return false
        case .plus, .minus, .asterisk, .divide, .remainder, .power:
            return true
        case .greaterThan, .lessThan, .greaterThanOrEqual, .lessThanOrEqual, .equal, .and, .or, .not, .absolute, .questionMark, .colon:
            return true
        }
    }

    func canBePrefixedByLiteral() -> Bool {
        switch self {
        case .leftParenthesis, .functionWithLeftParenthesis, .value, .row:
            return false
        case .comma, .rightParenthesis:
            return true
        case .plus, .minus, .asterisk, .divide, .remainder, .power:
            return true
        case .greaterThan, .lessThan, .greaterThanOrEqual, .lessThanOrEqual, .equal, .and, .or, .not, .absolute, .questionMark, .colon:
            return true
        }
    }

    func toString(rows rowNamesDict: [Int: String], functions functionNamesDict: [Int: String]) -> String {
        switch self {
        case .leftParenthesis:
            return "("
        case .rightParenthesis:
            return ")"
        case .functionWithLeftParenthesis(let id):
            if let funcName = functionNamesDict[id] {
                return "\(funcName)("
            } else {
                return "??("
            }
        case .comma:
            return ", "
        case .value(let value):
            return value.description
        case .row(let id):
            if let rowName = rowNamesDict[id] {
                return rowName
            } else {
                return "??"
            }
        case .plus:
            return " + "
        case .minus:
            return " - "
        case .asterisk:
            return " × "
        case .divide:
            return " ÷ "
        case .remainder:
            return " % "
        case .power:
            return " ^ "
        case .greaterThan:
            return " > "
        case .lessThan:
            return " < "
        case .greaterThanOrEqual:
            return " ≥ "
        case .lessThanOrEqual:
            return " ≤ "
        case .equal:
            return " = "
        case .and:
            return " & "
        case .or:
            return " or "
        case .not:
            return "!"
        case .absolute:
            return "|"
        case .questionMark:
            return "? "
        case .colon:
            return " : "
        }
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public extension AToken {
    func colorForLightTheme() -> Color {
        switch content {
        case .leftParenthesis, .rightParenthesis, .comma:
            return Color(red: 0.027, green: 0.302, blue: 0.423) // Dark Blue
        case .functionWithLeftParenthesis:
            return Color(red: 0.733, green: 0.0, blue: 0.0) // Red
        case .value(let value):
            return value.type.colorForLightTheme()
        case .plus, .minus, .asterisk, .divide, .remainder, .power,
             .greaterThan, .lessThan, .greaterThanOrEqual, .lessThanOrEqual, .equal,
             .and, .or, .not, .absolute, .questionMark, .colon:
            return Color(red: 0.627, green: 0.627, blue: 0.627) // Gray
        case .row:
            return .accentColor
        }
    }

    func colorForDarkTheme() -> Color {
        switch content {
        case .leftParenthesis, .rightParenthesis, .comma:
            return Color(red: 0.608, green: 0.678, blue: 0.847) // Light Blue
        case .functionWithLeftParenthesis:
            return Color(red: 0.945, green: 0.329, blue: 0.404) // Light Red
        case .value(let value):
            return value.type.colorForDarkTheme()
        case .plus, .minus, .asterisk, .divide, .remainder, .power,
             .greaterThan, .lessThan, .greaterThanOrEqual, .lessThanOrEqual, .equal,
             .and, .or, .not, .absolute, .questionMark, .colon:
            return Color(red: 0.502, green: 0.502, blue: 0.502) // Gray
        case .row:
            return .accentColor
        }
    }
}
