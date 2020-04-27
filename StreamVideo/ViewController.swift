//
//  ViewController.swift
//  StreamVideo
//
//  Created by panjianting on 2020/4/17.
//  Copyright © 2020 panjianting. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController {
    
    var videoView:UIView!
    var playControlView:UIView!
    var pauseButton:UIButton!
    var forwardButton:UIButton!
    var backButton:UIButton!
    var fullScreenButton:UIButton!
    var playerLayer:AVPlayerLayer?
    
    
    var videoHeight:CGFloat {
        return CGFloat(9 * self.view.frame.width / 16.0);
    };
    
    var minVideoWidth:CGFloat {
        return CGFloat(self.view.frame.width/3);
    }
    
    var minVideoHeight:CGFloat {
        return CGFloat(9 * minVideoWidth / 16.0)
    }
    
    
    var origHeight: CGFloat {
        return UIScreen.main.bounds.size.height
    }
    
    var origWidth: CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
    var isPlay = false;
    
    var scaleOffset:CGFloat = 1.00;
    
    var isMin = false;
    
    var offsetY:CGFloat = 0;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.videoView = UIView(frame: CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height, width: self.view.bounds.width, height: self.videoHeight));
        self.videoView.backgroundColor = UIColor.black;
        let controlTap = UITapGestureRecognizer(target: self, action: #selector(controlGesture(sender:)));
        self.videoView.addGestureRecognizer(controlTap);
        
        self.view.addSubview(self.videoView);
        
        
        let url = URL(string: "https://bit.ly/3bzwavX")
        let asset = AVAsset(url: url!);
        let playItem = AVPlayerItem(asset: asset);
        let player = AVPlayer(playerItem: playItem);
        self.playerLayer = AVPlayerLayer(player: player);
        self.playerLayer?.frame = self.videoView.bounds
        self.playerLayer?.videoGravity = .resizeAspect
        self.playerLayer?.player?.play();
        self.isPlay = true;
        
        self.videoView.layer.addSublayer(self.playerLayer!);
        
        self.playControlView = UIView(frame: CGRect(x: 0, y: 0, width: self.videoView.frame.width, height: self.videoView.frame.height));
        self.playControlView.backgroundColor = UIColor.darkGray;
        self.playControlView.alpha = 0.7;
        self.videoView.addSubview(self.playControlView);
        
        self.pauseButton = UIButton(frame: CGRect(x: self.playControlView.frame.width/2-15, y: self.playControlView.frame.height/2-15, width: 30, height: 30))
        self.pauseButton.setImage(UIImage(named: "pause"), for: .normal)
        let pauseTap = UITapGestureRecognizer(target: self, action: #selector(pauseGesture(sender:)))
        self.pauseButton.addGestureRecognizer(pauseTap)
        self.playControlView.addSubview(self.pauseButton);
        
        self.backButton = UIButton(frame: CGRect(x: self.playControlView.frame.width/4-15, y: self.playControlView.frame.height/2-15, width: 30, height: 30))
        self.backButton.setImage(UIImage(named: "back"), for: .normal)
        let backTap = UITapGestureRecognizer(target: self, action: #selector(backGesture(sender:)))
        self.backButton.addGestureRecognizer(backTap)
        self.playControlView.addSubview(self.backButton);
        
        self.forwardButton = UIButton(frame: CGRect(x: self.playControlView.frame.width/4*3-15, y: self.playControlView.frame.height/2-15, width: 30, height: 30))
        self.forwardButton.setImage(UIImage(named: "forward"), for: .normal)
        let forwardTap = UITapGestureRecognizer(target: self, action: #selector(forwardGesture(sender:)))
        self.forwardButton.addGestureRecognizer(forwardTap)
        self.playControlView.addSubview(self.forwardButton);
        
        self.fullScreenButton = UIButton(frame: CGRect(x: self.playControlView.frame.width-30, y: self.playControlView.frame.height-30, width: 20, height: 20))
        self.fullScreenButton.setImage(UIImage(named: "full"), for: .normal)
        let fullTap = UITapGestureRecognizer(target: self, action: #selector(fullGesture(sender:)))
        self.fullScreenButton.addGestureRecognizer(fullTap)
        self.playControlView.addSubview(self.fullScreenButton);
        
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(sender:)))
        
        self.videoView.addGestureRecognizer(pan);
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) -> Void in
            
            let orient = UIApplication.shared.statusBarOrientation
            
            switch orient {
                
            case .portrait:
                
                print("Portrait")
                self.videoView.frame = CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height, width: self.view.bounds.width, height: self.videoHeight)
                self.playerLayer?.frame = self.videoView.bounds
                self.playControlView.frame = self.videoView.bounds
                
                self.pauseButton.frame = CGRect(x: self.playControlView.frame.width/2-15, y: self.playControlView.frame.height/2-15, width: 30, height: 30)
                self.backButton.frame = CGRect(x: self.playControlView.frame.width/4-15, y: self.playControlView.frame.height/2-15, width: 30, height: 30)
                self.forwardButton.frame = CGRect(x: self.playControlView.frame.width/4*3-15, y: self.playControlView.frame.height/2-15, width: 30, height: 30)
                self.fullScreenButton.frame = CGRect(x: self.playControlView.frame.width-30, y: self.playControlView.frame.height-30, width: 20, height: 20)
                
                
            case .landscapeLeft,.landscapeRight :
                
                print("Landscape")
                self.videoView.frame = CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height, width: self.view.bounds.width, height: self.view.bounds.height);
                self.playerLayer?.frame = self.videoView.bounds
                self.playControlView.frame = self.videoView.bounds
                
                self.pauseButton.frame = CGRect(x: self.playControlView.frame.width/2-15, y: self.playControlView.frame.height/2-15, width: 30, height: 30)
                self.backButton.frame = CGRect(x: self.playControlView.frame.width/4-15, y: self.playControlView.frame.height/2-15, width: 30, height: 30)
                self.forwardButton.frame = CGRect(x: self.playControlView.frame.width/4*3-15, y: self.playControlView.frame.height/2-15, width: 30, height: 30)
                self.fullScreenButton.frame = CGRect(x: self.playControlView.frame.width-100, y: self.playControlView.frame.height-40, width: 20, height: 20)
                
                
            default:
                
                print("Anything But Portrait")
            }
            
        }, completion: { (UIViewControllerTransitionCoordinatorContext) -> Void in
            //refresh view once rotation is completed not in will transition as it returns incorrect frame size.Refresh here
            
        })
        super.viewWillTransition(to: size, with: coordinator)
        
    }

    
    @objc func panGestureAction(sender: UIPanGestureRecognizer) {
        
        guard UIApplication.shared.statusBarOrientation.isPortrait else {
            return
        }
        
        guard !self.isMin else {
            return
        }
        
        var startPosition:CGPoint = sender.translation(in: self.view.superview);
        
        switch sender.state {
        case .began:
            print("begin")
            startPosition = sender.translation(in: self.view.superview)
            self.playControlView.isHidden = true;
            break
        case .changed:
            print("change")
            if startPosition.y > 0{
                let newX = self.videoView.frame.origin.x + 1
                let newY = self.videoView.frame.origin.y + startPosition.y
                let newW = self.videoView.frame.width - 1
                let newH = 9 * newW / 16.0
                
                self.videoView.frame = CGRect(x: newX, y: newY, width: newW, height: newH)
                self.playerLayer?.frame = CGRect(x: 0, y: 0, width: newW, height: newH)
                sender.setTranslation(CGPoint.zero, in: self.videoView)
                
                self.offsetY = newY
            }
            
            break
        case .ended:
            print("end")
            
            if (self.offsetY > origHeight/5){
                self.toMin()
            } else {
                self.toMax()
            }
            
            break
        default:
            break
        }
    }
    
    @objc func controlGesture(sender: UITapGestureRecognizer){
        guard !self.isMin else {
            self.toMax();
            return
        }
        
        self.playControlView.isHidden = !self.playControlView.isHidden;
    }
    
    @objc func pauseGesture(sender: UITapGestureRecognizer){
        if self.isPlay {
            self.playerLayer?.player?.pause()
            self.pauseButton.setImage(UIImage(named: "play"), for: .normal);
            print("pause");
        }else{
            self.playerLayer?.player?.play()
            self.pauseButton.setImage(UIImage(named: "pause"), for: .normal);
            print("play");
        }
        self.isPlay = !self.isPlay
    }
    
    @objc func forwardGesture(sender: UITapGestureRecognizer){
        if let currentTime = self.playerLayer?.player?.currentTime(), let duration = self.playerLayer?.player?.currentItem?.duration{
            var newTime = CMTimeGetSeconds(currentTime) + 5;
            if newTime >= CMTimeGetSeconds(duration){
                newTime = CMTimeGetSeconds(duration)
            }
            
            self.playerLayer?.player?.seek(to: CMTime(value: CMTimeValue(newTime*1000), timescale: 1000))
        }
        
        print("forward");
    }
    
    @objc func backGesture(sender: UITapGestureRecognizer){
        if let currentTime = self.playerLayer?.player?.currentTime(){
            var newTime = CMTimeGetSeconds(currentTime) - 5;
            if newTime <= 0{
                newTime = 0
            }
            
            self.playerLayer?.player?.seek(to: CMTime(value: CMTimeValue(newTime*1000), timescale: 1000))
        }
        print("back");
    }
    
    @objc func fullGesture(sender: UITapGestureRecognizer){
        print("full");
        
        let orient = UIApplication.shared.statusBarOrientation
        switch orient {
        case .portrait:
            
            print("Portrait")
            UIDevice.current.setValue(Int(UIInterfaceOrientation.landscapeRight.rawValue), forKey: "orientation")
            
            self.fullScreenButton.setImage(UIImage(named: "exit"), for: .normal)
            
        case .landscapeLeft,.landscapeRight :
            
            print("Landscape")
            UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
            
            self.fullScreenButton.setImage(UIImage(named: "full"), for: .normal)
            
        default:
            print("Anything But Portrait")
        }
    }
    
    
    func toMin(){
        let x = self.view.frame.width - minVideoWidth - 20;
        let y = self.view.frame.height - minVideoHeight - 20;
        
        UIView.animate(withDuration: 0.2) {
            self.videoView.frame = CGRect(x: x, y: y, width: self.minVideoWidth, height: self.minVideoHeight);
            self.playerLayer?.frame = CGRect(x: 0, y: 0, width: self.minVideoWidth, height: self.minVideoHeight);
            self.playControlView.isHidden = true;
            self.isMin = true;
        }
    }
    
    func toMax(){
        
        UIView.animate(withDuration: 0.2) {
            self.videoView.frame = CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height, width: self.view.bounds.width, height: self.videoHeight)
            self.playerLayer?.frame = self.videoView.bounds
            self.playControlView.isHidden = true;
            self.isMin = false
        }
    }

}

