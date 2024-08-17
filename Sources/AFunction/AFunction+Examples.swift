import AValue
import CoreLocation
import Foundation

// Example functions
public extension AFunction {
    static let cosFunction = AFunction(
        id: 1,
        shortName: "cos",
        arguments: .finite([Argument(name: I18n.angleArgumentName, detail: I18n.angleArgumentDetail, type: .one(.number))]),
        returnValue: Argument(name: "result", detail: I18n.cosFunctionDescription, type: .one(.number)),
        part: .math,
        examples: [ExampleArg([.number(0)]), ExampleArg([.number(Double.pi / 2)])],
        instance: { args in
            let angle = try args.number(at: 0)
            return .number(cos(angle))
        }
    )

    static let sinFunction = AFunction(
        id: 2,
        shortName: "sin",
        arguments: .finite([Argument(name: I18n.angleArgumentName, detail: I18n.angleArgumentDetail, type: .one(.number))]),
        returnValue: Argument(name: "result", detail: I18n.sinFunctionDescription, type: .one(.number)),
        part: .math,
        examples: [ExampleArg([.number(0)]), ExampleArg([.number(Double.pi / 2)])],
        instance: { args in
            let angle = try args.number(at: 0)
            return .number(sin(angle))
        }
    )

    static let maxFunction = AFunction(
        id: 3,
        shortName: "max",
        arguments: .finite([
            Argument(name: I18n.value1ArgumentName, detail: I18n.value1ArgumentDetail, type: .one(.number)),
            Argument(name: I18n.value2ArgumentName, detail: I18n.value2ArgumentDetail, type: .one(.number))
        ]),
        returnValue: Argument(name: "result", detail: I18n.maxFunctionDescription, type: .one(.number)),
        part: .math,
        examples: [ExampleArg([.number(1), .number(2)]), ExampleArg([.number(3), .number(2)])],
        instance: { args in
            let value1 = try args.number(at: 0)
            let value2 = try args.number(at: 1)
            return .number(max(value1, value2))
        }
    )

    static let distanceFunction = AFunction(
        id: 4,
        shortName: "distance",
        arguments: .finite([
            Argument(name: I18n.location1ArgumentName, detail: I18n.location1ArgumentDetail, type: .one(.location)),
            Argument(name: I18n.location2ArgumentName, detail: I18n.location2ArgumentDetail, type: .one(.location))
        ]),
        returnValue: Argument(name: "result", detail: I18n.distanceFunctionDescription, type: .one(.number)),
        part: .geography,
        examples: [
            ExampleArg([.location(latitude: 37.7749, longitude: -122.4194), .location(latitude: 34.0522, longitude: -118.2437)]),
            ExampleArg([.location(latitude: 51.5074, longitude: -0.1278), .location(latitude: 48.8566, longitude: 2.3522)])
        ],
        instance: { args in
            let loc1 = try args.location(at: 0)
            let loc2 = try args.location(at: 1)
            let coord1 = CLLocation(latitude: loc1.latitude, longitude: loc1.longitude)
            let coord2 = CLLocation(latitude: loc2.latitude, longitude: loc2.longitude)
            return .number(coord1.distance(from: coord2))
        }
    )

    static let pointDistance = AFunction(
        id: 5,
        shortName: "pointDistance",
        arguments: .finite([
            Argument(name: "Point 1", detail: "The first point", type: .one(.point)),
            Argument(name: "Point 2", detail: "The second point", type: .one(.point))
        ]),
        returnValue: Argument(name: "Distance", detail: "Distance between two points", type: .one(.number)),
        part: .points,
        examples: [
            ExampleArg([.point(x: 0, y: 0), .point(x: 3, y: 4)]),
            ExampleArg([.point(x: 1, y: 1), .point(x: 4, y: 5)])
        ],
        instance: { args in
            let point1 = try args.point(at: 0)
            let point2 = try args.point(at: 1)
            let distance = sqrt(pow(point2.x - point1.x, 2) + pow(point2.y - point1.y, 2))
            return .number(distance)
        }
    )
}

// MARK: - All Cases

public extension AFunction {
    static var allCases: [AFunction] {
        return [
            .cosFunction,
            .sinFunction,
            .maxFunction,
            .distanceFunction,
            .pointDistance
            // 将其他函数添加到此数组中
        ]
    }

    static let functionInstances: [Int: @Sendable ([AValue]) throws -> AValue] = {
        var instances = [Int: @Sendable ([AValue]) throws -> AValue]()
        for function in AFunction.allCases {
            instances[function.id] = function.instance
        }
        return instances
    }()
}
