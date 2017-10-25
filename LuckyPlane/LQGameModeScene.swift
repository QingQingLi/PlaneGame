//
//  LQGameModeScene.swift
//  LuckyPlane
//
//  Created by 魔曦 on 2017/9/29.
//  Copyright © 2017年 魔曦. All rights reserved.
//

import UIKit
import SpriteKit

class LQGameModeScene: SKScene {

    //闯关模式  经典模式
    var levelButton : UIButton?
    var classicalButton : UIButton?
    var backMoveNode : SKNode?

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        self.backMoveNode = SKNode()
        self.addChild(self.backMoveNode!)
        
        let texture = SKTexture(imageNamed: "bg0")
        texture.filteringMode = SKTextureFilteringMode.nearest
        let backnode = SKSpriteNode(color: .white, size: self.frame.size)
        backnode.zPosition = 0
        backnode.texture = texture
        backnode.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        backnode.name = "back"
        self.backMoveNode!.addChild(backnode)

        let color = UIColor.init(colorLiteralRed: 237/255.0, green: 137/255.0, blue: 52/255.0, alpha: 1.0)
        
        levelButton = UIButton(type: .custom)
        levelButton?.frame.size = CGSize(width: 200, height: 60)
        levelButton?.center = CGPoint(x: self.frame.midX, y: self.frame.midY - 50)
        levelButton?.setBackgroundImage(UIImage(named: ""), for: .normal)
        levelButton?.setTitle(NSLocalizedString("闯关模式", comment: ""), for: .normal)
        levelButton?.titleLabel?.font = UIFont.init(name: "【何尼玛】土肥圆", size: 30)//UIFont.systemFont(ofSize: 30)
        levelButton?.setTitleColor(color, for: .normal)
        self.view?.addSubview(levelButton!)
        levelButton?.addTarget(self, action: #selector(LQGameModeScene.levelGame), for: .touchUpInside)
        
        classicalButton = UIButton(type: .custom)
        classicalButton?.frame.size = CGSize(width: 200, height: 60)
        classicalButton?.center = CGPoint(x: self.frame.midX ,y: (self.levelButton?.frame.maxY)! + 50)
        classicalButton?.setBackgroundImage(UIImage(named: ""), for: .normal)
        classicalButton?.setTitle(NSLocalizedString("经典模式", comment: ""), for: .normal)
        classicalButton?.titleLabel?.font = UIFont.init(name: "【何尼玛】土肥圆", size: 30)
        classicalButton?.setTitleColor(color, for: .normal)
        self.view?.addSubview(classicalButton!)
        classicalButton?.addTarget(self, action: #selector(LQGameModeScene.classicalGame), for: .touchUpInside)
        
        
    }
    
    func levelGame(){
        self.removeViews()
        
        self.view?.presentScene(LQLevelListScene(size: self.frame.size))

    }
    
    func classicalGame()  {
        self.removeViews()
        self.view?.presentScene(LQLevel01Scene(size: self.frame.size))
    }
    
    func removeViews()  {
        levelButton?.removeFromSuperview()
        classicalButton?.removeFromSuperview()
    }
    
    
}
