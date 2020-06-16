/*:
 # It's a matter of Harmony
 
 To begin understanding what Fourier's discoveries are all about, first we need to understand their foundation: the **Fourier Series**. To put it simply enough for our purposes:
 
 - The Fourier Series is a way to represent complex periodic functions as the **sum of simpler components** (in this case, sines and cosines), where each component is **harmonically related to the others in frequency**.
 
 This basically means that, for a periodic function of frequency **100Hz** for example, its Fourier series would be comprised of **N** sine components of different amplitudes (or *weights*) each, and frequencies of 100Hz, 200Hz, 300Hz, up to **N `x` 100Hz**.
 
 ---
 
 - Example:
 The **Live View** on the right will introduce us to the two **visualizations** that will be used throughout this Playground to illustrate the concepts we'll be studying: the **waveform display** and the **frequency graph**. We will also be using a bank of 8 sine waves: the first one - **the fundamental** - is at 220Hz frequency, and each of its **7 harmonics** is at an integer multiple of 220Hz.
 \
 \
 **Run the code** and see how the waves are represented. Use the **+ and - buttons** to switch between the harmonics, and **tap** on the waveform display to listen to them. The **frequency graph** shows the amplitude of each of these sine wave components - it will be a lot more useful later on ;)
 
 When you're done, press **Next** to continue.
 
 ---
 
 [Next](@next)
 */

//#-hidden-code
import SwiftUI
import PlaygroundSupport

struct ContentView: View {
    @ObservedObject public var audioController: AudioController
    @State var harmonic: Int = 1
    
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            Stepper(audioController.harmonicNames[harmonic - 1], value: $harmonic, in: 1...8, onEditingChanged: { isChanging in
                if !isChanging {
                    self.audioController.state = .play(harmonic: self.harmonic)
                }
            })
                .frame(width: 220)
            
            Text("Frequency: \(harmonic * 220)Hz").bold()
            
            HStack(alignment: .center, spacing: 24) {
                Button(action: {
                    self.audioController.state = .play(harmonic: self.harmonic)
                }) {
                    OscillatorView(harmonics: $harmonic, audioController: self.audioController)
                        .frame(width: 100, height: 100)
                        .offset(x: 0, y: 48)
                        .padding(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(lineWidth: 2)
                    )
                        .offset(x: -16, y: 0)
                        .foregroundColor(.red)
                        .hueRotation(.radians(Double(harmonic - 1) * ((2 * .pi)/8)))
                        .animation(.easeInOut)
                }
                
                SmallFrequencyGraph(audioController: audioController)
                    .disabled(true)
            }
            
            Button(action: {
                self.audioController.state = .stopped
            }) {
                StopButtonView()
            }
        }
    }
    
    init() {
        audioController = AudioController()
        audioController.partialVolumes = [1,0,0,0,0,0,0,0]
        audioController.state = .stopped
    }
}


// Present the view in the Live View window
PlaygroundPage.current.setLiveView(ContentView())
//#-hidden-code
