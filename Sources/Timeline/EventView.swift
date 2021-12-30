import UIKit

open class EventView: UIView {
    public var descriptor: EventDescriptor?
    public var color = SystemColors.label

    public var contentHeight: CGFloat {
        return titleView.frame.height
    }

    public lazy var titleView: UITextView = {
        let view = UITextView()
        view.isUserInteractionEnabled = false
        view.backgroundColor = .clear
        view.isScrollEnabled = false
        return view
    }()
    
    public lazy var timeView: UITextView = {
        let view = UITextView()
        view.isUserInteractionEnabled = false
        view.backgroundColor = .clear
        view.isScrollEnabled = false
        return view
    }()
    
    public lazy var redCircle: UIView = {
        let view = UIView()
        let errorRed500 = UIColor(red: 0.92, green: 0.17, blue: 0.12, alpha: 1.00)//#EA2B1F
        view.backgroundColor = errorRed500
        view.layer.cornerRadius = 4
        
        return view
    }()

  /// Resize Handle views showing up when editing the event.
  /// The top handle has a tag of `0` and the bottom has a tag of `1`
  public lazy var eventResizeHandles = [EventResizeHandleView(), EventResizeHandleView()]

  override public init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }

  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    configure()
  }

  private func configure() {
    clipsToBounds = false
    color = tintColor
    layer.cornerRadius = 5
    layer.masksToBounds = true
    addSubview(titleView)
    addSubview(timeView)
    addSubview(redCircle)
    
    for (idx, handle) in eventResizeHandles.enumerated() {
      handle.tag = idx
      addSubview(handle)
    }
  }

  public func updateWithDescriptor(event: EventDescriptor) {
    if let titleAttributedText = event.titleAttributedText {
        titleView.attributedText = titleAttributedText
    } else {
        titleView.text = event.titleText
        titleView.textColor = event.textColor
        titleView.font = .boldSystemFont(ofSize: 13)
    }
    
    if let timeAttributedText = event.timeAttributedText {
        timeView.attributedText = timeAttributedText
    } else {
        timeView.text = event.timeText
        timeView.textColor = event.textColor
        timeView.font = .systemFont(ofSize: 12)
    }
    
    if let lineBreakMode = event.lineBreakMode {
        titleView.textContainer.lineBreakMode = lineBreakMode
        timeView.textContainer.lineBreakMode = lineBreakMode
    }
    
    if event.isHiddenRedCircle{
        redCircle.isHidden = true
    } else {
        redCircle.isHidden = false
    }
    
    descriptor = event
    backgroundColor = event.backgroundColor
    layer.borderWidth = event.borderWidth
    layer.borderColor = event.borderColor
    color = event.color
    eventResizeHandles.forEach{
      $0.borderColor = event.color
      $0.isHidden = event.editedEvent == nil
    }
    drawsShadow = event.editedEvent != nil
    setNeedsDisplay()
    setNeedsLayout()
  }
  
  public func animateCreation() {
    transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
    func scaleAnimation() {
      transform = .identity
    }
    UIView.animate(withDuration: 0.2,
                   delay: 0,
                   usingSpringWithDamping: 0.2,
                   initialSpringVelocity: 10,
                   options: [],
                   animations: scaleAnimation,
                   completion: nil)
  }

  /**
   Custom implementation of the hitTest method is needed for the tap gesture recognizers
   located in the ResizeHandleView to work.
   Since the ResizeHandleView could be outside of the EventView's bounds, the touches to the ResizeHandleView
   are ignored.
   In the custom implementation the method is recursively invoked for all of the subviews,
   regardless of their position in relation to the Timeline's bounds.
   */
  public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    for resizeHandle in eventResizeHandles {
      if let subSubView = resizeHandle.hitTest(convert(point, to: resizeHandle), with: event) {
        return subSubView
      }
    }
    return super.hitTest(point, with: event)
  }

  override open func draw(_ rect: CGRect) {
    super.draw(rect)
    /*
    guard let context = UIGraphicsGetCurrentContext() else {
      return
    }
    context.interpolationQuality = .none
    context.saveGState()
    context.setStrokeColor(color.cgColor)
    context.setLineWidth(3)
    context.translateBy(x: 0, y: 0.5)
    let leftToRight = UIView.userInterfaceLayoutDirection(for: semanticContentAttribute) == .leftToRight
    let x: CGFloat = leftToRight ? 0 : frame.width - 1  // 1 is the line width
    let y: CGFloat = 0
    context.beginPath()
    context.move(to: CGPoint(x: x, y: y))
    context.addLine(to: CGPoint(x: x, y: (bounds).height))
    context.strokePath()
    context.restoreGState()
 */
  }

  private var drawsShadow = false

  override open func layoutSubviews() {
    super.layoutSubviews()
    if redCircle.isHidden{
        titleView.frame = {
            return CGRect(x: bounds.minX + 7, y: bounds.minY, width: bounds.width - 3, height: 25)
        }()
    } else {
        titleView.frame = {
            return CGRect(x: bounds.minX + 26, y: bounds.minY, width: bounds.width - 3, height: 25)
        }()
    }
    
    timeView.frame = {
        return CGRect(x: bounds.minX + 7, y: bounds.minY + 19, width: bounds.width - 3, height: 20)
    }()
    
    redCircle.frame = {
        return CGRect(x: bounds.minX + 13, y: bounds.minY + 12, width: 8, height: 8)
    }()
    
    if frame.minY < 0 {
      var textFrame = titleView.frame;
      textFrame.origin.y = frame.minY * -1;
      textFrame.size.height += frame.minY;
      titleView.frame = textFrame;
    }
    let first = eventResizeHandles.first
    let last = eventResizeHandles.last
    let radius: CGFloat = 40
    let yPad: CGFloat =  -radius / 2
    let width = bounds.width
    let height = bounds.height
    let size = CGSize(width: radius, height: radius)
    first?.frame = CGRect(origin: CGPoint(x: width - radius - layoutMargins.right, y: yPad),
                          size: size)
    last?.frame = CGRect(origin: CGPoint(x: layoutMargins.left, y: height - yPad - radius),
                         size: size)
    
    if drawsShadow {
      applySketchShadow(alpha: 0.13,
                        blur: 10)
    }
  }

  private func applySketchShadow(
    color: UIColor = .black,
    alpha: Float = 0.5,
    x: CGFloat = 0,
    y: CGFloat = 2,
    blur: CGFloat = 4,
    spread: CGFloat = 0)
  {
    layer.shadowColor = color.cgColor
    layer.shadowOpacity = alpha
    layer.shadowOffset = CGSize(width: x, height: y)
    layer.shadowRadius = blur / 2.0
    if spread == 0 {
      layer.shadowPath = nil
    } else {
      let dx = -spread
      let rect = bounds.insetBy(dx: dx, dy: dx)
      layer.shadowPath = UIBezierPath(rect: rect).cgPath
    }
  }
}
