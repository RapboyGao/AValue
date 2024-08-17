import SwiftUI

/// 只能复制着用
@available(iOS 16, macOS 13, tvOS 16, watchOS 9, *)
struct WrappingStackLayout: Layout {
    /// 行距
    var vSpacing: CGFloat
    /// 每个subView之间的水平间隔
    var hSpacing: CGFloat
    /// 是否从右到左排列
    var rightToLeft: Bool

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache _: inout ()) -> CGSize {
        guard let proposalWidth = proposal.width
        else { return .zero }
        /// 计算结果，本Stack的宽和高
        var res = CGSize(width: proposalWidth, height: 0)

        /// 当前行的已占用宽度
        var widthThisRow = 0.0

        /// 当前行的最高的高度
        var maxHeightThisRow = 0.0

        /// 总共多少行
        var rowsCount = 0.0

        for subview in subviews {
            /// 当前的subview的默认尺寸
            let size = subview.sizeThatFits(.unspecified)
            /// 增加当前行的水平宽度
            widthThisRow += size.width + hSpacing
            /// 增加
            if widthThisRow > proposalWidth { // 宽度超过外框，换行
                res.height += maxHeightThisRow // 换行的时候加入之前行的高度
                widthThisRow = size.width + hSpacing // 换行后将当前subView算入新行的宽度
                maxHeightThisRow = 0
                rowsCount += 1
            }
            maxHeightThisRow = max(maxHeightThisRow, size.height)
        }
        res.height += maxHeightThisRow
        res.height += rowsCount * vSpacing
        return res
    }

    func placeSubviews(in bounds: CGRect, proposal _: ProposedViewSize, subviews: Subviews, cache _: inout ()) {
        var position = CGPoint(x: rightToLeft ? bounds.maxX : bounds.minX, y: bounds.minY)
        /// 当前行最高的东西的高度
        var maxHeightThisRow = 0.0
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            maxHeightThisRow = max(size.height, maxHeightThisRow)
            if rightToLeft {
                // 从右到左反着排序
                position.x -= size.width // position的左边应该是subview的左边
                if position.x < bounds.minX { // 如果算上width比minX还小
                    position.x = bounds.maxX - size.width // 下一行，留出width位置
                    position.y += maxHeightThisRow + vSpacing // 垂直位置向下一行
                }
                subview.place(at: position, proposal: .unspecified) // 安排subView位置
                position.x -= hSpacing // 向左留出hSpacing位置
            } else {
                // 正常从左到右的顺序
                if position.x + size.width > bounds.maxX {
                    // 如果发现当前(位置 + 宽度)会超出范围，则换行
                    position.x = bounds.minX // 从最左侧开始
                    position.y += maxHeightThisRow + vSpacing // 向下留出上一行的高度，外加vSpacing
                }
                subview.place(at: position, proposal: .unspecified) // 安排subView位置
                position.x += size.width + hSpacing // 安排下一次的position
            }
        }
    }
}

@available(iOS 16, macOS 13, tvOS 16, watchOS 9, *)
public struct WrappingStack<Content: View>: View {
    /// 行距
    public var vSpacing: CGFloat
    /// 每个subView之间的水平间隔
    public var hSpacing: CGFloat
    /// 是否从右到左排列
    public var rightToLeft = false

    public var content: () -> Content

    public var body: some View {
        WrappingStackLayout(vSpacing: vSpacing, hSpacing: hSpacing, rightToLeft: rightToLeft) {
            content()
        }
    }

    public init(vSpacing: CGFloat = 0, hSpacing: CGFloat = 0, rightToLeft: Bool = false, @ViewBuilder content: @escaping () -> Content) {
        self.vSpacing = vSpacing
        self.hSpacing = hSpacing
        self.rightToLeft = rightToLeft
        self.content = content
    }
}
