//
//  MainScreen.swift
//  Maimon
//
//  Created by Evita Sihombing on 19/07/21.
//

import UIKit

class MainScreen: UIViewController {

    @IBOutlet var savingLbl: UILabel!
    @IBOutlet var incomeLbl: UILabel!
    @IBOutlet var expenseLbl: UILabel!
    @IBOutlet var expenseProgView: UIProgressView!
    @IBOutlet var tableViewCategory: UITableView!
    
    @IBOutlet var labelExpense: UILabel!
    @IBOutlet var addButton: UIButton!
    
    private var categorie : [Category] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //PersistanceManager.shared.insertCategory(name: "Needs", percentage: 50)
        //PersistanceManager.shared.insertCategory(name: "Saving", percentage: 30)
        //PersistanceManager.shared.insertCategory(name: "Interest", percentage: 20)
        load()
        
    }
    
    @IBAction func addIncomeExpense(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(identifier: "addIncomeExpense") as! addIncomeViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    func load(){
        var incomeValue = 0.0
        var expenseValue = 0.0
        var savingValue = 0.0
        
        var incomes = PersistanceManager.shared.fetchIncome()
        var expense = PersistanceManager.shared.fetchExpense()
        
        for inc in incomes {
            incomeValue += inc.total
        }
        
        for exp in expense {
            expenseValue += exp.total
        }
        
        savingValue = incomeValue - expenseValue
            
        let formatter = NumberFormatter()
        formatter.groupingSeparator = "."
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.decimalSeparator = ","
        formatter.numberStyle = .decimal
        
        incomeLbl.text = "Rp. " + formatter.string(from: NSNumber(value: incomeValue))!
        expenseLbl.text = "Rp. " + formatter.string(from: NSNumber(value: expenseValue))!
        savingLbl.text = "Rp. " + formatter.string(from: NSNumber(value: savingValue))!
        setExpenseProgView(income: incomeValue, expense: expenseValue)
    }
    
    func setExpenseProgView(income: Double, expense: Double){
        var percent = 0.0
        expenseProgView.transform = expenseProgView.transform.scaledBy(x: 1, y: 10)
        percent = expense/income
        if percent.isNaN == true{
            percent = 0.8
        }
        labelExpense.text = String(format :"%.1f",(percent*100)) + " %"
        labelExpense.textColor = .black
        expenseProgView.setProgress(Float(percent), animated: true)
        var color = UIColor()
        if percent < 0.4 {
            color = .systemGreen
        }else if percent >= 0.4 && percent < 0.7{
            color = .orange
        }else{
            color = .systemRed
        }
        expenseProgView.progressTintColor = color
    }
}
