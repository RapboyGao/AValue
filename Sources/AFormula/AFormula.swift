import AValue
import Foundation

public enum AFormula: Codable, Sendable, Hashable, ExpressibleByFloatLiteral, ExpressibleByIntegerLiteral, ExpressibleByStringLiteral, ExpressibleByBooleanLiteral {
    // 表示一个常量值
    case value(AValue)
    // 表示通过其 ID 引用的行
    case variable(id: Int)
    // 表示一个带有参数的函数 (优先级 1)
    indirect case function(id: Int, args: [AFormula])
    // 表示包含在括号中的公式 (优先级 1)
    indirect case parenthesis(AFormula)
    // 表示对一个数值公式的绝对值运算 (优先级 2)
    indirect case absolute(AFormula)
    // 表示对一个数值公式的取负运算 (优先级 2)
    indirect case negative(AFormula)
    // 表示对一个布尔公式的逻辑非运算 (优先级 2)
    indirect case not(AFormula)
    // 表示将一个公式提升到另一个公式的幂 (优先级 3)
    indirect case power(left: AFormula, right: AFormula)
    // 表示两个公式的乘法运算 (优先级 4)
    indirect case multiply(left: AFormula, right: AFormula)
    // 表示两个公式的除法运算 (优先级 4)
    indirect case divide(left: AFormula, right: AFormula)
    // 表示两个公式相除的余数 (优先级 4)
    indirect case remainder(left: AFormula, right: AFormula)
    // 表示两个公式的加法运算 (优先级 5)
    indirect case add(left: AFormula, right: AFormula)
    // 表示两个公式的减法运算 (优先级 5)
    indirect case subtract(left: AFormula, right: AFormula)
    // 表示一个公式是否大于另一个公式的比较 (优先级 6)
    indirect case greaterThan(left: AFormula, right: AFormula)
    // 表示一个公式是否小于另一个公式的比较 (优先级 6)
    indirect case lessThan(left: AFormula, right: AFormula)
    // 表示一个公式是否大于等于另一个公式的比较 (优先级 6)
    indirect case greaterThanOrEqual(left: AFormula, right: AFormula)
    // 表示一个公式是否小于等于另一个公式的比较 (优先级 6)
    indirect case lessThanOrEqual(left: AFormula, right: AFormula)
    // 表示两个公式是否相等的比较 (优先级 6)
    indirect case equal(left: AFormula, right: AFormula)
    // 表示两个布尔公式之间的逻辑与运算 (优先级 7)
    indirect case and(left: AFormula, right: AFormula)
    // 表示两个布尔公式之间的逻辑或运算 (优先级 7)
    indirect case or(left: AFormula, right: AFormula)
    // 表示三目运算符 (优先级 8)
    indirect case ternary(condition: AFormula, trueFormula: AFormula, falseFormula: AFormula)

    public var priority: Int {
        switch self {
        case .function, .parenthesis:
            return 1
        case .absolute, .negative, .not:
            return 2
        case .power:
            return 3
        case .multiply, .divide, .remainder:
            return 4
        case .add, .subtract:
            return 5
        case .greaterThan, .lessThan, .greaterThanOrEqual, .lessThanOrEqual, .equal:
            return 6
        case .and:
            return 7
        case .or:
            return 7
        case .ternary:
            return 8
        case .value, .variable:
            return 0 // constants and rows do not have operation priority
        }
    }

    public func toTokens() -> [AToken] {
        var tokens = [AToken]()
        let priority = self.priority // 定义当前公式的优先级

        // 辅助函数，用于根据当前公式的优先级添加子公式的 Token
        func addTokens(for formula: AFormula) {
            let subTokens = formula.toTokens()
            // 如果子公式的优先级高于当前公式，则添加括号
            if formula.priority > priority {
                tokens.append(AToken(.leftParenthesis))
                tokens.append(contentsOf: subTokens)
                tokens.append(AToken(.rightParenthesis))
            } else {
                tokens.append(contentsOf: subTokens)
            }
        }

        // 根据当前公式类型生成对应的 Token
        switch self {
        case let .value(value):
            tokens.append(AToken(.value(value)))

        case let .variable(id):
            tokens.append(AToken(.row(id: id)))

        case let .function(id, args):
            tokens.append(AToken(.functionWithLeftParenthesis(id: id)))
            for (index, arg) in args.enumerated() {
                addTokens(for: arg)
                if index < args.count - 1 {
                    tokens.append(AToken(.comma))
                }
            }
            tokens.append(AToken(.rightParenthesis))

        case let .parenthesis(formula):
            tokens.append(AToken(.leftParenthesis))
            tokens.append(contentsOf: formula.toTokens())
            tokens.append(AToken(.rightParenthesis))

        case let .absolute(formula):
            tokens.append(AToken(.absolute))
            addTokens(for: formula)
            tokens.append(AToken(.absolute))

        case let .negative(formula):
            tokens.append(AToken(.minus))
            addTokens(for: formula)

        case let .not(formula):
            tokens.append(AToken(.not))
            addTokens(for: formula)

        case let .power(left, right):
            addTokens(for: left)
            tokens.append(AToken(.power))
            addTokens(for: right)

        case let .multiply(left, right):
            addTokens(for: left)
            tokens.append(AToken(.asterisk))
            addTokens(for: right)

        case let .divide(left, right):
            addTokens(for: left)
            tokens.append(AToken(.divide))
            addTokens(for: right)

        case let .remainder(left, right):
            addTokens(for: left)
            tokens.append(AToken(.remainder))
            addTokens(for: right)

        case let .add(left, right):
            addTokens(for: left)
            tokens.append(AToken(.plus))
            addTokens(for: right)

        case let .subtract(left, right):
            addTokens(for: left)
            tokens.append(AToken(.minus))
            addTokens(for: right)

        case let .greaterThan(left, right):
            addTokens(for: left)
            tokens.append(AToken(.greaterThan))
            addTokens(for: right)

        case let .lessThan(left, right):
            addTokens(for: left)
            tokens.append(AToken(.lessThan))
            addTokens(for: right)

        case let .greaterThanOrEqual(left, right):
            addTokens(for: left)
            tokens.append(AToken(.greaterThanOrEqual))
            addTokens(for: right)

        case let .lessThanOrEqual(left, right):
            addTokens(for: left)
            tokens.append(AToken(.lessThanOrEqual))
            addTokens(for: right)

        case let .equal(left, right):
            addTokens(for: left)
            tokens.append(AToken(.equal))
            addTokens(for: right)

        case let .and(left, right):
            addTokens(for: left)
            tokens.append(AToken(.and))
            addTokens(for: right)

        case let .or(left, right):
            addTokens(for: left)
            tokens.append(AToken(.or))
            addTokens(for: right)

        case let .ternary(condition, trueFormula, falseFormula):
            addTokens(for: condition)
            tokens.append(AToken(.questionMark))
            addTokens(for: trueFormula)
            tokens.append(AToken(.colon))
            addTokens(for: falseFormula)
        }

        return tokens
    }

    public func isTheSame(as another: AFormula) -> Bool {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .sortedKeys
        guard let thisData = try? jsonEncoder.encode(self),
              let thisString = String(data: thisData, encoding: .utf8),
              let otherData = try? jsonEncoder.encode(another),
              let otherString = String(data: otherData, encoding: .utf8)
        else { return false }
        return thisString == otherString
    }
}

public extension AFormula {
    static func point(x: Double, y: Double) -> AFormula {
        return .value(.point(x: x, y: y))
    }

    static func location(latitude: Double, longitude: Double) -> AFormula {
        return .value(.location(latitude: latitude, longitude: longitude))
    }

    static func boolean(_ value: Bool) -> AFormula {
        return .value(.boolean(value))
    }

    static func groundWind(limit: AWindLimit) -> AFormula {
        return .value(.groundWind(limit: limit))
    }

    static func minutes(_ value: Int) -> AFormula {
        return .value(.minutes(value))
    }

    static func minutes(h hours: Int, m minutes: Int) -> AFormula {
        return .value(.minutes(hours * 60 + minutes))
    }

    static func calendar(_ date: Date) -> AFormula {
        return .value(.calendar(date))
    }

    static func dateDifference(_ components: DateComponents) -> AFormula {
        return .value(.dateDifference(components))
    }

    static func p(_ formula: AFormula) -> AFormula {
        .parenthesis(formula)
    }
}

public extension AFormula {
    static func + (left: AFormula, right: AFormula) -> AFormula {
        return .add(left: left, right: right)
    }

    static func - (left: AFormula, right: AFormula) -> AFormula {
        return .subtract(left: left, right: right)
    }

    static func * (left: AFormula, right: AFormula) -> AFormula {
        return .multiply(left: left, right: right)
    }

    static func / (left: AFormula, right: AFormula) -> AFormula {
        return .divide(left: left, right: right)
    }

    static func % (left: AFormula, right: AFormula) -> AFormula {
        return .remainder(left: left, right: right)
    }

    static prefix func - (formula: AFormula) -> AFormula {
        return .negative(formula)
    }

    static prefix func ! (formula: AFormula) -> AFormula {
        return .not(formula)
    }

    static func == (left: AFormula, right: AFormula) -> AFormula {
        return .equal(left: left, right: right)
    }

    static func > (left: AFormula, right: AFormula) -> AFormula {
        return .greaterThan(left: left, right: right)
    }

    static func < (left: AFormula, right: AFormula) -> AFormula {
        return .lessThan(left: left, right: right)
    }

    static func >= (left: AFormula, right: AFormula) -> AFormula {
        return .greaterThanOrEqual(left: left, right: right)
    }

    static func <= (left: AFormula, right: AFormula) -> AFormula {
        return .lessThanOrEqual(left: left, right: right)
    }

    static func && (left: AFormula, right: AFormula) -> AFormula {
        return .and(left: left, right: right)
    }

    static func || (left: AFormula, right: AFormula) -> AFormula {
        return .or(left: left, right: right)
    }
}

public extension AFormula {
    init(floatLiteral value: Double) {
        self = .value(.number(value))
    }

    init(booleanLiteral value: Bool) {
        self = .value(.boolean(value))
    }

    init(stringLiteral value: String) {
        self = .value(.string(value))
    }

    init(integerLiteral value: Int) {
        self = .value(.number(.init(value)))
    }

    init(tokens: [AToken]) throws {
        var parser = AFormulaParser(tokens: tokens)
        let someValue = try parser.parse()
        self = someValue
    }
}
