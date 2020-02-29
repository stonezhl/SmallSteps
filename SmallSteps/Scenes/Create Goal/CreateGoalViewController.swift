//
//  CreateGoalViewController.swift
//  SmallSteps
//
//  Created by Stone Zhang on 2/23/20.
//  Copyright © 2020 Stone Zhang. All rights reserved.
//

import UIKit

class CreateGoalViewController: UIViewController {
    private let cellIdentifier = "CreateGoalFrequencyCell"
    let viewModel: CreateGoalViewModel

    lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textField)
        textField.delegate = self
        textField.placeholder = "Enter a title for your goal"
        textField.font = .systemFont(ofSize: 17)
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .secondarySystemGroupedBackground
        return textField
    }()

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.allowsMultipleSelection = true
        return tableView
    }()

    var tableViewBottomConstraint: NSLayoutConstraint?

    init(viewModel: CreateGoalViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("`init(coder:)` has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Goal"
        view.backgroundColor = .systemBackground
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancelButton(sender:)))
        navigationItem.leftBarButtonItem = cancelButton
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(didTapSaveButton(sender:)))
        navigationItem.rightBarButtonItem = saveButton
        enableKeyboardHideOnTap()
        setupConstraints()
    }

    @objc func didTapSaveButton(sender: UIBarButtonItem) {
        guard let title = titleTextField.text, !title.isEmpty else {
            showAlert(title: "Empty Title", message: "Title can't be empty")
            return
        }
        guard let indexPaths = tableView.indexPathsForSelectedRows else {
            showAlert(title: "Invalid Frequency", message: "Please select at least one frequency")
            return
        }
        viewModel.saveGoal(title: title, selectedIndexPaths: indexPaths)
        if let tabBarController = presentingViewController as? UITabBarController,
            let navigationController = tabBarController.viewControllers?.first as? UINavigationController,
            let viewController = navigationController.viewControllers.first as? ActiveGoalListViewController {
            try? viewController.viewModel.fetchActiveGoals()
        }
        dismiss()
    }

    @objc func didTapCancelButton(sender: UIBarButtonItem) {
        dismiss()
    }

    private func dismiss() {
        dismiss(animated: true) {
            self.viewModel.didExitScene?()
        }
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }

    private func setupConstraints() {
        let tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 44 * 7)
        tableViewHeightConstraint.priority = UILayoutPriority(rawValue: 999)
        tableViewBottomConstraint = tableView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor)
        let constraints = [
            // title
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            titleTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 32),
            titleTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -32),
            titleTextField.heightAnchor.constraint(equalToConstant: 34),
            // table
            tableView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 32),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableViewHeightConstraint,
            tableViewBottomConstraint!,
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

extension CreateGoalViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.frequencyTitles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = viewModel.frequencyTitles[indexPath.row]
        let selectedIndexPaths = tableView.indexPathsForSelectedRows
        let isSelected = selectedIndexPaths != nil && selectedIndexPaths!.contains(indexPath)
        cell.accessoryType = isSelected ? .checkmark : .none
        cell.backgroundColor = .secondarySystemGroupedBackground
        return cell
    }
}

extension CreateGoalViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        cell.accessoryType = .checkmark
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        cell.accessoryType = .none
    }
}

extension CreateGoalViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleTextField.resignFirstResponder()
        return false
    }

    private func enableKeyboardHideOnTap(){
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard(sender:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func hideKeyboard(sender: UIView) {
        titleTextField.resignFirstResponder()
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
                return
        }
        UIView.animate(withDuration: duration) { [weak self] in
            self?.tableViewBottomConstraint?.constant = -keyboardFrame.height
            self?.view.layoutIfNeeded()
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        UIView.animate(withDuration: duration) { [weak self] in
            self?.tableViewBottomConstraint?.constant = 0
            self?.view.layoutIfNeeded()
        }
    }
}
