import AUnit
import AUnits
import AUnitViews
import AViewUI

#if os(iOS)

@available(iOS 16, *)
public struct AWindLimitStatusHStack: View {
    @Binding var unit: AUnit?
    var status: AWindLimitStatus
    var originalUnit: AUnit?

    private let dirFormat: FloatingPointFormatStyle<Double> = .number.precision(.integerLength(3))

    private var originalUnitIfSpeed: AUnit? {
        guard originalUnit?.unitType == .speed
        else { return nil }
        return originalUnit
    }

    private var displayedSpeed: Double {
        originalUnitIfSpeed?.convert(value: status.limit, to: unit)
            ?? status.limit
    }

    private var textSpeed: Text {
        Text("≤") +
            Text(displayedSpeed, format: .number.precision(.fractionLength(1)).rounded(rule: .towardZero))
    }

    private var displayedHeadOrTailwind: Double {
        status.diff.cos() * displayedSpeed
    }

    private var displayedCrosswind: Double {
        status.diff.sin() * displayedSpeed
    }

    private var selectedUnit: AUnit? {
        unit ?? originalUnitIfSpeed
    }

    private var bindSelectedUnit: Binding<AUnit?> {
        Binding<AUnit?> {
            selectedUnit
        } set: { newUnit in
            unit = newUnit
        }
    }

    private var windRelativeDirectionText: Text {
        Text("(") + Text(status.diff.converted(to: .degrees).value, format: dirFormat.sign(strategy: .always())) + Text(")")
    }

    private var windDirectionText: Text {
        Text(status.windDir.converted(to: .degrees).value, format: .number.precision(.integerLength(3)))
            + Text("°")
    }

    private var labelOfHeadwind: some View {
        var text = Text(displayedHeadOrTailwind, format: .number.precision(.fractionLength(1 ... 5)).rounded(rule: .awayFromZero))
        if let selectedUnit = selectedUnit {
            text = text + Text(" " + selectedUnit.symbol)
        }
        return Label {
            text
        } icon: {
            Image(systemName: displayedHeadOrTailwind < 0 ? "arrow.up" : "arrow.down")
        }
    }

    private var labelOfCross: some View {
        var text = Text(displayedCrosswind, format: .number.precision(.fractionLength(1 ... 5)).rounded(rule: .awayFromZero))
        if let selectedUnit = selectedUnit {
            text = text + Text(" " + selectedUnit.symbol)
        }
        return Label {
            text
        } icon: {
            Image(systemName: displayedHeadOrTailwind < 0 ? "arrow.right" : "arrow.left")
        }
    }

    public var body: some View {
        HStack {
            windDirectionText + windRelativeDirectionText
                .font(.caption2)
                .foregroundColor(.gray)
            if status.runway < .degrees(180) {
                Image(systemName: "location.north")
                    .rotationEffect(status.runway.toAngle())
                Image(systemName: "line.diagonal.arrow")
                    .rotationEffect(status.windDir.toAngle())
            } else {
                Image(systemName: "line.diagonal.arrow")
                    .rotationEffect(status.windDir.toAngle())
                Image(systemName: "location.north")
                    .rotationEffect(status.runway.toAngle())
            }

            Spacer()
            Menu {
                labelOfHeadwind
                labelOfCross
            } label: {
                textSpeed
            }
            if originalUnitIfSpeed != nil {
                AUnitEasySelectorView(unit: bindSelectedUnit, filter: .speed, showNone: false)
            }
        }
    }

    public init(unit: Binding<AUnit?>, status: AWindLimitStatus, originalUnit: AUnit?) {
        self._unit = unit
        self.status = status
        self.originalUnit = originalUnit
    }
}

@available(iOS 16, *)
private struct Example: View {
    @State var unit: AUnit? = .metersPerSecond
    let status = AWindLimit.b737.with(rHDG: .degrees(230)).maxWind(from: .degrees(340))

    var body: some View {
        List {
            AWindLimitStatusHStack(unit: $unit, status: status, originalUnit: .knots)
        }
    }
}

@available(iOS 16, *)
#Preview {
    Example()
}

#endif
