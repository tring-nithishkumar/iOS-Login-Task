//
//  AddItemViewController.swift
//  Login
//
//  Created by Tringapps on 07/02/24.
//

import UIKit

class AddItemViewController: UIViewController {

    private var summary: String!
    private var date: String!
    private var id: Int!
    private weak var summaryField: UITextView!
    private weak var datePickerControl: UIDatePicker!
    private weak var addButton: UIButton!
    private var buttonTitle = ""
    private var addItemFuncViewModel: AddItemFuncViewModel = AddItemFuncViewModel()

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    init(summary: String, date: String, id: Int) {
        self.summary = summary
        self.date = date
        self.id = id
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addUI()
    }

    private func addUI() {
        view.backgroundColor = .white

        if id != nil {
            title = "Update Item"
            buttonTitle = "Update"
        } else {
            title = "Add New Item"
            buttonTitle = "Add"
        }

        summaryField = createTextView(placeholder: "Summary")
        datePickerControl = createDatePickerControll()
        addButton = createButton(title: buttonTitle, action: #selector(handleAdd))

        NSLayoutConstraint.activate([
            summaryField.topAnchor.constraint(equalTo: view.topAnchor, constant: 250),
            summaryField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            summaryField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            summaryField.heightAnchor.constraint(equalToConstant: 100),

            datePickerControl.topAnchor.constraint(equalTo: summaryField.bottomAnchor, constant: 20),
            datePickerControl.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            datePickerControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            datePickerControl.heightAnchor.constraint(equalToConstant: 40),

            addButton.topAnchor.constraint(equalTo: datePickerControl.bottomAnchor, constant: 20),
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    private func createTextView(placeholder: String) -> UITextView {
        let textView = UITextView()
        view.addSubview(textView)

        if summary != nil {
            textView.text = summary
        }

        textView.font = UIFont.systemFont(ofSize: 16)
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.black.cgColor
        textView.layer.cornerRadius = 5.0
        textView.isScrollEnabled = true
        textView.showsVerticalScrollIndicator = true
        textView.isEditable = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }

    private func createDatePickerControll() -> UIDatePicker {
        let datePicker = UIDatePicker()
        let dateFormatter = DateFormatter()
        view.addSubview(datePicker)

        if date != nil {
            dateFormatter.dateFormat = "MMM dd yyyy hh:mm a"
            if let date = dateFormatter.date(from: date) {
                datePicker.date = date
            } else {
                print("Error: Unable to convert the initialDate string to a Date object")
            }
        }

        datePicker.datePickerMode = .dateAndTime
        datePicker.addTarget(self, action: #selector(handleDate(datePicker:)), for: UIControl.Event.valueChanged)
        datePicker.frame.size = CGSize(width: 0, height: 300)
        datePicker.preferredDatePickerStyle = .compact
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }

    private func createButton(title: String, action: Selector) -> UIButton {
        let button = UIButton()
        view.addSubview(button)
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        button.backgroundColor = .blue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }

    @objc private func handleBack() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func handleAdd() {
        guard let summary = summaryField.text else {
            return
        }
        let date = addItemFuncViewModel.formatDate(date: datePickerControl.date)
        if summary.count > 0 {
            if id != nil {
                addItemFuncViewModel.callFuncUpdateItemData(updatedSummary: summary, updatedDate: date, id: id)
            } else {
                addItemFuncViewModel.callFuncInsertItemData(summary: summary, date: date)
            }
            navigationController?.popViewController(animated: true)
        } else {
            showAlert(title: "Invalid inputField", message: "The input value must be more than 2 lines.")
        }
    }

    @objc private func handleDate(datePicker: UIDatePicker) {
        datePickerControl.date = datePicker.date
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
