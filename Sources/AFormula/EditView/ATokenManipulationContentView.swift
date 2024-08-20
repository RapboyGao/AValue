import AValue
import AViewUI
import SwiftUI

@available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
public struct ATokenManipulationContentView: View {
    @Binding var status: ATokenEditStatus

    public var body: some View {
        AKeyButton(cornerRadius: 4) {
            status.tryMoveLeft()
        } content: {
            Image(systemName: "chevron.left")
                .font(.system(size: 15))
        }
        .frame(width: 30, height: 30)

        AKeyButton(cornerRadius: 4) {
            status.tryMoveRight()
        } content: {
            Image(systemName: "chevron.right")
                .font(.system(size: 15))
        }
        .frame(width: 30, height: 30)

        AKeyButton(cornerRadius: 4) {
            status.tryDeleteLeft()
        } content: {
            Image(systemName: "delete.left")
                .font(.system(size: 15))
        }
        .frame(width: 30, height: 30)

        AKeyButton(cornerRadius: 4) {
            status.tryDeleteRight()
        } content: {
            Image(systemName: "delete.right")
                .font(.system(size: 15))
        }
        .frame(width: 30, height: 30)
    }
}
