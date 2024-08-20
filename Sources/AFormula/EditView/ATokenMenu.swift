import AViewUI
import SwiftUI

@available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
public struct ATokenMenu: View {
    @Binding var token: AToken

    var handleDelete: () -> Void
    var cursorToLeft: () -> Void
    var cursorToRight: () -> Void

    public var body: some View {
        Menu {
            Text(token.toString(rows: [:], functions: [:]))
            Button("Delete", systemImage: "trash", role: .destructive, action: handleDelete)
        } label: {
            Text(token.toString(rows: [:], functions: [:]))
                .foregroundStyle(token.colorForLightTheme())
        }
    }

    public init(_ token: Binding<AToken>, handleDelete: @escaping () -> Void, cursorToLeft: @escaping () -> Void, cursorToRight: @escaping () -> Void) {
        self._token = token
        self.handleDelete = handleDelete
        self.cursorToLeft = cursorToLeft
        self.cursorToRight = cursorToRight
    }
}
