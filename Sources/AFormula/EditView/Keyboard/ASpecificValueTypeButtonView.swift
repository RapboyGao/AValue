import AValue
import AViewUI
import SwiftUI

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public struct ASpecificValueTypeButtonView: View {
    @State private var value: AValue?
    var valueType: AValueType
    var handle: (AToken.Content) -> Void

    public var body: some View {
        ASheetButton {
            .init(.fullScreenCover, .button, return: value == nil ? .cancel : .done)
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 4)
                    .foregroundColor(valueType.colorForLightTheme())
                Image(systemName: valueType.symbolName)
                    .symbolRenderingMode(.hierarchical)
                    .foregroundColor(.white)
            }
        } cover: {
            AValueFSContent(value: $value, type: valueType, allowInput: true, name: "New Value", unit: .constant(nil))
        } onSheetClosed: {
            if let value = value {
                handle(.value(value))
            }
            value = nil
        }
    }

    public init(valueType: AValueType, handle: @escaping (AToken.Content) -> Void) {
        self.valueType = valueType
        self.handle = handle
    }
}
