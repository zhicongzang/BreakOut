//
//  StartScene.swift
//  BreakOut
//
//  Created by Zhicong Zang on 2/3/16.
//  Copyright © 2016 Zhicong Zang. All rights reserved.
//

import SpriteKit

class StartScene:SKScene {
    var contectCreated = false
    
    var textColor = SKColor.blackColor() {
        didSet{
            self.startLabelNode.fontColor = textColor
            self.descriptionLabelNode.fontColor = textColor
        }
    }
    
    lazy var startLabelNode: SKLabelNode = {
        let startNode = SKLabelNode(text: "Pull to Break Out!")
        startNode.fontColor = self.textColor
        startNode.fontSize = 20
        startNode.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        startNode.name = "Start"
        
        return startNode
    }()
    
    lazy var descriptionLabelNode: SKLabelNode = {
        let descriptionNode = SKLabelNode(text: "Scroll to move paddle")
        descriptionNode.fontColor = self.textColor
        descriptionNode.fontSize = 17
        descriptionNode.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame) - 20)
        descriptionNode.name = "Description"
        
        return descriptionNode
    }()
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        if !contectCreated {
            createSceneContents()
            contectCreated = true
        }
    }
    
    func createSceneContents() {
        scaleMode = .AspectFit
        addChild(startLabelNode)
        addChild(descriptionLabelNode)
    }
    
}
