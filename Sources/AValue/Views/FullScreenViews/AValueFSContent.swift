import AUnit
import SwiftUI

@available(iOS 15.0, macOS 12.0, *)
public struct AValueFSContent: View {
    @Binding var value: AValue?
    var type: AValueType
    var allowInput: Bool
    var name: String

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
}

@available(iOS 15.0, macOS 12.0, *)
private struct Example: View {
    @State private var showFSContent = false
    @State private var aValue: AValue? = .minutes(356)

    var body: some View {
        Button(aValue?.description ?? "nil") {
            showFSContent.toggle()
        }
        .fullScreenCover(isPresented: $showFSContent) {
            NavigationView {
                AValueFSContent(value: $aValue, type: aValue?.type ?? .number, allowInput: true, name: "Hello")
                    .toolbar {
                        ToolbarItemGroup {
                            Button("Done") {
                                showFSContent.toggle()
                            }
                        }
                    }
            }
        }
    }
}

@available(iOS 15.0, macOS 12.0, *)
#Preview {
    Example()
}
