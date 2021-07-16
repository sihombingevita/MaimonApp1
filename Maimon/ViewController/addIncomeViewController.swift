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
        
        self.dateIncome.setInputViewDatePicker(target: self, selector: #selector(tapDone)) //1

    }
    @objc func tapDone() {
        if let datePicker = self.dateIncome.inputView as? UIDatePicker { // 2-1
            let dateformatter = DateFormatter() // 2-2
            dateformatter.dateStyle = .medium // 2-3
            self.dateIncome.text = dateformatter.string(from: datePicker.date) //2-4
            
        }
            self.dateIncome.resignFirstResponder() // 2-5
        
    }
    @objc private func priceIncomeFilter(_ priceIncome: UITextField){
        if let text = priceIncome.text, let intText = Int(text){
            priceIncome.text = "\(intText)"
        }else{
            priceIncome.text = ""
            }
        }
}
extension UITextField {
    
    func setInputViewDatePicker(target: Any, selector: Selector) {
        // Create a UIDatePicker object and assign to inputView
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))//1
        datePicker.datePickerMode = .date //2
        // iOS 14 and above
        if #available(iOS 14, *) {// Added condition for iOS 14
          datePicker.preferredDatePickerStyle = .wheels
          datePicker.sizeToFit()
        }
        self.inputView = datePicker //3
        
        // Create a toolbar and assign it to inputAccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0)) //4
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) //5
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel)) // 6
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector) //7
        toolBar.setItems([cancel, flexible, barButton], animated: false) //8
        self.inputAccessoryView = toolBar //9
    }
    
    @objc func tapCancel() {
        self.resignFirstResponder()
    }
    
}
