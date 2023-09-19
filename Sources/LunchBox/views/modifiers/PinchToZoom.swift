//
//  PinchToZoom.swift
//
//
//  Created by Luis Alvarez on 9/14/23.
//

import SwiftUI
import UIKit

//
//  CabinitImage.swift
//  Cabinit
//
//  Created by Luis Alvarez on 9/16/21.
//

@available(iOS 16.0, *)
class PinchZoomView: UIView {
    weak var delegate: PinchZoomViewDelgate?

    private(set) var scale: CGFloat = 1 {
        didSet {
            delegate?.pinchZoomView(self, didChangeScale: scale)
        }
    }

    private(set) var anchor: UnitPoint = .center {
        didSet {
            delegate?.pinchZoomView(self, didChangeAnchor: anchor)
        }
    }

    private(set) var offset: CGSize = .zero {
        didSet {
            delegate?.pinchZoomView(self, didChangeOffset: offset)
        }
    }

    private(set) var isPinching: Bool = false {
        didSet {
            delegate?.pinchZoomView(self, didChangePinching: isPinching)
        }
    }

    private var lastUUID: UUID = .init()

    func reset(uuid: UUID?) {
        guard uuid != nil, uuid != lastUUID else {
            return
        }
        lastUUID = uuid!
        isPinching = false
        scaleDifference = nil
        scale = 1.0
        anchor = .center
        offset = .zero
    }

    private var startLocation: CGPoint = .zero
    private var location: CGPoint = .zero
    private var numberOfTouches: Int = 0
    private var scaleDifference: CGFloat?

    init() {
        super.init(frame: .zero)

        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinch(gesture:)))
        pinchGesture.cancelsTouchesInView = false
        addGestureRecognizer(pinchGesture)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError()
    }

    @objc private func pinch(gesture: UIPinchGestureRecognizer) {
        switch gesture.state {
        case .began:
            isPinching = true
            startLocation = gesture.location(in: self)
            anchor = UnitPoint(x: startLocation.x / bounds.width, y: startLocation.y / bounds.height)
            numberOfTouches = gesture.numberOfTouches

        case .changed:
            if gesture.numberOfTouches != numberOfTouches {
                // If the number of fingers being used changes, the start location needs to be adjusted to avoid jumping.
                let newLocation = gesture.location(in: self)
                let jumpDifference = CGSize(
                    width: newLocation.x - location.x, height: newLocation.y - location.y
                )
                startLocation = CGPoint(
                    x: startLocation.x + jumpDifference.width, y: startLocation.y + jumpDifference.height
                )

                numberOfTouches = gesture.numberOfTouches
            }

            if let lastScale = scaleDifference {
                if gesture.scale < lastScale {
                    let difference = lastScale - gesture.scale
                    let newScale = scale - difference
                    print("PINCHING OUT :: lastScale = \(lastScale), gesture = \(gesture.scale), diff = \(difference), newScale = \(newScale), currentScale = \(scale)  ")
                    scaleDifference = gesture.scale
                    scale = newScale
                } else if gesture.scale > lastScale {
                    let difference = gesture.scale - lastScale
                    let newScale = scale + difference
                    print("PINCHING IN :: lastScale = \(lastScale), gesture = \(gesture.scale), diff = \(difference), newScale = \(newScale), currentScale = \(scale) ")
                    scaleDifference = gesture.scale
                    scale = newScale
                }
            } else {
                scaleDifference = gesture.scale
            }

            location = gesture.location(in: self)
            offset = CGSize(width: location.x - startLocation.x, height: location.y - startLocation.y)

        case .ended, .cancelled, .failed:
            isPinching = false
            scaleDifference = nil
            if scale < 1 {
                scale = 1.0
                anchor = .center
                offset = .zero
            }

        default:
            break
        }
    }
}

@available(iOS 16.0, *)
protocol PinchZoomViewDelgate: AnyObject {
    func pinchZoomView(_ pinchZoomView: PinchZoomView, didChangePinching isPinching: Bool)
    func pinchZoomView(_ pinchZoomView: PinchZoomView, didChangeScale scale: CGFloat)
    func pinchZoomView(_ pinchZoomView: PinchZoomView, didChangeAnchor anchor: UnitPoint)
    func pinchZoomView(_ pinchZoomView: PinchZoomView, didChangeOffset offset: CGSize)
}

@available(iOS 16.0, *)
struct PinchZoom: UIViewRepresentable {
    @Binding var scale: CGFloat
    @Binding var anchor: UnitPoint
    @Binding var offset: CGSize
    @Binding var isPinching: Bool
    @Binding var shouldReset: UUID?

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> PinchZoomView {
        let pinchZoomView = PinchZoomView()
        pinchZoomView.delegate = context.coordinator
        return pinchZoomView
    }

    func updateUIView(_ pinchView: PinchZoomView, context _: Context) {
        pinchView.reset(uuid: shouldReset)
    }

    class Coordinator: NSObject, PinchZoomViewDelgate {
        var pinchZoom: PinchZoom

        init(_ pinchZoom: PinchZoom) {
            self.pinchZoom = pinchZoom
        }

        func pinchZoomView(_: PinchZoomView, didChangePinching isPinching: Bool) {
            pinchZoom.isPinching = isPinching
        }

        func pinchZoomView(_: PinchZoomView, didChangeScale scale: CGFloat) {
            pinchZoom.scale = scale
        }

        func pinchZoomView(_: PinchZoomView, didChangeAnchor anchor: UnitPoint) {
            pinchZoom.anchor = anchor
        }

        func pinchZoomView(_: PinchZoomView, didChangeOffset offset: CGSize) {
            pinchZoom.offset = offset
        }
    }
}

@available(iOS 16.0, *)
struct PinchToZoom: ViewModifier {
    var onDoubleTap: (() -> Void)? = nil
    @State var scale: CGFloat = 1.0
    @State var anchor: UnitPoint = .center
    @State var offset: CGSize = .zero
    @State var isPinching: Bool = false
    @State var shouldReset: UUID?

    func body(content: Content) -> some View {
        content
            .scaleEffect(scale, anchor: anchor)
            .offset(offset)
            .animation(isPinching ? .none : .spring(), value: offset)
            .overlay(PinchZoom(scale: $scale, anchor: $anchor, offset: $offset, isPinching: $isPinching, shouldReset: $shouldReset))
            .onTapGesture(count: 2, perform: {
                if isPinching {
                    shouldReset = UUID()
                    scale = 1.0
                    anchor = .center
                    offset = .zero
                    isPinching = false
                } else {
                    onDoubleTap?()
                }
            })
    }
}
