import CoreLocation
import SwiftUI

// MARK: - Binding

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Binding<AValue?> {
    /// Create a binding for a double value
    func doubleValue() -> Binding<Double?> {
        Binding<Double?>(
            get: {
                self.wrappedValue?.getNumber()
            },
            set: {
                if let newValue = $0 {
                    self.wrappedValue = .number(newValue)
                }
            }
        )
    }

    /// Create a binding for a point
    func pointValue() -> Binding<SIMD2<Double>?> {
        Binding<SIMD2<Double>?>(
            get: {
                self.wrappedValue?.getPoint()
            },
            set: {
                if let newValue = $0 {
                    self.wrappedValue = .point(x: newValue.x, y: newValue.y)
                }
            }
        )
    }

    /// Create a binding for a location
    func locationValue() -> Binding<CLLocationCoordinate2D?> {
        Binding<CLLocationCoordinate2D?>(
            get: {
                self.wrappedValue?.getLocation()
            },
            set: {
                if let newValue = $0 {
                    self.wrappedValue = .location(latitude: newValue.latitude, longitude: newValue.longitude)
                }
            }
        )
    }

    /// Create a binding for a boolean value
    func booleanValue() -> Binding<Bool?> {
        Binding<Bool?>(
            get: {
                self.wrappedValue?.getBoolean()
            },
            set: {
                if let newValue = $0 {
                    self.wrappedValue = .boolean(newValue)
                }
            }
        )
    }

    /// Create a binding for a string value
    func stringValue() -> Binding<String?> {
        Binding<String?>(
            get: {
                self.wrappedValue?.getString()
            },
            set: {
                if let newValue = $0 {
                    self.wrappedValue = .string(newValue)
                }
            }
        )
    }

    /// Create a binding for a ground wind limit
    func groundWindValue() -> Binding<AWindLimit?> {
        Binding<AWindLimit?>(
            get: {
                self.wrappedValue?.getGroundWindLimit()
            },
            set: {
                if let newValue = $0 {
                    self.wrappedValue = .groundWind(limit: newValue)
                }
            }
        )
    }

    /// Create a binding for minutes
    func minutesValue() -> Binding<Int?> {
        Binding<Int?>(
            get: {
                self.wrappedValue?.getMinutes()
            },
            set: {
                if let newValue = $0 {
                    self.wrappedValue = .minutes(newValue)
                }
            }
        )
    }

    /// Create a binding for a calendar date
    func calendarValue() -> Binding<Date?> {
        Binding<Date?>(
            get: {
                self.wrappedValue?.getCalendar()
            },
            set: {
                if let newValue = $0 {
                    self.wrappedValue = .calendar(newValue)
                }
            }
        )
    }

    /// Create a binding for a date difference
    func dateDifferenceValue() -> Binding<DateComponents?> {
        Binding<DateComponents?>(
            get: {
                self.wrappedValue?.getDateDifference()
            },
            set: {
                if let newValue = $0 {
                    self.wrappedValue = .dateDifference(newValue)
                }
            }
        )
    }
}
