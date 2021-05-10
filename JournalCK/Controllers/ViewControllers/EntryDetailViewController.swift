//
//  EntryDetailViewController.swift
//  JournalCK
//
//  Created by Travis Halle on 5/10/21.
//

import UIKit

class EntryDetailViewController: UIViewController {

    @IBOutlet weak var entryTitleTextField: UITextField!
    @IBOutlet weak var entryTimestampTextField: UILabel!
    @IBOutlet weak var entryBodyTextField: UITextView!
    
    var entry: Entry?

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.updateViews()
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let title = entryTitleTextField.text, !title.isEmpty,
              let body = entryBodyTextField.text, !title.isEmpty else {return}
        if let entry = entry {
            EntryController.shared.saveEntry(entry: entry) { result in
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }            }
        } else {
            EntryController.shared.createEntryWith(title: title, body: body) { result in
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    @IBAction func clearButtonTapped(_ sender: Any) {
        entryTitleTextField.text = ""
        entryBodyTextField.text = ""
        entryTimestampTextField.text = Date().formatDate()
    }
    func updateViews() {
        guard let entry = entry else {return}
        entryTitleTextField.text = entry.title
        entryTimestampTextField.text = entry.timestamp.formatDate()
        entryBodyTextField.text = entry.body
    }
}//End of class

extension EntryDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        entryTitleTextField.resignFirstResponder()
        return true
    }
}
