import Charts
import SwiftUI

struct GameResult: Identifiable {
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
    private let winner: GameResult = results.reduce(
        results[0],
        { winner, result in result.score > winner.score ? result : winner }
    )

    var body: some View {
        VStack {
            Chart(results, id: \.name) { result in
                // The SectorMark instances in donut charts typically
                // have the same value for the innerRadius argument
                // and do not specify an outerRadius argument.
                // let innerRatio = Double.random(in: 0.2 ... 0.6)
                // let outerRatio = Double.random(in: 0.6 ... 1)
                SectorMark(
                    angle: .value("Score", result.score),
                    innerRadius: .ratio(0.618),
                    // innerRadius: .ratio(innerRatio),
                    // outerRadius: .ratio(outerRatio),
                    angularInset: 2
                )
                .cornerRadius(10)
                .foregroundStyle(by: .value("Name", result.name))
            }
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
    }
}

#Preview {
    ContentView()
}
