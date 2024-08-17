import AUnit
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

@available(iOS 15.0, macOS 12.0, *)
private struct Example: View {
    @State private var showFSContent = false
    @State private var aValue: AValue? = .location(latitude: 40.16415, longitude: 116.44354)

    var body: some View {
        Button(aValue?.description ?? "nil") {
            showFSContent.toggle()
        }
        #if os(iOS)
        .fullScreenCover(isPresented: $showFSContent) {
            NavigationView {
                AValueFSContent(value: $aValue, type: aValue?.type ?? .number, allowInput: true, name: "Hello", unit: .constant(.knots))
                    .toolbar {
                        ToolbarItemGroup {
                            Button("Done") {
                                showFSContent.toggle()
                            }
                        }
                    }
            }
        }
        #endif
    }
}

@available(iOS 15.0, macOS 12.0, *)
#Preview {
    Example()
}
