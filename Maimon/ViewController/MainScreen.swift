//
//  MainScreen.swift
//  Maimon
//
//  Created by Evita Sihombing on 19/07/21.
//

import UIKit

class MainScreen: UIViewController, UITableViewDelegate {

    @IBOutlet var savingLbl: UILabel!
    @IBOutlet var incomeLbl: UILabel!
    @IBOutlet var expenseLbl: UILabel!
    @IBOutlet var expenseProgView: UIProgressView!
    
    
    @IBOutlet var labelExpense: UILabel!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var tableView: UITableView!
    
    private var categories : [Category] = []
    private var categoriesDefault : [Category] = []
    private let tableCellName : String = "CategoryTableViewCell"
    
    struct categoryStruct {
        var category = Category()
        var percent = 0.0
    }
    private var categoryData : [categoryStruct] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
//        PersistanceManager.shared.insertCategory(name: "Needs", percentage: 50)
//        PersistanceManager.shared.insertCategory(name: "Saving", percentage: 30)
//        PersistanceManager.shared.insertCategory(name: "Interest", percentage: 10)
//        PersistanceManager.shared.insertCategory(name: "Others", percentage: 10)
        setTableViewCell()
        configureTableView()
        load()
        
    }
    
    private func setTableViewCell(){
        let nib = UINib(nibName: tableCellName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: tableCellName)
    }
    
    @IBAction func addIncomeExpense(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(identifier: "addIncome") as! addIncomeViewController
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
        categoriesDefault = PersistanceManager.shared.fetchCategory()
        
        
        var percent = 0.0
        for cat in categoriesDefault{
            var expenseValue2 = 0.0
            var expenses = PersistanceManager.shared.fetchExpense(category: cat)
            for exp in expenses{
                expenseValue2 += exp.total
            }
            percent = (expenseValue2/incomeValue)*100
            percent = percent / cat.percentage
            if percent.isNaN == true{
                percent = 0.0
            }
            var catStruct = categoryStruct()
            catStruct.category = cat
            catStruct.percent = percent
            categoryData.append(catStruct)
        }
        categoryData.sort { (lhs: categoryStruct, rhs: categoryStruct) -> Bool in
            // you can have additional code here
            return lhs.percent > rhs.percent
        }
        
        
        for cat in categoryData{
            categories.append(cat.category)
        }
        
        tableView.reloadData()
    }
    
    func setExpenseProgView(income: Double, expense: Double){
        var percent = 0.0
        expenseProgView.transform = expenseProgView.transform.scaledBy(x: 1, y: 10)
        percent = expense/income
        if percent.isNaN == true{
            percent = 0.0
        }
        labelExpense.text = String(format :"%.1f",(percent*100)) + " %"
        labelExpense.textColor = .black
        expenseProgView.setProgress(Float(percent), animated: true)
        var color = UIColor()
        if percent < 0.4 {
            color = .systemGreen
        }else if percent >= 0.4 && percent < 0.7{
            color = .yellow
        }else{
            color = .systemRed
        }
        expenseProgView.progressTintColor = color
    }
}

extension MainScreen: UITableViewDataSource, UITabBarDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: tableCellName, for: indexPath) as?  CategoryTableViewCell {
            let category = self.categories[indexPath.row]
            var expenses = PersistanceManager.shared.fetchExpense(category: category)
            var incomes = PersistanceManager.shared.fetchIncome()
            var incomeValue = 0.0
            var expenseValue = 0.0
            var percent = 0.0
            for inc in incomes{
                incomeValue += inc.total
            }
            for exp in expenses{
                expenseValue += exp.total
            }
            percent = (expenseValue/incomeValue)*100
            cell.setDataIntoCell(name: category.name ?? "", percentage: percent, percentageCategory: category.percentage)
            
            cell.backgroundColor = .clear
                
            
            return cell
            
        }
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(80.0)
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let vc = storyboard?.instantiateViewController(identifier: "AddExpenseViewController") as? addExpenseViewController {
//            vc.categoryExpense = self.categories[indexPath.row]
//            self.navigationController?.pushViewController(vc, animated: false)
//        }
//    }
    
    func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
    }
}
