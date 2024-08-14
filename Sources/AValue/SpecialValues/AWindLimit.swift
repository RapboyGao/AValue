import AUnit
import Foundation

// 风限类型的枚举，用于表示不同的风限情况
public enum AWindLimitType: Int, RawRepresentable, Hashable, Sendable, Codable {
    case withinLimit = 0 // 在限值范围内
    case headWind // 顶风
    case tailWind // 顺风
    case crossWind // 侧风
    case totalWind // 总风速
}

// 风限状态结构体，包含风限类型、最大风速限制、风向和跑道方向
public struct AWindLimitStatus: Hashable, Sendable, Codable, Identifiable {
    public var id = Int.random(in: .min ... .max) // 唯一标识符
    public var code: AWindLimitType // 风限类型
    public var limit: Double // 最大风速限制
    public var windDir: AAngle // 风向
    public var runway: AAngle // 跑道方向

    // 计算风向和跑道方向的差值，并调整到 [-180, 180] 的范围内
    public var diff: AAngle {
        (windDir - runway).in180(include180: true)
    }
}

// 风限结构体，封装了与风限相关的数据和方法
public struct AWindLimit: Hashable, Sendable, Codable {
    private var headWindWrapped: Double // 顶风包裹值
    private var tailWindWrapped: Double // 顺风包裹值
    private var crossWindWrapped: Double // 侧风包裹值
    private var totalWindWrapped: Double // 总风速包裹值
    private var runwayHeadingWrapped: AAngle // 跑道方向包裹值

    // 顶风属性，确保值为正
    public var headWind: Double {
        get { headWindWrapped }
        set { headWindWrapped = abs(newValue) }
    }

    // 顺风属性，确保值为正
    public var tailWind: Double {
        get { tailWindWrapped }
        set { tailWindWrapped = abs(newValue) }
    }

    // 侧风属性，确保值为正
    public var crossWind: Double {
        get { crossWindWrapped }
        set { crossWindWrapped = abs(newValue) }
    }

    // 总风速属性，确保值为正
    public var totalWind: Double {
        get { totalWindWrapped }
        set { totalWindWrapped = abs(newValue) }
    }

    // 跑道方向属性，确保值在 [0, 360] 的范围内
    public var runwayHeading: AAngle {
        get { runwayHeadingWrapped }
        set { runwayHeadingWrapped = newValue.in360() }
    }

    // 返回风速中的最大值
    public var maxOfWinds: Double {
        max(headWindWrapped, tailWindWrapped, crossWindWrapped, totalWindWrapped.isFinite ? totalWindWrapped : 0)
    }

    // 判断风速数据是否合法
    public var isValid: Bool {
        guard headWindWrapped.isNormal || headWindWrapped.isZero,
              tailWindWrapped.isNormal || tailWindWrapped.isZero,
              crossWindWrapped.isNormal || crossWindWrapped.isZero,
              totalWindWrapped.isNormal || totalWindWrapped.isZero || totalWindWrapped.isInfinite,
              runwayHeadingWrapped.isNormalOrZero()
        else { return false }
        return true
    }

    // 初始化方法，设置顶风、顺风、侧风和跑道方向
    public init(headWind: Double, tailWind: Double, crossWind: Double, totalWind: Double? = nil, runwayHeading: AAngle? = nil) {
        self.headWindWrapped = abs(headWind)
        self.tailWindWrapped = abs(tailWind)
        self.crossWindWrapped = abs(crossWind)
        if let totalWind = totalWind {
            self.totalWindWrapped = abs(totalWind)
        } else {
            // 如果未指定总风速，则通过勾股定理计算
            self.totalWindWrapped = max(sqrt(pow(headWind, 2) + pow(crossWind, 2)), sqrt(pow(tailWind, 2) + pow(crossWind, 2)))
        }
        self.runwayHeadingWrapped = runwayHeading?.in360() ?? .zero
    }

    // 定义一个静态常量，表示B737的风限
    public static var b737 = AWindLimit(headWind: 50, tailWind: 10, crossWind: 30)
}

// 扩展AWindLimit，增加功能性方法
public extension AWindLimit {
    // 计算给定方向与跑道方向之间的角度差
    private func betweenRunwayHeading(heading: AAngle) -> AAngle {
        heading - runwayHeadingWrapped
    }

    // 根据角度计算最大风限状态
    func maxWind(from angle: AAngle) -> AWindLimitStatus {
        let angleDiff = betweenRunwayHeading(heading: angle)

        // 计算顶风或顺风的最大值
        let cosineValue = angleDiff.cos()
        let _maxWindByHeadOrTailWind: Double

        if cosineValue > 0 {
            _maxWindByHeadOrTailWind = headWindWrapped / abs(cosineValue)
        } else if cosineValue.isZero {
            _maxWindByHeadOrTailWind = .infinity
        } else {
            _maxWindByHeadOrTailWind = tailWindWrapped / abs(cosineValue)
        }

        // 计算侧风的最大值
        let sinValue = abs(angleDiff.sin())
        let _maxWindByCrossWind: Double
        if sinValue.isZero {
            _maxWindByCrossWind = .infinity
        } else {
            _maxWindByCrossWind = crossWindWrapped / sinValue
        }

        // 综合考虑风限，选择最小的限制
        let maximumAcceptableWind = min(_maxWindByHeadOrTailWind, _maxWindByCrossWind, totalWindWrapped)

        switch maximumAcceptableWind {
        case _maxWindByHeadOrTailWind:
            let limitType: AWindLimitType = cosineValue >= 0 ? .headWind : .tailWind
            return .init(code: limitType, limit: maximumAcceptableWind, windDir: angle, runway: runwayHeading)
        case _maxWindByCrossWind:
            return .init(code: .crossWind, limit: maximumAcceptableWind, windDir: angle, runway: runwayHeading)
        default:
            return .init(code: .totalWind, limit: maximumAcceptableWind, windDir: angle, runway: runwayHeading)
        }
    }

    // 返回一组代表不同方向的风限状态的数据
    func usefulData() -> [AWindLimitStatus] {
        stride(from: 0, to: 360, by: 10)
            .map { angleInDegrees in
                maxWind(from: .degrees(angleInDegrees))
            }
    }

    // 将风速从一个单位转换到另一个单位
    mutating func convert(from unit: AUnit, to newUnit: AUnit?) {
        guard let newUnit = newUnit,
              unit.unitType == .speed
        else { return }
        crossWindWrapped = unit.convert(value: crossWindWrapped, to: newUnit) ?? crossWindWrapped
        headWindWrapped = unit.convert(value: headWindWrapped, to: newUnit) ?? headWindWrapped
        tailWindWrapped = unit.convert(value: tailWindWrapped, to: newUnit) ?? tailWindWrapped
        totalWindWrapped = unit.convert(value: totalWindWrapped, to: newUnit) ?? totalWindWrapped
    }

    // 返回转换单位后的新风限
    func converted(from unit: AUnit, to newUnit: AUnit?) -> AWindLimit {
        var copied = self
        copied.convert(from: unit, to: newUnit)
        return copied
    }
}
