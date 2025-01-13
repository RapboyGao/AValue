import SwiftUI

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct ADateFSContent: View {
    @Binding var value: ADateAndTZ?
    var name: String
    var allowSet: Bool

    var withDefaultTimeZone: TimeZone {
        value?.timeZone ?? .current
    }

    var bindingTimeZone: Binding<TimeZone> {
        Binding {
            withDefaultTimeZone
        } set: {
            value = ADateAndTZ(date: .now, timeZone: $0)
        }
    }

    private var thisBinding: Binding<Date> {
        Binding {
            value?.date ?? .now
        } set: { newValue in
            value = ADateAndTZ(date: newValue, timeZone: withDefaultTimeZone)
        }
    }

    public var body: some View {
        List {
            HStack {
                Text(I18n.timeZone)
                Spacer()
                ATimeZoneSelector(bindingTimeZone)
            }
            DatePicker(name, selection: thisBinding, displayedComponents: [.hourAndMinute, .date])
                .datePickerStyle(.graphical)
                .environment(\.timeZone, withDefaultTimeZone)
        }
    }

    public init(_ value: Binding<ADateAndTZ?>, name: String, allowSet: Bool) {
        self._value = value
        self.name = name
        self.allowSet = allowSet
    }

    public init(_ value: Binding<AValue?>, name: String, allowSet: Bool) {
        self._value = Binding<ADateAndTZ?> {
            value.wrappedValue?.getCalendar()
        } set: { newValue in
            guard let newValue = newValue else {
                value.wrappedValue = nil
                return
            }
            value.wrappedValue = .calendar(newValue.date, timeZone: newValue.timeZone)
        }
        self.name = name
        self.allowSet = allowSet
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
private struct Example: View {
    @State private var aValue: AValue?

    var body: some View {
        ADateFSContent($aValue, name: "hello", allowSet: true)
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
#Preview {
    Example()
}
