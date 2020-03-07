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

    lazy var calendarView: GoalCalendarView = {
        let calendarView = GoalCalendarView(today: viewModel.today, dateRange: (startDate: viewModel.startDate, endDate: viewModel.endDate))
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(calendarView)
        calendarView.isMarked = { [weak self] date in
            return self?.viewModel.hasStep(on: date)
        }
        calendarView.isMonthChanged = { [weak self] startDate in
            self?.title = self?.viewModel.title(on: startDate)
        }
        return calendarView
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
        calendarView.scrollToToday(animated: false)
    }

    @objc func scrollToToday(sender: UIBarButtonItem) {
        calendarView.scrollToToday(animated: true)
    }

    private func setupConstraints() {
        let constraints = [
            calendarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            calendarView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            calendarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            calendarView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
