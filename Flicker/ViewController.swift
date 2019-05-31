import UIKit
import AudioToolbox

class ViewController: UIViewController {
	@IBOutlet weak var timeLabel: UILabel!
	@IBOutlet weak var countDownLabel: UILabel!
	@IBOutlet weak var astrasLabel: UILabel!
	@IBOutlet weak var astrasDescriptionLabel: UILabel!
	
	let colors = [#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1), #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1), #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1), #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1), #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1), #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.5058823824, green: 0.3372549117, blue: 0.06666667014, alpha: 1), #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1), #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1), #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)]
	let maxSeconds = 22
	var currentIndex = 0
	var timer: Timer!
	var flickerLimit = 0.0
	var flickerIncrease = 1.05
	var seconds = 0.0
	var astras = 0
	var state = GameState.ready
	var countDownSeconds = 3
	var endStatus: (endType: GameEndType, status: GameEndStatus, astras: Int, selectedColor: UIColor)?
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		super.prepare(for: segue, sender: self)
		guard let endGameVC = segue.destination as? EndGameViewController, let endStatus = endStatus else { return }
		endGameVC.status = endStatus.status
		endGameVC.endType = endStatus.endType
		endGameVC.astras = endStatus.astras
		endGameVC.selectedColor = endStatus.selectedColor
	}
	
	@IBAction func clickedScreen() {
		switch state {
		case .ready:
			startGame()
		case .waiting:
			AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
		case .inProgress:
			endGame(.selectedColor)
		}
	}
	
	func startGame() {
		state = .waiting
		updateCountDownLabel()
		countDownSeconds -= 1
		timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
			if self.countDownSeconds == 0 {
				UIView.animate(withDuration: 0.25, animations: {
					self.countDownLabel.alpha = 0
					self.countDownLabel.transform = CGAffineTransform(scaleX: 2, y: 2)
				}) {
					guard $0 else { return }
					self.timer.invalidate()
					self.countDownLabel.isHidden = true
					self.countDownSeconds = 4
					self.startTimer()
				}
			} else {
				self.countDownSeconds -= 1
				self.updateCountDownLabel()
			}
		}
	}
	
	func startTimer() {
		state = .inProgress
		currentIndex = Int.random(in: 0..<colors.count)
		timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
			if self.seconds < Double(self.maxSeconds) {
				if self.seconds >= self.flickerLimit {
					self.flicker()
					self.flickerIncrease /= 1.09
					self.flickerLimit += self.flickerIncrease
				}
				self.seconds += 0.1
				self.updateTimeLabel()
				self.updateAstras()
			} else {
				self.timer.invalidate()
				self.endGame(.timeUp)
			}
		}
	}
	
	func endGame(_ type: GameEndType) {
		state = .waiting
		timer.invalidate()
		endStatus = (endType: type, status: currentIndex == 0 ? .win : .lose, astras: astras, selectedColor: colors[currentIndex])
		performSegue(withIdentifier: "end", sender: self)
	}
	
	func flicker() {
		newIndex()
		view.backgroundColor = colors[currentIndex]
	}
	
	func newIndex() {
		currentIndex = (currentIndex + 1) % colors.count
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
		UIView.animate(withDuration: 0.5, animations: {
			self.countDownLabel.alpha = 0
			self.countDownLabel.transform = CGAffineTransform(scaleX: 2, y: 2)
		}) {
			guard $0 else { return }
			self.countDownLabel.alpha = 1
			self.countDownLabel.transform = .identity
			self.countDownLabel.text = self.countDownSeconds == 0 ? "GO!" : String(self.countDownSeconds)
		}
	}
}

enum GameState {
	case ready
	case inProgress
	case waiting
}

enum GameEndType {
	case selectedColor
	case timeUp
}

enum GameEndStatus {
	case win
	case lose
}
