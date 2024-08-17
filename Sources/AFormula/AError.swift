import AValue
import Foundation

enum AError: Error, Sendable, Codable {
    case invalidOperation // 无效操作
    case divisionByZero // 除零错误
    case comparisonError // 比较错误
    case rowNotFound(id: Int) // 行未找到错误，包含未找到的行ID
    case functionNotFound(id: Int) // 函数未找到错误，包含未找到的函数ID
    case indexOutOfBounds // 索引越界错误
    case typeMismatch(expected: AValueType, actual: AValueType) // 类型不匹配错误，包含期望类型和实际类型
    case invalidToken
}
