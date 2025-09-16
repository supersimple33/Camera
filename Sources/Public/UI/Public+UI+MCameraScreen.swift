#if os(iOS)
//
//  Public+UI+MCameraScreen.swift of MijickCamera
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2024 Mijick. All rights reserved.


import SwiftUI
import AVFoundation
import MijickTimer

/**
 Screen that displays the camera view and manages camera actions.

 - important: A view conforming to **MCameraScreen** has to be passed directly to ``MCamera``. See ``MCamera/setCameraScreen(_:)`` for more details.

 ## Usage
 ```swift
 struct ContentView: View {
    var body: some View {
        MCamera()
            .setCameraScreen(CustomCameraErrorScreen.init)

            // MUST BE CALLED!
            .startSession()
    }
 }

 // MARK: Custom Camera Screen
 struct CustomCameraScreen: MCameraScreen {
    @ObservedObject var cameraManager: CameraManager
    let namespace: Namespace.ID
    let closeMCameraAction: () -> ()


    var body: some View {
        VStack(spacing: 0) {
            createNavigationBar()
            createCameraOutputView()
            createCaptureButton()
        }
    }
 }
 private extension CustomCameraScreen {
    func createNavigationBar() -> some View {
        Text("This is a Custom Camera View")
            .padding(.top, 12)
            .padding(.bottom, 12)
    }
    func createCaptureButton() -> some View {
        Button(action: captureOutput) { Text("Click to capture") }
            .padding(.top, 12)
            .padding(.bottom, 12)
    }
 }
 ```
 */
public protocol MCameraScreen: View {
    var cameraManager: CameraManager { get }
    var namespace: Namespace.ID { get }
    var closeMCameraAction: () -> () { get }
}

// MARK: Methods
public extension MCameraScreen {
    /**
     View that displays the camera output.

     ## Usage
     ```swift
     struct CustomCameraScreen: MCameraScreen {
        @ObservedObject var cameraManager: CameraManager
        let namespace: Namespace.ID
        let closeMCameraAction: () -> ()


        var body: some View {
            (...)
            createCameraOutputView()
            (...)
        }
     }
     ```
     */
    func createCameraOutputView() -> some View { CameraBridgeView(cameraManager: cameraManager).equatable() }
}
public extension MCameraScreen {
    /**
     Capture the current camera output.

     The output type depends on what ``cameraOutputType`` is set to.
     */
    func captureOutput() { cameraManager.captureOutput() }

    /**
     Set the output type of the camera.

     For available options, please refer to the ``CameraOutputType`` documentation.
     */
    func setOutputType(_ outputType: CameraOutputType) { cameraManager.setOutputType(outputType) }

    /**
     Set the camera position.

     For available options, please refer to the ``CameraPosition`` documentation.

     - note: If the selected camera position is not available, the camera will not be changed.
     */
    func setCameraPosition(_ cameraPosition: CameraPosition) async throws { try await cameraManager.setCameraPosition(cameraPosition) }

    /**
     Set the zoom factor of the camera.

     - note: If the zoom factor is out of bounds, it will be set to the closest available value.
     */
    func setZoomFactor(_ zoomFactor: CGFloat) throws { try cameraManager.setCameraZoomFactor(zoomFactor) }

    /**
     Set the flash mode of the camera.

     For available options, please refer to the ``CameraFlashMode`` documentation.

     - note: If the selected flash mode is not available, the flash mode will not be changed.
     */
    func setFlashMode(_ flashMode: CameraFlashMode) { cameraManager.setFlashMode(flashMode) }

    /**
     Set the light mode of the camera.

     For available options, please refer to the ``CameraLightMode`` documentation.

     - note: If the selected light mode is not available, the light mode will not be changed.
     */
    func setLightMode(_ lightMode: CameraLightMode) throws { try cameraManager.setLightMode(lightMode) }

    /**
     Set the camera resolution.

     - important: Changing the resolution may affect the maximum frame rate that can be set.
     */
    func setResolution(_ resolution: AVCaptureSession.Preset) { cameraManager.setResolution(resolution) }

    /**
     Set the camera frame rate.

     - important: Changing the resolution may affect the maximum frame rate that can be set.
     - note: If the frame rate is out of bounds, it will be set to the closest available value.
     */
    func setFrameRate(_ frameRate: Int32) throws { try cameraManager.setFrameRate(frameRate) }

    /**
     Set the camera exposure duration.

     - note: If the exposure duration is out of bounds, it will be set to the closest available value.
     */
    func setExposureDuration(_ exposureDuration: CMTime) throws { try cameraManager.setExposureDuration(exposureDuration) }

    /**
     Set the camera exposure target bias.

     - note: If the target bias is out of bounds, it will be set to the closest available value.
     */
    func setExposureTargetBias(_ exposureTargetBias: Float) throws { try cameraManager.setExposureTargetBias(exposureTargetBias) }

    /**
     Set the camera ISO.

     - note: If the ISO is out of bounds, it will be set to the closest available value.
     */
    func setISO(_ iso: Float) throws { try cameraManager.setISO(iso) }

    /**
     Set the camera exposure mode.

     - note: If the exposure mode is not supported, the exposure mode will not be changed.
     */
    func setExposureMode(_ exposureMode: AVCaptureDevice.ExposureMode) throws { try cameraManager.setExposureMode(exposureMode) }

    /**
     Set the camera HDR mode.

     For available options, please refer to the ``CameraHDRMode`` documentation.
     */
    func setHDRMode(_ hdrMode: CameraHDRMode) throws { try cameraManager.setHDRMode(hdrMode) }

    /**
     Set the camera filters to be applied to the camera output.

     - important: Setting multiple filters simultaneously can affect the performance of the camera.
     */
    func setCameraFilters(_ filters: [CIFilter]) { cameraManager.setCameraFilters(filters) }

    /**
     Set whether the camera output should be mirrored.
     */
    func setMirrorOutput(_ shouldMirror: Bool) { cameraManager.setMirrorOutput(shouldMirror) }

    /**
     Set whether the camera grid should be visible.
     */
    func setGridVisibility(_ shouldShowGrid: Bool) { cameraManager.setGridVisibility(shouldShowGrid) }
}

// MARK: Attributes
public extension MCameraScreen {
    var cameraOutputType: CameraOutputType { cameraManager.attributes.outputType }
    var cameraPosition: CameraPosition { cameraManager.attributes.cameraPosition }
    var zoomFactor: CGFloat { cameraManager.attributes.zoomFactor }
    var flashMode: CameraFlashMode { cameraManager.attributes.flashMode }
    var lightMode: CameraLightMode { cameraManager.attributes.lightMode }
    var resolution: AVCaptureSession.Preset { cameraManager.attributes.resolution }
    var frameRate: Int32 { cameraManager.attributes.frameRate }
    var exposureDuration: CMTime { cameraManager.attributes.cameraExposure.duration }
    var exposureTargetBias: Float { cameraManager.attributes.cameraExposure.targetBias }
    var iso: Float { cameraManager.attributes.cameraExposure.iso }
    var exposureMode: AVCaptureDevice.ExposureMode { cameraManager.attributes.cameraExposure.mode }
    var hdrMode: CameraHDRMode { cameraManager.attributes.hdrMode }
    var cameraFilters: [CIFilter] { cameraManager.attributes.cameraFilters }
    var isOutputMirrored: Bool { cameraManager.attributes.mirrorOutput }
    var isGridVisible: Bool { cameraManager.attributes.isGridVisible }
}
public extension MCameraScreen {
    var hasFlash: Bool { cameraManager.hasFlash }
    var hasLight: Bool { cameraManager.hasLight }
    var recordingTime: MTime { cameraManager.videoOutput.recordingTime }
    var isRecording: Bool { cameraManager.videoOutput.timer.timerStatus == .running }
    var isOrientationLocked: Bool { cameraManager.attributes.orientationLocked || cameraManager.attributes.userBlockedScreenRotation }
    var deviceOrientation: AVCaptureVideoOrientation { cameraManager.attributes.deviceOrientation }
}
#endif
