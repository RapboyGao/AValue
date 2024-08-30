import AValue
import AViewUI
import SwiftUI

@available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
public struct ATokenManipulationContentView: View {
    @Binding var status: ATokenEditStatus

    public var body: some View {
        AKeyButton(cornerRadius: 4, sound: 1155) {
            status.tryDeleteLeft()
        } content: {
            Image(systemName: "delete.left")
        }

        AKeyButton(cornerRadius: 4, sound: 1155) {
            status.tryDeleteRight()
        } content: {
            Image(systemName: "delete.right")
        }
        AKeyButtonWithZoom(cornerRadius: 4) {
            status.tryMoveLeft()
        } content: {
            Image(systemName: "arrowtriangle.backward")
        }

        AKeyButtonWithZoom(cornerRadius: 4) {
            status.tryMoveRight()
        } content: {
            Image(systemName: "arrowtriangle.forward")
        }
    }
}
