//
//  UIImage+Extensions.swift
//  
//
//  Created by Luis Alvarez on 9/14/23.
//

import SwiftUI

@available(iOS 16.0, *)
extension UIImage {
    func scalePreservingAspectRatio(targetSize: CGSize) -> UIImage {
        // Determine the scale factor that preserves aspect ratio
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height

        let scaleFactor = min(widthRatio, heightRatio)

        // Compute the new image size that preserves aspect ratio
        let scaledImageSize = CGSize(
            width: size.width * scaleFactor,
            height: size.height * scaleFactor
        )

        // Draw and return the resized UIImage
        let renderer = UIGraphicsImageRenderer(
            size: scaledImageSize
        )

        let scaledImage = renderer.image { _ in
            self.draw(
                in: CGRect(
                    origin: .zero,
                    size: scaledImageSize
                ))
        }

        return scaledImage
    }

    func rotateCameraImageToProperOrientation(maxResolution: CGFloat = 1080)
        -> UIImage?
    {
        guard let imgRef = cgImage else {
            return nil
        }

        let width = CGFloat(imgRef.width)
        let height = CGFloat(imgRef.height)

        var bounds = CGRect(x: 0, y: 0, width: width, height: height)

        var scaleRatio: CGFloat = 1
        if width > maxResolution || height > maxResolution {
            scaleRatio = min(maxResolution / bounds.size.width, maxResolution / bounds.size.height)
            bounds.size.height = bounds.size.height * scaleRatio
            bounds.size.width = bounds.size.width * scaleRatio
        }

        var transform = CGAffineTransform.identity
        let orient = imageOrientation
        let imageSize = CGSize(width: CGFloat(imgRef.width), height: CGFloat(imgRef.height))

        switch imageOrientation {
        case .up:
            transform = .identity
        case .upMirrored:
            transform = CGAffineTransform(translationX: imageSize.width, y: 0).scaledBy(x: -1.0, y: 1.0)
        case .down:
            transform = CGAffineTransform(translationX: imageSize.width, y: imageSize.height).rotated(by: CGFloat.pi)
        case .downMirrored:
            transform = CGAffineTransform(translationX: 0, y: imageSize.height).scaledBy(x: 1.0, y: -1.0)
        case .left:
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width
            bounds.size.width = storedHeight
            transform = CGAffineTransform(translationX: 0, y: imageSize.width).rotated(by: 3.0 * CGFloat.pi / 2.0)
        case .leftMirrored:
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width
            bounds.size.width = storedHeight
            transform =
                CGAffineTransform(translationX: imageSize.height, y: imageSize.width).scaledBy(x: -1.0, y: 1.0).rotated(by: 3.0 * CGFloat.pi / 2.0)
        case .right:
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width
            bounds.size.width = storedHeight
            transform = CGAffineTransform(translationX: imageSize.height, y: 0).rotated(by: CGFloat.pi / 2.0)
        case .rightMirrored:
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width
            bounds.size.width = storedHeight
            transform = CGAffineTransform(scaleX: -1.0, y: 1.0).rotated(by: CGFloat.pi / 2.0)
        @unknown default:
            print("Unknown")
        }

        UIGraphicsBeginImageContext(bounds.size)
        if let context = UIGraphicsGetCurrentContext() {
            if orient == .right || orient == .left {
                context.scaleBy(x: -scaleRatio, y: scaleRatio)
                context.translateBy(x: -height, y: 0)
            } else {
                context.scaleBy(x: scaleRatio, y: -scaleRatio)
                context.translateBy(x: 0, y: -height)
            }

            context.concatenate(transform)
            context.draw(imgRef, in: CGRect(x: 0, y: 0, width: width, height: height))
        }

        let imageCopy = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return imageCopy
    }

    func resized(withPercentage percentage: CGFloat, isOpaque: Bool = true) -> UIImage? {
        let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }

    func resized(toWidth width: CGFloat, isOpaque: Bool = true) -> UIImage? {
        let canvas = CGSize(width: width, height: CGFloat(ceil(width / size.width * size.height)))
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
}

@available(iOS 16.0, *)
extension Image {
    func centerCropped(maxHeight: CGFloat) -> some View {
        Color.clear
            .overlay(
                resizable()
                    .scaledToFill()
            )
            .frame(idealHeight: maxHeight, maxHeight: maxHeight)
            .clipped()
    }
}
