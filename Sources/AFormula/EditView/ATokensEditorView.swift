import CommonViews
import SwiftUI

@available(iOS 16, macOS 13, tvOS 16, watchOS 9, *)
public struct ATokensEditorView: View {
    @State private var status: ATokenEditStatus = .init(formula: (20 + 50 / 40) * 30)

    @State private var cursorOffset: CGSize = .zero
    @State private var isCursorVisible: Bool = true

    private func renderToken(token: AToken) -> some View {
        Text(token.toString(rows: [:], functions: [:]))
            .foregroundStyle(token.content.colorForLightTheme())
            .onTapGesture {
                status.setCursor(toAfter: token)
            }
    }

    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                cursorOffset = value.translation
            }
            .onEnded { _ in
                cursorOffset = .zero
            }
    }

    public var body: some View {
        WrappingStack {
            ForEach(status.tokensBeforeCursor) { token in
                renderToken(token: token)
            }

            Rectangle()
                .fill(Color.blue)
                .highPriorityGesture(dragGesture)
                .frame(width: 2, height: 20)
                .opacity(isCursorVisible ? 1 : 0)
                .animation(Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: isCursorVisible)
                .offset(cursorOffset)

            ForEach(status.tokensAfterCursor) { token in
                renderToken(token: token)
            }
        }
        .onAppear {
            isCursorVisible.toggle()
        }
    }
}

@available(iOS 16, macOS 13, tvOS 16, watchOS 9, *)
#Preview {
    ATokensEditorView()
}
