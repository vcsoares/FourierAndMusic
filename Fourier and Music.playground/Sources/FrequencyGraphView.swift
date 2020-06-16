import SwiftUI

public struct FrequencyGraph: View {
    @ObservedObject public var audioController: AudioController
    
    public var body: some View {
        VStack {
            ForEach(audioController.oscillators.indices, id: \.self) { index in
                Slider(
                    value: Binding<Float>(
                        get: { self.audioController.partialVolumes[index] },
                        set: { value in
                            self.audioController.partialVolumes[index] = value
                    }), in: 0...1)
                .animation(.easeInOut)
                .accentColor(.red)
                .hueRotation(.radians(Double(index) * ((2 * .pi)/8)))
            }
        }.rotationEffect(.degrees(-90))
    }
    
    public init(audioController: AudioController) {
        self.audioController = audioController
    }
}

public struct SmallFrequencyGraph: View {
    @ObservedObject public var audioController: AudioController
    
    public var body: some View {
        VStack {
            ForEach(audioController.oscillators.indices, id: \.self) { index in
                Slider(
                    value: Binding<Float>(
                        get: { self.audioController.partialVolumes[index] },
                        set: { value in
                            self.audioController.partialVolumes[index] = value
                    }), in: 0...1)
                .frame(width: 125, height: 15, alignment: .center)
                .animation(.easeInOut)
                .accentColor(.red)
                .hueRotation(.radians(Double(index) * ((2 * .pi)/8)))
            }
        }.rotationEffect(.degrees(-90))
    }
    
    public init(audioController: AudioController) {
        self.audioController = audioController
    }
}
