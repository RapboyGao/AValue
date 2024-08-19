import Foundation

/// 表示公式解析器错误类型的枚举
enum AFormulaParserError: Error {
    case unexpectedToken // 意外的标记
    case mismatchedParenthesis // 括号不匹配
    case invalidExpression // 无效表达式
    case unknownFunction(id: Int) // 未知函数
    case incompleteExpression // 表达式不完整
    case invalidToken(token: AToken) // 无效的标记
    case invalidOperatorUsage // 操作符使用无效
}

/// 解析公式的结构体
struct AFormulaParser: Sendable, Hashable, Codable {
    private var tokens: [AToken]
    private var index: Int = 0

    init(tokens: [AToken]) {
        self.tokens = tokens
    }

    /// 解析输入的令牌数组并返回一个 AFormula
    mutating func parse() throws -> AFormula {
        let formula = try parseExpression()
        // 确保所有的令牌都被解析
        if index < tokens.count {
            throw AFormulaParserError.incompleteExpression // 如果解析完成后还有剩余标记，则表达式不完整
        }
        return formula
    }

    /// 解析表达式，首先尝试解析三元运算符
    private mutating func parseExpression() throws -> AFormula {
        return try parseTernary()
    }

    /// 解析三元运算符
    private mutating func parseTernary() throws -> AFormula {
        var result = try parseLogicalOr()
        while let token = currentToken, token.content == .questionMark {
            advance()
            let trueFormula = try parseExpression()
            guard let colonToken = currentToken, colonToken.content == .colon else {
                throw AFormulaParserError.invalidOperatorUsage // 无效的操作符使用
            }
            advance()
            let falseFormula = try parseExpression()
            result = .ternary(condition: result, trueFormula: trueFormula, falseFormula: falseFormula)
        }
        return result
    }

    /// 解析逻辑或运算
    private mutating func parseLogicalOr() throws -> AFormula {
        var result = try parseLogicalAnd()
        while let token = currentToken, token.content == .or {
            advance()
            let nextTerm = try parseLogicalAnd()
            result = .or(left: result, right: nextTerm)
        }
        return result
    }

    /// 解析逻辑与运算
    private mutating func parseLogicalAnd() throws -> AFormula {
        var result = try parseEquality()
        while let token = currentToken, token.content == .and {
            advance()
            let nextTerm = try parseEquality()
            result = .and(left: result, right: nextTerm)
        }
        return result
    }

    /// 解析等式运算
    private mutating func parseEquality() throws -> AFormula {
        var result = try parseComparison()
        while let token = currentToken, token.content == .equal {
            advance()
            let nextTerm = try parseComparison()
            result = .equal(left: result, right: nextTerm)
        }
        return result
    }

    /// 解析比较运算
    private mutating func parseComparison() throws -> AFormula {
        var result = try parseAdditive()
        while let token = currentToken, [.greaterThan, .lessThan, .greaterThanOrEqual, .lessThanOrEqual].contains(token.content) {
            advance()
            let nextTerm = try parseAdditive()
            switch token.content {
            case .greaterThan:
                result = .greaterThan(left: result, right: nextTerm)
            case .lessThan:
                result = .lessThan(left: result, right: nextTerm)
            case .greaterThanOrEqual:
                result = .greaterThanOrEqual(left: result, right: nextTerm)
            case .lessThanOrEqual:
                result = .lessThanOrEqual(left: result, right: nextTerm)
            default:
                throw AFormulaParserError.unexpectedToken // 意外的标记
            }
        }
        return result
    }

    /// 解析加法和减法运算
    private mutating func parseAdditive() throws -> AFormula {
        var result = try parseMultiplicative()
        while let token = currentToken, [.plus, .minus].contains(token.content) {
            let operatorToken = token
            advance()
            let nextTerm = try parseMultiplicative()
            switch operatorToken.content {
            case .plus:
                result = .add(left: result, right: nextTerm)
            case .minus:
                result = .subtract(left: result, right: nextTerm)
            default:
                throw AFormulaParserError.unexpectedToken // 意外的标记
            }
        }
        return result
    }

    /// 解析乘法、除法和取余运算
    private mutating func parseMultiplicative() throws -> AFormula {
        var result = try parsePower()
        while let token = currentToken, [.asterisk, .divide, .remainder].contains(token.content) {
            let operatorToken = token
            advance()
            let nextFactor = try parsePower()
            switch operatorToken.content {
            case .asterisk:
                result = .multiply(left: result, right: nextFactor)
            case .divide:
                result = .divide(left: result, right: nextFactor)
            case .remainder:
                result = .remainder(left: result, right: nextFactor)
            default:
                throw AFormulaParserError.unexpectedToken // 意外的标记
            }
        }
        return result
    }

    /// 解析幂运算
    private mutating func parsePower() throws -> AFormula {
        var result = try parseUnary()
        while let token = currentToken, token.content == .power {
            advance()
            let nextFactor = try parseUnary()
            result = .power(left: result, right: nextFactor)
        }
        return result
    }

    /// 解析一元运算
    private mutating func parseUnary() throws -> AFormula {
        guard let token = currentToken else {
            throw AFormulaParserError.unexpectedToken // 意外的标记
        }

        switch token.content {
        case .minus:
            advance()
            return try .negative(parseUnary()) // 解析负号或减号的表达式
        case .not:
            advance()
            return try .not(parseUnary()) // 解析逻辑非的表达式
        case .absolute:
            advance()
            let formula = try parseExpression()
            guard currentToken?.content == .absolute else {
                throw AFormulaParserError.mismatchedParenthesis // 绝对值括号不匹配
            }
            advance()
            return .absolute(formula) // 解析绝对值的表达式
        default:
            return try parsePrimary() // 解析主表达式
        }
    }

    /// 解析主表达式
    private mutating func parsePrimary() throws -> AFormula {
        guard let token = currentToken else {
            throw AFormulaParserError.unexpectedToken // 意外的标记
        }

        switch token.content {
        case .leftParenthesis:
            advance()
            let expression = try parseExpression()
            guard currentToken?.content == .rightParenthesis else {
                throw AFormulaParserError.mismatchedParenthesis // 括号不匹配
            }
            advance()
            return .parenthesis(expression) // 解析括号内的表达式
        case .row(let id):
            advance()
            return .variable(id: id) // 解析行引用
        case .functionWithLeftParenthesis(let id):
            advance()
            var args = [AFormula]()
            while currentToken?.content != .rightParenthesis {
                let arg = try parseExpression()
                args.append(arg)
                if currentToken?.content == .comma {
                    advance() // 解析函数参数列表
                }
            }
            guard currentToken?.content == .rightParenthesis else {
                throw AFormulaParserError.mismatchedParenthesis // 函数参数括号不匹配
            }
            advance()
            return .function(id: id, args: args) // 解析函数调用
        case .value(let value):
            advance()
            return .value(value) // 解析值
        default:
            throw AFormulaParserError.invalidToken(token: token) // 无效的标记
        }
    }

    /// 获取当前令牌
    private var currentToken: AToken? {
        guard index < tokens.count else {
            return nil
        }
        return tokens[index]
    }

    /// 前进到下一个令牌
    private mutating func advance() {
        index += 1 // 移动到下一个标记
    }
}
