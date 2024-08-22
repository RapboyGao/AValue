import AValue
import AViewUI
import SwiftUI

private let keys = Array(0 ... 9).map { "\($0)" } + ["."]

@available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
public struct ATokenNumberInputKeyboardContent: View {
    @Binding var status: ATokenEditStatus

    public var body: some View {
        ForEach(keys, id: \.self) { keyName in
            AKeyButtonWithZoom(cornerRadius: 4) {
                status.numberInputString += "\(keyName)"
            } content: {
                Text("\(keyName)")
            }
        }
    }
}
