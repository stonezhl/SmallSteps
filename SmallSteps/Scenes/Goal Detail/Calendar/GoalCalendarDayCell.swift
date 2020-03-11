//
//  GoalCalendarDayCell.swift
//  SmallSteps
//
//  Created by Stone Zhang on 2/26/20.
//  Copyright © 2020 Stone Zhang. All rights reserved.
//

import UIKit
import JTAppleCalendar

class GoalCalendarDayCell: JTACDayCell {
    lazy var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        view.backgroundColor = .separator
        return view
    }()

    lazy var backView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        view.layer.cornerRadius = 14
        view.layer.masksToBounds = true
        return view
    }()

    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        backView.addSubview(label)
        label.font = .systemFont(ofSize: 17)
        return label
    }()

    lazy var markView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = true
        return view
    }()

    var dateValue: (date: Date, isArchivedDate: Bool)? {
        didSet {
            guard let value = dateValue else {
                dateLabel.textColor = .label
                backView.backgroundColor = .clear
                return
            }
            let calendar = Calendar.current
            if calendar.isDateInToday(value.date) {
                dateLabel.textColor = .white
                backView.backgroundColor = .systemOrange
            } else {
                dateLabel.textColor = calendar.isDateInWeekend(value.date) ? .secondaryLabel : .label
                backView.backgroundColor = value.isArchivedDate ? .systemFill : .clear
            }
        }
    }

    var isMarked: Bool? {
        didSet {
            if let isMarked = isMarked {
                markView.backgroundColor = isMarked ? .systemOrange : .systemFill
                markView.isHidden = false
            } else {
                markView.isHidden = true
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupConstraints()
    }

    private func setupConstraints() {
        let constraints = [
            // separator
            separatorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale),
            // back
            backView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            backView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            backView.widthAnchor.constraint(equalToConstant: 28),
            backView.heightAnchor.constraint(equalToConstant: 28),
            // date
            dateLabel.centerXAnchor.constraint(equalTo: backView.centerXAnchor),
            dateLabel.centerYAnchor.constraint(equalTo: backView.centerYAnchor),
            // mark
            markView.topAnchor.constraint(equalTo: backView.bottomAnchor, constant: 6),
            markView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            markView.widthAnchor.constraint(equalToConstant: 8),
            markView.heightAnchor.constraint(equalToConstant: 8),
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
