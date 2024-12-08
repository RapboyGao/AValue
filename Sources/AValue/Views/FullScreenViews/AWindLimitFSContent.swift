import AUnit
import AViewUI
import SwiftUI

@available(iOS 16, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct AWindLimitFSContent: View {
    @Binding var windLimitValue: AWindLimit?
    @Binding var unit: AUnit?
    var originalUnit: AUnit?
    var allowSet: Bool
    var precision: FloatingPointFormatStyle<Double>.Configuration.Precision

    public var body: some View {
        List {
            Section(I18n.windSpeedLimit) {
                AWindLimitEditFSContent($windLimitValue, unit: $unit, originalUnit: originalUnit, allowSet: allowSet, precision: precision)
            }
            Section(I18n.maxWindInAllDirections) {
                AWindLimitAllDirectionContent(windLimitValue, unit: $unit, originalUnit: originalUnit, precision: precision)
            }
        }
    }

    public init(_ windLimitValue: Binding<AWindLimit?>, unit: Binding<AUnit?>, originalUnit: AUnit?, allowSet: Bool, precision: FloatingPointFormatStyle<Double>.Configuration.Precision) {
        self._windLimitValue = windLimitValue
        self._unit = unit
        self.originalUnit = originalUnit
        self.allowSet = allowSet
        self.precision = precision
    }

    public init(_ aValue: Binding<AValue?>, unit: Binding<AUnit?>, originalUnit: AUnit?, allowSet: Bool, precision: FloatingPointFormatStyle<Double>.Configuration.Precision) {
        self._windLimitValue = aValue.windLimit()
        self._unit = unit
        self.originalUnit = originalUnit
        self.allowSet = allowSet
        self.precision = precision
    }
}

@available(iOS 16, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
private struct Example: View {
    @State private var aValue: AValue? = 45
    @State private var unit: AUnit?

    var body: some View {
        AWindLimitFSContent($aValue, unit: $unit, originalUnit: .knots, allowSet: true, precision: .fractionLength(0 ... 2))
    }
}

@available(iOS 16, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
#Preview {
    Example()
}
