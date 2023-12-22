//
//  PinView.swift
//
//
//  Created by Luis Alvarez on 9/14/23.
//

import SwiftUI

@available(iOS 16.0, *)
public struct PinView: View {
    @Binding var input: String

    var onPinComplete: ((String) -> Void)? = nil
    var textColor: Color? = nil
    var hidesPin: Bool = true

    var currentEmoji: String? = nil
    var onClearEmoji: (() -> Void)? = nil

    public init(input: Binding<String>, onPinComplete: ((String) -> Void)? = nil, textColor: Color? = nil, hidesPin: Bool, currentEmoji: String? = nil, onClearEmoji: (() -> Void)? = nil) {
        _input = input
        self.onPinComplete = onPinComplete
        self.textColor = textColor
        self.hidesPin = hidesPin
        self.currentEmoji = currentEmoji
        self.onClearEmoji = onClearEmoji
    }

    private let buttons = PinButtonType.allCases
    private let maxDigits = 6

    private let cellSize: CGFloat = 20
    private let pinSize = 0.04

    public var body: some View {
        VStack {
            HStack {
                Spacer()
                if hidesPin {
                    ForEach(0 ..< maxDigits, id: \.self) { index in
                        if input.count >= index + 1 {
                            Circle().foregroundStyle(LunchboxThemeManager.shared.currentColor.gradient)
                                .frame(minHeight: 26, idealHeight: 26, maxHeight: 26)
                        } else {
                            Circle().stroke(LunchboxThemeManager.shared.currentColor, lineWidth: 3)
                                .frame(minHeight: 20, idealHeight: 20, maxHeight: 20)
                        }
                    }
                } else {
                    ForEach(0 ..< maxDigits, id: \.self) { index in
                        ZStack {
                            RoundedRectangle(cornerRadius: 12).stroke(Color.blue, lineWidth: 3).full()
                            if input.count >= index + 1 {
                                let strRange = input.index(input.startIndex, offsetBy: index)
                                let indexedStr = input[strRange]

                                Text(String(indexedStr))
                                    .autoFit(size: 40)
                                    .foregroundColor(Color.LBMonoScreenOffTone)
                                    .full()
                            }
                        }.frame(minWidth: 40, idealWidth: 40, maxWidth: 40, minHeight: 40, idealHeight: 40, maxHeight: 40)
                    }
                }
                Spacer()
            }.frame(minHeight: 60, idealHeight: 60, maxHeight: 60).horPadding(24)

            let f = ForEach(buttons, id: \.self) { button in
                Button(action: {
                    addAction(button: button)
                }, label: {
                    ZStack {
                        if button.isDigit() {
                            Text("\(button.identifier())")
                                .bold()
                                .autoFit(size: 40)
                                .foregroundColor(Color.LBMonoScreenOffTone)
                                .full()
                                .padding(12)
                                .background {
                                    Circle().foregroundColor(Color.systemSecondary)
                                }
                        } else if button == .Delete {
                            Image(systemName: button.identifier())
                                .resizable()
                                .foregroundColor(Color.LBMonoScreenOffTone)
                                .scaledToFit()
                                .squareFrame(length: 32)
                                .padding()

                        } else {
                            if onClearEmoji != nil, let _currentEmoji = currentEmoji {
                                Text(_currentEmoji).autoFit(size: 32).padding(12)
                                    .overlay(alignment: .bottom, content: {
                                        Text("Reset").font(.system(size: 12, weight: .heavy, design: .rounded)).foregroundColor(Color.LBMonoScreenOffTone)
                                            .horPadding(6)
                                            .background(Capsule().fill(Material.thin))
                                    })
                            } else {
                                Text("Clear").autoFit(size: 18)
                                    .foregroundColor(Color.LBMonoScreenOffTone)
                                    .padding(12)
                            }
                        }
                    }
                })
            }

            ViewThatFits(in: .vertical) {
                LazyVGrid(columns: [GridItem(), GridItem(), GridItem()]) {
                    f
                }.triPad()
                LazyVGrid(columns: [GridItem(), GridItem(), GridItem(), GridItem(), GridItem(), GridItem()]) {
                    f
                }.triPad()
            }
            Spacer()
        }
    }

    func addAction(button: PinButtonType) {
        switch button {
        case .One:
            input.append("1")
        case .Two:
            input.append("2")
        case .Three:
            input.append("3")
        case .Four:
            input.append("4")
        case .Five:
            input.append("5")
        case .Six:
            input.append("6")
        case .Seven:
            input.append("7")
        case .Eight:
            input.append("8")
        case .Nine:
            input.append("9")
        case .Zero:
            input.append("0")
        case .Delete:
            guard !input.isEmpty else {
                return
            }
            input.removeLast()
        case .Extra:
            input.removeAll()
            onClearEmoji?()
        }

        if input.count > maxDigits {
            let indexer = input.index(input.startIndex, offsetBy: 6)
            input = String(input.prefix(upTo: indexer))
        }

        if input.count == 6 {
            onPinComplete?(input)
        }
    }
}

public enum PinButtonType: CaseIterable {
    case One
    case Two
    case Three
    case Four
    case Five
    case Six
    case Seven
    case Eight
    case Nine
    case Delete
    case Zero
    case Extra

    func isDigit() -> Bool {
        if self == .Extra || self == .Delete {
            return false
        }
        return true
    }

    func identifier() -> String {
        switch self {
        case .One:
            return "1"
        case .Two:
            return "2"
        case .Three:
            return "3"
        case .Four:
            return "4"
        case .Five:
            return "5"
        case .Six:
            return "6"
        case .Seven:
            return "7"
        case .Eight:
            return "8"
        case .Nine:
            return "9"
        case .Delete:
            return "delete.left.fill"
        case .Zero:
            return "0"
        case .Extra:
            return ""
        }
    }
}

public struct PinButton {
    let id: PinButtonType
}

#Preview {
    StatefulPreviewWrapper(value: "Test") { f in
        PinView(input: f, hidesPin: true)
    }
}
