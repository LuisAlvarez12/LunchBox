//
//  SafariWebView.swift
//  
//
//  Created by Luis Alvarez on 9/13/23.
//

import SafariServices
import SwiftUI

public struct SafariWebView: UIViewControllerRepresentable {
    let url: URL

    public func makeUIViewController(context _: Context) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }

    public func updateUIViewController(_: SFSafariViewController, context _: Context) {}
}

//struct SafariWebView_PreviewProvider : PreviewProvider {
//    static var previews: some View {
//        
//    }
//}
