import SwiftUI

struct SpendingChart: View {
    let data: [Double]
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let maxValue = data.max() ?? 1
                let xStep = geometry.size.width / CGFloat(data.count - 1)
                let yStep = geometry.size.height / CGFloat(maxValue)
                
                path.move(to: CGPoint(x: 0, y: geometry.size.height - CGFloat(data[0]) * yStep))
                
                for index in 1..<data.count {
                    let point = CGPoint(
                        x: CGFloat(index) * xStep,
                        y: geometry.size.height - CGFloat(data[index]) * yStep
                    )
                    path.addLine(to: point)
                }
            }
            .stroke(Color.blue, lineWidth: 2)
            
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.blue.opacity(0.0)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .mask(
                Path { path in
                    let maxValue = data.max() ?? 1
                    let xStep = geometry.size.width / CGFloat(data.count - 1)
                    let yStep = geometry.size.height / CGFloat(maxValue)
                    
                    path.move(to: CGPoint(x: 0, y: geometry.size.height))
                    path.addLine(to: CGPoint(x: 0, y: geometry.size.height - CGFloat(data[0]) * yStep))
                    
                    for index in 1..<data.count {
                        let point = CGPoint(
                            x: CGFloat(index) * xStep,
                            y: geometry.size.height - CGFloat(data[index]) * yStep
                        )
                        path.addLine(to: point)
                    }
                    
                    path.addLine(to: CGPoint(x: geometry.size.width, y: geometry.size.height))
                    path.closeSubpath()
                }
            )
        }
    }
} 
