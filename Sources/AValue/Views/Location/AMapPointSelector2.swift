import MapKit
import SwiftUI

// 支持在地图上长按某个位置以选择该位置
// 选择后，该位置的annotation为蓝色，同时会利用ALatitudeFormat和ALongitudeFormat显示经纬度
// 如果用户拖拽地图，会更新region，注意不要导致region再通过updateUIView设置否则会导致死循环

#if os(iOS)
import UIKit

@available(iOS 13.0, *)
public struct AMapPointSelector2: UIViewRepresentable {
    @Binding var selectedCoordinate: CLLocationCoordinate2D?
    @Binding var region: MKCoordinateRegion?
    var name: String
    var auxiliaryPoints: [ALocation] // Add auxiliary points
}

#elseif os(macOS)

import AppKit

public struct AMapPointSelector2: NSViewRepresentable {
    @Binding var selectedCoordinate: CLLocationCoordinate2D?
    @Binding var region: MKCoordinateRegion?
    var name: String
    var auxiliaryPoints: [ALocation] // Add auxiliary points
}

#endif
