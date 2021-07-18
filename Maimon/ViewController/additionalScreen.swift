//
//  additionalScreen.swift
//  Maimon
//
//  Created by San on 18/07/21.
//

import UIKit

class additionalScreen: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    

    @IBOutlet weak var itemExpense: UITextField!
    @IBOutlet weak var categoryExpense: UITextField!
    @IBOutlet weak var priceExpense: UITextField!
    @IBOutlet weak var dateExpense: UITextField!
    
    let category1 = ["A", "B", "C", "D", "D"]
    let pickerCategory = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerCategory.delegate = self
        pickerCategory.dataSource = self
        categoryExpense.inputView = pickerCategory
        categoryExpense.textAlignment = .center
        
        priceExpense.keyboardType = .numberPad
        
        
        
        self.dateExpense.setInputViewDatePicker(target: self, selector: #selector(tapDone)) //1

    }
    @objc func tapDone() {
        if let datePicker = self.dateExpense.inputView as? UIDatePicker {
            let dateformatter = DateFormatter()
            dateformatter.dateStyle = .medium
            self.dateExpense.text = dateformatter.string(from:
                                                            datePicker.date)
        }
        self.dateExpense.resignFirstResponder() // 2-5
    }
    @objc private func priceIncomeFilter(_ priceIncome: UITextField){
        if let text = priceIncome.text, let intText = Int(text){
            priceIncome.text = "\(intText)"
        }else{
            priceIncome.text = ""
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return category1.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return category1[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryExpense.text = category1[row]
        categoryExpense.resignFirstResponder()
    }
}
extension UITextField {
    func setInputViewDatePicker(target: Any, selector: Selector) {
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width:
                                                        screenWidth, height: 216))
        datePicker.datePickerMode = .date
        if #available(iOS 14, *) {
                datePicker.preferredDatePickerStyle = .wheels
                datePicker.sizeToFit()
        }
        self.inputView = datePicker
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width:
                                                screenWidth, height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem:
                                        .flexibleSpace, target: nil, action: nil)
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain,
                                     target: nil, action: #selector(tapCancel))
        let barButton = UIBarButtonItem(title: "Done", style: .plain,
                                        target: target, action: selector)
        toolBar.setItems([cancel, flexible, barButton], animated: false)
        self.inputAccessoryView = toolBar //9
    }
    @objc func tapCancel() {
        self.resignFirstResponder()
    }
}
