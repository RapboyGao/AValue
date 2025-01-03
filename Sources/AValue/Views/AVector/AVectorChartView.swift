import Charts
import SwiftUI

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public struct AVectorChartView<Vector: AVectorProtocol>: View {
    public var vector: Vector

    private var points: [Vector] {
        [.init(x: 0, y: 0), vector]
    }

    private var domain: [Double] {
        guard vector.isValid
        else { return [-1, 1] }
        let length = vector.length
        let length12 = length * 1.1
        return [min(-length12, -1e-10), max(length12, 1e-10)]
    }

    public var body: some View {
        Chart {
            if vector.isValid {
                ForEach(points, id: \.self) { point in
                    LineMark(x: .value("x", point.x), y: .value("y", point.y))
                }
                PointMark(x: .value("x", vector.x), y: .value("y", vector.y))
                    .symbol {
                        Image(systemName: "smallcircle.filled.circle")
                            .foregroundColor(.orange)
                    }
            }
            PointMark(x: .value("x", 0), y: .value("y", 0))
                .symbol {
                    Image(systemName: "smallcircle.filled.circle")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
        }
        .chartXScale(domain: domain)
        .chartYScale(domain: domain)
        .chartXAxis {
            if vector.isValid {
                AxisMarks(preset: .inset, values: [vector.x, 0, -vector.x])
            }
        }
        .chartYAxis {
            if vector.isValid {
                AxisMarks(preset: .inset, values: [vector.y, 0, -vector.y])
            }
        }
    }

    public init(vector: Vector?) {
        self.vector = vector ?? .init(x: 0, y: 0)
    }

    public init(_ value: AValue?) where Vector == AVector {
        switch value {
        case .point(x: let x, y: let y):
            self.init(vector: .init(x: x, y: y))
        default:
            self.init(vector: .zero)
        }
    }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
struct VectorChartView_Previews: PreviewProvider {
    static var previews: some View {
        AVectorChartView(.point(x: 1, y: 2))
        AVectorChartView(.minutes(2))
    }
}
