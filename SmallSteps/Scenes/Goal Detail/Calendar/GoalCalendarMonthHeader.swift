//
//  GoalCalendarMonthHeader.swift
//  SmallSteps
//
//  Created by Stone Zhang on 2/27/20.
//  Copyright © 2020 Stone Zhang. All rights reserved.
//

import UIKit
import JTAppleCalendar

class GoalCalendarMonthHeader: JTACMonthReusableView {
    lazy var monthsView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        for _ in 0..<7 {
            let label = UILabel()
            label.font = .systemFont(ofSize: 19, weight: .semibold)
            label.textAlignment = .center
            stackView.addArrangedSubview(label)
        }
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()

    var dates: (startDate: Date?, today: Date?) {
        didSet {
            guard let startDate = dates.startDate, let today = dates.today else {
                monthsView.isHidden = true
                return
            }
            let index = startDate.weekday - 1
            let month = startDate.month
            let isThisMonth = (month == today.month)
            let text = Calendar.current.shortMonthSymbols[month - 1]
            monthsView.arrangedSubviews.enumerated().forEach { offset, view in
                guard let label = view as? UILabel else { return }
                if offset == index {
                    label.textColor = isThisMonth ? .systemOrange : .label
                    label.text = text
                } else {
                    label.text = nil
                }
            }
            monthsView.isHidden = false
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
            monthsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            monthsView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            monthsView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
