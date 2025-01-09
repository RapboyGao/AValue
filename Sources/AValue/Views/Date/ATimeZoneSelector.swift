import SwiftUI

private let allTimeZones = TimeZone.knownTimeZoneIdentifiers.compactMap {
    TimeZone(identifier: $0)
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
struct ATimeZoneSelector: View {
    @Binding var timeZone: TimeZone

    var body: some View {
        Menu {
            ForEach(-13 ..< 13) { timeDiff in
                Menu {
                    ForEach(allTimeZones.filter { $0.secondsFromGMT() == timeDiff * 3600 }, id: \.identifier) { timeZone in
                        Button(timeZone.description) {
                            self.timeZone = timeZone
                        }
                    }
                } label: {
                    Text("UTC") + Text(timeDiff, format: .number.sign(strategy: .always()))
                }
            }
        } label: {
            Text(timeZone.description) + Text(" (") + Text(timeZone.secondsFromGMT() / 3600, format: .number.sign(strategy: .always())) + Text(")")
        }
    }

    public init(_ timeZone: Binding<TimeZone>) {
        self._timeZone = timeZone
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
private struct Example: View {
    @State private var timeZone = TimeZone.current

    var body: some View {
        ATimeZoneSelector($timeZone)
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
#Preview {
    List {
        Example()
    }
}
