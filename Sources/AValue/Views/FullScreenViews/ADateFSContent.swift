import SwiftUI

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct ADateFSContent: View {
    @Binding var value: Date?
    var name: String
    var allowSet: Bool

    @State private var isUTC: Bool = false

    private var thisBinding: Binding<Date> {
        Binding {
            value ?? .now
        } set: { newValue in
            value = newValue
        }
    }

    public var body: some View {
        List {
            if #available(macOS 13, iOS 16, tvOS 16, watchOS 9, *) {
                DatePicker(name, selection: thisBinding, displayedComponents: [.hourAndMinute, .date])
                    .datePickerStyle(.graphical)
                    .environment(\.timeZone, isUTC ? .gmt : .current)
                Toggle("UTC", isOn: $isUTC)
            } else {
                DatePicker(name, selection: thisBinding, displayedComponents: [.hourAndMinute, .date])
                    .datePickerStyle(.graphical)
            }
        }
    }

    public init(_ value: Binding<Date?>, name: String, allowSet: Bool) {
        self._value = value
        self.name = name
        self.allowSet = allowSet
    }

    public init(value: Binding<AValue?>, name: String, allowSet: Bool) {
        self._value = value.calendarValue()
        self.name = name
        self.allowSet = allowSet
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
#Preview {
    ADateFSContent(.constant(.now), name: "hello", allowSet: true)
}
