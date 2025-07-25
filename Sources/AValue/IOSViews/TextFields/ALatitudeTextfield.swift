import AViewUI

#if os(iOS)

@available(iOS 16, *)
public struct ALatitudeTextfield: View {
    @Binding var value: Double?
    @State var format: ACoordinateFormat
    var allowSet: Bool
    var placeholder: String

    private var formatStyle: ALatitudeFormat {
        ALatitudeFormat(format)
    }

    public var body: some View {
        if allowSet {
            AFormatOptionalTextfield(placeholder, value: $value, format: formatStyle) { textfield, bindString in
                textfield
                    .aKeyboardView { uiTextfield in
                        ALatitudeKeyboard(uiTextfield, string: bindString, format: $format)
                            .frame(height: 250)
                    }
                    .multilineTextAlignment(.trailing)
            }
        } else if let value = value {
            Spacer()
            Menu {
                ForEach(ACoordinateFormat.allCases, id: \.self) { thisFormat in
                    Button(ALatitude(value, format: thisFormat).description) {
                        format = thisFormat
                    }
                }
            } label: {
                Text("= ") + Text(value, format: formatStyle)
            }

        } else {
            Text("-")
        }
    }

    public init(_ value: Binding<Double?>, allowSet: Bool, placeholder: String) {
        self._value = value
        self.allowSet = allowSet
        self.placeholder = placeholder
        self._format = State(initialValue: .degreesM)
    }

    public init(_ value: Binding<AValue?>, allowSet: Bool, placeholder: String) {
        self._value = value.doubleValue()
        self.allowSet = allowSet
        self.placeholder = placeholder
        self._format = State(initialValue: .degreesM)
    }

    public init(_ value: Binding<AValue?>, allowSet: Bool, placeholder: String, format: ACoordinateFormat) {
        self._value = value.doubleValue()
        self.allowSet = allowSet
        self.placeholder = placeholder
        self._format = State(initialValue: format)
    }

    public init(_ value: Binding<Double?>, allowSet: Bool, placeholder: String, format: ACoordinateFormat) {
        self._value = value
        self.allowSet = allowSet
        self.placeholder = placeholder
        self._format = State(initialValue: format)
    }
}

@available(iOS 16, *)

private struct Example: View {
    @State var value: AValue? = 39.12646465
    var body: some View {
        HStack {
            ALatitudeTextfield($value, allowSet: true, placeholder: "Latitude")
        }
        HStack {
            ALatitudeTextfield($value, allowSet: false, placeholder: "Latitude")
        }
    }
}

@available(iOS 16, *)
#Preview {
    List {
        Example()
    }
}

#endif
