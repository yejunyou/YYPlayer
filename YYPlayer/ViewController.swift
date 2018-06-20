//
//  ViewController.swift
//  YYPlayer
//
//  Created by yejunyou on 2018/6/20.
//  Copyright © 2018年 futureversion. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet var playerView: YYPlayerView!
    

    var playerItem:AVPlayerItem!
    var avplayer:AVPlayer!
    var playerLayer:AVPlayerLayer!
    var link: CADisplayLink!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 检测连接是否存在 不存在报错
        let urlstring = "https://vd1.bdstatic.com/mda-hg1wrbbae7q25wnr/mda-hg1wrbbae7q25wnr.mp4?playlist=%5B%22hd%22%5D&auth_key=1529483930-0-0-eb797a50b5adc3d722c59009fc7b8267&bcevod_channel=searchbox_feed&pd=wisenatural"
        guard let url = URL(string: urlstring) else { fatalError("连接错误") }
        // 创建视频资源
        playerItem = AVPlayerItem.init(url: url)
        // 监听缓冲进度改变
        playerItem.addObserver(self, forKeyPath: "loadedTimeRanges", options: .new, context: nil)
        // 监听状态改变
        playerItem.addObserver(self, forKeyPath: "status", options: .new, context: nil)
        // 将视频资源赋值给视频播放对象
        self.avplayer = AVPlayer(playerItem: playerItem)
//        avplayer  = AVPlayer.init(playerItem: playerItem)
        // 初始化视频显示layer
        /// 注：下边的方法创建layer失败？！
        playerLayer = AVPlayerLayer(player: avplayer)
//        playerLayer = AVPlayerLayer.init(layer: avplayer)
        // 设置显示模式
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspect
        playerLayer.contentsScale = UIScreen.main.scale
        // 赋值给自定义的View
        self.playerView.playerLayer = self.playerLayer
        // 位置放在最底下
        self.playerView.layer.insertSublayer(playerLayer, at: 0)
        self.playerView.backgroundColor = UIColor.red
        self.playerView.delegate = self
        
        print("here")
        self.link = CADisplayLink.init(target: self, selector: #selector(update))
        self.link.add(to: RunLoop.main, forMode: .defaultRunLoopMode)
    }
    
    @objc func update() -> Void {
        let currentTime = CMTimeGetSeconds(self.avplayer.currentTime())
        let totalTime = TimeInterval.init(playerItem.duration.value)/TimeInterval.init(playerItem.duration.timescale)
        
        // 播放时间
        let timeStr = "\(formatPlayTime(second: currentTime))/\(formatPlayTime(second: totalTime))"
        playerView.timeLabel.text = timeStr
        
        // 不滑动的时候更新进度条
        if self.playerView.isSliding == false {
            playerView.slider.value = Float(currentTime/totalTime)
        }
    }
    
    /// 移除观察者
    deinit {
        playerItem.removeObserver(self, forKeyPath: "loadedTimeRanges")
        playerItem.removeObserver(self, forKeyPath: "status")
    }
    
    /// 秒 -> 时间字符串
    func formatPlayTime(second: TimeInterval) -> String {
        if second.isNaN {
            return "00:00"
        }
        let min: Int = Int(second/60)
        let sec: Int = Int(second.truncatingRemainder(dividingBy: 60))
        return String(format: "%02d:%02d", min, sec)
    }
    
    /// 监听事件
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let playserItem = object as? AVPlayerItem else {return}
        
        if keyPath == "loadedTimeRanges" {
            // 缓冲进度 暂不处理
        }else if keyPath == "status" { // unknown/readyToPlay/failed
            if playserItem.status == .readyToPlay {
                self.avplayer.play()
            }else{
                print("加载异常!")
            }
        }
    }
}

extension ViewController: YYPlayerViewDelegate {
    
    //  滑动条事件
    func yyplayer(_ player: YYPlayerView, sliderTouchUpOut slider: UISlider) {
       
        // 当视频状态为AVPlayerStatusReadyToPlay时才处理
        if avplayer.status == .readyToPlay {
            let duration = slider.value * Float(CMTimeGetSeconds(avplayer.currentItem!.duration))
            let seekTime = CMTimeMake(Int64(duration), 1)
            
            // 指定视频位置
            self.avplayer.seek(to: seekTime) { (b) in
                player.isSliding = false
            }
        }
    }
}
