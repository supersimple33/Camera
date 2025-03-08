//
//  CameraManager+NotificationCenter.swift of MijickCamera
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2024 Mijick. All rights reserved.


import Foundation
import UIKit

@MainActor class CameraManagerNotificationCenter {
    private var isActive = true
    private(set) weak var parent: CameraManager!
    
    init() { observeAppCycle() }
    deinit { NotificationCenter.default.removeObserver(self) }
}

// MARK: Setup
extension CameraManagerNotificationCenter {
    func setup(parent: CameraManager) {
        self.parent = parent
        NotificationCenter.default.addObserver(self, selector: #selector(handleSessionWasInterrupted), name: .AVCaptureSessionWasInterrupted, object: self.parent?.captureSession)
    }
}
private extension CameraManagerNotificationCenter {
    func observeAppCycle() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleAppBecomeActive), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleAppEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
}
private extension CameraManagerNotificationCenter {
    @objc func handleSessionWasInterrupted() {
        parent?.attributes.lightMode = .off
        parent?.videoOutput.reset()
    }
    @objc func handleAppBecomeActive() { Task { @MainActor in
        guard !isActive else { return }
        guard !isSessionRunning else { return }
        isActive = true
        await Task.sleep(seconds: 0.3) // need a time to make ui ready to read new state
        try await parent?.setup()
    }}
    @objc func handleAppEnterBackground() {
        guard isSessionRunning else { return } // checks if it's an active camera
        parent?.cancel()
        isActive = false
    }
}
private extension CameraManagerNotificationCenter {
    var isSessionRunning: Bool { parent?.captureSession.isRunning == true }
}

// MARK: Reset
extension CameraManagerNotificationCenter {
    func reset() {
        NotificationCenter.default.removeObserver(self, name: .AVCaptureSessionWasInterrupted, object: parent?.captureSession)
    }
}
