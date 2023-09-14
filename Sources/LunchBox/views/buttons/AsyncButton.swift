//
//  AsyncButton.swift
//
//
//  Created by Luis Alvarez on 9/14/23.
//

import SwiftUI

@available(iOS 14.0, *)
public struct AsyncButton<Label: View>: View {
    var action: () async -> Void
    var actionOptions = Set(ActionOption.allCases)
    @ViewBuilder var label: () -> Label

    @State private var isDisabled = false
    @State private var showProgressView = false

    public var body: some View {
        Button(
            action: {
                if actionOptions.contains(.disableButton) {
                    isDisabled = true
                }

                Task {
                    var progressViewTask: Task<Void, Error>?

                    if actionOptions.contains(.showProgressView) {
                        progressViewTask = Task {
                            try await Task.sleep(nanoseconds: 150_000_000)
                            showProgressView = true
                        }
                    }

                    await action()
                    progressViewTask?.cancel()

                    isDisabled = false
                    showProgressView = false
                }
            },
            label: {
                ZStack {
                    label().opacity(showProgressView ? 0 : 1)

                    if showProgressView {
                        ProgressView()
                    }
                }
            }
        )
        .disabled(isDisabled)
    }
}

@available(iOS 14.0, *)
public extension AsyncButton where Label == Text {
    init(_ label: String,
         actionOptions _: Set<ActionOption> = Set(ActionOption.allCases),
         action: @escaping () async -> Void)
    {
        self.init(action: action) {
            Text(label)
        }
    }
}

@available(iOS 14.0, *)
public extension AsyncButton where Label == Image {
    init(systemImageName: String,
         actionOptions _: Set<ActionOption> = Set(ActionOption.allCases),
         action: @escaping () async -> Void)
    {
        self.init(action: action) {
            Image(systemName: systemImageName)
        }
    }
}

@available(iOS 14.0, *)
public extension AsyncButton {
    enum ActionOption: CaseIterable {
        case disableButton
        case showProgressView
    }
}
