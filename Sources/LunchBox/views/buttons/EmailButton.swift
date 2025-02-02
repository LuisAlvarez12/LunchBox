//
//  EmailButton.swift
//
//
//  Created by Luis Alvarez on 9/13/23.
//

import SwiftUI

/// Adds email button functionality to a view
@available(iOS 16.0, *)
public extension View {
    /// Wraps a view in an email button that opens the mail app when tapped
    /// - Parameters:
    ///   - email: The recipient email address
    ///   - subject: The subject line of the email
    ///   - emailBody: The body content of the email
    /// - Returns: A view that opens the mail app when tapped
    func emailButton(email: String = "team@rezonating.app", subject: String, emailBody: String) -> some View {
        EmailButton(email: email, subject: subject, emailBody: emailBody, content: {
            self
        })
    }
}

extension UIApplication {
    /// Opens the mail app with pre-filled email content
    /// - Parameters:
    ///   - email: The recipient email address
    ///   - subject: The subject line of the email
    ///   - emailBody: The body content of the email
    func sendEmail(email: String = "team@rezonating.app", subject: String, emailBody: String) {
        let coded = "mailto:\(email)?subject=\(subject)&body=\(emailBody)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        if let emailURL = URL(string: coded!) {
            if UIApplication.shared.canOpenURL(emailURL) {
                UIApplication.shared.open(emailURL, options: [:], completionHandler: { result in
                    if !result {
                        // show some Toast or error alert
                        // ("Your device is not currently configured to send mail.")
                    }
                })
            }
        }
    }
}

/// A button that opens the mail app with pre-filled content when tapped
@available(iOS 16.0, *)
public struct EmailButton<Content>: View where Content: View {
    /// The recipient email address
    public var email: String = "team@rezonating.app"
    /// The subject line of the email
    public let subject: String
    /// The body content of the email
    public let emailBody: String

    /// The view builder for the button's content
    @ViewBuilder public var content: () -> Content

    /// Creates a new email button
    /// - Parameters:
    ///   - email: The recipient email address
    ///   - subject: The subject line of the email
    ///   - emailBody: The body content of the email
    ///   - content: A closure that creates the button's content view
    public init(email: String, subject: String, emailBody: String, content: @escaping () -> Content) {
        self.email = email
        self.subject = subject
        self.emailBody = emailBody
        self.content = content
    }

    public var body: some View {
        Button(action: {
            UIApplication.shared.sendEmail(email: email, subject: subject, emailBody: emailBody)
        }, label: {
            content()
        })
    }
}

// #Preview {
//    EmailButton(subject: "", emailBody: <#T##LocalizedStringKey#>, content: <#T##() -> _#>)
// }
