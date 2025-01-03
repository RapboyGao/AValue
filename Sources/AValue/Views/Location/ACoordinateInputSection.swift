import CoreLocation
import SwiftUI

#if os(iOS)

@available(iOS 16, *)
public struct ACoordinateInputSection: View {
    @Binding var value: CLLocationCoordinate2D?
    var allowSet: Bool
    var name: String

    @State private var thisLatitude: Double?
    @State private var thisLongitude: Double?

    @FocusState private var focusOnLatitude: Bool
    @FocusState private var focusOnLongitude: Bool

    private var bindLatitude: Binding<Double?> {
        Binding {
            value?.latitude ?? thisLatitude
        } set: { newValue in
            thisLatitude = newValue
            guard let thisLongitude = thisLongitude // 如果也有经度
            else { return }
            if let latitude = thisLatitude, value == nil {
                self.value = .init(latitude: latitude, longitude: thisLongitude)
            } else if let someNewValue = newValue {
                value?.latitude = someNewValue
            }
        }
    }

    private var bindLongitude: Binding<Double?> {
        Binding {
            value?.longitude ?? thisLongitude
        } set: { newValue in
            thisLongitude = newValue
            guard let thisLatitude = thisLatitude // 如果也有纬度
            else { return }
            if let longitude = thisLongitude, value == nil {
                self.value = .init(latitude: thisLatitude, longitude: longitude)
            } else if let someNewValue = newValue {
                value?.longitude = someNewValue
            }
        }
    }

    public var body: some View {
        Section(I18n.coordinates) {
            HStack {
                Text(I18n.latitude)
                ALatitudeTextfield(bindLatitude, allowSet: allowSet, placeholder: I18n.latitude, format: .degreesM)
                    .focused($focusOnLatitude)
            }
            HStack {
                Text(I18n.longitude)
                ALongitudeTextfield(bindLongitude, allowSet: allowSet, placeholder: I18n.longitude, format: .degreesM)
                    .focused($focusOnLongitude)
            }
        }
    }

    public init(_ value: Binding<CLLocationCoordinate2D?>, allowSet: Bool, name: String) {
        self._value = value
        self.allowSet = allowSet
        self.name = name
        if let location = value.wrappedValue {
            self._thisLatitude = State(initialValue: location.latitude)
            self._thisLongitude = State(initialValue: location.longitude)
        }
    }

    public init(_ value: Binding<AValue?>, allowSet: Bool, name: String) {
        self._value = value.locationValue()
        self.allowSet = allowSet
        self.name = name
        if case let .location(latitude, longitude) = value.wrappedValue {
            self._thisLatitude = State(initialValue: latitude)
            self._thisLongitude = State(initialValue: longitude)
        }
    }

    public init(_ value: Binding<AValue?>, allowSet: Bool, name: String, format: ACoordinateFormat) {
        self._value = value.locationValue()
        self.allowSet = allowSet
        self.name = name
        if case let .location(latitude, longitude) = value.wrappedValue {
            self._thisLatitude = State(initialValue: latitude)
            self._thisLongitude = State(initialValue: longitude)
        }
    }
}

@available(iOS 16, *)

private struct Example: View {
    @State var value: AValue?
    var body: some View {
        List {
            ACoordinateInputSection($value, allowSet: true, name: "Location")
            Section(I18n.map) {
                AMapPointSelector($value, name: "Location", other: .examples)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .frame(minHeight: 400)
                    .padding(.vertical)
            }
        }
    }
}

@available(iOS 16, *)
#Preview {
    Example()
}

#endif
