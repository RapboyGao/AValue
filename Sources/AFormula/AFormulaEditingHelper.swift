import AFunction
import Foundation
import SwiftUI

public struct AFormulaEditingHelper: Sendable {
    public private(set) var rowDict: [Int: String]
    public private(set) var functionNameDict: [Int: String]
    public private(set) var functions: [AFunction]
}
