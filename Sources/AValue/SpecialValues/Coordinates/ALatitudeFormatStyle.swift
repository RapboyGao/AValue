import Foundation

//public struct ALatitudeFormat: ParseableFormatStyle {
//    public var preferredFormat: ACoordinateFormat
//    public var digits: Int
//    public var parseStrategy: Strategy
//
//    public func format(_ value: Double) -> String {
//        ALatitude(value, format: preferredFormat).toString(digits: digits)
//    }
//
//    public typealias FormatInput = Double
//
//    public typealias FormatOutput = String
//}
//
//public extension ALatitudeFormat {
//    struct Strategy: Codable, Hashable {
//        public func parse(_ value: String) throws -> Double {
//            guard let number = AMathExpression<ANumber>(value)?.evaluate() else {
//                return try displayedFormat.parseStrategy.parse(value)
//            }
//            return number
//        }
//    }
//}
