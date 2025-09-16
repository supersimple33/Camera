#if os(iOS)
//
//  CaptureDeviceInput.swift of MijickCamera
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2024 Mijick. All rights reserved.


import AVKit

protocol CaptureDeviceInput: NSObject {
    // MARK: Attributes
    associatedtype CD: CaptureDevice
    var device: CD { get }

    // MARK: Methods
    static func get(mediaType: AVMediaType, position: AVCaptureDevice.Position?) -> Self?
}
#endif
