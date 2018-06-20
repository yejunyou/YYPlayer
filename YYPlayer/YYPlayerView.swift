//
//  YYPlayerView.swift
//  YYPlayer
//
//  Created by yejunyou on 2018/6/20.
//  Copyright © 2018年 futureversion. All rights reserved.
//

import UIKit
import AVFoundation
import SnapKit

// 滑动条事件结束后回调
protocol YYPlayerViewDelegate: NSObjectProtocol {
    func yyplayer(_ player: YYPlayerView, sliderTouchUpOut slider: UISlider)
}

class YYPlayerView: UIView {

    weak var delegate: YYPlayerViewDelegate?
    public var playerLayer: AVPlayerLayer?
    var isSliding: Bool  = true
    
    override func awakeFromNib() {
        slider.addTarget(self, action: #selector(sliderTouchDown(_:)), for: .touchDown)
        slider.addTarget(self, action: #selector(sliderTouchUpOut(_:)), for: .touchUpOutside)
        slider.addTarget(self, action: #selector(sliderTouchUpOut(_:)), for: .touchUpInside)
        slider.addTarget(self, action: #selector(sliderTouchUpOut(_:)), for: .touchCancel)
    }
    
    @objc func sliderTouchDown(_ slider: UISlider) {
        self.isSliding = true
    }
    
    @objc func sliderTouchUpOut(_ slider: UISlider) {
        // YYTODO: 代理处理
        delegate?.yyplayer(self, sliderTouchUpOut: slider)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        playerLayer?.frame = self.bounds
        
        addSubview(timeLabel)
        addSubview(slider)
        
        timeLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self).inset(5)
            make.bottom.equalTo(self).inset(5)
        }
        
        slider.snp.makeConstraints { (make) in
            make.bottom.equalTo(self).inset(5)
            make.left.equalTo(self).offset(50)
            make.right.equalTo(self).inset(100)
            make.height.equalTo(15)
        }
    }

    public lazy var timeLabel: UILabel = {
        let l = UILabel.init()
        l.font = UIFont.systemFont(ofSize: 12)
        l.textColor = UIColor.white
        return l
    } ()
    
    public lazy var slider: UISlider = {
        let s = UISlider.init()
        s.minimumValue = 0
        s.maximumValue = 1
        s.value = 0
        s.minimumTrackTintColor = UIColor.black
        s.maximumTrackTintColor = UIColor.white
        s.setThumbImage(UIImage.init(named: "Artboard"), for: .normal)
        return s
    } ()
}
