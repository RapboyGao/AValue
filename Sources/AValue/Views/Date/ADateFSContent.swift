import SwiftUI

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct ADateFSContent: View {
    @Binding var value: Date?
    var name: String
    var allowSet: Bool

    @State private var timeZone = TimeZone.current

    private var thisBinding: Binding<Date> {
        Binding {
            value ?? .now
        } set: { newValue in
            value = newValue
        }
    }

    public var body: some View {
        List {
            HStack {
                Text(I18n.timeZone)
                Spacer()
                ATimeZoneSelector($timeZone)
            }
            DatePicker(name, selection: thisBinding, displayedComponents: [.hourAndMinute, .date])
                .datePickerStyle(.graphical)
                .environment(\.timeZone, timeZone)
        }
    }

    public init(_ value: Binding<Date?>, name: String, allowSet: Bool) {
        self._value = value
        self.name = name
        self.allowSet = allowSet
    }

    public init(_ value: Binding<AValue?>, name: String, allowSet: Bool) {
        self._value = value.calendarValue()
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
