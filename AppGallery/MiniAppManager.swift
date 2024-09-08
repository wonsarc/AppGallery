import UIKit
import TicTacToeApp
import CurrentCityApp
import CurrentWeatherApp
import StepCounterApp
import CrosswordApp

struct MiniApp {
    let type: MiniAppType
    let view: UIView
}

enum MiniAppType: String {
    case currentCity
    case ticTacToe
    case currentWeather
    case stepCounter
    case crossword
}

final class MiniAppManager {

    var miniApps: [MiniApp] = []

    func setupMiniApps(in parent: UIViewController) {
        let miniAppViewControllers: [(UIViewController, MiniAppType)] = [
            (CurrentCityVС(), .currentCity),
            (TicTacToeViewController(), .ticTacToe),
            (CurrentWeatherVC(), .currentWeather),
            (StepCounterVC(), .stepCounter),
            (CrosswordVC(), .crossword),
            (CurrentCityVС(), .currentCity),
            (TicTacToeViewController(), .ticTacToe),
            (CurrentWeatherVC(), .currentWeather),
            (StepCounterVC(), .stepCounter),
            (CrosswordVC(), .crossword)
        ]

        for (vc, type) in miniAppViewControllers {
            parent.addChild(vc)
            vc.didMove(toParent: parent)
            miniApps.append(MiniApp(type: type, view: vc.view))
        }
    }
}
