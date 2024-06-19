//
//  EmailButton.swift
//
//
//  Created by Luis Alvarez on 9/13/23.
//

import SwiftUI

@available(iOS 16.0, *)
public extension View {
    func emailButton(email: String = "team@rezonating.app", subject: String, emailBody: String) -> some View {
        EmailButton(email: email, subject: subject, emailBody: emailBody, content: {
            self
        })
    }
}

extension UIApplication {
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

@available(iOS 16.0, *)
public struct EmailButton<Content>: View where Content: View {
    public var email: String = "team@rezonating.app"
    public let subject: String
    public let emailBody: String

    @ViewBuilder public var content: () -> Content

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
