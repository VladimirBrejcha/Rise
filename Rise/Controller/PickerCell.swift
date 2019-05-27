//
//  CustomCell.swift
//  Rise
//
//  Created by Vladimir Korolev on 27/05/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

public protocol PickerCellDelegate: class {
    func pickerCell(_ cell: PickerCell, didPickDate date: Date?)
}

open class PickerCell: UITableViewCell {

    weak var delegate: PickerCellDelegate?

    static let dateFormatter = DateFormatter()

    /// The selected date, set to current date/time on initialization.
    open var date: Date = Date() {
        didSet {
            datePicker.date = date
            PickerCell.dateFormatter.dateStyle = dateStyle
            PickerCell.dateFormatter.timeStyle = timeStyle
            rightLabel.text = PickerCell.dateFormatter.string(from: date)
        }
    }

    /// The timestyle.
    open var timeStyle = DateFormatter.Style.short {
        didSet {
            PickerCell.dateFormatter.timeStyle = timeStyle
            rightLabel.text = PickerCell.dateFormatter.string(from: date)
        }
    }

    /// The datestyle.
    open var dateStyle = DateFormatter.Style.medium {
        didSet {
            PickerCell.dateFormatter.dateStyle = dateStyle
            rightLabel.text = PickerCell.dateFormatter.string(from: date)
        }
    }

    open var leftLabel = UILabel() /// Label on the left side of the cell.
    open var rightLabel = UILabel() /// Label on the right side of the cell.

    /// Color of the right label. Default is the color of a normal detail label.
    open var rightLabelTextColor = UIColor(hue: 0.639, saturation: 0.041, brightness: 0.576, alpha: 1.0) {
        didSet {
            rightLabel.textColor = rightLabelTextColor
        }
    }

    var datePickerContainer = UIView()

    open var datePicker: UIDatePicker = UIDatePicker() /// The datepicker embeded in the cell.

    open var pickerView: UIPickerView = UIPickerView() // The pickerview embeded in the cell.

    open var expanded = false /// Is the cell expanded?
    var unexpandedHeight = CGFloat(44)

    // MARK: Life cycle

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override open func awakeFromNib() {
        super.awakeFromNib()
        setup()

    }

    // MARK: Setup UI

    private func setupConstraints() {
        leftLabelConstraints()
        rightLabelConstraints()
        containerConstraints()
        datePickerConstraints()
        pickerConstraints()
    }

    private func setup() {

        self.clipsToBounds = true

        let views = [leftLabel, rightLabel, datePickerContainer, datePicker, pickerView]

        for view in views {
            self.contentView .addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }

        pickerView.isHidden = true
        pickerView.delegate = self
        pickerView.dataSource = self

        datePicker.addTarget(self, action: #selector(PickerCell.datePicked), for: UIControl.Event.valueChanged)

        datePickerContainer.clipsToBounds = true
        datePickerContainer.addSubview(datePicker)
        datePickerContainer.addSubview(pickerView)

        setupConstraints()

        // Clear seconds.
        let timeIntervalWithoutSeconds = floor(date.timeIntervalSinceReferenceDate / 60.0) * 60.0
        date = Date(timeIntervalSinceReferenceDate: timeIntervalWithoutSeconds)

        leftLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        rightLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }

    open func datePickerHeight() -> CGFloat {
        let expandedHeight = unexpandedHeight + CGFloat(datePicker.frame.size.height)
        return expanded ? expandedHeight : unexpandedHeight
    }

    open func selectedInTableView(_ tableView: UITableView) {

        expanded = !expanded

        UIView.transition(with: rightLabel,
                          duration: 0.25,
                          options: UIView.AnimationOptions.transitionCrossDissolve,
                          animations: { () -> Void in
                            self.rightLabel.textColor = self.expanded ? self.tintColor : self.rightLabelTextColor

        },
                          completion: nil)

        tableView.beginUpdates()
        tableView.endUpdates()
    }

    // Action for the datePicker ValueChanged event.
    @objc func datePicked() {

        date = datePicker.date

        // date picked, call delegate method
        self.delegate?.pickerCell(self, didPickDate: date)
    }

    private func leftLabelConstraints() {
        self.contentView.addConstraints([
            NSLayoutConstraint(
                item: leftLabel,
                attribute: NSLayoutConstraint.Attribute.height,
                relatedBy: NSLayoutConstraint.Relation.equal,
                toItem: nil,
                attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                multiplier: 1.0,
                constant: 44
            ),
            NSLayoutConstraint(
                item: leftLabel,
                attribute: NSLayoutConstraint.Attribute.top,
                relatedBy: NSLayoutConstraint.Relation.equal,
                toItem: self.contentView,
                attribute: NSLayoutConstraint.Attribute.top,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: leftLabel,
                attribute: NSLayoutConstraint.Attribute.left,
                relatedBy: NSLayoutConstraint.Relation.equal,
                toItem: self.contentView,
                attribute: NSLayoutConstraint.Attribute.left,
                multiplier: 1.0,
                constant: self.separatorInset.left
            )
            ])
    }

    private func rightLabelConstraints() {
        self.contentView.addConstraints([
            NSLayoutConstraint(
                item: rightLabel,
                attribute: NSLayoutConstraint.Attribute.height,
                relatedBy: NSLayoutConstraint.Relation.equal,
                toItem: nil,
                attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                multiplier: 1.0,
                constant: 44
            ),
            NSLayoutConstraint(
                item: rightLabel,
                attribute: NSLayoutConstraint.Attribute.top,
                relatedBy: NSLayoutConstraint.Relation.equal,
                toItem: self.contentView,
                attribute: NSLayoutConstraint.Attribute.top,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: rightLabel,
                attribute: NSLayoutConstraint.Attribute.right,
                relatedBy: NSLayoutConstraint.Relation.equal,
                toItem: self.contentView,
                attribute: NSLayoutConstraint.Attribute.right,
                multiplier: 1.0,
                constant: -self.separatorInset.left
            )
            ])
    }

    private func containerConstraints() {
        self.contentView.addConstraints([
            NSLayoutConstraint(
                item: datePickerContainer,
                attribute: NSLayoutConstraint.Attribute.left,
                relatedBy: NSLayoutConstraint.Relation.equal,
                toItem: self.contentView,
                attribute: NSLayoutConstraint.Attribute.left,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: datePickerContainer,
                attribute: NSLayoutConstraint.Attribute.right,
                relatedBy: NSLayoutConstraint.Relation.equal,
                toItem: self.contentView,
                attribute: NSLayoutConstraint.Attribute.right,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: datePickerContainer,
                attribute: NSLayoutConstraint.Attribute.top,
                relatedBy: NSLayoutConstraint.Relation.equal,
                toItem: leftLabel,
                attribute: NSLayoutConstraint.Attribute.bottom,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: datePickerContainer,
                attribute: NSLayoutConstraint.Attribute.bottom,
                relatedBy: NSLayoutConstraint.Relation.equal,
                toItem: self.contentView,
                attribute: NSLayoutConstraint.Attribute.bottom,
                multiplier: 1.0,
                constant: 1
            )
            ])
    }

    private func datePickerConstraints() {
        datePickerContainer.addConstraints([
            NSLayoutConstraint(
                item: datePicker,
                attribute: NSLayoutConstraint.Attribute.left,
                relatedBy: NSLayoutConstraint.Relation.equal,
                toItem: datePickerContainer,
                attribute: NSLayoutConstraint.Attribute.left,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: datePicker,
                attribute: NSLayoutConstraint.Attribute.right,
                relatedBy: NSLayoutConstraint.Relation.equal,
                toItem: datePickerContainer,
                attribute: NSLayoutConstraint.Attribute.right,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: datePicker,
                attribute: NSLayoutConstraint.Attribute.top,
                relatedBy: NSLayoutConstraint.Relation.equal,
                toItem: datePickerContainer,
                attribute: NSLayoutConstraint.Attribute.top,
                multiplier: 1.0,
                constant: 0
            )
            ])
    }

    private func pickerConstraints() {
        datePickerContainer.addConstraints([
            NSLayoutConstraint(
                item: pickerView,
                attribute: NSLayoutConstraint.Attribute.left,
                relatedBy: NSLayoutConstraint.Relation.equal,
                toItem: datePickerContainer,
                attribute: NSLayoutConstraint.Attribute.left,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: pickerView,
                attribute: NSLayoutConstraint.Attribute.right,
                relatedBy: NSLayoutConstraint.Relation.equal,
                toItem: datePickerContainer,
                attribute: NSLayoutConstraint.Attribute.right,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: pickerView,
                attribute: NSLayoutConstraint.Attribute.top,
                relatedBy: NSLayoutConstraint.Relation.equal,
                toItem: datePickerContainer,
                attribute: NSLayoutConstraint.Attribute.top,
                multiplier: 1.0,
                constant: 0
            )
            ])
    }

}

extension PickerCell: UIPickerViewDelegate, UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    public func pickerView(_ pickerView: UIPickerView,
                           numberOfRowsInComponent component: Int) -> Int {
        return 4
    }

    public func pickerView(_ pickerView: UIPickerView,
                           attributedTitleForRow row: Int,
                           forComponent component: Int) -> NSAttributedString? {

        switch PersonalTimeViewController.numberOfCell {
        case 0:
            return NSAttributedString(string: Contstants.DataForPicker.timeYouHaveArray[row],
                                      attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        case 3:
            return NSAttributedString(string: Contstants.DataForPicker.wantedHoursOfSleep[row],
                                      attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        default:
            return NSAttributedString(string: Contstants.DataForPicker.timeYouHaveArray[row],
                                      attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        }
    }

}
