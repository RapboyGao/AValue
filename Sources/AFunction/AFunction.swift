import AValue
import Foundation

public struct AFunction: Sendable, Identifiable, CustomStringConvertible {
    public let id: Int
    public let shortName: String
    public let arguments: Arguments
    public let returnValue: Argument
    public let part: Part
    public let examples: [ExampleArg]
    public let instance: @Sendable ([AValue]) throws -> AValue

    public init(id: Int, shortName: String, arguments: Arguments, returnValue: Argument, part: Part, examples: [ExampleArg], instance: @escaping @Sendable ([AValue]) -> AValue) {
        self.id = id
        self.shortName = shortName
        self.arguments = arguments
        self.returnValue = returnValue
        self.part = part
        self.examples = examples
        self.instance = instance
    }

    public var description: String {
        "(" + arguments.description + ")->" + returnValue.name
    }
}
