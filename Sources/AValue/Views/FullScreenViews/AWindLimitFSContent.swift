import AViewUI
import SwiftUI

@available(iOS 16, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct AWindLimitFSContent: View {
    @Binding var value: AWindLimit?
    var allowSet: Bool

    @FocusState private var isFocused
    @Environment(\.dismiss) private var dismiss

    public var body: some View {
        List {
            HStack {
                Text("Headwind")
                Spacer()
                TextField("Headwind", value: .constant(1.0 as Double?), format: .number)
                    .multilineTextAlignment(.trailing)
            }
        }
    }

    public init(_ valueBinding: Binding<AWindLimit?>, allowSet: Bool) {
        self._value = valueBinding
        self.allowSet = allowSet
    }

    public init(aValue valueBinding: Binding<AValue?>, allowSet: Bool) {
        self._value = valueBinding.windLimit()
        self.allowSet = allowSet
    }
}

@available(iOS 16, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
private struct Example: View {
    @State private var aValue: AValue? = 45

    var body: some View {
        AWindLimitFSContent(aValue: $aValue, allowSet: true)
    }
}

@available(iOS 16, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
#Preview {
    Example()
}
