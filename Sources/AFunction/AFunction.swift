import AValue
import Foundation

public struct AFunction: Sendable, Identifiable {
    public let id: Int
    public let shortName: String
    public let arguments: Arguments
    public let returnValue: Argument
    public let part: Part
    public let examples: [ExampleArg]
    public let instance: @Sendable ([AValue]) throws -> AValue
}
