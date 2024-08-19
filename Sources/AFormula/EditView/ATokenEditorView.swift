import CommonViews
import SwiftUI

@available(iOS 16, macOS 13, tvOS 16, watchOS 9, *)
public struct ATokenEditorView: View {
    @State private var status: ATokenEditStatus = .init(formula: (20 + 50) * 30)
    @State private var dragLocation: CGPoint = .zero

    public var body: some View {
        WrappingStack {
            ForEach(status.tokensBeforeCursor) { token in
                Text(token.toString(rows: [:], functions: [:]))
            }

            // Cursor View
            CursorView()

            ForEach(status.tokensAfterCursor) { token in
                Text(token.toString(rows: [:], functions: [:]))
            }
        }
    }
}

@available(iOS 16, macOS 13, tvOS 16, watchOS 9, *)
#Preview {
    ATokenEditorView()
}

//public struct ATokenEditStatus: Hashable, Sendable, Codable {
//    var tokensBeforeCursor: [AToken]
//    var tokensAfterCursor: [AToken]
//
//    var cursorPosition: Int {
//        get {
//            tokensBeforeCursor.count
//        }
//        set {
//            // 确保 newValue 在有效范围内
//            let totalTokens = tokensBeforeCursor + tokensAfterCursor
//            let validNewValue = min(max(newValue, 0), totalTokens.count)
//
//            let newTokensBeforeCursor = Array(totalTokens.prefix(validNewValue))
//            let newTokensAfterCursor = Array(totalTokens.dropFirst(validNewValue))
//
//            tokensBeforeCursor = newTokensBeforeCursor
//            tokensAfterCursor = newTokensAfterCursor
//        }
//    }
//
//    public init(formula: AFormula) {
//        tokensBeforeCursor = formula.toTokens()
//        tokensAfterCursor = []
//    }
//}
