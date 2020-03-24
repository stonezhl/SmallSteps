//
//  ActiveGoalListViewController.swift
//  SmallSteps
//
//  Created by Stone Zhang on 2/9/20.
//  Copyright © 2020 Stone Zhang. All rights reserved.
//

import UIKit
import HGPlaceholders

class ActiveGoalListViewController: UIViewController {
    private let cellIdentifier = "ActiveGoalListCell"

    lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.insertSegment(withTitle: NSLocalizedString("Today", comment: "Filter of active goals scene"), at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: NSLocalizedString("All", comment: "Filter of active goals scene"), at: 1, animated: false)
        segmentedControl.selectedSegmentIndex = viewModel.isTodayOnly ? 0 : 1
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(sender:)), for: .valueChanged)
        return segmentedControl
    }()

    lazy var tableView: UITableView = {
        let tableView = TableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.placeholderDelegate = self
        tableView.register(ActiveGoalListCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.rowHeight = 64
        tableView.tableFooterView = UIView()
        tableView.placeholdersProvider = .default
        tableView.placeholdersProvider.add(placeholders: noActiveGoalsPlaceholder)
        return tableView
    }()

    lazy var noActiveGoalsPlaceholder: Placeholder = {
        var style = PlaceholderStyle()
        style.backgroundColor = .systemBackground
        style.titleColor = .label
        style.subtitleColor = .secondaryLabel
        style.actionBackgroundColor = .systemOrange
        style.actionTitleColor = .white
        style.isAnimated = false
        var data = PlaceholderData()
        data.image = UIImage(named: "empty_active")
        data.title =  NSLocalizedString("No goals found", comment: "Title of empty active goals scene")
        data.subtitle = NSLocalizedString("You can take steps to achieve your goal but you need to plan them first", comment: "Subtitle of empty active goals scene")
        data.action = NSLocalizedString("Add a Goal", comment: "Action of empty active goals scene")
        return Placeholder(data: data, style: style, key: .noResultsKey)
    }()

    override func setEditing(_ editing: Bool, animated: Bool) {
        if editing, viewModel.goalsCount == 0 { return }
        super.setEditing(editing, animated: animated)
        if editing {
            if tableView.isEditing {
                tableView.setEditing(false, animated: true)
            }
        }
        tableView.setEditing(editing, animated: true)
        if editing == false {
            tableView.visibleCells.forEach { cell in
                guard let indexPath = tableView.indexPath(for: cell) else { return }
                let cell = cell as! ActiveGoalListCell
                cell.viewModel = self.viewModel.cellViewModel(at: indexPath)
            }
        }
    }

    let viewModel: ActiveGoalListViewModel

    init(viewModel: ActiveGoalListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("`init(coder:)` has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        navigationItem.titleView = segmentedControl
        navigationItem.leftBarButtonItem = editButtonItem
        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus.circle"), style: .plain, target: self, action: #selector(didTapAddButton(sender:)))
        let archiveButton = UIBarButtonItem(image: UIImage(systemName: "archivebox"), style: .plain, target: self, action: #selector(didTapArchiveButton(sender:)))
        navigationItem.rightBarButtonItems = [addButton, archiveButton]
        setupConstraints()
        viewModel.isDataUpdated = { [weak self] in
            self?.tableView.reloadData()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    @objc func segmentedControlValueChanged(sender: UISegmentedControl) {
        try? viewModel.fetchActiveGoals(isTodayOnly: sender.selectedSegmentIndex == 0)
    }

    @objc func didTapAddButton(sender: UIBarButtonItem) {
        viewModel.addGoal()
    }

    @objc func didTapArchiveButton(sender: UIBarButtonItem) {
        viewModel.showArchived()
    }

    private func setupConstraints() {
        let constraints = [
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

extension ActiveGoalListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.goalsCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ActiveGoalListCell
        cell.viewModel = viewModel.cellViewModel(at: indexPath)
        return cell
    }
}

extension ActiveGoalListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if !isEditing { return nil }
        let action = UIContextualAction(style: .destructive, title: nil) { [weak self] action, view, completion in
            self?.viewModel.archiveOrDeleteGoal(at: indexPath)
            self?.tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        action.image = viewModel.editActionImage(at: indexPath)
        return UISwipeActionsConfiguration(actions: [action])
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.showDetail(at: indexPath)
    }
}

extension ActiveGoalListViewController: PlaceholderDelegate {
    func view(_ view: Any, actionButtonTappedFor placeholder: Placeholder) {
        viewModel.addGoal()
    }
}
