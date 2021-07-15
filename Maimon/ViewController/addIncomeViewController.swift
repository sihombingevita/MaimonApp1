//
//  addIncomeViewController.swift
//  Maimon
//
//  Created by San on 14/07/21.
//

import UIKit

class addIncomeViewController: UIViewController {

    @IBOutlet weak var priceIncome: UITextField!
    @IBOutlet weak var dateIncome: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        priceIncome.keyboardType = .numberPad
        priceIncome.layer.cornerRadius = 15
        priceIncome.layer.borderWidth = 0.5
        
        dateIncome.layer.cornerRadius = 15
        dateIncome.layer.borderWidth = 0.5
        
        self.dateIncome.datePicker(target: self, doneAction: #selector(doneAction), cancelAction: #selector(cancelAction), datePickerMode: .date)
        

        // Do any additional setup after loading the view.
    }
    
    @objc
    func cancelAction() {
        self.dateIncome.resignFirstResponder()
    }

    @objc
    func doneAction() {
        if let datePickerView = self.dateIncome.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let dateString = dateFormatter.string(from: datePickerView.date)
            self.dateIncome.text = dateString
            
            print(datePickerView.date)
            print(dateString)
            
            self.dateIncome.resignFirstResponder()
        }
    }

}
extension UITextField {
    func datePicker<T>(target: T,
                       doneAction: Selector,
                       cancelAction: Selector,
                       datePickerMode: UIDatePicker.Mode = .date) {
        let screenWidth = UIScreen.main.bounds.width
        
        func buttonItem(withSystemItemStyle style: UIBarButtonItem.SystemItem) -> UIBarButtonItem {
            let buttonTarget = style == .flexibleSpace ? nil : target
            let action: Selector? = {
                switch style {
                case .cancel:
                    return cancelAction
                case .done:
                    return doneAction
                default:
                    return nil
                }
            }()
            
            let barButtonItem = UIBarButtonItem(barButtonSystemItem: style,
                                                target: buttonTarget,
                                                action: action)
            
            return barButtonItem
        }
        
        let datePicker = UIDatePicker(frame: CGRect(x: 0,
                                                    y: 0,
                                                    width: screenWidth,
                                                    height: 216))
        datePicker.datePickerMode = datePickerMode
        self.inputView = datePicker
        
        let toolBar = UIToolbar(frame: CGRect(x: 0,
                                              y: 0,
                                              width: screenWidth,
                                              height: 44))
        toolBar.setItems([buttonItem(withSystemItemStyle: .cancel),
                          buttonItem(withSystemItemStyle: .flexibleSpace),
                          buttonItem(withSystemItemStyle: .done)],
                         animated: true)
        self.inputAccessoryView = toolBar
    }
}

