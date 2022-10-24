import UIKit

class ViewController: UIViewController {
    // MARK: Outputs
    var didLoad: (() -> Void)?
    var didAppear: (() -> Void)?

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        didLoad?()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        didAppear?()
    }
}
