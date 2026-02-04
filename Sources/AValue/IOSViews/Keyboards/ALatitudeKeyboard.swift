import AViewUI
import SwiftUI

#if os(iOS)

@available(iOS 16, *)
public struct ALatitudeKeyboard: View, AKeyboardProtocol {
    @Binding private var format: ACoordinateFormat
    public var input: ACustomKeyboardInputContext

    @State private var turnDirection: Angle = .zero

    @ViewBuilder
    private func makeTextButton(_ text: String) -> some View {
        AKeyButton(connerRadius) {
            input.insertText(text)
        } content: { _ in
            Text(text).font(numbersFont)
                .bold()
        }
    }

    @ViewBuilder
    private func makeNumberButton(_ number: Int) -> some View {
        AKeyButton(connerRadius) {
            input.insertText(number.formatted(.number))
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
            guard var latitude = try? ALatitude(input.text)
            else { return }
            if input.text == latitude.description {
                // 如果已经一样了
                let nextFormat = latitude.format.nextFormat
                format = nextFormat
                latitude = latitude.toFormat(nextFormat)
            } else {
                format = latitude.format
            }
            let newContent = latitude.description
            input.setText(newContent)
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
                    input.deleteBackward()
                } content: { isPressed in
                    Image(systemName: isPressed ? "delete.left.fill" : "delete.left")
                        .font(.system(size: 24))
                        .fontWeight(.light)
                }

                ForEach(4 ..< 7, content: makeNumberButton)
                makeTextButton("N")

                ForEach(7 ..< 10, content: makeNumberButton)
                makeTextButton("S")

                AKeyButton(connerRadius, colors: .sameAsBackground) {
                    input.insertText(".")
                } content: { isPressed in
                    Text(".")
                        .font(numbersFont)
                        .bold(isPressed)
                }
                makeNumberButton(0)

                AKeyButton(connerRadius, colors: .sameAsBackground, sound: 1155) {
                    input.clear()
                    withAnimation {
                        turnDirection -= .degrees(360)
                    }
                } content: { _ in
                    Image(systemName: "arrow.counterclockwise")
                        .font(.system(size: 24))
                        .rotationEffect(turnDirection)
                }
                doneButton()
            }
            .frame(width: screenWidth)
        }
    }

    public init(_ context: ACustomKeyboardInputContext, format: Binding<ACoordinateFormat>) {
        self.input = context
        self._format = format
    }

    public init(_ textfield: UITextField, string bindString: Binding<String>, format: Binding<ACoordinateFormat>) {
        self.init(.make(textField: textfield, bindString: bindString), format: format)
    }

    public init(_ textfield: UITextField, string bindString: Binding<String>) {
        let defaultFormat = State(initialValue: ACoordinateFormat.degreesM)
        self.init(.make(textField: textfield, bindString: bindString), format: defaultFormat.projectedValue)
    }
}

@available(iOS 16, *)
#Preview {
    ALatitudeKeyboard(.init(), string: .constant(""))
        .frame(height: 240)
}

#endif
