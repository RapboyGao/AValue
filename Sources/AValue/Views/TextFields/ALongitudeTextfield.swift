import AViewUI

#if os(iOS)

@available(iOS 16, *)
public struct ALongitudeTextfield: View {
    @Binding var value: Double?
    @State var format: ACoordinateFormat = .degreesM
    var allowSet: Bool
    var placeholder: String

    private var formatStyle: ALongitudeFormat {
        ALongitudeFormat(format)
    }

    public var body: some View {
        if allowSet {
            AFormatOptionalTextfield(placeholder, value: $value, format: formatStyle) { textfield, bindString in
                textfield
                    .aKeyboardView { uiTextfield in
                        ALongitudeKeyboard(uiTextfield, string: bindString, format: $format)
                            .frame(height: 250)
                    }
                    .multilineTextAlignment(.trailing)
            }
        } else if let value = value {
            Spacer()
            Menu {
                ForEach(ACoordinateFormat.allCases, id: \.self) { thisFormat in
                    Button(ALongitude(value, format: thisFormat).description) {
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
    }

    public init(_ value: Binding<AValue?>, allowSet: Bool, placeholder: String) {
        self._value = value.doubleValue()
        self.allowSet = allowSet
        self.placeholder = placeholder
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
    @State var value: AValue? = 78.151564
    var body: some View {
        HStack {
            ALongitudeTextfield($value, allowSet: true, placeholder: "Longitude")
        }
        HStack {
            ALongitudeTextfield($value, allowSet: false, placeholder: "Longitude")
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
