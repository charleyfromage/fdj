import UIKit

typealias TeamDetailsView = TeamDetailsViewInputs & TeamDetailsViewOutputs

protocol TeamDetailsViewInputs: ViewInputs {
    func showActivityIndicator(shouldShow: Bool)

    func showStackView(shouldShow: Bool)

    func updateTitle(title: String?)
    func updateImage(url: URL?)
    func updateCountryLabelText(text: String?)
    func updateLeagueLabelText(text: String?)
    func updateDescriptionLabelText(text: String?)
}

protocol TeamDetailsViewOutputs: ViewOutputs {}

final class TeamDetailsViewController: ViewController, TeamDetailsView {
    // MARK: Outlets
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var countryLabel: UILabel!
    @IBOutlet private weak var leagueLabel: UILabel!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var descriptionLabel: UILabel!

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

//        setUpView()
    }

    // MARK: Inputs
    /// ActivityIndicator
    func showActivityIndicator(shouldShow: Bool) {
        DispatchQueue.main.async {
            self.activityIndicatorView.isHidden = !shouldShow
        }
    }

    /// StackView
    func showStackView(shouldShow: Bool) {
        DispatchQueue.main.async {
            self.stackView.isHidden = !shouldShow
        }
    }

    /// NavigationBar
    func updateTitle(title: String?) {
        DispatchQueue.main.async {
            self.title = title
        }
    }

    /// ImageView
    func updateImage(url: URL?) {
        imageView.load(url: url)
    }

    /// CountryLabel
    func updateCountryLabelText(text: String?) {
        DispatchQueue.main.async {
            self.countryLabel.text = text
        }
    }

    /// CountryLabel
    func updateLeagueLabelText(text: String?) {
        DispatchQueue.main.async {
            self.leagueLabel.text = text
        }
    }

    /// CountryLabel
    func updateDescriptionLabelText(text: String?) {
        DispatchQueue.main.async {
            self.descriptionLabel.text = text
        }
    }
}
