import UIKit

final class TeamCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var imageView: UIImageView!

    var imageURL: URL? {    /// Some image cache and placeholder should be implemented for a better UI experience
        didSet {
            imageView.load(url: imageURL)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        imageView.image = nil
    }
}
