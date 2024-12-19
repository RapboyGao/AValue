import SwiftUI

#if os(iOS)

@available(iOS 16, *)
public struct ALatTextfield: View {
    @Binding var value: Double?
    @State var format: ACoordinateFormat = .degreesM
    var allowSet: Bool
    var placeholder: String

    private var formatStyle: ALatFormat {
        ALatFormat(format)
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
    }

    public init(_ value: Binding<AValue?>, allowSet: Bool, placeholder: String) {
        self._value = value.doubleValue()
        self.allowSet = allowSet
        self.placeholder = placeholder
    }
}

@available(iOS 16, *)

private struct Example: View {
    @State var value: AValue? = 39.12646465
    var body: some View {
        HStack {
            ALatTextfield($value, allowSet: true, placeholder: "Latitude")
        }
        HStack {
            ALatTextfield($value, allowSet: false, placeholder: "Latitude")
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
