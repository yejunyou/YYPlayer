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
    func yyplayer(_ player: YYPlayerView, playOrPause playButton: UIButton)
}

class YYPlayerView: UIView {

    weak var delegate: YYPlayerViewDelegate?
    public var playerLayer: AVPlayerLayer?
    public var isSliding: Bool = true
    public var isPlaying: Bool = true
    
    override func awakeFromNib() {
        
        addSubview(timeLabel)
        addSubview(slider)
        addSubview(progressView)
        addSubview(playButton)
        
        slider.addTarget(self, action: #selector(sliderTouchDown(_:)), for: .touchDown)
        slider.addTarget(self, action: #selector(sliderTouchUpOut(_:)), for: .touchUpOutside)
        slider.addTarget(self, action: #selector(sliderTouchUpOut(_:)), for: .touchUpInside)
        slider.addTarget(self, action: #selector(sliderTouchUpOut(_:)), for: .touchCancel)
    }
    
    @objc func sliderTouchDown(_ slider: UISlider) {
        self.isSliding = true
    }
    
    @objc func sliderTouchUpOut(_ slider: UISlider) {
        delegate?.yyplayer(self, sliderTouchUpOut: slider)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        playerLayer?.frame = self.bounds
        
        
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
        
        progressView.snp.makeConstraints { (make) in
            make.left.right.centerY.equalTo(slider)
            make.height.equalTo(2)
        }
        
        playButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(slider)
            make.left.equalTo(self).offset(10)
            make.width.height.equalTo(30)
        }
    }

    // MARK: ==lazy add==
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
    
    public lazy var progressView: UIProgressView = {
        let p = UIProgressView.init()
        p.tintColor = UIColor.red
        p.progress = 0
        return p
    } ()
    
    public lazy var playButton: UIButton = {
        let button = UIButton.init()
        button.setImage(UIImage.init(named: "BMPlayer_play"), for: .normal)
        button.setImage(UIImage.init(named: "BMPlayer_pause"), for: .selected)
        button.addTarget(self, action: #selector(playOrPause(_:)), for: .touchUpInside)
        return button
    } ()
    
    @objc func playOrPause(_ button: UIButton) {
        // 选中态显示暂停图片
        isPlaying = !isPlaying
        playButton.isSelected = isPlaying == false
        delegate?.yyplayer(self, playOrPause: button)
    }
}
