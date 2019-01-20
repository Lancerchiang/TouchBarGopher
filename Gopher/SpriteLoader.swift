//
//  File.swift
//  Gopher
//
//  Created by ALEX XIONG and WENBO JIANG on 19/1/19.
//  Copyright © 2019 Alex&Wenbo All rights reserved.
//

import SpriteKit

struct SpriteLoader {
    
    static let SpriteSheet = SKTexture(imageNamed: "gophers.png")
    
    static func loadAnimation(name: String) -> [SKTexture] {
        guard let path = Bundle.main.path(forResource: "gophers", ofType: "plist"),
            let atlas = NSDictionary(contentsOfFile: path),
            let animation = atlas[name] as? [CFDictionary] else {
                fatalError()
        }
        
        return animation.map{CGRect(dictionaryRepresentation: $0)!}
            .map{ SKTexture(rect: $0, in: SpriteLoader.SpriteSheet) }
    }
    
    static func loadAliveTextures() -> [SKTexture] {
        return loadAnimation(name: "alive")
    }
    
    // The rest texture is blank
    static func loadRestTextures() -> [SKTexture] {
        return loadAnimation(name: "rest")
    }
    
    static func loadDeadTextures() -> [SKTexture] {
        return loadAnimation(name: "dead")
    }
    
}
