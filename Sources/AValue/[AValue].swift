import Foundation

public extension [AValue] {
    @Sendable private func value(at index: Int) throws -> AValue {
        guard index >= 0 && index < self.count else {
            throw AValueError.indexOutOfBounds
        }
        return self[index]
    }

    @Sendable func number(at index: Int) throws -> Double {
        let value = try self.value(at: index)
        if case let .number(number) = value {
            return number
        } else {
            throw AValueError.typeMismatch(expected: .number, actual: value.type)
        }
    }

    @Sendable func point(at index: Int) throws -> SIMD2<Double> {
        let value = try self.value(at: index)
        if case let .point(x, y) = value {
            return SIMD2(x, y)
        } else {
            throw AValueError.typeMismatch(expected: .point, actual: value.type)
        }
    }

    @Sendable func location(at index: Int) throws -> (latitude: Double, longitude: Double) {
        let value = try self.value(at: index)
        if case let .location(latitude, longitude) = value {
            return (latitude, longitude)
        } else {
            throw AValueError.typeMismatch(expected: .location, actual: value.type)
        }
    }

    @Sendable func boolean(at index: Int) throws -> Bool {
        let value = try self.value(at: index)
        if case let .boolean(boolean) = value {
            return boolean
        } else {
            throw AValueError.typeMismatch(expected: .boolean, actual: value.type)
        }
    }

    @Sendable func string(at index: Int) throws -> String {
        let value = try self.value(at: index)
        if case let .string(string) = value {
            return string
        } else {
            throw AValueError.typeMismatch(expected: .string, actual: value.type)
        }
    }

    @Sendable func minutes(at index: Int) throws -> Int {
        let value = try self.value(at: index)
        if case let .minutes(minutes) = value {
            return minutes
        } else {
            throw AValueError.typeMismatch(expected: .minutes, actual: value.type)
        }
    }

    @Sendable func calendar(at index: Int) throws -> Date {
        let value = try self.value(at: index)
        if case let .calendar(calendar) = value {
            return calendar
        } else {
            throw AValueError.typeMismatch(expected: .calendar, actual: value.type)
        }
    }

    @Sendable func dateDifference(at index: Int) throws -> DateComponents {
        let value = try self.value(at: index)
        if case let .dateDifference(dateDifference) = value {
            return dateDifference
        } else {
            throw AValueError.typeMismatch(expected: .dateDifference, actual: value.type)
        }
    }
}
