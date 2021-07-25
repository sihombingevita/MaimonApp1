//
//  Intro3ViewController.swift
//  Maimon
//
//  Created by Ramona Lily Artha Lubis on 22/07/21.
//

import UIKit

class Intro3ViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate {

    @IBOutlet weak var budgetingTextField: UITextField!
    @IBOutlet weak var budgetingScrollView: UIScrollView!
    @IBOutlet weak var contButton: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    
    let toolbar = UIToolbar()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createPickerView()
        dismissPickerView()
        
        budgetingTextField.delegate = self
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeFunc(gesture:)))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        toolbar.sizeToFit()
        let clearButton = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clearButtonPressed))
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonPressed))
        let spaceFill = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbar.setItems([clearButton,spaceFill,doneButton], animated: true)
        budgetingTextField.inputAccessoryView = toolbar
        
    }
    
    @IBAction func goToMain(_ sender: Any) {
//        let vc = self.storyboard?.instantiateViewController(identifier: "main") as! MainScreen
//        vc.modalPresentationStyle = .fullScreen
//        self.present(vc, animated: true)
        
//        let vc = storyboard?.instantiateViewController(identifier: "main") as! MainScreen
//        vc.modalPresentationStyle = .fullScreen
//            present(vc,animated: true)
//
//        let transition = CATransition()
//        transition.duration = 0.5
//        transition.type = CATransitionType.push
//        transition.subtype = CATransitionSubtype.fromLeft
//        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
//        view.window!.layer.add(transition, forKey: kCATransition)
//        present(vc, animated: false, completion: nil)
        
        let vc = storyboard?.instantiateViewController(identifier: "main") as! MainScreen
        vc.modalPresentationStyle = .fullScreen
//            present(vc,animated: true)
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        present(vc, animated: false, completion: nil)
        
    }
    
    
    @objc func swipeFunc(gesture:UISwipeGestureRecognizer) {
        if gesture.direction == .right {
            print("swiped right")
//            performSegue(withIdentifier: "Second Instructions", sender: self)
            
            let vc = storyboard?.instantiateViewController(identifier: "introSecond") as! IntroViewController
            vc.modalPresentationStyle = .fullScreen
//            present(vc,animated: true)
            
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromLeft
            transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
            view.window!.layer.add(transition, forKey: kCATransition)
            present(vc, animated: false, completion: nil)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        budgetingScrollView.setContentOffset(CGPoint(x: 0, y: 70), animated: true)
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        budgetingScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
//    }
//
    @objc func clearButtonPressed(){
        budgetingTextField.text = ""
    }
    
    @objc func doneButtonPressed(){
        self.view.endEditing(true)
    }
    
    // function dismis dropdown picker
     
     func createPickerView() {
            let pickerView = UIPickerView()
            pickerView.delegate = self
            budgetingTextField.inputView = pickerView
     }
     func dismissPickerView() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
         let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.action))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        budgetingTextField.inputAccessoryView = toolBar
     }
     @objc func action() {
           view.endEditing(true)
     }
    
   
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
