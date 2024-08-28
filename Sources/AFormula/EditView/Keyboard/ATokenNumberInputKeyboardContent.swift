import AValue
import AViewUI
import SwiftUI

private let keys = Array(1 ... 9).map { "\($0)" } + ["0", "."]

@available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
public struct ATokenNumberInputKeyboardContent: View {
    @Binding var status: ATokenEditStatus

    private var foregroundColor: Color {
        status.canInsertNumber ? .primary : .gray
    }

    public var body: some View {
        ForEach(keys, id: \.self) { keyName in
            AKeyButtonWithZoom(cornerRadius: 4) {
                status.numberInputString += "\(keyName)"
            } content: {
                Text("\(keyName)")
                    .foregroundColor(foregroundColor)
            }
            .disabled(!status.canInsertNumber)
        }
    }
}
