//
//  ViewController.swift
//  LuckyPlane
//
//  Created by 魔曦 on 2017/9/26.
//  Copyright © 2017年 魔曦. All rights reserved.
//   首页

import UIKit
import SpriteKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        
//        let backgroundScene = LQBackgroundScene(size: self.view!.frame.size)
        
        
        let startScene = LQStartScene(size: self.view!.frame.size)
        
        let skView = SKView(frame: self.view.bounds)//self.view as! SKView
//        skView.showsFPS = true
//        skView.showsNodeCount = true
//        skView.showsDrawCount = true
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        startScene.scaleMode = .aspectFill
        self.view.addSubview(skView)
//        skView.presentScene(backgroundScene)
        skView.presentScene(startScene)
        
//        let playButton:UIButton = UIButton(frame: CGRect(x: 10, y: 10, width: 70, height: 38))
//        playButton.setImage(UIImage(named: "play"), for: UIControlState())
//        playButton.setImage(UIImage(named: "play-pressed"), for: UIControlState.highlighted)
//        playButton.addTarget(scene, action:#selector(SKVideoNode.play), for: UIControlEvents.touchDown)
//        self.view.addSubview(playButton)
    }
    
class  func getListPlayDataWithIndex(_ index:NSInteger, result:(_ model : NSString,_ error : NSError?) -> Void) -> Void {
        
   }
    
    func showStepToScene(_ sceneName : NSString) {
        
    }
    
    override var shouldAutorotate: Bool{
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        }else{
            return .all
        }
    }
    
//    override var prefersStatusBarHidden: Bool{
//        return true
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

