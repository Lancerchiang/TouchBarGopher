//
//  Gopher.swift
//  Gopher
//
//  Created by ALEX XIONG and WENBO JIANG on 19/1/19.
//  Copyright © 2019 Alex&Wenbo All rights reserved.
//

import SpriteKit

enum State {
    case alive
    case dead
    case rest
    
}

class Gopher: SKSpriteNode {
    // gopher states and action logic goes here.
    var state: State = .rest {
        didSet{
            switch state {
            case .alive:
                grow()
            case .dead:
                die()
            case .rest:
                rest()
            }
        }
    }
    
    
    func grow() {
        removeAllActions()
        let textures = SpriteLoader.loadAliveTextures()
        let animate = SKAction.animate(with: textures, timePerFrame: 0.2)
        let growAction = SKAction.repeat(animate, count: 1)
        
        run(growAction, completion: {
            self.state = .rest
        })
    }
    
    func rest() {
        removeAllActions()
        let textures = SpriteLoader.loadRestTextures()
        let animate = SKAction.animate(with: textures, timePerFrame: 0.2)
        let restAction = SKAction.repeat(animate, count: 1)
        run(restAction)
    }
    
    func die() {
        removeAllActions()
        let textures = SpriteLoader.loadDeadTextures()
        let animate = SKAction.animate(with: textures, timePerFrame: 0.2)
        let dieAction = SKAction.repeat(animate, count: 1)
        let moveAction1 = SKAction.moveBy(x: 0, y: -10, duration: 0.1)
        let moveAction2 = SKAction.moveBy(x: 0, y: 10, duration: 0.1)
        
        // chained application of SKAction
        run(moveAction1, completion: {
            self.run(moveAction2, completion: {
                self.run(moveAction1, completion: {
                    self.run(moveAction2, completion: {
                        self.run(dieAction, completion: {
                            self.state = .rest
                        })
                    })
                })
            })
        })
    }
    
    init() {
        super.init(texture: nil, color: NSColor.clear, size: CGSize(width: 30, height: 30))
//        switch state {
//        case .alive:
//            grow()
//            break
//        default:
//            break
//        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
