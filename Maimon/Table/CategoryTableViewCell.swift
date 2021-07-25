//
//  CategoryTableViewCell.swift
//  Maimon
//
//  Created by Evita Sihombing on 18/07/21.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    @IBOutlet weak var nameCategoryLabel: UILabel!
    @IBOutlet weak var percentageCategoryLabel: UILabel!
    
    @IBOutlet var progressBar: UIProgressView!
    
    func setDataIntoCell(name: String, percentage: Double, percentageCategory: Double){
        var percent = 0.0
        nameCategoryLabel.text = name
        progressBar.transform = progressBar.transform.scaledBy(x: 1, y: 10)
        percent = percentage/percentageCategory
        if percent.isNaN == true{
            percent = 0.0
        }
        var color = UIColor()
        if percent < 0.4 {
            color = .systemGreen
        }else if percent >= 0.4 && percent < 0.7{
            color = .yellow
        }else{
            color = .systemRed
        }
        percentageCategoryLabel.text = String(format :"%.1f",(percent*100)) + " %"
        percentageCategoryLabel.textColor = .black
        progressBar.setProgress(Float(percent), animated: true)
        progressBar.progressTintColor = color
        progressBar.tintColor = .gray
    }
    
    
}
