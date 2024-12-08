import AUnit
import AUnitViews
import AViewUI

#if os(iOS)

@available(iOS 16, *)
public struct AWindLimitAllDirectionContent: View {
    var windLimitValue: AWindLimit?
    @Binding var unit: AUnit?
    var originalUnit: AUnit?
    var precision: FloatingPointFormatStyle<Double>.Configuration.Precision

    private var allDirectionContent: [AWindLimitStatus] {
        windLimitValue?.usefulData() ?? []
    }

    public var body: some View {
        ForEach(allDirectionContent) { windData in
            AWindLimitStatusHStack(unit: $unit, status: windData, originalUnit: originalUnit, precision: precision)
        }
    }

    public init(_ windLimitValue: AWindLimit?, unit: Binding<AUnit?>, originalUnit: AUnit?, precision: FloatingPointFormatStyle<Double>.Configuration.Precision) {
        self.windLimitValue = windLimitValue
        self._unit = unit
        self.originalUnit = originalUnit
        self.precision = precision
    }

    public init(_ aValue: AValue?, unit: Binding<AUnit?>, originalUnit: AUnit?, precision: FloatingPointFormatStyle<Double>.Configuration.Precision) {
        self.windLimitValue = aValue?.getGroundWindLimit()
        self._unit = unit
        self.originalUnit = originalUnit
        self.precision = precision
    }
}

@available(iOS 16, *)
private struct Example: View {
    @State private var aValue: AValue? = .groundWind(limit: .b737.with(rHDG: .degrees(350)))
    @State private var unit: AUnit? = .knots

    var body: some View {
        List {
            AWindLimitAllDirectionContent(aValue, unit: $unit, originalUnit: .knots, precision: .fractionLength(0 ... 2))
        }
    }
}

@available(iOS 16, *)
#Preview {
    Example()
}

#endif
