//
//  GoalDetailViewController.swift
//  SmallSteps
//
//  Created by Stone Zhang on 2/24/20.
//  Copyright © 2020 Stone Zhang. All rights reserved.
//

import UIKit
import JTAppleCalendar

class GoalDetailViewController: UIViewController {
    private let cellIdentifier = "GoalDetailDayCell"
    private let headerIdentifier = "GoalDetailMonthHeader"
    let viewModel: GoalDetailViewModel

    lazy var weekdaysView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
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
        view.addSubview(monthView)
        monthView.calendarDataSource = self
        monthView.calendarDelegate = self
        monthView.register(GoalDetailDayCell.self, forCellWithReuseIdentifier: cellIdentifier)
        monthView.register(GoalDetailMonthHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        monthView.minimumInteritemSpacing = 0
        monthView.minimumLineSpacing = 0
        monthView.cellSize = 72
        monthView.backgroundColor = .systemBackground
        return monthView
    }()

    init(viewModel: GoalDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("`init(coder:)` has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.title(on: viewModel.today)
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "calendar"), style: .plain, target: self, action: #selector(scrollToToday(sender:)))
        setupConstraints()
        viewModel.fetchSteps()
        goToToday(animated: false)
    }

    @objc func scrollToToday(sender: UIBarButtonItem) {
        goToToday(animated: true)
    }

    private func goToToday(animated: Bool) {
        if let indexPath = viewModel.todayIndex {
            monthView.scrollToItem(at: indexPath, at: .centeredVertically, animated: animated)
        }
    }

    private func setupConstraints() {
        let constraints = [
            // weekdays
            weekdaysView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            weekdaysView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            weekdaysView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
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
            monthView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            monthView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            monthView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

extension GoalDetailViewController: JTACMonthViewDataSource {
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        return ConfigurationParameters(startDate: viewModel.startDate,
                                       endDate: viewModel.endDate,
                                       generateInDates: .forAllMonths,
                                       generateOutDates: .tillEndOfRow)
    }
}

extension GoalDetailViewController: JTACMonthViewDelegate {
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        if Calendar.current.isDateInToday(date) {
            viewModel.todayIndex = indexPath
        }
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! GoalDetailDayCell
        configureCell(cell: cell, cellState: cellState)
        return cell
    }

    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        configureCell(cell: cell as! GoalDetailDayCell, cellState: cellState)
    }

    func configureCell(cell: GoalDetailDayCell, cellState: CellState) {
        cell.dateLabel.text = cellState.text
        if cellState.dateBelongsTo == .thisMonth {
            cell.date = cellState.date
            cell.isMarked = viewModel.hasStep(on: cellState.date)
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
        title = viewModel.title(on: startDate)
        let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: headerIdentifier, for: indexPath) as! GoalDetailMonthHeader
        header.dates = (date: startDate, today: viewModel.today)
        return header
    }
}
