/*:
 # Coming full circle
 
 Now that we know why (and how) it's possible for us to recreate complex sounds from simpler waves, it's time to unleash the full potential of our humble frequency graph: it is now a full fledged **harmonic mixer**, that lets you freely set the amplitude of each of our 8 sine waves to mix them together in different ways.
 
 Go ahead! Run the code, and **drag each of the sliders** to adjust individual harmonic volumes. **Experiment freely!** You might end up finding some vocal sounds, or maybe something resembling an oboe - or maybe something else entirely different 😉
 
 - Example:
 **Tap the buttons below** to fill the mixer with some rough approximations of real instruments, to get you started. There are approximations for **Clarinet, Flute, Guitar, Horn** and **Piano** sounds.
 
 ---
 
 My name is **Vinicius Chagas**, and I'm a 22 year old developer and CS student from Brazil with a ***huge*** passion for music, audio development and eveything inbetween. I hope this (very) short introduction to the Fourier Series and Additive Synthesis has been interesting and fun - because that's the best way to learn something, and that's how everything music-related should be 🎶
 */

//#-hidden-code
import SwiftUI
import PlaygroundSupport

let clarinet: [Float] = [1.0, 0.36, 0.26, 0.02, 0.08, 0.2, 0.03, 0]
let horn: [Float] = [1.0, 0.39, 0.24, 0.22, 0.075, 0.06, 0.075, 0.06]
let piano: [Float] = [1.0, 0.1, 0.325, 0.06, 0.05, 0.045, 0, 0.025]
let flute: [Float] = [0.111, 1, 0.417, 0.194, 0.028, 0.01, 0, 0.005]
let guitar: [Float] = [0.8, 0.54, 1, 0.1, 0.1008, 0.0992, 0, 0.008]

let presets = [clarinet, flute, guitar, horn, piano]
let presetNames = ["Clarinet", "Flute", "Guitar", "Horn", "Piano"]

struct ContentView: View {
    @ObservedObject public var audioController: AudioController
    @State var presetIndex: Int?
    
    var body: some View {
        VStack(alignment: .center, spacing: 32) {
            FrequencyGraph(audioController: audioController)
                .frame(width: 200, height: 200)
            
            ZStack {
                ForEach(audioController.oscillators.indices, id: \.self) { index in
                    OscillatorView(harmonics: Binding<Int>(
                        get: { index + 1 },
                        set: { _ in }), audioController: self.audioController)
                        .frame(width: 200, height: 200)
                        .foregroundColor(.red)
                        .hueRotation(.radians(Double(index) * ((2 * .pi)/8)))
                }
            }.offset(x: 0, y: 100)
            
            HStack {
                ForEach(presets.indices, id: \.self) { index in
                    Button(action: {
                        self.audioController.partialVolumes = presets[index]
                        self.presetIndex = index
                    }) {
                        Text(presetNames[index])
                            .padding(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(lineWidth: 2)
                            )
                            .foregroundColor(self.presetIndex == index ? .green : .blue)
                    }
                }
            }
            
            HStack {
                Button(action: {
                    self.audioController.state = .stopped
                }) {
                    StopButtonView()
                }
                
                Button(action: {
                    self.audioController.partialVolumes = [Float](repeating: 0, count: 8)
                }) {
                    Text("Reset")
                    .padding(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 2)
                    )
                        .foregroundColor(.purple)
                }
            }
            
        }
    }
    
    init() {
        audioController = AudioController()
        audioController.state = .playing
    }
}


// Present the view in the Live View window
PlaygroundPage.current.setLiveView(ContentView())
//#-hidden-code
