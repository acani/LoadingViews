import UIKit
import UIHelper

public class LoadingViewController : UIViewController, UIViewControllerTransitioningDelegate {
    public static let sharedLoadingViewController = LoadingViewController()
    private let fadeAnimator = FadeAnimator()

    override public var title: String? {
        didSet { (viewIfLoaded?.viewWithTag(31) as! UILabel?)?.text = title }
    }

    public init(title: String? = nil) {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .OverFullScreen
        self.title = title ?? "Connecting"
        transitioningDelegate = self
    }
    required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") } // NSCoding

    // MARK: - UIViewController

    override public func viewDidLoad() {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 128, height: 128))
        containerView.autoresizingMask = [.FlexibleTopMargin, .FlexibleLeftMargin, .FlexibleBottomMargin, .FlexibleRightMargin]
        containerView.backgroundColor = UIColor(white: 0, alpha: 0.75)
        let screenBounds = UIScreen.mainScreen().bounds
        containerView.center = CGPoint(x: screenBounds.midX, y: screenBounds.midY)
        containerView.layer.cornerRadius = 10
        view.addSubview(containerView)

        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        activityIndicatorView.center = CGPoint(x: 128/2, y: 128/2)
        activityIndicatorView.startAnimating()
        containerView.addSubview(activityIndicatorView)

        let titleLabel = UILabel(frame: CGRect(x: 0, y: 128-20-16, width: 128, height: 20))
        titleLabel.font = UIFont.boldSystemFontOfSize(16)
        titleLabel.tag = 31
        titleLabel.text = title
        titleLabel.textAlignment = .Center
        titleLabel.textColor = .whiteColor()
        containerView.addSubview(titleLabel)
    }

    public static func present() {
        presentWithTitle("Connecting")
    }

    public static func presentWithTitle(title: String) {
        sharedLoadingViewController.title = title
        print(sharedLoadingViewController.title)
        UIApplication.auh_topmostViewController.auh_presentViewController(sharedLoadingViewController)
    }

    public static func dismiss(completion: (() -> Void)?) {
        sharedLoadingViewController.dismissViewControllerAnimated(true, completion: completion)
    }

    // MARK: - UIViewControllerTransitioningDelegate

    public func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        fadeAnimator.presenting = true
        return fadeAnimator
    }

    public func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        fadeAnimator.presenting = false
        return fadeAnimator
    }
}

class FadeAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    static let duration = 0.3
    var presenting = false

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return FadeAnimator.duration
    }

    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let key = presenting ? UITransitionContextToViewKey : UITransitionContextFromViewKey
        let fadingView = transitionContext.viewForKey(key)!

        if presenting {
            let containerView = transitionContext.containerView()!
            fadingView.alpha = 1
            containerView.addSubview(fadingView)
            transitionContext.completeTransition(true)
        } else {
            UIView.animateWithDuration(FadeAnimator.duration, animations: { fadingView.alpha = 0 }, completion: { _ in
                transitionContext.completeTransition(true)
            })
        }
    }
}
