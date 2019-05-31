import UIKit

class EndGameViewController: UIViewController {
	@IBOutlet weak var statusImageView: UIImageView!
	@IBOutlet weak var statusLabel: UILabel!
	@IBOutlet weak var astrasLabel: UILabel!
	@IBOutlet weak var astrasDescriptionLabel: UILabel!
	@IBOutlet weak var youChoseLabel: UILabel!
	@IBOutlet weak var colorView: UIView!
	
	var astras: Int?
	var endType: GameEndType?
	var status: GameEndStatus?
	var selectedColor: UIColor?
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		guard let endType = endType, let status = status else { return }
		loadEndType(endType)
		loadStatus(status)
	}
	
	@IBAction func done() {
		performSegue(withIdentifier: "start", sender: self)
	}
	
	func loadEndType(_ type: GameEndType) {
		switch type {
		case .selectedColor:
			guard let astras = astras else { return }
			astrasLabel.text = String(astras)
			astrasDescriptionLabel.text = "ASTRA\(astras == 1 ? "" : "S")"
			colorView.backgroundColor = selectedColor
		case .timeUp:
			astrasLabel.text = "Time up!"
			astrasDescriptionLabel.text = nil
			youChoseLabel.text = nil
			colorView.isHidden = true
		}
	}
	
	func loadStatus(_ status: GameEndStatus) {
		switch status {
		case .win:
			statusImageView.image = #imageLiteral(resourceName: "Check")
			statusLabel.text = "You win!"
		case .lose:
			statusImageView.image = #imageLiteral(resourceName: "X")
			statusLabel.text = "You lose!"
		}
	}
}
