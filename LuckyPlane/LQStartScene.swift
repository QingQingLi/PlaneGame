//
//  LQStartScene.swift
//  LuckyPlane
//
//  Created by 魔曦 on 2017/9/26.
//  Copyright © 2017年 魔曦. All rights reserved.
//

import SpriteKit

class LQStartScene: SKScene {
    
    
    var backMoveNode : SKNode?
    var labelNode : SKNode?
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        self.backMoveNode = SKNode()
        self.backMoveNode?.zPosition = 0
        self.insertChild(self.backMoveNode!, at: 0)
        
        self.labelNode = SKNode()
        self.labelNode?.zPosition = 1
        self.addChild(self.labelNode!)
        
        let texture = SKTexture(imageNamed: "bg0")
        texture.filteringMode = SKTextureFilteringMode.nearest
        let backnode = SKSpriteNode(color: .white, size: self.frame.size)
        backnode.zPosition = 0
        backnode.texture = texture
        backnode.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        backnode.name = "back"
        self.backMoveNode!.addChild(backnode)
            
        let myLabel = SKLabelNode.init(fontNamed:"【何尼玛】土肥圆")//109 72 47
        myLabel.text = NSLocalizedString("开始游戏", comment: "")
        myLabel.fontSize = 40
        myLabel.fontColor = UIColor.init(colorLiteralRed: 237/255.0, green: 137/255.0, blue: 52/255.0, alpha: 1.0)
        myLabel.position = CGPoint.init(x: self.frame.midX, y: self.frame.midY - 20)
        self.labelNode?.addChild(myLabel)
        myLabel.name = "helloMyLabel"
        
        let zoom = SKAction.scale(to: 1.2, duration: 0.8)
        let pause = SKAction.wait(forDuration: 0.2)
        let bigAction = SKAction.scale(to: 1, duration: 0.8)
        let sequence = SKAction.sequence([zoom,pause,bigAction])
        let repeatAction = SKAction.repeatForever(sequence)
        myLabel.run(repeatAction)
        
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let helloLabel = self.labelNode?.childNode(withName: "helloMyLabel") as? SKLabelNode {
            helloLabel.name = nil
            let transition = SKTransition.doorway(withDuration: 0.5)

//            let transition = SKTransition.doorsOpenVertical(withDuration: 0.6)
            self.view!.presentScene(LQGameModeScene(size : self.view!.frame.size), transition: transition)
            
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    

}
