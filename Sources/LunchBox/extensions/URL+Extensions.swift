//
//  URL+Extensions.swift
//
//
//  Created by Luis Alvarez on 9/13/23.
//

import SwiftUI

@available(iOS 16.0, *)
public extension URL {
    func subDirectories() throws -> [URL] {
        // @available(macOS 10.11, iOS 9.0, *)
        guard hasDirectoryPath else { return [] }
        return try FileManager.default.contentsOfDirectory(
            at: self, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles]
        ).filter(\.hasDirectoryPath)
    }

    func isImage() -> Bool {
        pathExtension.lowercased() == "png" || pathExtension.lowercased() == "jpg" || pathExtension.lowercased() == "heic"
            || pathExtension.lowercased() == "jpeg" || pathExtension.lowercased() == "webp"
    }

    func isCompressed() -> Bool {
        pathExtension.lowercased() == "zip" || pathExtension.lowercased() == "cbr" || pathExtension.lowercased() == "cbz"
    }

    func toUIImage() -> UIImage {
        return try! UIImage(data: Data(contentsOf: self)) ?? UIImage()
    }

    func toUIImage() async -> UIImage {
        try! UIImage(data: Data(contentsOf: self)) ?? UIImage()
    }

    func toNullableUIIMage(withPercentage: CGFloat = 0.5) async -> UIImage? {
        try? UIImage(data: Data(contentsOf: self))?.resized(withPercentage: withPercentage)
    }

    var isDirectory: Bool {
        (try? resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory == true
    }

    var attributes: [FileAttributeKey: Any]? {
        do {
            return try FileManager.default.attributesOfItem(atPath: path)
        } catch let error as NSError {
            print("FileAttribute error: \(error)")
        }
        return nil
    }

    var fileSize: UInt64 {
        return attributes?[.size] as? UInt64 ?? UInt64(0)
    }

    var fileSizeString: String {
        return ByteCountFormatter.string(fromByteCount: Int64(fileSize), countStyle: .file)
    }

    var creationDate: Date? {
        return attributes?[.creationDate] as? Date
    }
}
