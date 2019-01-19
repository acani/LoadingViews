import UIKit
import UIHelper

open class LoadingViewController : UIViewController, UIViewControllerTransitioningDelegate {
  public static let sharedLoadingViewController = LoadingViewController()
  private let fadeAnimator = FadeAnimator()

  override open var title: String? {
    didSet { (viewIfLoaded?.viewWithTag(31)! as! UILabel?)?.text = title }
  }

  public init(title: String? = nil) {
    super.init(nibName: nil, bundle: nil)
    modalPresentationStyle = .overFullScreen
    self.title = title ?? "Connecting"
    transitioningDelegate = self
  }
  required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") } // NSCoding

  // MARK: - UIViewController

  override open func viewDidLoad() {
    let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 128, height: 128))
    containerView.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin, .flexibleBottomMargin, .flexibleRightMargin]
    containerView.backgroundColor = UIColor(white: 0, alpha: 0.75)
    let screenBounds = UIScreen.main.bounds
    containerView.center = CGPoint(x: screenBounds.midX, y: screenBounds.midY)
    containerView.layer.cornerRadius = 10
    view.addSubview(containerView)

    let activityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
    activityIndicatorView.center = CGPoint(x: 128/2, y: 128/2)
    activityIndicatorView.startAnimating()
    containerView.addSubview(activityIndicatorView)

    let titleLabel = UILabel(frame: CGRect(x: 0, y: 128-20-16, width: 128, height: 20))
    titleLabel.font = .boldSystemFont(ofSize: 16)
    titleLabel.tag = 31
    titleLabel.text = title
    titleLabel.textAlignment = .center
    titleLabel.textColor = .white
    containerView.addSubview(titleLabel)
  }

  public static func present() {
    present(withTitle: "Connecting")
  }

  public static func present(withTitle title: String) {
    sharedLoadingViewController.title = title
    UIApplication.auh_topmostViewController.present(sharedLoadingViewController, animated: true)
  }

  public static func dismiss(completion: (() -> Swift.Void)? = nil) {
    sharedLoadingViewController.dismiss(animated: true, completion: completion)
  }

  // MARK: - UIViewControllerTransitioningDelegate

  open func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    fadeAnimator.presenting = true
    return fadeAnimator
  }

  open func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    fadeAnimator.presenting = false
    return fadeAnimator
  }
}

class FadeAnimator: NSObject, UIViewControllerAnimatedTransitioning {
  static let duration = 0.3
  var presenting = false

  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return FadeAnimator.duration
  }

  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    let key = presenting ? UITransitionContextViewKey.to : UITransitionContextViewKey.from
    let fadingView = transitionContext.view(forKey: key)!

    if presenting {
      let containerView = transitionContext.containerView
      fadingView.alpha = 1
      containerView.addSubview(fadingView)
      transitionContext.completeTransition(true)
    } else {
      UIView.animate(withDuration: FadeAnimator.duration, animations: { fadingView.alpha = 0 }, completion: { _ in
        transitionContext.completeTransition(true)
      })
    }
  }
}
