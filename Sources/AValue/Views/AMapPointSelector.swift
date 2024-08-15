import CoreLocation
import Foundation
import MapKit
import SwiftUI

#if os(iOS)

// MARK: - iOS

@available(iOS 13.0, *)
struct AMapPointSelector: UIViewRepresentable {
    @Binding var selectedCoordinate: CLLocationCoordinate2D?
    var name: String
    var auxiliaryPoints: [ALocation] // Add auxiliary points

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.mapType = .hybrid
        mapView.showsScale = true
        mapView.delegate = context.coordinator

        // Enable showing the user's location
        mapView.showsUserLocation = true

        let longPressGesture = UILongPressGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleLongPress))
        mapView.addGestureRecognizer(longPressGesture)

        if let coordinate = selectedCoordinate {
            centerMap(on: coordinate, mapView: mapView, animated: false)
            addAnnotation(at: coordinate, on: mapView, title: name)
        }

        // Add auxiliary points
        addAuxiliaryPoints(on: mapView)

        return mapView
    }

    func updateUIView(_ mapView: MKMapView, context: Context) {
        if let coordinate = selectedCoordinate {
            // Center the map on the new selected coordinate with animation
            centerMap(on: coordinate, mapView: mapView, animated: true)
            addAnnotation(at: coordinate, on: mapView, title: name)
        }

        // Add auxiliary points
        addAuxiliaryPoints(on: mapView)
    }

    private func addAnnotation(at coordinate: CLLocationCoordinate2D, on mapView: MKMapView, title: String) {
        // Clear existing annotations before adding a new one
        mapView.removeAnnotations(mapView.annotations.filter { $0.title == title })

        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate

        annotation.title = title
        mapView.addAnnotation(annotation)
    }

    private func addAuxiliaryPoints(on mapView: MKMapView) {
        mapView.removeAnnotations(mapView.annotations.filter { $0.title != name }) // Keep main annotation

        for point in auxiliaryPoints {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude)
            annotation.title = point.name
            mapView.addAnnotation(annotation)
        }
    }
}
#else

// MARK: - MacOS

@available(macOS 11, *)
struct AMapPointSelector: NSViewRepresentable {
    @Binding var selectedCoordinate: CLLocationCoordinate2D?
    var name: String
    var auxiliaryPoints: [ALocation] // Add auxiliary points

    func makeNSView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.mapType = .hybrid
        mapView.showsScale = true
        mapView.delegate = context.coordinator

        // Enable showing the user's location
        mapView.showsUserLocation = true

        let clickGesture = NSClickGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleClick))
        mapView.addGestureRecognizer(clickGesture)

        if let coordinate = selectedCoordinate {
            centerMap(on: coordinate, mapView: mapView, animated: false)
            addAnnotation(at: coordinate, on: mapView, title: name)
        }

        // Add auxiliary points
        addAuxiliaryPoints(on: mapView)

        return mapView
    }

    func updateNSView(_ mapView: MKMapView, context: Context) {
        if let coordinate = selectedCoordinate {
            // Center the map on the new selected coordinate with animation
            centerMap(on: coordinate, mapView: mapView, animated: true)
            addAnnotation(at: coordinate, on: mapView, title: name)
        }

        // Add auxiliary points
        addAuxiliaryPoints(on: mapView)
    }

    private func addAnnotation(at coordinate: CLLocationCoordinate2D, on mapView: MKMapView, title: String) {
        // Clear existing annotations before adding a new one
        mapView.removeAnnotations(mapView.annotations.filter { $0.title == title })

        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title
        mapView.addAnnotation(annotation)
    }

    private func addAuxiliaryPoints(on mapView: MKMapView) {
        mapView.removeAnnotations(mapView.annotations.filter { $0.title != name }) // Keep main annotation

        for point in auxiliaryPoints {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude)
            annotation.title = point.name
            mapView.addAnnotation(annotation)
        }
    }
}
#endif

// MARK: - Shared MapView Functions

@available(iOS 13.0, macOS 11, *)
extension AMapPointSelector {
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    private func centerMap(on coordinate: CLLocationCoordinate2D, mapView: MKMapView, animated: Bool) {
        var region = mapView.region
        region.center = coordinate
        mapView.setRegion(region, animated: animated)
    }

    fileprivate func updateMapView(_ mapView: MKMapView) {
        // This function is no longer needed as its functionality is handled in updateUIView/updateNSView
    }
}

// MARK: - Coordinator

@available(iOS 13.0, macOS 11, *)
extension AMapPointSelector {
    @available(macOS 11.0, *)
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: AMapPointSelector

        init(_ parent: AMapPointSelector) {
            self.parent = parent
        }

        #if os(iOS)
        @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
            if gesture.state == .began {
                let location = gesture.location(in: gesture.view)
                if let mapView = gesture.view as? MKMapView {
                    let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
                    parent.selectedCoordinate = coordinate
                }
            }
        }
        #else
        @objc func handleClick(gesture: NSClickGestureRecognizer) {
            let location = gesture.location(in: gesture.view)
            if let mapView = gesture.view as? MKMapView {
                let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
                parent.selectedCoordinate = coordinate
            }
        }
        #endif

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard !(annotation is MKUserLocation) else {
                return nil
            }

            let identifier = "SelectedLocation"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView

            if annotationView == nil {
                annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
            } else {
                annotationView?.annotation = annotation
            }

            // Customize the marker appearance
            if annotation.title == parent.name {
                annotationView?.markerTintColor = .systemBlue
            } else {
                annotationView?.markerTintColor = .gray // Gray color for auxiliary points
            }
            annotationView?.titleVisibility = .visible

            return annotationView
        }
    }
}

// MARK: - Example View

@available(iOS 14.0, macOS 11.0, *)
private struct Example: View {
    @State private var selectedCoordinate: CLLocationCoordinate2D? = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194) // Example initial location (San Francisco)
    private let locationName = "My Selected Location" // Define a location name

    var body: some View {
        AMapPointSelector(selectedCoordinate: $selectedCoordinate, name: locationName, auxiliaryPoints: .examples)
            .ignoresSafeArea()
    }
}

@available(iOS 14.0, macOS 11.0, *)
#Preview {
    Example()
}
