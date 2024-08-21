import AValue
import AViewUI
import SwiftUI

@available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
public struct ATokenManipulationContentView: View {
    @Binding var status: ATokenEditStatus

    private let viewSize = (width: 50.0, height: 50.0, fontSize: 20.0)

    public var body: some View {
        AKeyButton(cornerRadius: 4) {
            status.tryMoveLeft()
        } content: {
            Image(systemName: "chevron.left")
                .font(.system(size: viewSize.fontSize))
        }
        .frame(width: viewSize.width, height: viewSize.height)

        AKeyButton(cornerRadius: 4) {
            status.tryDeleteLeft()
        } content: {
            Image(systemName: "delete.left")
                .font(.system(size: viewSize.fontSize))
        }
        .frame(width: viewSize.width, height: viewSize.height)

        AKeyButton(cornerRadius: 4) {
            status.tryDeleteRight()
        } content: {
            Image(systemName: "delete.right")
                .font(.system(size: viewSize.fontSize))
        }
        .frame(width: viewSize.width, height: viewSize.height)

        AKeyButton(cornerRadius: 4) {
            status.tryMoveRight()
        } content: {
            Image(systemName: "chevron.right")
                .font(.system(size: viewSize.fontSize))
        }
        .frame(width: viewSize.width, height: viewSize.height)
    }
}
