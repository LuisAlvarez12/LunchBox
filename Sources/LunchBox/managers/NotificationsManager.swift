//
//  NotificationsManager.swift
//
//
//  Created by Luis Alvarez on 9/14/23.
//

import SwiftUI

@Observable
class NotificationsManager {
    var notificationMessage: AlertMessage? = nil

    static var shared = NotificationsManager()

    private var currentTask: Task<Void, Never>?

    func showMessage(_ msg: LocalizedStringKey) {
        updateAlert(alertMessage: AlertMessage(message: msg, color: .blue))
    }

    func showLoading() {
        HapticsManager.shared.onGeneral()

        withAnimation(.easeIn(duration: 0.1)) {
            notificationMessage = AlertMessage(message: "Setting up your Files", color: .blue, isLoading: true)
        }
    }

    func error(_ msg: LocalizedStringKey) {
        updateAlert(alertMessage: AlertMessage(message: msg, color: Color.red))
    }

    func updateAlert(alertMessage: AlertMessage) {
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

struct SimpleNotificationView: View {
    @Environment(\.colorScheme) var colorScheme

    let title: LocalizedStringKey
    let image: String
    var color: Color = .blue
    var loading: Bool = false

    var body: some View {
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
                .foregroundColor(Color.LBMonoScreenOffTone)
                .vertPadding(10)

        }.horPadding(16).background {
            Capsule().fill(Material.thin)
                .shadow(radius: 2)
        }
    }
}

struct AlertMessage {
    let message: LocalizedStringKey
    var color: Color = .blue
    var imageName: String = "info.circle.fill"
    var isLoading: Bool = false
}

struct FloatingNotice: View {
    let alertMessage: AlertMessage

    var body: some View {
        SimpleNotificationView(title: alertMessage.message, image: alertMessage.imageName, color: alertMessage.color)
    }
}
