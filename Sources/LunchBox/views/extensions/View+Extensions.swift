//
//  View+Extensions.swift
//
//
//  Created by Luis Alvarez on 9/13/23.
//

import SwiftUI

@available(iOS 16.0, *)
public extension View {
    func geoHeight(proxy: GeometryProxy, ratio: Double, fullWidth: Bool = false) -> some View {
        let r = proxy.size.height * ratio

        if fullWidth {
            return frame(idealWidth: .infinity, maxWidth: .infinity, idealHeight: r, maxHeight: r)
        } else {
            return frame(idealHeight: r, maxHeight: r)
        }
    }

    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }

    func geoWidth(proxy: GeometryProxy, ratio: Double, fullHeight: Bool = false) -> some View {
        let r = proxy.size.width * ratio

        if fullHeight {
            return frame(idealWidth: r, maxWidth: r, idealHeight: .infinity, maxHeight: .infinity)
        } else {
            return frame(idealWidth: r, maxWidth: r)
        }
    }

    func hideTopSeperator() -> some View {
        listRowSeparator(.hidden, edges: .top)
    }

    func hideBottomSeperator() -> some View {
        listRowSeparator(.hidden, edges: .bottom)
    }

    func aligned() -> some View {
        frame(maxWidth: .infinity, alignment: .leading)
    }

    func horPadding(_ value: CGFloat = 16) -> some View {
        padding([.leading, .trailing], value)
    }

    func vertPadding(_ value: CGFloat = 16) -> some View {
        padding([.top, .bottom], value)
    }

    func triPad(_ value: CGFloat = 16) -> some View {
        padding([.top, .leading, .trailing], value)
    }

    func embedInNavigationView() -> some View {
        NavigationView {
            self
        }
    }

    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }

    func full() -> some View {
        frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    func fullWidth() -> some View {
        frame(maxWidth: .infinity)
    }

    func fullWidth(alignment: Alignment) -> some View {
        frame(maxWidth: .infinity, alignment: alignment)
    }

    func fullHeight() -> some View {
        frame(idealHeight: .infinity, maxHeight: .infinity)
    }

    func squareFrame(length: CGFloat) -> some View {
        frame(width: length, height: length)
    }

    func withTitle(_ title: LocalizedStringKey) -> some View {
        VStack {
            Text(title).font(.system(size: 32, weight: .heavy, design: .default)).aligned().padding(.top, 24).padding(.leading, 16)
            self
        }
    }

    func bottomGravity() -> some View {
        VStack(spacing: 0) {
            Spacer()
            self
        }
    }

    func autoFit(size: CGFloat = 1000, weight: Font.Weight = .regular, design: Font.Design = .default) -> some View {
        font(.system(size: size, weight: weight, design: design)).minimumScaleFactor(0.01)
    }

    func clearListBackground() -> some View {
        modifier(ClearListBackgroundModifier())
    }

    func pinchToZoom(onDoubleTap: (() -> Void)? = nil) -> some View {
        modifier(PinchToZoom(onDoubleTap: onDoubleTap))
    }

    func animatesIn(offset: CGFloat = 40, duration: Double = 0.7) -> some View {
        modifier(AnimatesIn(offSet: offset, duration: duration))
    }

    func sheetCompat<Content>(isPresented: Binding<Bool>, onDismiss: (() -> Void)? = nil, @ViewBuilder content: @escaping () -> Content) -> some View where Content: View {
        if #available(iOS 16.0, *) {
            return self.sheet(isPresented: isPresented, onDismiss: onDismiss) {
                content().presentationDetents([.medium, .large])
            }
        } else {
            return sheet(isPresented: isPresented, onDismiss: onDismiss, content: content)
        }
    }
}

@available(iOS 16.0, *)
public struct ClearListBackgroundModifier: ViewModifier {
    public func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content.scrollContentBackground(.hidden)
        } else {
            content
        }
    }
}

@available(iOS 16.0, *)
private struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect, byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

@available(iOS 16.0, *)
public struct AnimatesIn: ViewModifier {
    var offSet: CGFloat
    var duration: Double
    @State var enabled = false

    public func body(content: Content) -> some View {
        content
            .opacity(enabled ? 1.0 : 0.0)
            .transition(.opacity)
            .offset(y: enabled ? 0 : offSet)
            .animation(.easeIn(duration: duration).delay(0.3), value: enabled)
            .onAppear {
                print("animating in")
                withAnimation {
                    enabled = true
                }
            }
    }
}

@available(iOS 16.0.0, *)
struct MaxWidthLargeScreenModifier_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello, world!")
            .modifier(MaxWidthLargeScreenModifier(ipadMaxWidth: 300))
    }
}
