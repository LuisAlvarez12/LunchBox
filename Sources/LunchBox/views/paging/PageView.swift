//
//  PageView.swift
//
//
//  Created by Luis Alvarez on 9/14/23.
//

import SwiftUI

@available(iOS 16.0, *)
public struct PagingView<Page: View>: View {
    var pages: [Page]
    @Binding var currentPage: Int

    public var body: some View {
        PageViewController(pages: pages, currentPage: $currentPage)
    }
}

@available(iOS 16.0.0, *)
struct PageView_Extensions_Previews: PreviewProvider {
    static var previews: some View {
        StatefulPreviewWrapper(1, content: {
            PagingView(pages: [Color.red, Color.blue, Color.green], currentPage: $0)
        })
    }
}

/**
 Internal controller
 */
@available(iOS 16.0, *)
public struct PageViewController<Page: View>: UIViewControllerRepresentable {
    var pages: [Page]

    @Binding var currentPage: Int

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    public func makeUIViewController(context: Context) -> UIPageViewController {
        let pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal
        )
        pageViewController.view.backgroundColor = UIColor.clear
        pageViewController.dataSource = context.coordinator
        pageViewController.delegate = context.coordinator
        if pages.count == 1 {
            pageViewController.disableSwipeGesture()
        }

        return pageViewController
    }

    public func updateUIViewController(_ pageViewController: UIPageViewController, context: Context) {
        let count = pageViewController.viewControllers
        pageViewController.setViewControllers(
            [context.coordinator.controllers[currentPage]], direction: .forward, animated: true
        )
    }

    public class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
        var parent: PageViewController
        var controllers = [UIViewController]()

        init(_ pageViewController: PageViewController) {
            parent = pageViewController
            controllers = parent.pages.map { UIHostingController(rootView: $0) }
        }

        public func pageViewController(
            _: UIPageViewController,
            viewControllerBefore viewController: UIViewController
        ) -> UIViewController? {
            guard let index = controllers.firstIndex(of: viewController) else {
                return nil
            }
            if index == 0 {
                return controllers.last
            }
            return controllers[index - 1]
        }

        public func pageViewController(
            _: UIPageViewController,
            viewControllerAfter viewController: UIViewController
        ) -> UIViewController? {
            guard let index = controllers.firstIndex(of: viewController) else {
                return nil
            }
            if index + 1 == controllers.count {
                return controllers.first
            }
            return controllers[index + 1]
        }

        public func pageViewController(
            _ pageViewController: UIPageViewController,
            didFinishAnimating _: Bool,
            previousViewControllers _: [UIViewController],
            transitionCompleted completed: Bool
        ) {
            if completed,
               let visibleViewController = pageViewController.viewControllers?.first,
               let index = controllers.firstIndex(of: visibleViewController)
            {
                parent.currentPage = index
            }
        }
    }
}

@available(iOS 16.0, *)
public extension UIPageViewController {
    func enableSwipeGesture() {
        for view in view.subviews {
            if let subView = view as? UIScrollView {
                subView.isScrollEnabled = true
            }
        }
    }

    func disableSwipeGesture() {
        for view in view.subviews {
            if let subView = view as? UIScrollView {
                subView.isScrollEnabled = false
            }
        }
    }
}
