//
//  GopheraScene.swift
//  Gopher
//
//  Created by ALEX XIONG and WENBO JIANG on 19/1/19.
//  Copyright © 2019 Alex&Wenbo All rights reserved.
//

import SpriteKit

class GophersScene: SKScene {
    var isStarted = false
    let fireThreshold: Float = 0.8
    var gophers = [Gopher]()
    var gophersPos = [CGPoint?](repeating: nil, count: 10)
    var totalGophers: Int = 0
    var totalMiss: Int = 0  // @notice: to avoid async callback from missed gopher, we calculate miss by total-hit-wrongHit.
    var totalHit: Int = 0
    var totalWrongHit: Int = 0
    
    var bgm = SKAudioNode(fileNamed: "background.mp3")
    var hitSound = SKAction.playSoundFileNamed("hit_sound.mp3", waitForCompletion: false)
    var failSound = SKAction.playSoundFileNamed("error.mp3", waitForCompletion: false)
    
    var grassField = SKSpriteNode(imageNamed: "background.png")
    var greySky = SKSpriteNode(imageNamed: "grey.png")
    var instruction = SKLabelNode()
    
    let totalTime = 3.0 // seconds
    var gameEnd = false
    
    func didBegin() {
        // NOTE: empty for now.
    }
    
    func addGopher(at: CGPoint) {
        let g = Gopher()
        scene?.addChild(g)
        g.position = at
        g.state = State.rest
        gophers.append(g)
    }
    
    func gopherAt(point: CGPoint) -> Gopher? {
        return gophers.filter { $0.contains(point) }.first
    }
    override func touchesBegan(with event: NSEvent) {
        if #available(OSX 10.12.2, *) {
            if isStarted && !gameEnd {
                let touches = event.allTouches()
                for touch in touches {
                    let interval: Int = Int(touch.location(in: self.view).x/90)
                    hitGopher(g: gophers[interval])
                }
            } else {
                isStarted = true
                startGame()
            }
        }
    }
    
    func fireGophers() {
        for gopher in gophers {
            if gopher.state == .rest {
                let fraction = Float.random(in: 0 ..< 1)
                if fraction >= fireThreshold {
                    gopher.state = .alive
                    totalGophers += 1
                }
            }
        }
    }
    
    func hitGopher(g: Gopher) {
        if g.state == .alive {
            g.state = .dead
            totalHit += 1
            run(hitSound)
        }
        if g.state == .rest {
            // NOTE: add some negative feedback to user
            totalWrongHit += 1
            run(failSound)
        }
        print("Total Hit: \(totalHit); Total WrongHit: \(totalWrongHit); Total: \(totalGophers).\n")
    }
    
    // Infinite loop that fires random gophers with certian probability
    func clock(timer:Timer) {
        if !gameEnd {
            DispatchQueue.global(qos: DispatchQoS.background.qosClass).async {
                self.fireGophers()
            }
        }
    }
    
    func startGame() {
        gameEnd = false
        instruction.isHidden = true
        self.addChild(bgm)
        Timer.scheduledTimer(withTimeInterval: totalTime, repeats: false) {
            _ in
            self.gameEnd = true
            self.removeChildren(in: [self.bgm])
            for gopher in self.gophers {
                gopher.state = .rest
            }
            self.instruction.text = "You've smacked \(self.totalHit) out of \(self.totalGophers) Gophers! Tap anywhere to start a new game."
            self.instruction.fontSize = 14
            self.instruction.isHidden = false
            print("game Ended")
        }
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {
            timer in
            self.clock(timer: timer)
        }
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        for (i, _) in gophersPos.enumerated() {
            // hardcoded center positions of each gopher
            // assuming gopher width: 30, total width: 900
            // totalGopher: 10
            let x: Float = 45.0 + Float(i)*90.0
            gophersPos[i] = CGPoint(x: CGFloat(x), y: CGFloat(15.0))
            addGopher(at: gophersPos[i] ?? CGPoint(x: 0, y:0))
        }

        // Add background image
        grassField.size = size
        grassField.position = CGPoint(x: size.width / 2, y: size.height / 2 - 17)
        self.addChild(grassField)
        
        greySky.size = size
        greySky.position = CGPoint(x: size.width / 2, y: size.height / 2)
        greySky.zPosition = -1
        self.addChild(greySky)
        
        instruction.text = "Please touch anywhere to start a new game."
        instruction.fontSize = 15
        instruction.fontName = "Futura"
        instruction.position = CGPoint(x: self.size.width/2, y: self.size.height/2-5)
        instruction.fontColor = SKColor(red: 0, green: 0, blue: 0, alpha: 1)
        instruction.zPosition = 50
        instruction.isHidden = false
        self.addChild(instruction)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


