import AUnitViews
import SwiftUI

#if os(iOS)

@available(iOS 16, *)
struct ADateComponentFSContent: View {
    @Binding var value: DateComponents?

    var allowSet: Bool

    @ViewBuilder
    func bindInt(_ name: String, _ bindInt: Binding<Int?>) -> some View {
        HStack {
            Text(name)
            if allowSet {
                TextField(name, value: bindInt, format: .number)

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
            guard let newValue = newValue
            else {
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
            guard let newValue = newValue else {
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
            guard let newValue = newValue else {
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
            guard let newValue = newValue else {
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
            guard let newValue = newValue else {
                value = DateComponents(minute: newValue)
                return
            }
            value?.minute = newValue
        }
    }

    private var bindSecond: Binding<Int?> {
        Binding {
            value?.second
        } set: { newValue in
            guard let newValue = newValue else {
                value = DateComponents(second: newValue)
                return
            }
            value?.second = newValue
        }
    }

    var body: some View {
        bindInt("Year", bindYear)
        bindInt("Month", bindMonth)
        bindInt("Day", bindDay)
        bindInt("Hour", bindHour)
        bindInt("Minute", bindMinute)
        bindInt("Second", bindSecond)
    }

    public init(_ value: Binding<DateComponents?>, allowSet: Bool) {
        self._value = value
        self.allowSet = allowSet
    }

    public init(_ value: Binding<AValue?>, allowSet: Bool) {
        self._value = value.dateDifferenceValue()
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
