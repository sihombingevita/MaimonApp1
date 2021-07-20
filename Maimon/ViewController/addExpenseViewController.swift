//
//  addExpenseViewController.swift
//  Maimon
//
//  Created by San on 14/07/21.
//

import UIKit

class addExpenseViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate  {

    
    @IBOutlet var backBtn: UIButton!
    @IBOutlet var changeBtn: UISegmentedControl!
    @IBOutlet weak var descExpense: UITextField!
    @IBOutlet weak var amountExpense: UITextField!
    @IBOutlet weak var priceExpense: UITextField!
    @IBOutlet weak var dateExpense: UITextField!
    @IBOutlet var categoryExpense: UITextField!
    @IBOutlet var repeatSW: UISwitch!
    @IBOutlet var daily: UISwitch!
    @IBOutlet var weekly: UISwitch!
    @IBOutlet var montly: UISwitch!
    @IBOutlet var viewRepeat: UIView!
    @IBOutlet var saveBtn: UIButton!
    
    private var expense : [Expense] = []
    
    var selectedCategory: String?
    //var categoryList: [String] = []
    var categoryList : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descExpense.layer.cornerRadius = 15
        descExpense.layer.borderWidth = 0.5
        amountExpense.layer.cornerRadius = 15
        amountExpense.layer.borderWidth = 0.5
        categoryExpense.layer.cornerRadius = 15
        categoryExpense.layer.borderWidth = 0.5
//        priceExpense.layer.cornerRadius = 15
//        priceExpense.layer.borderWidth = 0.5
        dateExpense.layer.cornerRadius = 15
        dateExpense.layer.borderWidth = 0.5
        
        repeatSW.isOn = false
        daily.isOn = true
        weekly.isOn = false
        montly.isOn = false
        viewRepeat.isHidden = true
        
        initiateCategory()
        createPickerView()
        dismissPickerView()
        
        self.dateExpense.setInputViewDatePicker(target: self, selector: #selector(tapDone)) //1
        
    }
    
    
    @IBAction func saveButton(_ sender: Any) {
        guard let total = amountExpense.text else {
            return
        }
        
        guard let descriptionExp = descExpense.text else {
            return
        }
        
        guard let dateExp = dateExpense.text else {
            return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        var dateComponent = DateComponents()
        dateComponent.day = 1
        var date = dateFormatter.date(from: dateExp)
        date = Calendar.current.date(byAdding: dateComponent, to: date ?? Date())
        
        //set repeatExp
        var repeatExp = "NONE"
        if(daily.isOn == true){
            repeatExp = "DAILY"
        }else if (weekly.isOn == true){
            repeatExp = "WEEKLY"
        }else{
            repeatExp = "MONTHLY"
        }
        let categoryExp = PersistanceManager.shared.fetchCategory(name: categoryExpense.text ?? "")
        var categoryExpense : Category!
        categoryExpense = categoryExp[0]
        
        

        //insert data ke database
        PersistanceManager.shared.insertExpense(total: Double(total) ?? 0.0, descriptionExp: description, date: date ?? Date(), repeatExp: repeatExp, category: categoryExpense)
        
//        // fungsi untuk balik ke main screen
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "main") as! MainScreen
                self.present(newViewController, animated: true, completion: nil)

       
    }
    
    @IBAction func backBtn(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(identifier: "main") as! MainScreen
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    @objc func tapDone() {
        if let datePicker = self.dateExpense.inputView as? UIDatePicker { // 2-1
            let dateformatter = DateFormatter() // 2-2
            dateformatter.dateStyle = .medium // 2-3
            self.dateExpense.text = dateformatter.string(from: datePicker.date) //2-4
            
        }
            self.dateExpense.resignFirstResponder() // 2-5
        
    }
    
    func initiateCategory(){
        let categories = PersistanceManager.shared.fetchCategory()
        for cat in categories{
            categoryList.append(cat.name ?? "")
            print(cat.name)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // number of session
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryList.count // number of dropdown item
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryList[row] // dropdown item
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCategory = categoryList[row] // selected item
        categoryExpense.text = selectedCategory
        
    }
    
    // function dismis dropdown picker
     
     func createPickerView() {
            let pickerView = UIPickerView()
            pickerView.delegate = self
            categoryExpense.inputView = pickerView
     }
     func dismissPickerView() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
         let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.action))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        categoryExpense.inputAccessoryView = toolBar
     }
     @objc func action() {
           view.endEditing(true)
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
    
    @IBAction func monthly(_ sender: Any) {
        if(montly.isOn == true){
            daily.setOn(false, animated: true)
            weekly.setOn(false, animated: true)
            
        }
    }
    
    @IBAction func changeButton(_ sender: Any) {
        var index = changeBtn.selectedSegmentIndex
        if(index == 0){
            let vc = self.storyboard?.instantiateViewController(identifier: "addIncome") as! addIncomeViewController
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: false)
        }
    }
    
    
//    @objc private func priceIncomeFilter(_ priceIncome: UITextField){
//        if let text = priceIncome.text, let intText = Int(text){
//            priceIncome.text = "\(intText)"
//        }else{
//            priceIncome.text = ""
//            }
//        }
}

//extension UITextField {
//
//    func setInputViewDatePicker(target: Any, selector: Selector) {
//        // Create a UIDatePicker object and assign to inputView
//        let screenWidth = UIScreen.main.bounds.width
//        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))//1
//        datePicker.datePickerMode = .date //2
//        // iOS 14 and above
//        if #available(iOS 14, *) {// Added condition for iOS 14
//          datePicker.preferredDatePickerStyle = .wheels
//          datePicker.sizeToFit()
//        }
//        self.inputView = datePicker //3
//
//        // Create a toolbar and assign it to inputAccessoryView
//        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0)) //4
//        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) //5
//        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel)) // 6
//        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector) //7
//        toolBar.setItems([cancel, flexible, barButton], animated: false) //8
//        self.inputAccessoryView = toolBar //9
//    }
//
//    @objc func tapCancel() {
//        self.resignFirstResponder()
//    }
//
//}
