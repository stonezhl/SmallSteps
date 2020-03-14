//
//  GoalCalendarView.swift
//  SmallSteps
//
//  Created by Stone Zhang on 3/7/20.
//  Copyright © 2020 Stone Zhang. All rights reserved.
//

import UIKit
import JTAppleCalendar

typealias DateRange = (startDate: Date, endDate: Date)

class GoalCalendarView: UIView {
    private let cellIdentifier = "GoalCalendarDayCell"
    private let headerIdentifier = "GoalCalendarMonthHeader"

    lazy var weekdaysView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        Calendar.current.veryShortWeekdaySymbols.enumerated().forEach { offset, weekday in
            let label = UILabel()
            label.text = weekday
            label.font = .systemFont(ofSize: 11, weight: .semibold)
            label.textColor = (offset == 0 || offset == 6 ? .secondaryLabel : .label)
            label.textAlignment = .center
            stackView.addArrangedSubview(label)
        }
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()

    lazy var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemChromeMaterial)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        weekdaysView.insertSubview(visualEffectView, at: 0)
        return visualEffectView
    }()

    lazy var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        weekdaysView.addSubview(view)
        view.layer.shadowOffset = CGSize(width: 0, height: 1 / UIScreen.main.scale)
        view.layer.shadowRadius = 0
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.25
        view.backgroundColor = .separator
        return view
    }()

    lazy var monthView: JTACMonthView = {
        let monthView = JTACMonthView()
        monthView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(monthView)
        monthView.calendarDataSource = self
        monthView.calendarDelegate = self
        monthView.register(GoalCalendarDayCell.self, forCellWithReuseIdentifier: cellIdentifier)
        monthView.register(GoalCalendarMonthHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        monthView.minimumInteritemSpacing = 0
        monthView.minimumLineSpacing = 0
        monthView.cellSize = 72
        monthView.backgroundColor = .systemBackground
        return monthView
    }()

    let today: Date
    let archivedDate: Date?
    let dateRange: DateRange
    private(set) var year: Int {
        didSet {
            isYearChanged?(year)
        }
    }
    var isMarked: ((Date) -> (Bool?))?
    var isYearChanged: ((Int) -> Void)?

    init(today: Date, archivedDate: Date?, dateRange: DateRange) {
        self.today = today
        self.archivedDate = archivedDate
        self.dateRange = dateRange
        year = today.year
        super.init(frame: .zero)
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func scrollToToday(animated: Bool) {
        // https://github.com/patchthecode/JTAppleCalendar/issues/1230
//        monthView.scrollToDate(today)
    }

    private func setupConstraints() {
        let constraints = [
            // weekdays
            weekdaysView.topAnchor.constraint(equalTo: topAnchor),
            weekdaysView.leadingAnchor.constraint(equalTo: leadingAnchor),
            weekdaysView.trailingAnchor.constraint(equalTo: trailingAnchor),
            weekdaysView.heightAnchor.constraint(equalToConstant: 24),
            // blur
            blurEffectView.topAnchor.constraint(equalTo: weekdaysView.topAnchor),
            blurEffectView.leadingAnchor.constraint(equalTo: weekdaysView.leadingAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: weekdaysView.bottomAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: weekdaysView.trailingAnchor),
            // separator
            separatorView.leadingAnchor.constraint(equalTo: weekdaysView.leadingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: weekdaysView.bottomAnchor),
            separatorView.trailingAnchor.constraint(equalTo: weekdaysView.trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale),
            // month
            monthView.topAnchor.constraint(equalTo: weekdaysView.bottomAnchor),
            monthView.leadingAnchor.constraint(equalTo: leadingAnchor),
            monthView.bottomAnchor.constraint(equalTo: bottomAnchor),
            monthView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

extension GoalCalendarView: JTACMonthViewDataSource {
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        return ConfigurationParameters(startDate: dateRange.startDate,
                                       endDate: dateRange.endDate,
                                       generateInDates: .forAllMonths,
                                       generateOutDates: .tillEndOfRow)
    }
}

extension GoalCalendarView: JTACMonthViewDelegate {
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! GoalCalendarDayCell
        configureCell(cell: cell, cellState: cellState)
        return cell
    }

    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        configureCell(cell: cell as! GoalCalendarDayCell, cellState: cellState)
    }

    func configureCell(cell: GoalCalendarDayCell, cellState: CellState) {
        cell.dateLabel.text = cellState.text
        if cellState.dateBelongsTo == .thisMonth {
            if let archivedDate = archivedDate {
                cell.dateValue = (date: cellState.date, isArchivedDate: cellState.date.inSameDayAs(archivedDate))
            } else {
                cell.dateValue = (date: cellState.date, isArchivedDate: false)
            }
            cell.isMarked = isMarked?(cellState.date)
            cell.isHidden = false
        } else {
            cell.isHidden = true
        }
    }

    func calendarSizeForMonths(_ calendar: JTACMonthView?) -> MonthSize? {
        return MonthSize(defaultSize: 32)
    }

    func calendar(_ calendar: JTACMonthView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTACMonthReusableView {
        let startDate = range.start
        let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: headerIdentifier, for: indexPath) as! GoalCalendarMonthHeader
        header.dates = (startDate: startDate, today: today)
        year = startDate.year
        return header
    }
}
