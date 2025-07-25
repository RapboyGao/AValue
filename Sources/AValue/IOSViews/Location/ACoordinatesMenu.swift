import CoreLocation
import SwiftUI

private func formatCoordinate(_ location: CLLocationCoordinate2D, format: ACoordinateFormat) -> String {
    let latitude = ALatitude(location.latitude)
    let longitude = ALongitude(location.longitude)
    return latitude.toFormat(format).description + longitude.toFormat(format).description
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 10.0, *)
public struct ACoordinatesMenu: View {
    var location: CLLocationCoordinate2D?
    @State var format: ACoordinateFormat = .degreesM

    public var body: some View {
        if let location = location {
            Menu {
                ForEach(ACoordinateFormat.allCases, id: \.self) { format in
                    Button(formatCoordinate(location, format: format)) {
                        self.format = format
                    }
                }
            } label: {
                Label(formatCoordinate(location, format: format), systemImage: "mappin.and.ellipse")
                    .labelStyle(.titleAndIcon)
            }
            .background {
                RoundedRectangle(cornerRadius: 5)
                    .fill(.thinMaterial)
            }
        }
    }

    public init(_ location: CLLocationCoordinate2D?) {
        self.location = location
    }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
private struct Example: View {
    @State private var location: CLLocationCoordinate2D? = .init(latitude: 39, longitude: 116)
    var body: some View {
        NavigationStack {
            AMapPointSelector(selectedCoordinate: $location, name: "Location", auxiliaryPoints: .examples)
                .ignoresSafeArea()
                .toolbar {
                    ToolbarItemGroup(placement: .status) {
                        ACoordinatesMenu(location)
                    }
                }
        }
    }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
#Preview {
    Example()
}
