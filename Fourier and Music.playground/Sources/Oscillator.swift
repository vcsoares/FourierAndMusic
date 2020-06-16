//
//  Oscillator.swift
//  additive-synth
//
//  Created by Vinícius Chagas on 11/05/20.
//  Copyright © 2020 Vinícius Chagas. All rights reserved.
//

import Foundation
import AVFoundation

// Dumb sample-based oscillator class
// Since this is going to run in a quite restricted environment (Playgrounds)
// it wouldn't be worth the effort of trying to synthesize proper waveforms
// or even trying to repitch in real time a base wave sample.
//
// Instead, we'll be using individual .wav files for each of our partials,
// and since this is meant to be an educational primer to additive synthesis
// it should be more than enough :)

public class Oscillator: Identifiable {
    public var id = UUID()
    public var volume: Float = 0 {
        didSet {
            self.player?.volume = self.volume
        }
    }
    public var player : AVAudioPlayer?
    
    public init(harmonic: Int) {
        if harmonic > 0 {
            guard let url = Bundle.main.url(forResource: "sine-\(harmonic)", withExtension: "wav") else { return }

            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                try AVAudioSession.sharedInstance().setActive(true)

                player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
                player?.numberOfLoops = -1

//                print("player \(harmonic) initialized")
            } catch {
                print(error)
            }
        } else {
            guard let url = Bundle.main.url(forResource: "square-220", withExtension: "wav") else { return }
            
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                try AVAudioSession.sharedInstance().setActive(true)
                
                player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
                player?.numberOfLoops = -1
                
//                print("player initialized")
            } catch {
                print(error)
            }
        }
    }
    
    deinit {
        self.player?.stop()
    }
    
    public func play() {
//        print("[\(Date())] Entrando na função \t \(#function)")
        guard let player = self.player else { return }
        
        if player.isPlaying {
            self.player?.setVolume(self.volume, fadeDuration: 0.05)
        } else {
            self.player?.volume = 0
            self.player?.prepareToPlay()
            self.player?.play()
            self.player?.setVolume(self.volume, fadeDuration: 0.05)
        }
    }

    public func stop() {
//        print("[\(Date())] Entrando na função \t \(#function)")
        guard let player = self.player else { return }
        
        if player.isPlaying {
            self.player?.setVolume(0, fadeDuration: 0.25)
        }
    }
}




////
////  Oscillator.swift
////  additive-synth
////
////  Created by Vinícius Chagas on 11/05/20.
////  Copyright © 2020 Vinícius Chagas. All rights reserved.
////
//
//import Foundation
//import AVFoundation
//
//// Dumb sample-based oscillator class
//// Since this is going to run in a quite restricted environment (Playgrounds)
//// it wouldn't be worth the effort of trying to synthesize proper waveforms
//// or even trying to repitch in real time a base wave sample.
////
//// Instead, we'll be using individual .wav files for each of our partials,
//// and since this is meant to be an educational primer to additive synthesis
//// it should be more than enough already :)
//
//public class Oscillator: Identifiable {
//    public var id = UUID()
//
//    public var player : AVAudioPlayer?
//
//    public init(harmonic: Int) {
//        if harmonic > 0 {
//            guard let url = Bundle.main.url(forResource: "sine-\(harmonic)", withExtension: "wav") else { return }
//
//            do {
//                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
//                try AVAudioSession.sharedInstance().setActive(true)
//
//                player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
//                player?.numberOfLoops = -1
//                player?.volume = 0
//
//                print("player \(harmonic) initialized")
//            } catch {
//                print(error)
//            }
//        } else {
//            guard let url = Bundle.main.url(forResource: "square-220", withExtension: "wav") else { return }
//
//            do {
//                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
//                try AVAudioSession.sharedInstance().setActive(true)
//
//                player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
//                player?.numberOfLoops = -1
//                player?.volume = 0
//
//                print("square player initialized")
//            } catch {
//                print(error)
//            }
//        }
//    }
//
//    deinit {
//        self.player?.stop()
//    }
//
//    public func play() {
//        print("[\(Date())] Entrando na função \t \(#function)")
//        self.player?.prepareToPlay()
//        self.player?.play()
//    }
//
//    public func stop() {
//        print("[\(Date())] Entrando na função \t \(#function)")
//        self.player?.stop()
//        self.player?.currentTime = 0
//    }
//}
//
//
