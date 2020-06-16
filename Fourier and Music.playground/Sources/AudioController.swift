//
//  AudioController.swift
//  additive-synth
//
//  Created by Vinícius Chagas on 11/05/20.
//  Copyright © 2020 Vinícius Chagas. All rights reserved.
//

import Foundation
import AVFoundation

public class AudioController: ObservableObject {
    public enum State {
        case stopped
        case playing
        
        // special cases
        case play(harmonic: Int)
        case playSquare
    }
    
    public var state : State {
        didSet {
            switch state {
            case .stopped:
                oscillators.forEach { $0.stop() }
                squareOscillator.stop()
            case .playing:
                squareOscillator.stop()
                oscillators.forEach { $0.play() }
            case .play(harmonic: let harmonic):
                squareOscillator.stop()
                oscillators.forEach { $0.stop() }
                partialVolumes = [Float](repeating: 0, count: 8)
                partialVolumes[harmonic - 1] = 1
                oscillators[harmonic - 1].play()
            case .playSquare:
                oscillators.forEach { $0.stop() }
                squareOscillator.play()
            }
        }
    }
    
    @Published public var oscillators : [Oscillator] = []
    public var squareOscillator = Oscillator(harmonic: 0)
    
    public var points : [[CGPoint]] = []
    
    public var harmonicNames : [String] = [
        "Fundamental",
        "2nd Harmonic",
        "3rd Harmonic",
        "4th Harmonic",
        "5th Harmonic",
        "6th Harmonic",
        "7th Harmonic",
        "8th Harmonic"
    ]
    
    public var partialVolumes : [Float] = [] {
        didSet {
            partialVolumes.enumerated().map { oscillators[$0].volume = $1 }
            self.objectWillChange.send()
        }
    }
    
    public init() {
        self.state = .stopped
        
        for harmonic in 1...8 {
            oscillators.append(Oscillator(harmonic: harmonic))
            
            var points = [CGPoint]()
            let maxLen = harmonic * 4
            
            for i in 0...maxLen {
                let x = Double(i) / Double(maxLen)
                let y = sin(2 * .pi * x * Double(harmonic))
                points.append(CGPoint(x: x, y: y))
            }
            
            self.points.append(points)
            
            partialVolumes.append(0)
        }
        
        self.squareOscillator.volume = 1
    }
}
