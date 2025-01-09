import AUnitViews
import SwiftUI

#if os(iOS)

@available(iOS 16.0, *)
public struct AVetcorEditView<Vector: AVectorProtocol>: View {
    @Binding public var vector: Vector?
    @Binding public var selectedUnit: AUnit?

    var originalUnit: AUnit?
    var allowSet: Bool
    var precision: FloatingPointFormatStyle.Configuration.Precision

    private var convertedVector: Vector? {
        vector?.converted(from: originalUnit, to: selectedUnit)
    }

    public var body: some View {
        VStack {
            GeometryReader { geometry in
                AVectorChartView(vector: convertedVector)
                    .frame(minHeight: geometry.size.width)
                    .ignoresSafeArea()
            }
            List {
                AVectorMathContents($vector, $selectedUnit, originalUnit: originalUnit, allowSet: allowSet, precision: precision)
            }
        }
    }

    public init(_ vector: Binding<Vector?>, _ selectedUnit: Binding<AUnit?>, originalUnit: AUnit?, allowSet: Bool, precision: FloatingPointFormatStyle.Configuration.Precision) {
        self._vector = vector
        self._selectedUnit = selectedUnit
        self.originalUnit = originalUnit
        self.allowSet = allowSet
        self.precision = precision
    }
}

@available(iOS 16.0, *)
private struct Example: View {
    @State private var value: AVector?
    @State private var unit: AUnit?

    var body: some View {
        AVetcorEditView($value, $unit, originalUnit: .meters, allowSet: true, precision: .fractionLength(0 ... 3))
    }
}

@available(iOS 16.0, *)
#Preview {
    Example()
}

#endif
