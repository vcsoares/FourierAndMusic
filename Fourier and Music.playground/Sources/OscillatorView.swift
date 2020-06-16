import SwiftUI

public struct OscillatorView: View {
    @Binding public var harmonics: Int
    @ObservedObject public var audioController: AudioController
        
    public var body: some View {
        GeometryReader { g in
            Path {
                p in
                let width = min(g.size.width, g.size.height)
                let height = width/2 * CGFloat(self.audioController.partialVolumes[self.harmonics - 1])
                let points = self.audioController.points[self.harmonics - 1]
                let stride = (1 / CGFloat(points.count - 1)) * width
                
                var prevControlY: CGFloat = -height
                
                p.move(to: .zero)
                
                for (i, point) in points.enumerated() {
                    let point = CGPoint(
                        x: point.x * width,
                        y: point.y * -height
                    )

                    
                    
                    let controlPoint : CGPoint
                    
                    if i == 0 {
                        controlPoint = .zero
                    } else {
                        controlPoint = .init(
                            x: point.x - (stride/2),
                            y: (prevControlY)
                        )
                    }
                    
                    if abs(point.y).rounded() == 0 && i > 0 {
                        prevControlY = -prevControlY
                    }
//                    print("i: \(i)\tp: \(point)\tc:\(controlPoint)")
                
                    p.addQuadCurve(to: point, control: controlPoint)
                }
            }
            .stroke(lineWidth: 4 * (1/CGFloat(self.harmonics)))
        }
    }
    
    public init(harmonics: Binding<Int>, audioController: AudioController) {
        self._harmonics = harmonics
        self.audioController = audioController
    }
}
