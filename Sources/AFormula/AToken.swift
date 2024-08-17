import AValue
import Foundation
import SwiftUI

struct AToken: Identifiable, Hashable, Sendable, Codable {
    let id: Int
    let type: Token

    init(_ type: Token) {
        self.id = .random(in: .min ... .max)
        self.type = type
    }
}

// MARK: - Token

extension AToken {
    enum Token: Hashable, Sendable, Codable {
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
        case plus // +
        case minusOrNegative // 代表减，或者 负
        case asterisk // *
        case divide // "/"
        case remainder // "%"
        case power // "^"
        case greaterThan, lessThan, greaterThanOrEqual, lessThanOrEqual, equal
        case and, or, not
        case absolute // "|" （左右都是这个）
        case questionMark // "?"
        case colon // ":"
    }
}

// MARK: - toString

extension AToken.Token {
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
        case .minusOrNegative:
            return " - "
        case .asterisk:
            return " * "
        case .divide:
            return " / "
        case .remainder:
            return " % "
        case .power:
            return " ^ "
        case .greaterThan:
            return " > "
        case .lessThan:
            return " < "
        case .greaterThanOrEqual:
            return " >= "
        case .lessThanOrEqual:
            return " <= "
        case .equal:
            return " == "
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
extension AToken.Token {
    func colorForLightTheme() -> Color {
        switch self {
        case .leftParenthesis, .rightParenthesis, .comma:
            return Color(red: 0.027, green: 0.302, blue: 0.423) // Dark Blue
        case .functionWithLeftParenthesis:
            return Color(red: 0.733, green: 0.0, blue: 0.0) // Red
        case .value(let value):
            return value.type.colorForLightTheme()
        case .plus, .minusOrNegative, .asterisk, .divide, .remainder, .power,
             .greaterThan, .lessThan, .greaterThanOrEqual, .lessThanOrEqual, .equal,
             .and, .or, .not, .absolute, .questionMark, .colon:
            return Color(red: 0.627, green: 0.627, blue: 0.627) // Gray
        case .row:
            return .accentColor
        }
    }

    func colorForDarkTheme() -> Color {
        switch self {
        case .leftParenthesis, .rightParenthesis, .comma:
            return Color(red: 0.608, green: 0.678, blue: 0.847) // Light Blue
        case .functionWithLeftParenthesis:
            return Color(red: 0.945, green: 0.329, blue: 0.404) // Light Red
        case .value(let value):
            return value.type.colorForDarkTheme()
        case .plus, .minusOrNegative, .asterisk, .divide, .remainder, .power,
             .greaterThan, .lessThan, .greaterThanOrEqual, .lessThanOrEqual, .equal,
             .and, .or, .not, .absolute, .questionMark, .colon:
            return Color(red: 0.502, green: 0.502, blue: 0.502) // Gray
        case .row:
            return .accentColor
        }
    }
}
