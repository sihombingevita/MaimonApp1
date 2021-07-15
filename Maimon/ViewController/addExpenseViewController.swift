//
//  addExpenseViewController.swift
//  Maimon
//
//  Created by San on 14/07/21.
//

import UIKit

class addExpenseViewController: UIViewController {

    
    @IBOutlet weak var itemExpense: UITextField!
    @IBOutlet weak var categoryExpense: UITextField!
    @IBOutlet weak var priceExpense: UITextField!
    @IBOutlet weak var dateExpense: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        itemExpense.layer.cornerRadius = 15
        itemExpense.layer.borderWidth = 0.5
        categoryExpense.layer.cornerRadius = 15
        categoryExpense.layer.borderWidth = 0.5
        priceExpense.layer.cornerRadius = 15
        priceExpense.layer.borderWidth = 0.5
        dateExpense.layer.cornerRadius = 15
        dateExpense.layer.borderWidth = 0.5
        
    }
}
