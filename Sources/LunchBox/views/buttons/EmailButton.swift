//
//  EmailButton.swift
//  
//
//  Created by Luis Alvarez on 9/13/23.
//

import SwiftUI

@available(iOS 13.0, *)
public struct EmailButton<Content>: View where Content: View {
    var email: String = "team@rezonating.app"
    let subject: LocalizedStringKey
    let emailBody: LocalizedStringKey

    @ViewBuilder var content: () -> Content

    public var body: some View {
        Button(action: {
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
        }, label: {
            content()
        })
    }
}

//#Preview {
//    EmailButton(subject: "", emailBody: <#T##LocalizedStringKey#>, content: <#T##() -> _#>)
//}
