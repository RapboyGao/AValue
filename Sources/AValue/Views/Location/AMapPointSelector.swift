import CoreLocation
import Foundation
import MapKit
import SwiftUI

#if os(iOS)

// MARK: - iOS

/// AMapPointSelector 是一个用于选择地图点的视图组件
@available(iOS 13.0, *)
public struct AMapPointSelector: UIViewRepresentable {
    /// 选中的坐标
    @Binding var selectedCoordinate: CLLocationCoordinate2D?
    /// 选中点的名称
    var name: String
    /// 辅助点数组
    var auxiliaryPoints: [ALocation]

    /// 创建并配置 MKMapView
    public func makeUIView(context: Context) -> MKMapView {
        // 创建并配置 MKMapView
        let mapView = setupMapView(context: context)
        if let coordinate = selectedCoordinate {
            // 如果有选中的坐标，则将地图中心移动到该坐标
            centerMap(on: coordinate, mapView: mapView, animated: false)
            // 添加选中的坐标的标注
            addAnnotation(at: coordinate, on: mapView, title: name)
        }
        // 添加辅助点的标注
        addAuxiliaryPoints(on: mapView)
        return mapView
    }

    /// 更新 MKMapView
    public func updateUIView(_ mapView: MKMapView, context: Context) {
        if let coordinate = selectedCoordinate {
            // 如果有选中的坐标，则将地图中心移动到该坐标
            centerMap(on: coordinate, mapView: mapView, animated: true)
            // 添加选中的坐标的标注
            addAnnotation(at: coordinate, on: mapView, title: name)
        }
        if context.coordinator.currentAuxiliaryPoints != auxiliaryPoints {
            addAuxiliaryPoints(on: mapView)
            context.coordinator.currentAuxiliaryPoints = auxiliaryPoints
        }
    }

    /// 配置 MKMapView
    private func setupMapView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.mapType = .hybrid
        mapView.showsScale = true
        mapView.showsUserLocation = true
        mapView.delegate = context.coordinator
        // 添加长按手势识别器
        let longPressGesture = UILongPressGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleLongPress))
        mapView.addGestureRecognizer(longPressGesture)
        return mapView
    }

    /// 添加标注
    private func addAnnotation(at coordinate: CLLocationCoordinate2D, on mapView: MKMapView, title: String) {
        // 移除已有的同名标注
        mapView.removeAnnotations(mapView.annotations.filter { $0.title == title })
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title
        mapView.addAnnotation(annotation)
    }

    /// 添加辅助点的标注
    private func addAuxiliaryPoints(on mapView: MKMapView) {
        // 移除所有非主标注的标注
        mapView.removeAnnotations(mapView.annotations.filter { $0.title != name })
        for point in auxiliaryPoints {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude)
            annotation.title = point.name
            mapView.addAnnotation(annotation)
        }
    }
}

#elseif os(macOS)

// MARK: - MacOS

/// AMapPointSelector 是一个用于选择地图点的视图组件
@available(macOS 11, *)
public struct AMapPointSelector: NSViewRepresentable {
    /// 选中的坐标
    @Binding var selectedCoordinate: CLLocationCoordinate2D?
    /// 选中点的名称
    var name: String
    /// 辅助点数组
    var auxiliaryPoints: [ALocation]

    /// 创建并配置 MKMapView
    public func makeNSView(context: Context) -> MKMapView {
        // 创建并配置 MKMapView
        let mapView = setupMapView(context: context)
        if let coordinate = selectedCoordinate {
            // 如果有选中的坐标，则将地图中心移动到该坐标
            centerMap(on: coordinate, mapView: mapView, animated: false)
            // 添加选中的坐标的标注
            addAnnotation(at: coordinate, on: mapView, title: name)
        }
        // 添加辅助点的标注
        addAuxiliaryPoints(on: mapView)
        return mapView
    }

    /// 更新 MKMapView
    public func updateNSView(_ mapView: MKMapView, context: Context) {
        if let coordinate = selectedCoordinate {
            // 如果有选中的坐标，则将地图中心移动到该坐标
            centerMap(on: coordinate, mapView: mapView, animated: true)
            // 添加选中的坐标的标注
            addAnnotation(at: coordinate, on: mapView, title: name)
        }
        if context.coordinator.currentAuxiliaryPoints != auxiliaryPoints {
            addAuxiliaryPoints(on: mapView)
            context.coordinator.currentAuxiliaryPoints = auxiliaryPoints
        }
    }

    /// 配置 MKMapView
    private func setupMapView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.mapType = .hybrid
        mapView.showsScale = true
        mapView.showsUserLocation = true
        mapView.delegate = context.coordinator
        // 添加点击手势识别器
        let clickGesture = NSClickGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleClick))
        mapView.addGestureRecognizer(clickGesture)
        return mapView
    }

    /// 添加标注
    private func addAnnotation(at coordinate: CLLocationCoordinate2D, on mapView: MKMapView, title: String) {
        // 移除已有的同名标注
        mapView.removeAnnotations(mapView.annotations.filter { $0.title == title })
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title
        mapView.addAnnotation(annotation)
    }

    /// 添加辅助点的标注
    private func addAuxiliaryPoints(on mapView: MKMapView) {
        // 移除所有非主标注的标注
        mapView.removeAnnotations(mapView.annotations.filter { $0.title != name })
        for point in auxiliaryPoints {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude)
            annotation.title = point.name
            mapView.addAnnotation(annotation)
        }
    }
}
#endif

#if os(iOS) || os(macOS)

// MARK: - Shared MapView Functions

@available(iOS 13.0, macOS 11, *)
extension AMapPointSelector {
    public func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    /// 将地图中心移动到指定坐标
    private func centerMap(on coordinate: CLLocationCoordinate2D, mapView: MKMapView, animated: Bool) {
        var region = mapView.region
        region.center = coordinate
        region.span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        mapView.setRegion(region, animated: animated)
    }
}

// MARK: - Initializer

@available(iOS 14.0, macOS 11.0, *)
public extension AMapPointSelector {
    init(_ bindCoordinate: Binding<CLLocationCoordinate2D?>, name: String, other auxiliaryPoints: [ALocation]) {
        self._selectedCoordinate = bindCoordinate
        self.name = name
        self.auxiliaryPoints = auxiliaryPoints
    }

    init(_ bindValue: Binding<AValue?>, name: String, other auxiliaryPoints: [ALocation]) {
        self._selectedCoordinate = bindValue.locationValue()
        self.name = name
        self.auxiliaryPoints = auxiliaryPoints
    }
}

// MARK: - Coordinator

@available(iOS 13.0, macOS 11, *)
public extension AMapPointSelector {
    @available(macOS 11.0, *)
    class Coordinator: NSObject, MKMapViewDelegate {
        public var parent: AMapPointSelector
        public var currentAuxiliaryPoints: [ALocation]

        public init(_ parent: AMapPointSelector) {
            self.parent = parent
            self.currentAuxiliaryPoints = parent.auxiliaryPoints
        }

        #if os(iOS)
        /// 处理长按手势
        @objc public func handleLongPress(gesture: UILongPressGestureRecognizer) {
            if gesture.state == .began {
                let location = gesture.location(in: gesture.view)
                if let mapView = gesture.view as? MKMapView {
                    let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
                    parent.selectedCoordinate = coordinate
                }
            }
        }
        #else
        /// 处理点击手势
        @objc public func handleClick(gesture: NSClickGestureRecognizer) {
            let location = gesture.location(in: gesture.view)
            if let mapView = gesture.view as? MKMapView {
                let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
                parent.selectedCoordinate = coordinate
            }
        }
        #endif

        /// 配置标注视图
        public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
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

            if annotation.title == parent.name {
                annotationView?.markerTintColor = .systemBlue
            } else {
                annotationView?.markerTintColor = .gray
            }
            annotationView?.titleVisibility = .visible

            return annotationView
        }
    }
}

// MARK: - Example View

@available(iOS 14.0, macOS 11.0, *)
private struct Example: View {
    @State private var selectedCoordinate: CLLocationCoordinate2D? = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
    private let locationName = "Location"

    var body: some View {
        AMapPointSelector($selectedCoordinate, name: locationName, other: .examples)
            .ignoresSafeArea()
    }
}

@available(iOS 14.0, macOS 11.0, *)
#Preview {
    Example()
}

#endif
