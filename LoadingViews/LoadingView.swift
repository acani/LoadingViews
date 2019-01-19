import UIKit

open class LoadingView: UIView {
  private var activityIndicatorView: UIActivityIndicatorView {
    return viewWithTag(1)! as! UIActivityIndicatorView
  }

  open var titleLabel: UILabel {
    return viewWithTag(2)! as! UILabel
  }

  public convenience init() {
    self.init(title: "Loading…")
  }

  public init(title: String) {
    let activityIndicatorView = UIActivityIndicatorView(style: .gray)
    let width1 = activityIndicatorView.frame.width
    activityIndicatorView.center = CGPoint(x: width1/2, y: width1/2)
    activityIndicatorView.tag = 1
    activityIndicatorView.isUserInteractionEnabled = false

    let titleLabel = UILabel(frame: .zero)
    titleLabel.font = .systemFont(ofSize: 14)
    titleLabel.tag = 2
    titleLabel.text = title
    titleLabel.textAlignment = .center
    titleLabel.textColor = UIColor(white: 102/255, alpha: 1)
    titleLabel.isUserInteractionEnabled = false

    super.init(frame: .zero)
    isUserInteractionEnabled = false

    addSubview(activityIndicatorView)
    addSubview(titleLabel)

    translatesAutoresizingMaskIntoConstraints = false
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: titleLabel, attribute: .trailing, multiplier: 1, constant: 0),
      NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: activityIndicatorView, attribute: .height, multiplier: 1, constant: 0),
      NSLayoutConstraint(item: titleLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: width1+4),
      NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
      NSLayoutConstraint(item: titleLabel, attribute: .height, relatedBy: .equal, toItem: activityIndicatorView, attribute: .height, multiplier: 1, constant: -1)
    ])
  }
  required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") } // NSCoding

  open func show(in viewController: UIViewController) {
    activityIndicatorView.startAnimating()

    let view = viewController.view
    view?.addSubview(self)
    NSLayoutConstraint.activate([
      NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0),
      NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: viewController.topLayoutGuide.length)
    ])
  }

  open func dismiss() {
    activityIndicatorView.stopAnimating()
    removeFromSuperview()
  }
}
