//
//  GophersCanvas.swift
//  Gopher
//
//  Created by ALEX XIONG and WENBO JIANG on 19/1/19.
//  Copyright © 2019 Alex&Wenbo All rights reserved.
//

import Cocoa
import SpriteKit


class GophersCanvas: SKView {

    override func awakeFromNib() {
        super.awakeFromNib()
        let scene = GophersScene(size: CGSize(width: 900.0, height: 30.0))
        scene.isUserInteractionEnabled = true
        presentScene(scene)
        scene.scaleMode = .resizeFill
    }
    
    override func touchesBegan(with event: NSEvent) {
        scene?.touchesBegan(with: event)
    }

}
