import CoreLocation
import SwiftUI

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public struct ALocationFSContent: View {
    @Binding var selectedCoordinate: CLLocationCoordinate2D?
    var allowSet: Bool
    var name: String
    var auxiliaryPoints: [ALocation] // Add auxiliary points

    @Namespace private var namespace
    @State var showInputPage = true

    public var body: some View {
        Group {
            if showInputPage {
                List {
                    ACoordinateInputSection($selectedCoordinate, allowSet: allowSet, name: name)
                    Section(I18n.map) {
                        AMapPointSelector($selectedCoordinate, name: name, other: auxiliaryPoints)
                            .matchedGeometryEffect(id: 1, in: namespace)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .frame(idealHeight: 450)
                            .padding(.vertical)
                            .onTapGesture {
                                withAnimation {
                                    showInputPage.toggle()
                                }
                            }
                    }
                }
            } else {
                AMapPointSelector($selectedCoordinate, name: name, other: auxiliaryPoints)
                    .matchedGeometryEffect(id: 1, in: namespace)
                    .ignoresSafeArea()
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .status) {
                if !showInputPage {
                    ACoordinatesMenu(selectedCoordinate)
                }
            }
            ToolbarItemGroup(placement: .topBarLeading) {
                Button {
                    withAnimation {
                        showInputPage.toggle()
                    }
                } label: {
                    if showInputPage {
                        Image(systemName: "map")
                            .matchedGeometryEffect(id: 2, in: namespace)
                    } else {
                        Image(systemName: "slider.horizontal.3")
                            .matchedGeometryEffect(id: 2, in: namespace)
                            .padding(5)
                            .background {
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(.thinMaterial)
                            }
                    }
                }
            }
        }
    }

    public init(_ bindCoordinate: Binding<CLLocationCoordinate2D?>, allowSet: Bool, name: String, other auxiliaryPoints: [ALocation]) {
        self._selectedCoordinate = bindCoordinate
        self.allowSet = allowSet
        self.name = name
        self.auxiliaryPoints = auxiliaryPoints
    }

    public init(_ bindValue: Binding<AValue?>, allowSet: Bool, name: String, other auxiliaryPoints: [ALocation]) {
        self._selectedCoordinate = bindValue.locationValue()
        self.allowSet = allowSet
        self.name = name
        self.auxiliaryPoints = auxiliaryPoints
    }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
private struct Example: View {
    @State var value: AValue? = .location(latitude: 35.12456, longitude: 117.12646)

    var body: some View {
        NavigationStack {
            ALocationFSContent($value, allowSet: true, name: "Location", other: .examples)
        }
    }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
#Preview {
    Example()
}
