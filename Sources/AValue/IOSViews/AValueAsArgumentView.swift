import AUnit
import AViewUI
import SwiftUI

#if os(iOS)

@available(iOS 16.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct AValueAsArgumentView: View {
    private var value: AValue
    private var precision: NumberFormatStyleConfiguration.Precision
    private var unit: AUnit?
    private var name: String

    @Environment(\.colorScheme) private var colorScheme
    @State private var selectedUnit: AUnit?

    private var format: FloatingPointFormatStyle<Double> {
        .number.grouping(.never).precision(precision)
    }

    private var color: Color {
        value.type.color(for: colorScheme)
    }

    public var body: some View {
        switch value {
        case .number(let double):
            if let unit = unit {
                Menu {
                    ForEach(unit.unitType.allUnits) { thisUnit in
                        if let someValue = unit.convert(value: double, to: thisUnit) {
                            Text("= ") + Text(someValue, format: format) + Text(" ") + Text(thisUnit.symbol)
                        } else {
                            Text("- ") + Text(thisUnit.symbol)
                        }
                    }
                } label: {
                    Group {
                        Text(double, format: format) + Text(unit.symbol)
                    }
                    .foregroundColor(color)
                }
            } else {
                Text(double, format: format)
                    .foregroundColor(color)
            }
        case .point(let x, let y):
            ASheetButton {
                .init(.fullScreenCover, .tapGesture, return: .done)
            } label: {
                Group {
                    if let unit = unit {
                        Text("(") + Text(x, format: format) + Text(",") + Text(y, format: format) + Text(")") + Text(unit.symbol)
                    } else {
                        Text("(") + Text(x, format: format) + Text(",") + Text(y, format: format) + Text(")")
                    }
                }
                .foregroundColor(color)
            } cover: {
                AValueFSContent(value: .constant(value), type: .point, allowInput: false, name: name, unit: $selectedUnit, originalUnit: unit)
            } onSheetClosed: {
                // Do nothing
            }
        case .minutes(let minutes):
            Menu {
                ForEach(AHourMinuteValue.Format.allCases, id: \.self) {
                    Text("=") + Text(minutes, format: AHMFormat.notEmpty($0))
                }
            } label: {
                Text(minutes, format: AHMFormat.notEmpty(.hourMinute))
                    .foregroundColor(color)
            }
        case .location, .boolean, .string, .groundWind, .calendar, .dateDifference:
            ASheetButton {
                .init(.fullScreenCover, .tapGesture, return: .done)
            } label: {
                Text(value.description)
                    .foregroundColor(color)
            } cover: {
                AValueFSContent(value: .constant(value), type: value.type, allowInput: false, name: name, unit: $selectedUnit, originalUnit: unit)
            } onSheetClosed: {
                // Do nothing
            }
        case .color(let color):
            Text(color.attributedString(for: colorScheme))
        }
    }

    public init(value: AValue, precision: NumberFormatStyleConfiguration.Precision, unit: AUnit?, name: String) {
        self.value = value
        self.precision = precision
        self.unit = unit
        self.name = name
    }
}

@available(iOS 16.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
private struct Example: View {
    @State private var examples: [AValue] = AValueType.allCases.map { valueType in
        valueType.baseValue()
    }

    @State private var examples2: [AValue] = AValueType.allCases.map { valueType in
        valueType.randomValue()
    }

    var body: some View {
        List {
            Section("Defaults") {
                ForEach(examples, id: \.self) { example in
                    AValueAsArgumentView(value: example, precision: .fractionLength(0 ... 3), unit: .knots, name: "Location")
                }
            }
            Section("Randoms") {
                ForEach(examples2, id: \.self) { example in
                    AValueAsArgumentView(value: example, precision: .fractionLength(0 ... 3), unit: .knots, name: "Location")
                }
            }
        }
    }
}

@available(iOS 16.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
#Preview {
    Example()
}

#endif
