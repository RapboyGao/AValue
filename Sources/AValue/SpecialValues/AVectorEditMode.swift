
import Foundation

public enum AVectorEditMode: Hashable, Sendable, Codable, CaseIterable, Identifiable {
    case compass, math, xY

    public var id: Self {
        self
    }

    public var systemImage: String {
        switch self {
        case .compass:
            "location.north.line"
        case .math:
            "chart.line.flattrend.xyaxis"
        case .xY:
            "chart.dots.scatter"
        }
    }
}
