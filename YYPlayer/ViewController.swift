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
        print("here")
    }
    
    /// 移除观察者
    deinit {
        playerItem.removeObserver(self, forKeyPath: "loadedTimeRanges")
        playerItem.removeObserver(self, forKeyPath: "status")
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

