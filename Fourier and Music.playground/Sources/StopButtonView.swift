import SwiftUI

public struct StopButtonView: View {
    public var body: some View {
        Text("Stop").bold()
        .padding(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10.0)
                .stroke(lineWidth: 2.0)
        )
            .foregroundColor(.red)
    }
    
    public init() {}
}
