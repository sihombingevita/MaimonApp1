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
    
    let toolbar = UIToolbar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        descExpense.layer.cornerRadius = 10
        descExpense.layer.borderWidth = 0.5
        amountExpense.layer.cornerRadius = 10
        amountExpense.layer.borderWidth = 0.5
        categoryExpense.layer.cornerRadius = 10
        categoryExpense.layer.borderWidth = 0.5
        dateExpense.layer.cornerRadius = 10
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
        
        amountExpense.delegate = self
        descExpense.delegate = self
        dateExpense.delegate = self
        categoryExpense.delegate = self
        
        amountExpense.keyboardType = .asciiCapableNumberPad
        
        toolbar.sizeToFit()
        let clearButton = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clearButtonPressed))
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonPressed))
        let spaceFill = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbar.setItems([clearButton,spaceFill,doneButton], animated: true)
        amountExpense.inputAccessoryView = toolbar
        descExpense.inputAccessoryView = toolbar
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    @objc func clearButtonPressed(){
        amountExpense.text = ""
        descExpense.text = ""
    }
    
    @objc func doneButtonPressed(){
        self.view.endEditing(true)
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
}
