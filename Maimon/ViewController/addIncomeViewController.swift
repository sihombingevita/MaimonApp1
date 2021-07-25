//
//  addIncomeViewController.swift
//  Maimon
//
//  Created by San on 14/07/21.
//

import UIKit

class addIncomeViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet var descIncome: UITextField!
    @IBOutlet weak var dateIncome: UITextField!
    @IBOutlet var amountIncome: UITextField!
    @IBOutlet var changePageBtn: UISegmentedControl!
    @IBOutlet var repeatSW: UISwitch!
    @IBOutlet var daily: UISwitch!
    @IBOutlet var weekly: UISwitch!
    @IBOutlet var montly: UISwitch!
    @IBOutlet var viewRepeat: UIView!
    
    @IBOutlet var saveBtn: UIButton!
    private var income : [Income] = []
    let toolbar = UIToolbar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descIncome.layer.cornerRadius = 10
        descIncome.layer.borderWidth = 0.5
        amountIncome.keyboardType = .numberPad
        
        dateIncome.layer.cornerRadius = 10
        dateIncome.layer.borderWidth = 0.5
        
        amountIncome.layer.cornerRadius = 10
        amountIncome.layer.borderWidth = 0.5
        
        self.dateIncome.setInputViewDatePicker(target: self, selector: #selector(tapDone)) //1
        
        //set nilai switch untuk repeat dan kawannya
        repeatSW.isOn = false
        daily.isOn = true
        weekly.isOn = false
        montly.isOn = false
        viewRepeat.isHidden = true
        
        amountIncome.delegate = self
        descIncome.delegate = self
        dateIncome.delegate = self
        
        toolbar.sizeToFit()
        let clearButton = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clearButtonPressed))
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonPressed))
        let spaceFill = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbar.setItems([clearButton,spaceFill,doneButton], animated: true)
        amountIncome.inputAccessoryView = toolbar
        descIncome.inputAccessoryView = toolbar
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    @objc func clearButtonPressed(){
        amountIncome.text = ""
        descIncome.text = ""
    }
    
    @objc func doneButtonPressed(){
        self.view.endEditing(true)
    }
    
    
    @IBAction func saveButton(_ sender: Any) {
        let regex = #"^[0-9]*(\.\d{1,2})?$"#
        var result = amountIncome.text!.range(
            of: regex,
            options: .regularExpression
        )
        
        if amountIncome.text == "" || descIncome.text == "" || dateIncome.text == ""{
            //alert
            let alert = UIAlertController(title: "Warning", message: "Please fill all the blank fields!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Back", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else if result == nil{
            let alert = UIAlertController(title: "Warning", message: "Incorrect format in amount field!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Back", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            guard let total = amountIncome.text else {
                return
            }
            guard let description = descIncome.text else {
                return
            }
            guard let dateInc = dateIncome.text else {
                return
            }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            var dateComponent = DateComponents()
            dateComponent.day = 1
            var date = dateFormatter.date(from: dateInc)
            date = Calendar.current.date(byAdding: dateComponent, to: date ?? Date())
            
            //set nilai repeat
            var repeatInc = "NONE"
            if(repeatSW.isOn == true){
                if(daily.isOn == true){
                    repeatInc = "DAILY"
                }else if(weekly.isOn == true){
                    repeatInc = "WEEKLY"
                }else{
                    repeatInc = "MONTHLY"
                }
            }
            
            PersistanceManager.shared.insertIncome(descriptionInc: description, total: Double(total) ?? 0.0, date: date ?? Date(), repeatInc: repeatInc)
            
            // fungsi untuk balik ke main screen
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "main") as! MainScreen
            newViewController.modalPresentationStyle = .fullScreen
            self.present(newViewController, animated: true, completion: nil)}
    }
    
    @IBAction func repeatPressed(_ sender: Any) {
        if(repeatSW.isOn == true){
            viewRepeat.isHidden = false
        }else{
            viewRepeat.isHidden = true
        }
    }
    
    @IBAction func dailyPressed(_ sender: Any) {
        if(daily.isOn == true){
            weekly.setOn(false, animated: true)
            montly.setOn(false, animated: true)
        }
    }
    
    @IBAction func weeklyPressed(_ sender: Any) {
        if(weekly.isOn == true){
            daily.setOn(false, animated: true)
            montly.setOn(false, animated: true)
            
        }
    }
    
    @IBAction func monthyly(_ sender: Any) {
        if(montly.isOn == true){
            daily.setOn(false, animated: true)
            weekly.setOn(false, animated: true)
            
        }
    }
    
    @IBAction func backBtn(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(identifier: "main") as! MainScreen
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    @IBAction func changePage(_ sender: Any) {
        var index = changePageBtn.selectedSegmentIndex
        if(index == 1){
            let vc = self.storyboard?.instantiateViewController(identifier: "addExpense") as! addExpenseViewController
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: false)
            
        }
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
