import AViewUI
import SwiftUI

#if os(iOS)

@available(iOS 16, *)
public struct ALongitudeKeyboard: View {
    @Binding private var format: ACoordinateFormat
    private var textfield: UITextField
    private let lettersFont: Font = .system(size: 10)
    private let numbersFont: Font = .system(size: 23)
    private let connerRadius: CGFloat = 4

    @State private var turnDirection: Angle = .zero

    @ViewBuilder
    private func makeTextButton(_ text: String) -> some View {
        AKeyButton(connerRadius) {
            textfield.insertText(text)
        } content: { _ in
            Text(text).font(numbersFont)
                .bold()
        }
    }

    @ViewBuilder
    private func makeNumberButton(_ number: Int) -> some View {
        AKeyButton(connerRadius) {
            textfield.insertText(number.formatted(.number))
        } content: { _ in
            ANumKeyVStack(number, letters: lettersFont, number: numbersFont)
                .bold()
        }
    }

    @ViewBuilder
    private func doneButton() -> some View {
        AKeyButton(cornerRadius: connerRadius) { isClicked, colorScheme in
            if isClicked {
                return AKeyColors.defaultColors.getColor(isClicked, colorScheme)
            } else {
                return .blue
            }
        } action: {
            guard let text = textfield.text,
                  var longitude = try? ALongitude(text)
            else { return }
            if textfield.text == longitude.description {
                // 如果已经一样了
                let nextFormat = format.nextFormat
                format = nextFormat
                longitude = longitude.toFormat(nextFormat)
                textfield.text = longitude.description
            } else {
                textfield.text = longitude.description
                format = longitude.format
            }

        } content: { isClicked in
            Text("=")
                .font(numbersFont)
                .foregroundColor(isClicked ? .primary : .white)
        }
    }

    public var body: some View {
        AKeyboardBackgroundView { screenWidth in
            KeyBoardSpaceAroundStack(columns: 4, rowSpace: 5, columnSpace: 5) {
                ForEach(1 ..< 4, content: makeNumberButton)
                AKeyButton(connerRadius, sound: 1155) {
                    textfield.deleteBackward()
                } content: { isPressed in
                    Image(systemName: isPressed ? "delete.left.fill" : "delete.left")
                        .font(.system(size: 24))
                        .fontWeight(.light)
                }

                ForEach(4 ..< 7, content: makeNumberButton)
                AKeyButton(connerRadius, colors: .sameAsBackground) {
                    textfield.insertText(".")
                } content: { isPressed in
                    Text(".")
                        .font(numbersFont)
                        .bold(isPressed)
                }

                ForEach(7 ..< 10, content: makeNumberButton)

                AKeyButton(connerRadius, colors: .sameAsBackground, sound: 1155) {
                    textfield.text = ""
                    withAnimation {
                        turnDirection -= .degrees(360)
                    }
                } content: { _ in
                    Image(systemName: "arrow.counterclockwise")
                        .font(.system(size: 24))
                        .rotationEffect(turnDirection)
                }

                makeTextButton("W")
                makeNumberButton(0)

                makeTextButton("E")
                doneButton()
            }
            .frame(width: screenWidth)
        }
    }

    public init(_ textfield: UITextField, format: Binding<ACoordinateFormat>) {
        self.textfield = textfield
        self._format = format
    }

    public init(_ textfield: UITextField) {
        self.textfield = textfield
        let defaultFormat = State(initialValue: ACoordinateFormat.degreesM)
        self._format = defaultFormat.projectedValue
    }
}

@available(iOS 16, *)
#Preview {
    ALongitudeKeyboard(.init())
        .frame(height: 240)
}

#endif
