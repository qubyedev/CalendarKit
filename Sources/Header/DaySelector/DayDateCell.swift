import UIKit

public final class DayDateCell: UIView, DaySelectorItemProtocol {

  private let dateLabel = DateLabel()
  private let dayLabel = UILabel()

  private var regularSizeClassFontSize: CGFloat = 17

  public var date = Date() {
    didSet {
      dateLabel.date = date
      updateState()
    }
  }

  public var calendar = Calendar.autoupdatingCurrent {
    didSet {
      dateLabel.calendar = calendar
      updateState()
    }
  }


  public var selected: Bool {
    get {
      return dateLabel.selected
    }
    set(value) {
      dateLabel.selected = value
      updateState()
    }
  }

  var style = DaySelectorStyle()

  override public var intrinsicContentSize: CGSize {
    return CGSize(width: 75, height: 35)
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }

  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    configure()
  }

  private func configure() {
    clipsToBounds = true
    [dateLabel, dayLabel].forEach(addSubview(_:))
  }

  public func updateStyle(_ newStyle: DaySelectorStyle) {
    style = newStyle
    dateLabel.updateStyle(newStyle)
    updateState()
  }

  private func updateState() {
//    let isWeekend = isAWeekend(date: date)
    dayLabel.font = UIFont.systemFont(ofSize: 14)
//    dayLabel.textColor = isWeekend ? style.weekendTextColor : style.inactiveTextColor
    // 0114 by yuan
    if selected{
        dayLabel.textColor = style.activeTextColor
    } else {
        dayLabel.textColor = style.inactiveTextColor
    }
    // 0114 by yuan
    
    dateLabel.updateState()
    updateDayLabel()
    setNeedsLayout()
  }

  private func updateDayLabel() {
    let daySymbols = calendar.shortWeekdaySymbols
    let weekendMask = [true] + [Bool](repeating: false, count: 5) + [true]
    var weekDays = Array(zip(daySymbols, weekendMask))
    weekDays.shift(calendar.firstWeekday - 1)
    let weekDay = component(component: .weekday, from: date)
    dayLabel.text = "\(daySymbols[weekDay - 1])"// 20211230 did work with "eee"
//    print("test 0117 dayLabel: \(dayLabel.text)")
    
    // 0114 by yuan
    if selected{
        dayLabel.textColor = style.activeTextColor
    } else {
        dayLabel.textColor = style.inactiveTextColor
    }
    // 0114 by yuan
  }

  private func component(component: Calendar.Component, from date: Date) -> Int {
    return calendar.component(component, from: date)
  }

  private func isAWeekend(date: Date) -> Bool {
    let weekday = component(component: .weekday, from: date)
    if weekday == 7 || weekday == 1 {
      return true
    }
    return false
  }

  override public func layoutSubviews() {
    super.layoutSubviews()
    dayLabel.sizeToFit()
    dayLabel.center.y = center.y
    dayLabel.frame.size = CGSize(width: dayLabel.frame.size.width, height: 30.0)
//    dayLabel.center.y = 22.25
//    print("test 0117 dayLabel.center.y: \(dayLabel.center.y)")
//    print("test 0117 dayLabel.bounds: \(dayLabel.bounds)")
//    let interItemSpacing: CGFloat = selected ? 5 : 3
//    let interItemSpacing: CGFloat = 5
    dateLabel.sizeToFit()
    dateLabel.center.y = center.y
//    dateLabel.center.y = 22.25
//    dateLabel.frame.origin.x = dayLabel.frame.maxX + interItemSpacing
    dateLabel.frame.size = CGSize(width: 30, height: 30)
    dayLabel.frame.origin.x = dateLabel.frame.maxX// + interItemSpacing
//    print("test 0117 dateLabel.center.y: \(dateLabel.center.y)")
//    print("test 0117 dateLabel.bounds: \(dateLabel.bounds)")

    let freeSpace = bounds.width - (dayLabel.frame.origin.x + dayLabel.frame.width)
    let padding = freeSpace / 2
    [dateLabel, dayLabel].forEach { (label) in
      label.frame.origin.x += padding
        print("test 0117 label.text: \(label.text)")
    }
  }
  override public func tintColorDidChange() {
    updateState()
  }
}
