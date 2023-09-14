//
//  URL+Extensions.swift
//  
//
//  Created by Luis Alvarez on 9/13/23.
//

import SwiftUI

@available(iOS 16.0, *)
public extension URL {
    public func subDirectories() throws -> [URL] {
        // @available(macOS 10.11, iOS 9.0, *)
        guard hasDirectoryPath else { return [] }
        return try FileManager.default.contentsOfDirectory(
            at: self, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles]
        ).filter(\.hasDirectoryPath)
    }

    public func isImage() -> Bool {
        pathExtension.lowercased() == "png" || pathExtension.lowercased() == "jpg" || pathExtension.lowercased() == "heic"
            || pathExtension.lowercased() == "jpeg" || pathExtension.lowercased() == "webp"
    }

    public func isCompressed() -> Bool {
        pathExtension.lowercased() == "zip" || pathExtension.lowercased() == "cbr" || pathExtension.lowercased() == "cbz"
    }

    public  func toUIImage() -> UIImage {
        return try! UIImage(data: Data(contentsOf: self)) ?? UIImage()
    }

    public  func toUIImage() async -> UIImage {
        try! UIImage(data: Data(contentsOf: self)) ?? UIImage()
    }

    public  func toNullableUIIMage(withPercentage: CGFloat = 0.5) async -> UIImage? {
        try? UIImage(data: Data(contentsOf: self))?.resized(withPercentage: withPercentage)
    }

    public  var isDirectory: Bool {
        (try? resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory == true
    }

    public var attributes: [FileAttributeKey: Any]? {
        do {
            return try FileManager.default.attributesOfItem(atPath: path)
        } catch let error as NSError {
            print("FileAttribute error: \(error)")
        }
        return nil
    }

    public  var fileSize: UInt64 {
        return attributes?[.size] as? UInt64 ?? UInt64(0)
    }

    public  var fileSizeString: String {
        return ByteCountFormatter.string(fromByteCount: Int64(fileSize), countStyle: .file)
    }

    public  var creationDate: Date? {
        return attributes?[.creationDate] as? Date
    }
}

