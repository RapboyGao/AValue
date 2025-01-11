import AViewUI

#if os(iOS)

@available(iOS 16, *)
public struct AHMTextfield: View {
    @Binding var value: Int?
    @State var format: AHourMinuteValue.Format = .days24HM
    var allowSet: Bool
    var placeholder: String

    private var formatStyle: AHMFormat {
        AHMFormat(format: format)
    }

    public var body: some View {
        if allowSet {
            AFormatOptionalTextfield(placeholder, value: $value, format: formatStyle) { textfield, bindString in
                textfield.aKeyboardView { uiTextfield in
                    AHMKeyboard(uiTextfield, bindString, format: $format)
                }
            }
            .multilineTextAlignment(.trailing)
        } else if let value = value {
            Spacer()
            switch value {
            case 0 ..< 1440:
                Text(AHourMinuteValue(minutes: value).toHM().description)
            default:
                Menu {
                    if format == .days24HM {
                        Button {
                            format = .hourMinute
                        } label: {
                            Text(value, format: AHMFormat(format: .hourMinute))
                        }
                    } else {
                        Button {
                            format = .days24HM
                        } label: {
                            Text(value, format: AHMFormat(format: .days24HM))
                        }
                    }
                    Text("= ") + Text(value, format: AHMFormat(format: .totalMinutes))
                    Text("= ") + Text(value, format: AHMFormat(format: .totalHours))
                } label: {
                    Text("= ") + Text(value, format: formatStyle)
                }
            }
        } else {
            Text("-")
        }
    }

    public init(_ value: Binding<Int?>, allowSet: Bool, placeholder: String) {
        self._value = value
        self.allowSet = allowSet
        self.placeholder = placeholder
    }

    public init(_ value: Binding<AValue?>, allowSet: Bool, placeholder: String) {
        self._value = value.minutesValue()
        self.allowSet = allowSet
        self.placeholder = placeholder
    }
}

@available(iOS 16, *)

private struct Example: View {
    @State var value: Int?
    var body: some View {
        HStack {
            AHMTextfield($value, allowSet: true, placeholder: "Time")
        }
        HStack {
            AHMTextfield($value, allowSet: false, placeholder: "Time")
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
