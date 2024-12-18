import SwiftUI

public struct ALongFormat: ParseableFormatStyle {
    public var preferredFormat: ACoordinateFormat
    public var digits: Int
    public var parseStrategy = Strategy()

    public func format(_ value: Double) -> String {
        ALongitude(value, format: preferredFormat).toString(digits: digits)
    }

    public static func degrees(digits: Int = 7) -> Self {
        .init(preferredFormat: .degrees, digits: digits)
    }

    public static func dM(digits: Int = 1) -> Self {
        .init(preferredFormat: .degreesM, digits: digits)
    }

    public static func dMS(digits: Int = 1) -> Self {
        .init(preferredFormat: .degreesMS, digits: digits)
    }

    public init(preferredFormat: ACoordinateFormat, digits: Int) {
        self.preferredFormat = preferredFormat
        self.digits = digits
    }
}

public extension ALongFormat {
    struct Strategy: Codable, Hashable, ParseStrategy {
        public func parse(_ value: String) throws -> Double {
            let result = try ALongitude(value)
            let number = result.toNumber()
            guard number <= 180, number >= -180
            else {
                throw ACoordinateParsingError.notWithinRange
            }
            return result.toNumber()
        }
    }
}

//
// @available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
// private struct Example: View {
//    @State var longitude: Double?
//    var body: some View {
//        TextField("Longitude", value: $longitude, format: ALongFormat.dM(digits: 1))
//    }
// }
//
// @available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
// struct ALongFormat_Previews: PreviewProvider {
//    static var previews: some View {
//        Example()
//    }
// }
