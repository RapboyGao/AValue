import SwiftUI

private let allTimeZones = TimeZone.knownTimeZoneIdentifiers.map {
    TimeZone(identifier: $0)!
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
struct ATimeZoneEditor: View {
    @Binding var timeZone: TimeZone

    var body: some View {
        Picker("Time Zone", selection: $timeZone) {
            ForEach(-12 ..< 13) { timeDiff in
                Menu("UTC\(timeDiff >= 0 ? "+" : "")\(timeDiff)") {
                    ForEach(allTimeZones.filter { $0.secondsFromGMT() == timeDiff * 3600 }, id: \.identifier) { timeZone in
                        Button(timeZone.identifier) {
                            self.timeZone = timeZone
                        }
                    }
                }
            }
        }
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
struct ATimeZoneEditor_Previews: PreviewProvider {
    static var previews: some View {
        ATimeZoneEditor(timeZone: .constant(TimeZone.current))
    }
}
