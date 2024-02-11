
//
//  URLComposerManager.swift
//  UnderCovers
//
//  Created by Luis Alvarez on 7/28/23.
//

import SwiftUI

public struct URLComposerManager {
    public static let shared = URLComposerManager()

    public func toURL(urlComponent: String) async -> URL? {
        let imageURL = await LunchboxFileManager.shared.addBasePathForURL(fileURLpath: urlComponent)
        return imageURL
    }

    public func toComponent(url: URL?) async -> String {
        guard let _url = url else { return "" }

        let docspath: String
        if _url.absoluteString.localizedCaseInsensitiveContains("file:///private/") {
            docspath = URL.documentsDirectory.absoluteString.replacingOccurrences(
                of: "file:///", with: "file:///private/"
            )
        } else {
            docspath = URL.documentsDirectory.absoluteString
        }

        return _url.absoluteString.removingPercentEncoding?.replacingOccurrences(of: docspath, with: "") ?? _url.absoluteString.replacingOccurrences(of: docspath, with: "")
    }
}
