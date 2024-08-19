import AUnit
import AViewUI
import SwiftUI

@available(iOS 15.0, macOS 12.0, *)
public struct AValueFSContent: View {
    @Binding var value: AValue?
    var type: AValueType
    var allowInput: Bool
    var name: String

    @Binding var unit: AUnit?
    var originalUnit: AUnit?

    public var body: some View {
        switch type {
        case .number:
            ANumberFSContent(aValue: $value, name: name, allowSet: allowInput)
        case .point:
            ProgressView()
        case .location:
            AMapPointSelector($value, name: name, other: [])
                .ignoresSafeArea()
        case .boolean:
            ProgressView()
        case .string:
            ProgressView()
        case .groundWind:
            ProgressView()
        case .minutes:
            ProgressView()
        case .calendar:
            ADateFSContent(value: $value, name: name, allowSet: allowInput)
        case .dateDifference:
            ProgressView()
        }
    }

    public init(value: Binding<AValue?>, type: AValueType, allowInput: Bool, name: String, unit: Binding<AUnit?>, originalUnit: AUnit? = nil) {
        self._value = value
        self.type = type
        self.allowInput = allowInput
        self.name = name
        self._unit = unit
        self.originalUnit = originalUnit
    }
}

@available(iOS 16.0, macOS 13.0, *)
private struct Example: View {
    @State private var showFSContent = false
    @State private var aValue: AValue? = .location(latitude: 40.16415, longitude: 116.44354)

    var body: some View {
        ASheetButton(type: .fullScreenCover, .button) {
            Text(aValue?.description ?? "nil")
        } cover: {
            AValueFSContent(value: $aValue, type: aValue?.type ?? .number, allowInput: true, name: "Hello", unit: .constant(.knots))
        }
    }
}

@available(iOS 16.0, macOS 13.0, *)
#Preview {
    Example()
}
