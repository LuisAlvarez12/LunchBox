//
//  AsyncButton.swift
//
//
//  Created by Luis Alvarez on 9/14/23.
//

import SwiftUI

/// A button that handles asynchronous actions with optional loading indicators
@available(iOS 16.0, *)
public struct AsyncButton<Label: View>: View {
    /// The asynchronous action to perform when the button is tapped
    var action: () async -> Void
    /// Options for button behavior during action execution
    var actionOptions = Set(ActionOption.allCases)
    /// The view builder for the button's label
    @ViewBuilder var label: () -> Label

    /// Whether the button is currently disabled
    @State private var isDisabled = false
    /// Whether to show the progress view
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

@available(iOS 16.0, *)
public extension AsyncButton where Label == Text {
    /// Creates an async button with a text label
    /// - Parameters:
    ///   - label: The text to display on the button
    ///   - actionOptions: Options for button behavior during action execution
    ///   - action: The asynchronous action to perform when tapped
    init(_ label: String,
         actionOptions: Set<ActionOption> = Set(ActionOption.allCases),
         action: @escaping () async -> Void)
    {
        self.init(action: action) {
            Text(label)
        }
    }
}

@available(iOS 16.0, *)
public extension AsyncButton where Label == Image {
    /// Creates an async button with a system image
    /// - Parameters:
    ///   - systemImageName: The name of the system image to display
    ///   - actionOptions: Options for button behavior during action execution
    ///   - action: The asynchronous action to perform when tapped
    init(systemImageName: String,
         actionOptions: Set<ActionOption> = Set(ActionOption.allCases),
         action: @escaping () async -> Void)
    {
        self.init(action: action) {
            Image(systemName: systemImageName)
        }
    }
}

@available(iOS 16.0, *)
public extension AsyncButton {
    /// Options for controlling button behavior during async action execution
    enum ActionOption: CaseIterable {
        /// Disables the button while the action is executing
        case disableButton
        /// Shows a progress view while the action is executing
        case showProgressView
    }
}
