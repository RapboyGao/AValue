import AUnitViews
import AViewUI
import SwiftUI

#if os(iOS)

@available(iOS 16, *)
struct ADateComponentFSContent: View {
    @Binding var value: DateComponents?

    var allowSet: Bool

    @ViewBuilder
    func intView(_ name: String, _ bindInt: Binding<Int?>) -> some View {
        HStack {
            Text(name)
            if allowSet {
                ACustomKeyboardOptionalFormatField(
                    name,
                    value: bindInt,
                    format: .number,
                    configure: { textField in
                        textField.textAlignment = .right
                    }
                ) { context, _ in
                    AIntKeyboard(context)
                        .frame(height: 250)
                }
            } else {
                Spacer()
                if let number = bindInt.wrappedValue {
                    Text("= ") + Text(number, format: .number)
                } else {
                    Text("-")
                }
            }
        }
    }

    private var bindYear: Binding<Int?> {
        Binding {
            value?.year
        } set: { newValue in
            guard newValue != 0 else {
                value?.year = nil
                return
            }
            guard self.value != nil else {
                value = DateComponents(year: newValue)
                return
            }
            value?.year = newValue
        }
    }

    private var bindMonth: Binding<Int?> {
        Binding {
            value?.month
        } set: { newValue in
            guard newValue != 0 else {
                value?.month = nil
                return
            }
            guard self.value != nil else {
                value = DateComponents(month: newValue)
                return
            }
            value?.month = newValue
        }
    }

    private var bindDay: Binding<Int?> {
        Binding {
            value?.day
        } set: { newValue in
            guard newValue != 0 else {
                value?.day = nil
                return
            }
            guard self.value != nil else {
                value = DateComponents(day: newValue)
                return
            }
            value?.day = newValue
        }
    }

    private var bindHour: Binding<Int?> {
        Binding {
            value?.hour
        } set: { newValue in
            guard newValue != 0 else {
                value?.hour = nil
                return
            }
            guard self.value != nil else {
                value = DateComponents(hour: newValue)
                return
            }
            value?.hour = newValue
        }
    }

    private var bindMinute: Binding<Int?> {
        Binding {
            value?.minute
        } set: { newValue in
            guard newValue != 0 else {
                value?.minute = nil
                return
            }
            guard self.value != nil else {
                value = DateComponents(minute: newValue)
                return
            }
            value?.minute = newValue
        }
    }

    var body: some View {
        intView(AUnit.years.shortName, bindYear)
        intView(I18n.months, bindMonth)
        intView(AUnit.days.shortName, bindDay)
        intView(AUnit.hours.shortName, bindHour)
        intView(AUnit.minutes.shortName, bindMinute)
        // bindInt("Second", bindSecond)
        // bindInt("Nanosecond", bindNanosecond)
    }

    public init(_ value: Binding<DateComponents?>, allowSet: Bool) {
        _value = value
        self.allowSet = allowSet
    }

    public init(_ value: Binding<AValue?>, allowSet: Bool) {
        _value = value.dateDifferenceValue()
        self.allowSet = allowSet
    }
}

@available(iOS 16, *)
private struct Example: View {
    @State var value: AValue?

    var body: some View {
        List {
            Section {
                ADateComponentFSContent($value, allowSet: true)
            }
            Section {
                ADateComponentFSContent($value, allowSet: false)
            }
        }
    }
}

@available(iOS 16, *)
#Preview {
    Example()
}

#endif
