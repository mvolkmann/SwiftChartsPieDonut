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
    // This value goes from 0 to 52 because the sum of the scores is 52.
    @State private var selectedAngle: PlottableAngle?

    private func innerRatio(_ result: GameResult) -> Double {
        return result == selectedResult ? 0.55 : 0.6
    }

    private func outerRatio(_ result: GameResult) -> Double {
        return result == selectedResult ? 1 : 0.95
    }

    // Finds the GameResult that corresponds to given selected value.
    // The values go from 0 to 52 because the sum of the scores is 52.
    // The 12 o'clock position is 0 and values increase going clockwise.
    private var selectedResult: GameResult? {
        guard let selectedAngle else { return nil }
        let value = selectedAngle.primitivePlottable
        var sum = 0
        for result in results {
            sum += result.score
            if value <= sum { return result }
        }
        return nil
    }

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
                SectorMark(
                    angle: .value("Score", result.score),
                    innerRadius: .ratio(innerRatio(result)),
                    outerRadius: .ratio(outerRatio(result)),
                    angularInset: 2
                )
                .cornerRadius(10)
                .foregroundStyle(by: .value("Name", result.name))
                .opacity(result == selectedResult ? 1.0 : 0.5)
            }
            .chartAngleSelection($selectedAngle)
            .chartBackground { proxy in
                GeometryReader { geometry in
                    let frame = geometry[proxy.plotAreaFrame]
                    VStack {
                        if let selectedResult {
                            Text(selectedResult.name)
                            Text("\(selectedResult.score)")
                        } else {
                            Text("Winner").fontWeight(.bold)
                            Text(winner.name)
                        }
                    }
                    .font(.largeTitle)
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
