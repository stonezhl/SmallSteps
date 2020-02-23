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
        textField.font = .systemFont(ofSize: 18)
        textField.borderStyle = .roundedRect
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
        view.backgroundColor = UIColor.white
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancelButton(sender:)))
        navigationItem.leftBarButtonItems = [cancelButton]
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(didTapSaveButton(sender:)))
        navigationItem.rightBarButtonItems = [saveButton]
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
            viewController.viewModel.refreshGoals()
            viewController.tableView.reloadData()
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
        let constraints = [
            // title
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            titleTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 64),
            titleTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -64),
            // table
            tableView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 32),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
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
        UIView.animate(withDuration: duration) {
            self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        UIView.animate(withDuration: duration) {
            self.tableView.contentInset = .zero
        }
    }
}
