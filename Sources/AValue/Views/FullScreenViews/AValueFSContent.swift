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
            ProgressView()
        case .location:
            AMapPointSelector($value, name: name, other: [])
                .ignoresSafeArea()
        case .boolean:
            Toggle(name, isOn: bindBoolean)
                .padding()
        case .string:
            TextEditor(text: bindString)
                .padding()
        case .groundWind:
            AWindLimitFSContent($value, unit: $unit, originalUnit: originalUnit, allowSet: allowInput, precision: .significantDigits(1 ... 2))
        case .minutes:
            ProgressView()
        case .calendar:
            ADateFSContent(value: $value, name: name, allowSet: allowInput)
        case .dateDifference:
            ProgressView()
        }
    }

    public init(value: Binding<AValue?>, type: AValueType, allowInput: Bool, name: String, unit: Binding<AUnit?>, originalUnit: AUnit? = nil) {
        self._value = value
        self.type = type
        self.allowInput = allowInput
        self.name = name
        self._unit = unit
        self.originalUnit = originalUnit
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

@available(iOS 16.0, macOS 13.0, *)
#Preview {
    Example()
}
