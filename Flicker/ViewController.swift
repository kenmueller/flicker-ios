import UIKit
import AudioToolbox

class ViewController: UIViewController {
	@IBOutlet weak var timeLabel: UILabel!
	@IBOutlet weak var countDownLabel: UILabel!
	@IBOutlet weak var astrasLabel: UILabel!
	@IBOutlet weak var astrasDescriptionLabel: UILabel!
	
	var timer: Timer!
	var seconds = 0.0
	var astras = 0
	var state = GameState.ready
	var countDownSeconds = 3
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	@IBAction func clickedScreen() {
		switch state {
		case .ready:
			startGame()
		case .starting:
			AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
		case .inProgress:
			endGame()
		}
	}
	
	func startGame() {
		state = .starting
		timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
			if self.countDownSeconds == 0 {
				UIView.animate(withDuration: 0.25, animations: {
					self.countDownLabel.alpha = 0
					self.countDownLabel.transform = CGAffineTransform(scaleX: 2, y: 2)
				}) {
					guard $0 else { return }
					self.timer.invalidate()
					self.countDownLabel.isHidden = true
					self.startTimer()
				}
			} else {
				self.countDownSeconds -= 1
				self.updateCountDownLabel()
			}
		}
	}
	
	func startTimer() {
		timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
			self.seconds += 0.1
			self.updateTimeLabel()
			self.updateAstras()
		}
	}
	
	func endTimer() {
		timer.invalidate()
		// show modal
	}
	
	func endGame() {
		
	}
	
	func updateTimeLabel() {
		timeLabel.text = "\(round(10 * seconds) / 10)s"
	}
	
	func updateAstras() {
		astras = Int(seconds / 3)
		astrasLabel.text = String(astras)
		astrasDescriptionLabel.text = "ASTRA\(astras == 1 ? "" : "S")"
	}
	
	func updateCountDownLabel() {
		countDownLabel.text = countDownSeconds == 0 ? "GO!" : String(countDownSeconds)
	}
}

enum GameState {
	case ready
	case starting
	case inProgress
}
