import AUnit
import AUnitViews
import AViewUI

#if os(iOS)

@available(iOS 16, *)
public struct AValueInputContent: View {
    @Binding var value: AValue?
    @Binding var unit: AUnit?

    var allowInput: Bool
    var name: String
    var originalUnit: AUnit?
    var auxPoints: [ALocation]
    var precision: NumberFormatStyleConfiguration.Precision
    var designatedType: AValueType?

    var sheetConfig: ASheetButtonConfig {
        ASheetButtonConfig(.fullScreenCover, .tapGesture, return: .done)
    }

    var actualType: AValueType {
        designatedType ?? value?.type ?? .number
    }

    var bindDouble: Binding<Double?> {
        Binding {
            value?.getNumber()
        } set: { newValue in
            guard let newValue = newValue else {
                value = nil
                return
            }
            value = .number(newValue)
        }
    }

    var bindBool: Binding<Bool> {
        Binding {
            value?.getBoolean() ?? false
        } set: { newValue in
            value = .boolean(newValue)
        }
    }

    var bindString: Binding<String> {
        Binding {
            value?.getString() ?? ""
        } set: { newValue in
            value = .string(newValue)
        }
    }

    var bindColor: Binding<Color> {
        Binding {
            value?.getColor() ?? .clear
        } set: { newValue in
            value = .init(color: newValue)
        }
    }

    public var body: some View {
        switch actualType {
        case .number:
            AUnitTextfieldContentDebounce(bindDouble, $unit, originalUnit: originalUnit, placeholder: name, allowSet: allowInput, precision: precision)
        case .point:
            Spacer()
            if !allowInput {
                Text("=")
            }
            ASheetButton {
                sheetConfig
            } label: {
                Text(value?.description ?? "-")
            } cover: {
                AVectorEditView($value, $unit, originalUnit: originalUnit, allowSet: allowInput, precision: precision)
            }
        case .location:
            Spacer()
            if !allowInput {
                Text("=")
            }
            ASheetButton {
                sheetConfig
            } label: {
                Text(value?.description ?? "-")
            } cover: {
                ALocationFSContent($value, allowSet: allowInput, name: name, other: auxPoints)
            }
        case .boolean:
            Spacer()
            if allowInput {
                Toggle(name, isOn: bindBool)
                    .labelsHidden()
            } else {
                Text("= ") + Text(value?.description ?? "-")
            }
        case .string:
            if allowInput {
                TextEditor(text: bindString)
                    .multilineTextAlignment(.trailing)
            } else {
                Spacer()
                Text(value?.getString() ?? "")
            }
        case .groundWind:
            Spacer()
            if !allowInput {
                Text("=")
            }
            ASheetButton {
                sheetConfig
            } label: {
                Text(value?.description ?? "-")
            } cover: {
                AWindLimitFSContent($value, unit: $unit, originalUnit: originalUnit, allowSet: allowInput, precision: precision)
            }
        case .minutes:
            AHMTextfield($value, allowSet: allowInput, placeholder: name)
        case .calendar:
            Spacer()
            if !allowInput {
                Text("=")
            }
            ASheetButton {
                sheetConfig
            } label: {
                Text(value?.description ?? "-")
            } cover: {
                ADateFSContent($value, name: name, allowSet: allowInput)
            }
        case .dateDifference:
            Spacer()
            if !allowInput {
                Text("=")
            }
            ASheetButton {
                sheetConfig
            } label: {
                Text(value?.description ?? "-")
            } cover: {
                List {
                    ADateComponentFSContent($value, allowSet: allowInput)
                }
            }
        case .color:
            Spacer()
            if allowInput {
                ColorPicker(name, selection: bindColor, supportsOpacity: true)
                    .labelsHidden()
            } else {
                ColorPicker(name, selection: bindColor, supportsOpacity: true)
                    .labelsHidden()
                    .disabled(true)
            }
        }
    }

    public init(_ bindValue: Binding<AValue?>, _ bindUnit: Binding<AUnit?>, allowInput: Bool, name: String, originalUnit: AUnit?, auxPoints: [ALocation], precision: NumberFormatStyleConfiguration.Precision, designatedType: AValueType? = nil) {
        self._value = bindValue
        self._unit = bindUnit
        self.allowInput = allowInput
        self.name = name
        self.originalUnit = originalUnit
        self.auxPoints = auxPoints
        self.precision = precision
        self.designatedType = designatedType
    }
}

@available(iOS 16, *)
private struct Example: View {
    @State private var values: [AValue?]
    @State private var unit: AUnit? = .knots

    var originalUnit = AUnit.knots

    var body: some View {
        ForEach($values, id: \.wrappedValue?.type) { bindValue in
            HStack {
                Text("Value")
                AValueInputContent(bindValue, $unit, allowInput: true, name: "Hello", originalUnit: originalUnit, auxPoints: .examples, precision: .fractionLength(0...6))
            }
            HStack {
                Text("Value")
                AValueInputContent(bindValue, $unit, allowInput: false, name: "Hello", originalUnit: originalUnit, auxPoints: .examples, precision: .fractionLength(0...6))
            }
        }
    }

    init() {
        let someValues = AValueType.allCases.map {
            $0.randomValue() as AValue?
        }
        self._values = State(initialValue: someValues)
    }
}

@available(iOS 16, *) #Preview {
    List {
        Example()
    }
    .scrollDismissesKeyboard(.immediately)
}

#endif
