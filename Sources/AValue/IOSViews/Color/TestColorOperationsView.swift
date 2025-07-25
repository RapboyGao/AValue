
import SwiftUI

@available(iOS 16, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
struct TestColorOperationsView: View {
    @State var color1 = Color(red: 0.8, green: 0.5, blue: 0.07)
    @State var color2 = Color(red: 0.0, green: 0.9, blue: 0.07)

    var colorMultiplied: Color? {
        guard let value1 = AValue(color: color1),
              let value2 = AValue(color: color2),
              let value3 = try? value1.multiply(by: value2),
              let someColor = value3.getColor()
        else { return nil }
        return someColor
    }

    var colorInverted: Color? {
        guard let value1 = AValue(color: color1),
              let value2 = try? value1.negative()
        else { return nil }
        return value2.getColor()
    }

    var body: some View {
        VStack {
            ZStack {
                color1
                ColorPicker("", selection: $color1, supportsOpacity: true)
                    .labelsHidden()
            }
            ZStack {
                color2
                ColorPicker("", selection: $color2, supportsOpacity: true)
                    .labelsHidden()
            }
            Text("Multiply")
            if let colorMultiplied = colorMultiplied {
                color1.colorMultiply(color2)
                colorMultiplied
            }
            if let colorInverted = colorInverted {
                Text("Invert")
                color1.colorInvert()
                colorInverted
            }
        }
    }
}

@available(iOS 16, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
#Preview {
    TestColorOperationsView()
}
