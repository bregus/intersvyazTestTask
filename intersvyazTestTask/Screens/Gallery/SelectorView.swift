import UIKit

public final class SelectorView: UICollectionReusableView {
  private let subtitleLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    return label
  }()

  private let arrowImageView = UIImageView()
  private let separatorView = UIView()

  public var subtitle: String? {
    get { subtitleLabel.text }
    set { subtitleLabel.text = newValue }
  }

  public var arrowHidden: Bool {
    get { arrowImageView.isHidden }
    set { arrowImageView.isHidden = newValue }
  }

  public var expanded: Bool = false {
    didSet {
      UIView.animate(withDuration: 0.3) { [self] in
        arrowImageView.transform = expanded ? .init(rotationAngle: .pi) : .init(rotationAngle: -2 * .pi)
      }
    }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupSubtitleLabel()
    setupArrowView()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupSubtitleLabel() {
    addSubview(subtitleLabel)
    subtitleLabel.snp.makeConstraints { make in
      make.top.left.bottom.equalToSuperview().inset(16)
    }
  }

  private func setupArrowView() {
    addSubview(arrowImageView)
    arrowImageView.isHidden = arrowHidden
    arrowImageView.image = UIImage(systemName: "arrowtriangle.down.fill")
    arrowImageView.snp.makeConstraints { make in
      make.centerY.equalTo(subtitleLabel)
      make.right.equalToSuperview().inset(16)
      make.left.equalTo(subtitleLabel.snp.right).inset(-16)
      make.size.equalTo(24)
    }
  }
}
