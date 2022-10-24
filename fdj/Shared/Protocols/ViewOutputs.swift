import UIKit

protocol ViewOutputs: UIViewController {
    var didLoad: (() -> Void)? { get set }
    var didAppear: (() -> Void)? { get set }
}
