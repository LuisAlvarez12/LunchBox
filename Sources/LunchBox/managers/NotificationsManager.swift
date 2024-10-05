//
//  NotificationsManager.swift
//
//
//  Created by Luis Alvarez on 9/14/23.
//

import SwiftUI

@Observable
public class NotificationsManager {
    public var notificationMessage: AlertMessage? = nil

    public static var shared = NotificationsManager()

    private var currentTask: Task<Void, Never>?

    public func showMessage(_ msg: LocalizedStringKey) {
        updateAlert(alertMessage: AlertMessage(message: msg, color: .blue))
    }

    public func showLoading() {
        HapticsManager.shared.onGeneral()

        withAnimation(.easeIn(duration: 0.1)) {
            notificationMessage = AlertMessage(message: "Setting up your Files", color: .blue, isLoading: true)
        }
    }

    public  func error(_ msg: LocalizedStringKey) {
        updateAlert(alertMessage: AlertMessage(message: msg, color: Color.red))
    }

    public func updateAlert(alertMessage: AlertMessage) {
        HapticsManager.shared.onGeneral()

        withAnimation(.easeIn(duration: 0.1)) {
            notificationMessage = alertMessage
        }
        currentTask?.cancel()
        currentTask = hideAlertTask()
    }

    private func hideAlertTask() -> Task<Void, Never> {
        return Task {
            try? await Task.sleep(nanoseconds: 1.nano())
            if Task.isCancelled {
                return
            }

            await MainActor.run {
                withAnimation(.easeIn(duration: 0.2)) {
                    notificationMessage = nil
                }
            }
        }
    }
}

private struct FloatingNoticeTestView: View {
    @State var notificationsHelper: NotificationsManager = .shared

    var body: some View {
        VStack {
            Button("Show Alert", action: {
                notificationsHelper.showMessage("Hello!")
            })
        }.full()
    }
}

struct FloatingNotice_Previews: PreviewProvider {
    static var previews: some View {
        FloatingNoticeTestView()
    }
}

public struct SimpleNotificationView: View {
    @Environment(\.colorScheme) var colorScheme

    public let title: LocalizedStringKey
    public let image: String
    public var color: Color = .blue
    public var loading: Bool = false
    
    public init(title: LocalizedStringKey, image: String, color: Color = .blue, loading: Bool = false) {
        self.title = title
        self.image = image
        self.color = color
        self.loading = loading
    }

    public var body: some View {
        HStack(alignment: .center) {
            if loading {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(.white)
                    .padding(6)
                    .background(Circle().fill(color.gradient))
                    .vertPadding(4)
            } else {
                Image(systemName: image)
                    .foregroundColor(.white)
                    .font(.system(size: 20, weight: .medium, design: .rounded))
                    .padding(6)
                    .background(Circle().fill(color.gradient))
                    .vertPadding(4)
            }

            Text(title)
                .autoFit(size: 18, weight: .medium, design: .rounded)
                .foregroundColor(AppThemeManager.shared.currentTheme.background)
                .vertPadding(10)

        }.horPadding(16).background {
            Capsule().fill(Material.thin)
                .shadow(radius: 2)
        }
    }
}

public struct AlertMessage {
    public let message: LocalizedStringKey
    public var color: Color = .blue
    public var imageName: String = "info.circle.fill"
    public var isLoading: Bool = false
    
    public init(message: LocalizedStringKey, color: Color = .blue, imageName: String = "info.circle.fill", isLoading: Bool = false) {
        self.message = message
        self.color = color
        self.imageName = imageName
        self.isLoading = isLoading
    }
}

public struct FloatingNotice: View {
    public let alertMessage: AlertMessage

    public init(alertMessage: AlertMessage) {
        self.alertMessage = alertMessage
    }
    
    public var body: some View {
        SimpleNotificationView(title: alertMessage.message, image: alertMessage.imageName, color: alertMessage.color)
    }
}
