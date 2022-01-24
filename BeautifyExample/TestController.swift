//
//  TestController.swift
//  BeautifyExample
//
//  Created by zhaoyongqiang on 2022/1/18.
//  Copyright © 2022 Agora. All rights reserved.
//

import Foundation

class TestController: UIViewController {
    private var rtcEnginer: AgoraRtcEngineKit?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rtcEnginer = AgoraRtcEngineKit()

    }
    
}

extension TestController: AgoraVideoFrameDelegate {
    func onCapture(_ srcFrame: AgoraOutputVideoFrame, dstFrame: AutoreleasingUnsafeMutablePointer<AgoraOutputVideoFrame?>?) -> Bool {
        let pixelBuffer = SenseMeFilter.shareManager().processFrame(srcFrame.pixelBuffer)
        srcFrame.pixelBuffer = pixelBuffer?.takeUnretainedValue()
        dstFrame?.pointee = srcFrame;
        return true
    }
}
