import SwiftUI

@available(iOS 16, macOS 13, tvOS 16, watchOS 9, *)
private struct WrappingStackLayout: Layout {
    var vSpacing: CGFloat  // 垂直间距
    var hSpacing: CGFloat  // 水平间距
    var rightToLeft: Bool  // 控制布局方向是否从右到左

    // 计算合适的尺寸以容纳所有子视图
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache _: inout ()) -> CGSize {
        // 确保提案宽度有效，如果无效则使用一个默认值或返回零尺寸
        guard let proposalWidth = proposal.width else { return .zero }
        var res = CGSize(width: proposalWidth, height: 0)  // 初始化结果尺寸，宽度为提案宽度，高度为0

        var widthThisRow = 0.0  // 当前行的宽度
        var maxHeightThisRow = 0.0  // 当前行中最高视图的高度
        var rowsCount = 0.0  // 记录行数

        // 遍历每个子视图以计算布局尺寸
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)  // 获取子视图的尺寸
            if widthThisRow + size.width + hSpacing > proposalWidth {  // 如果当前行的宽度超过了提案宽度
                res.height += maxHeightThisRow  // 增加总高度
                widthThisRow = size.width + hSpacing  // 新行开始，重置当前行宽度
                maxHeightThisRow = size.height  // 重置当前行最高视图的高度
                rowsCount += 1  // 增加行数计数
            } else {
                widthThisRow += size.width + hSpacing  // 累加当前行的宽度，考虑水平间距
                maxHeightThisRow = max(maxHeightThisRow, size.height)  // 更新当前行最高视图的高度
            }
        }
        res.height += maxHeightThisRow  // 增加最后一行的高度
        res.height += rowsCount * vSpacing  // 考虑每行之间的垂直间距
        return res  // 返回计算后的尺寸
    }

    // 将子视图放置在指定的边界内
    func placeSubviews(in bounds: CGRect, proposal _: ProposedViewSize, subviews: Subviews, cache _: inout ()) {
        var position = CGPoint(x: rightToLeft ? bounds.maxX : bounds.minX, y: bounds.minY)  // 初始化放置位置，根据布局方向决定起点
        var maxHeightThisRow = 0.0  // 当前行最高视图的高度

        // 遍历每个子视图以放置它们的位置
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)  // 获取子视图的尺寸
            if rightToLeft {
                if position.x - size.width < bounds.minX {  // 如果位置超出左边界
                    position.x = bounds.maxX - size.width  // 移动到下一行的起始位置
                    position.y += maxHeightThisRow + vSpacing  // 增加y坐标以开始新行
                    maxHeightThisRow = size.height  // 重置当前行最高视图的高度
                } else {
                    maxHeightThisRow = max(size.height, maxHeightThisRow)  // 更新当前行最高视图的高度
                }
                position.x -= size.width  // 向左移动位置
                subview.place(at: position, proposal: .unspecified)  // 放置子视图
                position.x -= hSpacing  // 增加水平间距
            } else {
                if position.x + size.width > bounds.maxX {  // 如果位置超出右边界
                    position.x = bounds.minX  // 移动到下一行的起始位置
                    position.y += maxHeightThisRow + vSpacing  // 增加y坐标以开始新行
                    maxHeightThisRow = size.height  // 重置当前行最高视图的高度
                } else {
                    maxHeightThisRow = max(size.height, maxHeightThisRow)  // 更新当前行最高视图的高度
                }
                subview.place(at: position, proposal: .unspecified)  // 放置子视图
                position.x += size.width + hSpacing  // 增加水平间距
            }
        }
    }
}

// WrappingStack 是一个包装自定义布局的视图结构体
@available(iOS 16, macOS 13, tvOS 16, watchOS 9, *)
public struct WrappingStack<Content: View>: View {
    public var vSpacing: CGFloat  // 垂直间距
    public var hSpacing: CGFloat  // 水平间距
    public var rightToLeft = false  // 控制布局方向是否从右到左

    public var content: () -> Content  // 用于提供子视图的内容闭包

    public var body: some View {
        // 使用自定义布局 WrappingStackLayout 来排列子视图
        WrappingStackLayout(vSpacing: vSpacing, hSpacing: hSpacing, rightToLeft: rightToLeft) {
            content()  // 提供子视图内容
        }
    }

    // 初始化方法，允许配置垂直间距、水平间距和布局方向
    public init(vSpacing: CGFloat = 0, hSpacing: CGFloat = 0, rightToLeft: Bool = false, @ViewBuilder content: @escaping () -> Content) {
        self.vSpacing = vSpacing
        self.hSpacing = hSpacing
        self.rightToLeft = rightToLeft
        self.content = content
    }
}
