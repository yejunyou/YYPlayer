//
//  YYPlayerView.swift
//  YYPlayer
//
//  Created by yejunyou on 2018/6/20.
//  Copyright © 2018年 futureversion. All rights reserved.
//

import UIKit
import AVFoundation

class YYPlayerView: UIView {

    var playerLayer: AVPlayerLayer?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = self.bounds
    }

}
