import AUnit
import AViewUI
import SwiftUI

#if os(iOS)

@available(iOS 16, *)
public struct AHMKeyboard: View, AKeyboardProtocol {
    @Binding var format: AHourMinuteValue.Format
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
    private func makeDayButton() -> some View {
        AKeyButton(connerRadius) {
            input.insertText("d")
        } content: { _ in
            Text(AUnit.days.shortName)
                .font(numbersFont)
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
            guard let hmValues = [AHourMinuteValue](input.text)
            else { return }
            let hasDay = hmValues.contains {
                $0.format == .days24HM
            }
            let newHourMinuteValue = hasDay ? hmValues.sum(format: .days24HM) : hmValues.sum(format: .hourMinute)
            let newText = newHourMinuteValue.description
            guard input.text == newText
            else {
                input.setText(newText)
                format = hasDay ? .days24HM : .hourMinute
                return
            }
            switch newHourMinuteValue.toNumber() {
            case 0 ..< 1440:
                input.dismissKeyboard()
            default:
                switch format {
                case .hourMinute, .totalHours, .totalMinutes:
                    format = .days24HM
                case .days24HM:
                    format = .hourMinute
                }
                let newText = newHourMinuteValue.toFormat(format).description
                input.setText(newText)
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
                makeTextButton("+")

                ForEach(4 ..< 7, content: makeNumberButton)
                makeTextButton("-")

                ForEach(7 ..< 10, content: makeNumberButton)
                makeDayButton()

                AKeyButton(connerRadius, colors: .sameAsBackground) {
                    input.insertText(":")
                } content: { isClicked in
                    Text(":")
                        .bold(isClicked)
                        .font(numbersFont)
                }
                makeNumberButton(0)
                AKeyButton(connerRadius, colors: .sameAsBackground, sound: 1155) {
                    input.setText("")
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
        .onAppear {
            if input.text == "00:00" {
                input.setText("")
            }
        }
    }

    public init(_ context: ACustomKeyboardInputContext) {
        self.input = context
        let someState = State(initialValue: AHourMinuteValue.Format.hourMinute)
        self._format = someState.projectedValue
    }

    public init(_ context: ACustomKeyboardInputContext, format: Binding<AHourMinuteValue.Format>) {
        self.input = context
        self._format = format
    }

    public init(_ textfield: UITextField) {
        self.init(.make(textField: textfield))
    }

    public init(_ textfield: UITextField, format: Binding<AHourMinuteValue.Format>) {
        self.init(.make(textField: textfield), format: format)
    }

    public init(_ textfield: UITextField, _ bindText: Binding<String>) {
        self.init(.make(textField: textfield, bindString: bindText))
    }

    public init(_ textfield: UITextField, _ bindText: Binding<String>, format: Binding<AHourMinuteValue.Format>) {
        self.init(.make(textField: textfield, bindString: bindText), format: format)
    }
}

@available(iOS 16, *)
#Preview {
    AHMKeyboard(.init())
        .frame(height: 240)
}

#endif
