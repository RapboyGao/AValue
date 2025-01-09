import AUnitViews
import SwiftUI

/// Constant value for Pi (π)
private let pi = 3.14159265358979323846264338327950288419716939937510

#if os(iOS)

@available(iOS 16.0, *)
public struct AVectorMathContents<Vector: AVectorProtocol>: View {
    @State private var mode: AVectorEditMode = .compass

    @Binding public var vector: Vector?
    @Binding public var selectedUnit: AUnit?

    @State private var angleUnit: AUnit? = .degrees
    var originalUnit: AUnit?
    var allowSet: Bool
    var precision: FloatingPointFormatStyle.Configuration.Precision

    var bindX: Binding<Double?> {
        Binding {
            vector?.x
        } set: { newValue in
            if vector == nil {
                guard let newValue = newValue
                else { return }
                vector = Vector(x: newValue, y: 0)
            } else {
                guard let newValue = newValue
                else { return }
                vector?.x = newValue
            }
        }
    }

    var bindY: Binding<Double?> {
        Binding {
            vector?.y
        } set: { newValue in
            if vector == nil {
                guard let newValue = newValue
                else { return }
                vector = Vector(x: 0, y: newValue)
            } else {
                guard let newValue = newValue
                else { return }
                vector?.y = newValue
            }
        }
    }

    var bindLen: Binding<Double?> {
        Binding {
            vector?.length
        } set: { newValue in
            if vector == nil {
                guard let newValue = newValue else { return }
                vector = Vector(x: newValue, y: 0)
            } else {
                guard let newValue = newValue
                else { return }
                vector?.length = newValue
            }
        }
    }

    var bindATan2Double: Binding<Double> {
        Binding {
            vector?.atan2.value ?? 0
        } set: { newValue in
            guard vector != nil
            else {
                vector = Vector(atan2: .radians(newValue), length: 10)
                return
            }
            vector?.atan2 = .radians(newValue)
        }
    }

    var bindATan2Double2: Binding<Double?> {
        Binding {
            vector?.atan2.value
        } set: { newValue in
            guard let newValue = newValue else { return }
            guard vector != nil
            else {
                vector = Vector(atan2: .radians(newValue), length: 10)
                return
            }
            vector?.atan2 = .radians(newValue)
        }
    }

    var bindCompassTowardsDouble: Binding<Double> {
        Binding {
            vector?.compassTowards.value ?? 0
        } set: { newValue in
            guard vector != nil
            else {
                vector = Vector(towards: .radians(newValue), length: 10)
                return
            }
            vector?.compassTowards = .radians(newValue)
        }
    }

    var bindCompassTowardsDouble2: Binding<Double?> {
        Binding {
            vector?.compassTowards.value
        } set: { newValue in
            guard let newValue = newValue else { return }
            guard vector != nil
            else {
                vector = Vector(towards: .radians(newValue), length: 10)
                return
            }
            vector?.compassTowards = .radians(newValue)
        }
    }

    var bindCompassFromDouble: Binding<Double> {
        Binding {
            vector?.compassFrom.value ?? pi
        } set: { newValue in
            guard vector != nil
            else {
                vector = Vector(from: .radians(newValue), length: 10)
                return
            }
            vector?.compassFrom = .radians(newValue)
        }
    }

    var bindCompassFromDouble2: Binding<Double?> {
        Binding {
            vector?.compassFrom.value
        } set: { newValue in
            guard let newValue = newValue
            else { return }
            guard vector != nil
            else {
                vector = Vector(from: .radians(newValue), length: 10)
                return
            }
            vector?.compassFrom = .radians(newValue)
        }
    }

    @ViewBuilder
    private var xView: some View {
        HStack {
            Text("x")
            AUnitTextfieldContent(bindX, $selectedUnit, original: originalUnit, filter: AUnitType.casesUsedInVector, allowSet: allowSet, mathKeyboard: true, name: "x", precision: precision)
        }
    }

    @ViewBuilder
    private var yView: some View {
        HStack {
            Text("y")
            AUnitTextfieldContent(bindY, $selectedUnit, original: originalUnit, filter: AUnitType.casesUsedInVector, allowSet: allowSet, mathKeyboard: true, name: "y", precision: precision)
        }
    }

    @ViewBuilder
    private var lengthView: some View {
        HStack {
            Text("Length")
            AUnitTextfieldContent(bindLen, $selectedUnit, original: originalUnit, filter: AUnitType.casesUsedInVector, allowSet: allowSet, mathKeyboard: true, name: "Length", precision: precision)
        }
    }

    @ViewBuilder
    private var atan2View: some View {
        VStack {
            HStack {
                Text("atan2")
                AUnitTextfieldContent(bindATan2Double2, $angleUnit, original: .radians, filter: [.angle], allowSet: allowSet, mathKeyboard: true, name: "atan2", precision: precision)
            }
            if allowSet {
                Slider(value: bindATan2Double, in: -pi ... pi)
            }
        }
    }

    @ViewBuilder
    private var towardsView: some View {
        VStack {
            HStack {
                Text("Compass HDG")
                AUnitTextfieldContent(bindCompassTowardsDouble2, $angleUnit, original: .radians, filter: [.angle], allowSet: allowSet, mathKeyboard: true, name: "Compass HDG", precision: precision)
            }
            if allowSet {
                Slider(value: bindCompassTowardsDouble, in: 0 ... 2 * pi)
            }
        }
    }

    @ViewBuilder
    private var fromView: some View {
        VStack {
            HStack {
                Text("Compass From")
                AUnitTextfieldContent(bindCompassFromDouble2, $angleUnit, original: .radians, filter: [.angle], allowSet: allowSet, mathKeyboard: true, name: "Compass From", precision: precision)
            }
            if allowSet {
                Slider(value: bindCompassFromDouble, in: 0 ... 2 * pi)
            }
        }
    }

    public var body: some View {
        Picker(selection: $mode) {
            ForEach(AVectorEditMode.allCases) { someMode in
                Image(systemName: someMode.systemImage)
            }
        } label: {
            Image(systemName: mode.systemImage)
        }
        .pickerStyle(.segmented)

        switch mode {
        case .compass:
            lengthView
            towardsView
            fromView
        case .math:
            lengthView
            atan2View
        case .xY:
            xView
            yView
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
        List {
            AVectorMathContents($value, $unit, originalUnit: .meters, allowSet: true, precision: .fractionLength(0 ... 3))
        }
    }
}

@available(iOS 16.0, *)
#Preview {
    Example()
}

#endif
