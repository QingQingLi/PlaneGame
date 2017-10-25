//
//  Bullet.swift
//  LuckyPlane
//
//  Created by 魔曦 on 2017/9/26.
//  Copyright © 2017年 魔曦. All rights reserved.
//

import SpriteKit

class Bullet: NSObject {

    var frame : String
    var offset : String
    var rotated : Bool
    var sourceColorRect : String
    var sourceSize : String
    
    var texture : SKTexture?
    
    var frameValue: CGRect {
        set {
            self.frame = NSStringFromCGRect(frameValue)
        }
        
        get {
            return CGRectFromString(self.frame)
        }
        
    }
    
    var offsetValue: CGPoint {
        
        set {
            self.frame = NSStringFromCGPoint(offsetValue)
        }
        
        get {
            return CGPointFromString(self.offset)
        }
        
    }
    
    var sourceColorRectValue: CGRect {
        set {
            self.frame = NSStringFromCGRect(sourceColorRectValue)
        }
        
        get {
            return CGRectFromString(self.sourceColorRect)
        }
    }
    
    var sourceSizeValue: CGSize {
       
        set {
            self.frame = NSStringFromCGSize(sourceSizeValue)

        }
        
        get {
            return CGSizeFromString(self.sourceSize)
        }
    }
    
    override init() {

            self.texture = SKTexture()
            self.rotated = false
            self.frame = ""
            self.offset = ""
            self.sourceColorRect = ""
            self.sourceSize = ""
            super.init()

        }
    
    init(frame: String, offset: String, rotated: Bool, sourceColorRect: String, sourceSize: String) {
        self.frame = frame
        self.offset = offset
        self.rotated = rotated
        self.sourceColorRect = sourceColorRect
        self.sourceSize = sourceSize
        super.init()
    }
    
    
    
}












