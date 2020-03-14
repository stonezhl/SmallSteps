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
        segmentedControl.insertSegment(withTitle: "Today", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "All", at: 1, animated: false)
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
        style.actionTitleColor = .systemBackground
        style.isAnimated = false
        var data = PlaceholderData()
        data.image = UIImage(named: "empty_active")
        data.title = "No goals found"
        data.subtitle = "Let's add a goal and then take steps to achieve it."
        data.action = "Add a Goal"
        return Placeholder(data: data, style: style, key: .noResultsKey)
    }()

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
        refreshTableView()
    }

    @objc func segmentedControlValueChanged(sender: UISegmentedControl) {
        refreshTableView()
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
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

    @objc func didTapAddButton(sender: UIBarButtonItem) {
        viewModel.addGoal()
    }

    @objc func didTapArchiveButton(sender: UIBarButtonItem) {
        viewModel.showArchived()
    }

    private func refreshTableView() {
        try? viewModel.fetchActiveGoals(isTodayOnly: segmentedControl.selectedSegmentIndex == 0)
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
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return isEditing ? .delete : .none
    }

    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return viewModel.editActionTitle(at: indexPath)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        viewModel.archiveOrDeleteGoal(at: indexPath)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard !isEditing, viewModel.canTakeStep(at: indexPath) else { return nil }
        let stepAction = UIContextualAction(style: .normal, title: "Take a step") { [weak self] action, view, completion in
            self?.viewModel.takeStep(at: indexPath)
            let cell = tableView.cellForRow(at: indexPath) as! ActiveGoalListCell
            cell.viewModel = self?.viewModel.cellViewModel(at: indexPath)
            completion(true)
        }
        return UISwipeActionsConfiguration(actions: [stepAction])
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
