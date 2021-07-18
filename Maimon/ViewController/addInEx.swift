//
//  addInEx.swift
//  Maimon
//
//  Created by San on 18/07/21.
//

import UIKit

class addInEx: UIViewController {
    @IBOutlet weak var addView: UIView!
    var addYourIn: UIView!
    var addYourEx: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addYourIn = addIncome().view
        addYourEx = addExpenses().view
        addView.addSubview(addYourIn)
        addView.addSubview(addYourEx)
        addView.bringSubviewToFront(addYourIn)
        

        // Do any additional setup after loading the view.
    }
    @IBAction func switchAdd(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            addView.bringSubviewToFront(addYourIn)
            break
        case 1:
            addView.bringSubviewToFront(addYourEx)
            break
        default:
            break
        }
    }
    

}
