import Charts
import SwiftUI

struct PlottableAngle: Equatable, Plottable {
    var primitivePlottable: Int
    init?(primitivePlottable: Int) {
        self.primitivePlottable = primitivePlottable
    }
}

struct GameResult: Equatable, Identifiable {
    var id: String { name }
    var name: String
    var score: Int

    init(name: String, score: Int) {
        self.name = name
        self.score = score
    }
}

private let results: [GameResult] = [
    .init(name: "Mark", score: 19),
    .init(name: "Tami", score: 16),
    .init(name: "Amanda", score: 10),
    .init(name: "Jeremy", score: 7)
]

struct ContentView: View {
    @State var selectedAngle: PlottableAngle?

    private let winner: GameResult = results.reduce(
        results[0],
        { winner, result in result.score > winner.score ? result : winner }
    )

    var body: some View {
        VStack {
            Chart(results, id: \.name) { result in
                // let innerRatio = result == selectedResult ? 0.5 : 0.618
                let innerRatio = 0.618

                // The SectorMark instances in donut charts typically
                // have the same value for the innerRadius argument
                // and do not specify an outerRadius argument.
                SectorMark(
                    angle: .value("Score", result.score),
                    innerRadius: .ratio(innerRatio),
                    // outerRadius: .ratio(outerRatio),
                    angularInset: 2
                )
                .cornerRadius(10)
                .foregroundStyle(by: .value("Name", result.name))
            }
            .chartAngleSelection($selectedAngle)
            .chartBackground { proxy in
                GeometryReader { geometry in
                    let frame = geometry[proxy.plotAreaFrame]
                    VStack {
                        Text("Winner").font(.headline)
                        Text(winner.name)
                    }
                    .position(x: frame.midX, y: frame.midY)
                }
            }
        }
        .padding()
        .onChange(of: selectedAngle) {
            print("selectedAngle =", selectedAngle)
        }
    }
}

#Preview {
    ContentView()
}
