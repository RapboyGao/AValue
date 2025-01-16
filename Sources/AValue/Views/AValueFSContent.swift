import AUnit
import AViewUI
import SwiftUI

@available(iOS 16, macOS 12.0, *)
public struct AValueFSContent: View {
    @Binding var value: AValue?
    var type: AValueType
    var allowInput: Bool
    var name: String

    @Binding var unit: AUnit?
    var originalUnit: AUnit?
    var auxPoints: [ALocation]

    private var bindBoolean: Binding<Bool> {
        Binding {
            value == true
        } set: { newValue in
            value = .boolean(newValue)
        }
    }

    private var bindString: Binding<String> {
        Binding {
            guard case let .string(string) = value
            else { return "" }
            return string
        } set: { newValue in
            value = .string(newValue)
        }
    }

    public var body: some View {
        switch type {
        case .number:
            ANumberFSContent(aValue: $value, name: name, allowSet: allowInput)
        case .point:
            AVectorEditView($value, $unit, originalUnit: originalUnit, allowSet: allowInput, precision: .fractionLength(0 ... 3))
        case .location:
            ALocationFSContent($value, allowSet: allowInput, name: name, other: auxPoints)
        case .boolean:
            ABoolFSContent($value)
        case .string:
            ATextFSContent($value, allowSet: allowInput)
        case .groundWind:
            AWindLimitFSContent($value, unit: $unit, originalUnit: originalUnit, allowSet: allowInput, precision: .fractionLength(0 ... 3))
        case .minutes:
            AHourMinuteFSContent(aValue: $value, name: name, allowSet: allowInput)
        case .calendar:
            ADateFSContent($value, name: name, allowSet: allowInput)
        case .dateDifference:
            List {
                ADateComponentFSContent($value, allowSet: allowInput)
            }
        case .color:
            AValueColorLabel($value)
        }
    }

    public init(value: Binding<AValue?>, type: AValueType, allowInput: Bool, name: String, unit: Binding<AUnit?>, originalUnit: AUnit? = nil, auxPoints: [ALocation] = []) {
        self._value = value
        self.type = type
        self.allowInput = allowInput
        self.name = name
        self._unit = unit
        self.originalUnit = originalUnit
        self.auxPoints = auxPoints
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
private extension Binding {
    func optional() -> Binding<Value?> {
        Binding<Value?> {
            wrappedValue
        } set: { newValue in
            if let newVal = newValue {
                wrappedValue = newVal
            }
        }
    }
}

@available(iOS 16.0, macOS 13.0, *)
private struct Example: View {
    @State private var values: [AValue] = AValueType.allCases.map { $0.baseValue() }

    var body: some View {
        NavigationStack {
            List {
                ForEach($values, id: \.type) { thisValue in
                    ASheetButton {
                        .init(.fullScreenCover, .button, return: .done)
                    } label: {
                        Label(thisValue.wrappedValue.description, systemImage: thisValue.wrappedValue.type.symbolName)
                    } cover: {
                        AValueFSContent(value: thisValue.optional(), type: thisValue.wrappedValue.type, allowInput: true, name: "Hello", unit: .constant(.meters))
                    }
                }
            }
        }
    }
}

@available(iOS 16.0, macOS 13.0, *)
#Preview {
    Example()
}
