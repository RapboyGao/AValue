import SwiftUI

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct CursorView: View {
    @State private var isVisible: Bool = true

    public var body: some View {
        Rectangle()
            .fill(Color.blue)
            .frame(width: 2, height: 20)
            .opacity(isVisible ? 1 : 0)
            .animation(Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: isVisible)
            .onAppear {
                isVisible.toggle()
            }
    }

    public init() {}
}
