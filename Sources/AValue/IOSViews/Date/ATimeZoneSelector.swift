import Algorithms
import SwiftUI

private let allTimeZones: [TimeZone] = TimeZone.knownTimeZoneIdentifiers
    .compactMap {
        TimeZone(identifier: $0)
    }
    .uniqued { timeZone in
        timeZone.localizedName(for: .shortGeneric, locale: nil)
    }

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
private struct TimeZonesView: View {
    @Environment(\.locale) private var locale

    var offset: Int
    var action: (TimeZone) -> Void

    private func isSameTimeZone(_ timeZone: TimeZone) -> Bool {
        timeZone.secondsFromGMT() == offset * 3600
    }

    private func getName(_ someTimeZone: TimeZone) -> String {
        someTimeZone.localizedName(for: .shortGeneric, locale: locale) ?? someTimeZone.identifier
    }

    private var filteredTimeZone: [TimeZone] {
        allTimeZones
            .filter {
                isSameTimeZone($0)
            }
            .uniqued {
                getName($0)
            }
    }

    var body: some View {
        ForEach(filteredTimeZone, id: \.identifier) { someTimeZone in
            Button {
                action(someTimeZone)
            } label: {
                Text(getName(someTimeZone))
            }
        }
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct ATimeZoneSelector: View {
    @Binding var timeZone: TimeZone
    var allowSet: Bool
    @Environment(\.locale) private var locale

    private func getName(_ someTimeZone: TimeZone) -> String {
        someTimeZone.localizedName(for: .shortGeneric, locale: locale) ?? timeZone.identifier
    }

    private func isSameTimeZone(diff: Int, timeZone: TimeZone) -> Bool {
        timeZone.secondsFromGMT() == diff * 3600
    }

    @ViewBuilder
    private var label: some View {
        Text(getName(timeZone)) + Text(" (") + Text(timeZone.secondsFromGMT() / 3600, format: .number.sign(strategy: .always())) + Text(")")
    }

    public var body: some View {
        if allowSet {
            Menu {
                ForEach(-11 ..< 13) { timeDiff in
                    Menu {
                        TimeZonesView(offset: timeDiff) { newTimeZone in
                            timeZone = newTimeZone
                        }
                    } label: {
                        Text("UTC") + Text(timeDiff, format: .number.sign(strategy: .always()))
                    }
                }
            } label: {
                label
            }
        } else {
            label
        }
    }

    public init(_ timeZone: Binding<TimeZone>, allowSet: Bool) {
        self._timeZone = timeZone
        self.allowSet = allowSet
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
private struct Example: View {
    @State private var timeZone = TimeZone.current

    var body: some View {
        ATimeZoneSelector($timeZone, allowSet: false)
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
#Preview {
    List {
        Example()
    }
}
