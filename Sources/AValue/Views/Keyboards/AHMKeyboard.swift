import AUnit
import AViewUI
import SwiftUI

#if os(iOS)

@available(iOS 16, *)
public struct AHMKeyboard: View {
    @Binding var format: AHourMinuteValue.Format
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
    private func makeDayButton() -> some View {
        AKeyButton(connerRadius) {
            textfield.insertText("d")
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
            guard let text = textfield.text,
                  let hmValues = [AHourMinuteValue](text)
            else { return }
            let hasDay = hmValues.contains {
                $0.format == .days24HM
            }
            let newHourMinuteValue = hasDay ? hmValues.sum(format: .days24HM) : hmValues.sum(format: .hourMinute)
            let newText = newHourMinuteValue.description
            guard textfield.text == newText
            else {
                textfield.text = newText
                format = hasDay ? .days24HM : .hourMinute
                return
            }
            switch newHourMinuteValue.toNumber() {
            case 0 ..< 1440:
                textfield.resignFirstResponder()
            default:
                switch format {
                case .hourMinute, .totalHours, .totalMinutes:
                    format = .days24HM
                case .days24HM:
                    format = .hourMinute
                }
                textfield.text = newHourMinuteValue.toFormat(format).description
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

//                makeTextButton(":")
                Text("")
                makeNumberButton(0)
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

                doneButton()
            }
            .frame(width: screenWidth)
        }
    }

    public init(_ textfield: UITextField) {
        self.textfield = textfield
        let someState = State(initialValue: AHourMinuteValue.Format.hourMinute)
        self._format = someState.projectedValue
    }

    public init(_ textfield: UITextField, format: Binding<AHourMinuteValue.Format>) {
        self.textfield = textfield
        self._format = format
    }
}

@available(iOS 16, *)
#Preview {
    AHMKeyboard(.init())
        .frame(height: 240)
}

#endif
