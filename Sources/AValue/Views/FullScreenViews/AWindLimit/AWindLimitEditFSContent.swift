import AUnit
import AUnitViews
import AViewUI

#if os(iOS)

@available(iOS 16, *)
public struct AWindLimitEditFSContent: View {
    @Binding var windLimitValue: AWindLimit?
    @Binding var unit: AUnit?
    var originalUnit: AUnit
    var allowSet: Bool
    var precision: FloatingPointFormatStyle<Double>.Configuration.Precision

    private var bindHeadwind: Binding<Double?> {
        Binding {
            windLimitValue?.headWind
        } set: {
            if let newValue = $0 {
                if windLimitValue == nil {
                    windLimitValue = .b737
                }
                windLimitValue?.headWind = newValue
            }
        }
    }

    private var bindCrosswind: Binding<Double?> {
        Binding {
            windLimitValue?.crossWind
        } set: {
            if let newValue = $0 {
                if windLimitValue == nil {
                    windLimitValue = .b737
                }
                windLimitValue?.crossWind = newValue
            }
        }
    }

    private var bindTailwind: Binding<Double?> {
        Binding {
            windLimitValue?.tailWind
        } set: {
            if let newValue = $0 {
                if windLimitValue == nil {
                    windLimitValue = .b737
                }
                windLimitValue?.tailWind = newValue
            }
        }
    }

    private var bindTotalWind: Binding<Double?> {
        Binding {
            windLimitValue?.totalWind
        } set: {
            if let newValue = $0 {
                if windLimitValue == nil {
                    windLimitValue = .b737
                }
                windLimitValue?.totalWind = newValue
            }
        }
    }

    private var bindRunwayHeading: Binding<Double?> {
        Binding {
            windLimitValue?.runwayHeadingInDegrees
        } set: {
            if let newValue = $0 {
                if windLimitValue == nil {
                    windLimitValue = .b737
                }
                windLimitValue?.runwayHeadingInDegrees = newValue
            }
        }
    }

    public var body: some View {
        HStack {
            Text(I18n.crosswind)
            AUnitTextfieldContent(
                bindCrosswind,
                $unit,
                original: originalUnit,
                filter: [.speed],
                allowSet: allowSet,
                mathKeyboard: false,
                name: I18n.crosswind,
                precision: precision)
        }

        HStack {
            Text(I18n.headwind)
            AUnitTextfieldContent(
                bindHeadwind,
                $unit,
                original: originalUnit,
                filter: [.speed],
                allowSet: allowSet,
                mathKeyboard: false,
                name: I18n.headwind,
                precision: precision)
        }

        HStack {
            Text(I18n.tailwind)
            AUnitTextfieldContent(
                bindTailwind,
                $unit,
                original: originalUnit,
                filter: [.speed],
                allowSet: allowSet,
                mathKeyboard: false,
                name: I18n.tailwind,
                precision: precision)
        }

        HStack {
            Text(I18n.totalWind)
            AUnitTextfieldContent(
                bindTotalWind,
                $unit,
                original: originalUnit,
                filter: [.speed],
                allowSet: allowSet,
                mathKeyboard: false,
                name: I18n.totalWind,
                precision: precision)
        }

        HStack {
            Text(I18n.rwyHDG)
            if allowSet {
                TextField(I18n.rwyHDG, value: bindRunwayHeading, format: .number.precision(.fractionLength(0 ... 2)))
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            } else if let runwayHeading = windLimitValue?.runwayHeadingInDegrees {
                Spacer()
                Text("= ") + Text(runwayHeading, format: .number)
            } else {
                Spacer()
                Text("-")
            }
            Text(AUnit.degrees.symbol)
                .foregroundStyle(.tint)
        }
    }

    public init(_ windLimitValue: Binding<AWindLimit?>, unit: Binding<AUnit?>, originalUnit: AUnit, allowSet: Bool, precision: FloatingPointFormatStyle<Double>.Configuration.Precision) {
        self._windLimitValue = windLimitValue
        self._unit = unit
        self.originalUnit = originalUnit
        self.allowSet = allowSet
        self.precision = precision
    }

    public init(_ aValue: Binding<AValue?>, unit: Binding<AUnit?>, originalUnit: AUnit, allowSet: Bool, precision: FloatingPointFormatStyle<Double>.Configuration.Precision) {
        self._windLimitValue = aValue.windLimit()
        self._unit = unit
        self.originalUnit = originalUnit
        self.allowSet = allowSet
        self.precision = precision
    }
}

@available(iOS 16, *)
private struct Example: View {
    @State private var aValue: AValue? = 45
    @State private var unit: AUnit?

    var body: some View {
        List {
            Section {
                AWindLimitEditFSContent($aValue, unit: $unit, originalUnit: .knots, allowSet: true, precision: .fractionLength(0 ... 1))
            }
            Section {
                AWindLimitEditFSContent($aValue, unit: $unit, originalUnit: .knots, allowSet: false, precision: .fractionLength(0 ... 1))
            }
        }
    }
}

@available(iOS 16, *)
#Preview {
    Example()
}

#endif
