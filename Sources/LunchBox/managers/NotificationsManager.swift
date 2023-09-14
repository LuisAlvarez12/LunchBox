//
//  NotificationsManager.swift
//  
//
//  Created by Luis Alvarez on 9/14/23.
//

import SwiftUI

@available(iOS 16.0, *)
class NotificationsManager: ObservableObject {
    @Published var isShown = false
    var notificationMessage = AlertMessage(message: "")

    static var shared = NotificationsManager()

    var currentTask: Task<Void, Never>?

    func showMessage(_ msg: LocalizedStringKey) {
        updateAlert(alertMessage: AlertMessage(message: msg))
    }

    func error(_ msg: LocalizedStringKey) {
        updateAlert(alertMessage: AlertMessage(message: msg, color: Color.red))
    }

    func updateAlert(alertMessage: AlertMessage) {
        HapticsManager.shared.onGeneral()

        withAnimation(.easeIn(duration: 0.1)) {
            notificationMessage = alertMessage
            isShown = true
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
                withAnimation(.easeIn(duration: 0.3)) {
                    isShown = false
                }
            }
        }
    }
}

@available(iOS 16.0, *)
struct AlertMessage {
    let message: LocalizedStringKey
    var color: Color = Color.appPrimary
    var imageName: String = "info.circle.fill"
}

@available(iOS 16.0, *)
struct FloatingNotice: View {
    @Binding var showingNotice: Bool
    let alertMessage = NotificationsManager.shared.notificationMessage

    var body: some View {
        SimpleNotificationView(title: alertMessage.message, image: alertMessage.imageName, color: alertMessage.color)
    }
}

@available(iOS 16.0, *)
private struct FloatingNoticeTestView: View {
    @ObservedObject var notificationsHelper: NotificationsManager = .shared

    var body: some View {
        VStack {
            Button("Show Alert", action: {
                notificationsHelper.showMessage("Hello!")
            })
        }.full()
            .overlay(alignment: .top, content: {
                VStack {
//                    FloatingNotice(showingNotice: $notificationsHelper.isShown)
                    SimpleNotificationView(title: "Export Links", image: "square.and.arrow.up")
                    Spacer()
                }.full().opacity(notificationsHelper.isShown ? 1.0 : 0.0)
            })
    }
}

@available(iOS 16.0, *)
struct FloatingNotice_Previews: PreviewProvider {
    static var previews: some View {
        FloatingNoticeTestView()
    }
}

@available(iOS 16.0, *)
struct SimpleNotificationView: View {
    @Environment(\.colorScheme) var colorScheme

    let title: LocalizedStringKey
    let image: String
    var color: Color = .appPrimary

    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: image)
                .foregroundColor(.white)
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .padding(6)
                .background(Circle().fill(color.gradient))
                .vertPadding(4)

            Text(title)
                .autoFit(size: 16, weight: .medium, design: .rounded)
                .foregroundColor(.screenTone)
                .vertPadding(10)

        }.horPadding(16).background {
            Capsule().fill(Material.thin)
                .shadow(radius: 2)
        }
    }
}
