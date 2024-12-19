import SwiftUI

#if os(iOS)

@available(iOS 16, *)
public struct ALongTextfield: View {
    @Binding var value: Double?
    @State var format: ACoordinateFormat = .degreesM
    var allowSet: Bool
    var placeholder: String

    private var formatStyle: ALongFormat {
        ALongFormat(format)
    }

    public var body: some View {
        if allowSet {
            TextField(placeholder, value: $value, format: formatStyle)
                .aKeyboardView { uiTextfield in
                    ALatKeyboard(uiTextfield, format: $format)
                        .frame(height: 250)
                }
                .multilineTextAlignment(.trailing)
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
}

@available(iOS 16, *)

private struct Example: View {
    @State var value: AValue? = 78.151564
    var body: some View {
        HStack {
            ALongTextfield($value, allowSet: true, placeholder: "Longitude")
        }
        HStack {
            ALongTextfield($value, allowSet: false, placeholder: "Longitude")
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
