import Foundation
import SwiftUI

public enum ANumberKey: Int, RawRepresentable, Codable, Sendable, Hashable, CaseIterable {
    case number1 = 1, number2, number3, number4, number5, number6, number7, number8, number9
    case number0 = 0
}

public enum ATimeNumberKey: Codable, Sendable, Hashable {
    case number(ANumberKey)
    case plus
    case minus
    case colon
}
