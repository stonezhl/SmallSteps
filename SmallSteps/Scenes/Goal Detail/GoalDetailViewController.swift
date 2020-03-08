//
//  GoalDetailViewController.swift
//  SmallSteps
//
//  Created by Stone Zhang on 2/24/20.
//  Copyright © 2020 Stone Zhang. All rights reserved.
//

import UIKit
import JTAppleCalendar

enum GoalDetailContent {
    case none
    case calendar
    case chart
}

class GoalDetailViewController: UIViewController {
    private let cellIdentifier = "GoalDetailDayCell"
    private let headerIdentifier = "GoalDetailMonthHeader"
    let viewModel: GoalDetailViewModel

    lazy var calendarView: GoalCalendarView = {
        let calendarView = GoalCalendarView(today: viewModel.today, dateRange: (startDate: viewModel.startDate, endDate: viewModel.endDate))
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(calendarView)
        calendarView.isMarked = { [weak self] date in
            return self?.viewModel.hasStep(on: date)
        }
        calendarView.isYearChanged = { [weak self] year in
            self?.title = "\(year)"
        }
        return calendarView
    }()

    lazy var chartView: GoalChartView = {
        let chartView = GoalChartView()
        chartView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(chartView, belowSubview: calendarView)
        return chartView
    }()

    lazy var calendarButton: UIBarButtonItem = {
        let image = UIImage(systemName: "calendar")
        image?.withRenderingMode(.alwaysTemplate)
        let barButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(showCalendarView(sender:)))
        return barButton
    }()

    lazy var chartButton: UIBarButtonItem = {
        let image = UIImage(systemName: "chart.pie")
        image?.withRenderingMode(.alwaysTemplate)
        let barButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(showChartView(sender:)))
        return barButton
    }()

    var currentContent: GoalDetailContent = .none {
        didSet {
            if oldValue == .none {
                switch currentContent {
                case .calendar:
                    calendarButton.tintColor = .systemOrange
                    calendarView.isHidden = false
                    chartButton.tintColor = .label
                    chartView.isHidden = true
                    title = "\(calendarView.year)"
                case .chart:
                    calendarButton.tintColor = .label
                    calendarView.isHidden = true
                    chartButton.tintColor = .systemOrange
                    chartView.isHidden = false
                    title = "Steps Chart"
                default:
                    calendarButton.tintColor = .label
                    calendarView.isHidden = true
                    chartButton.tintColor = .label
                    chartView.isHidden = true
                    title = nil
                }
                return
            }
            guard currentContent != oldValue else { return }
            if currentContent == .calendar {
                calendarButton.tintColor = .systemOrange
                chartButton.tintColor = .label
                title = "\(calendarView.year)"
                UIView.transition(from: chartView,
                                  to: calendarView,
                                  duration: 0.5,
                                  options: [.transitionCurlDown, .showHideTransitionViews],
                                  completion: nil)
            } else {
                calendarButton.tintColor = .label
                chartButton.tintColor = .systemOrange
                title = "Steps Chart"
                UIView.transition(from: calendarView,
                                  to: chartView,
                                  duration: 0.5,
                                  options: [.transitionCurlUp, .showHideTransitionViews],
                                  completion: nil)
            }
        }
    }

    init(viewModel: GoalDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("`init(coder:)` has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItems = [chartButton, calendarButton]
        setupConstraints()
        viewModel.fetchSteps()
        currentContent = .calendar
    }

    @objc func showCalendarView(sender: UIBarButtonItem) {
        currentContent = .calendar
    }

    @objc func showChartView(sender: UIBarButtonItem) {
        currentContent = .chart
    }

    private func setupConstraints() {
        let constraints = [
            // calendar
            calendarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            calendarView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            calendarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            calendarView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            // chart
            chartView.topAnchor.constraint(equalTo: view.topAnchor),
            chartView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            chartView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            chartView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
