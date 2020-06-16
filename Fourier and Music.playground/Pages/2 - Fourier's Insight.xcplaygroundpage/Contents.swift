/*:
 # Everything is made of sin()
 
 Fourier's stroke of genius came from this particular insight he had: that one could greatly simplify the study of complex periodic functions by decomposing them into a sum of simpler functions. In fact, by breaking these functions into a sum of **harmonically related sines** - in other words, the **Fourier Series** we've just seen moments ago :) - one could potentially recreate **any periodic function**, no matter how complex.
 
 ***And how does this relate to music?*** Well, for starters, the sound of a musical instrument is in essence a periodic wave, which means we can even **resynthesize** it using the Fourier Series - a process known as **Additive Synthesis** 🤯
 
 ---
 
 - Example:
 To demonstrate this, take a look at the **Live View** on the right. We'll be using the same 8 harmonically related sine waves we've seen before, except this time we'll **compose them together** to try and approximate a **square wave**. By summing them together with different volumes for each, we get a rough approximation of our reference audio.
 \
 \
 Tap on the **waveform displays** to play the corresponding wave. Besides each display, there's also a **frequency spectrum** showing the amplitudes of each **sine component** the wave is made of.
 
 Run the code and listen to the original wave and our approximation. When you're done, press **Next** to continue.
 
 ---
 
 [Next](@next)
 */

//#-hidden-code
import SwiftUI
import PlaygroundSupport

let squareWave: [Float] = [
    1.0, 0.0,
    1/3, 0.0,
    1/5, 0.0,
    1/7, 0.0
]

struct SquareView: View {
    var body: some View {
        GeometryReader { g in
            Path {
                p in
                let width = min(g.size.width, g.size.height)
                let height = width/2
                
                p.move(to: .zero)
                
                p.addLines([
                    .init(x: 0, y: height),
                    .init(x: 0, y: -height),
                    .init(x: width/2, y: -height),
                    .init(x: width/2, y: height),
                    .init(x: width, y: height),
                    .init(x: width, y: -height),
                ])
            }
            .stroke(lineWidth: 4)
        }
    }
}

struct ContentView: View {
    @ObservedObject public var audioController: AudioController
    
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            Text("Tap the highlighted areas below to listen").bold()
            Button(action: {
                self.audioController.state = .playSquare
            }) {
                VStack {
                    Text("220Hz Square Wave")
                        .offset(x: 0, y: -50)
                    HStack(alignment: .bottom) {
                        SquareView()
                            .frame(width: 100, height: 100)
                        Image(uiImage: UIImage(named: "sq-fft")!)
                            .renderingMode(.original)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 100)
                            .offset(x: 0, y: -50)
                    }.offset(x: 12.5, y: 0)
                }
                .offset(x: 0, y: 50)
                .padding(10)
                .padding(.bottom, 10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10.0)
                        .stroke(lineWidth: 2.0)
                )
            }
            
            Button(action: {
                self.audioController.state = .playing
            }) {
                VStack {
                    Text("220Hz Approximated Square Wave")
                    HStack(alignment: .bottom, spacing: 48) {
                        ZStack {
                            ForEach(audioController.oscillators.indices, id: \.self) { index in
                                OscillatorView(harmonics: Binding<Int>(
                                    get: { index + 1 },
                                    set: { _ in }), audioController: self.audioController)
                                    .frame(width: 100, height: 100)
                                    .foregroundColor(.red)
                                    .hueRotation(.radians(Double(index) * ((2 * .pi)/8)))
                            }
                        }
                        
                        SmallFrequencyGraph(audioController: audioController)
                            .offset(x: 0, y: -12.5)
                            .disabled(true)
                    }.offset(x: -12.5, y: 0)
                    
                    Text("We can only use 4 out of our 8 harmonics to try to approximate this sound, which is too little to be really accurate. That's why it sounds a little dull :)")
                        .font(Font.system(size: 10, weight: .light, design: .rounded))
                        .frame(width: 300, height: 40)
                        .offset(x: 0, y: -12.5)
                    
                }
                .padding(.horizontal, 14)
                .padding(.top, 10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10.0)
                        .stroke(lineWidth: 2.0)
                )
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
        audioController.partialVolumes = squareWave
        audioController.state = .stopped
    }
}


// Present the view in the Live View window
PlaygroundPage.current.setLiveView(ContentView())
//#-hidden-code
