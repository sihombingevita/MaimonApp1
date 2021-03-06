//
//  IntroViewController.swift
//  Maimon
//
//  Created by Ramona Lily Artha Lubis on 22/07/21.
//

import UIKit

class IntroViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var incomeInfoTextField: UITextField!
    @IBOutlet weak var incomeScrollView: UIScrollView!
    @IBOutlet weak var skipButton: UIButton!
    
    let toolbar = UIToolbar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        incomeInfoTextField.delegate = self
        incomeInfoTextField.keyboardType = .decimalPad

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeFunc(gesture:)))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeFunc(gesture:)))
        swipeRight.direction = .left
        self.view.addGestureRecognizer(swipeLeft)

        toolbar.sizeToFit()
        let clearButton = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clearButtonPressed))
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonPressed))
        let spaceFill = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbar.setItems([clearButton,spaceFill,doneButton], animated: true)
        incomeInfoTextField.inputAccessoryView = toolbar
    }
    
    //prevent user to input others characters
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = "1234567890"
        let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
        let typedCharacterSet = CharacterSet(charactersIn: string)
        return allowedCharacterSet.isSuperset(of: typedCharacterSet)
    }
    
    
    @IBAction func goToBudgeting(_ sender: Any) {
        
        let vc = storyboard?.instantiateViewController(identifier: "introThird") as! Intro3ViewController
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
            
            let vc = storyboard?.instantiateViewController(identifier: "introFirst") as! Intro1ViewController
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
        if gesture.direction == .left {
            print("swiped left")
//            performSegue(withIdentifier: "Second Instructions", sender: self)
            
            let vc = storyboard?.instantiateViewController(identifier: "introThird") as! Intro3ViewController
            vc.modalPresentationStyle = .fullScreen
            vc.income = incomeInfoTextField.text!
//            present(vc,animated: true)
            
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromRight
            transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
            view.window!.layer.add(transition, forKey: kCATransition)
            present(vc, animated: false, completion: nil)
        }
    }

    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        incomeScrollView.setContentOffset(CGPoint(x: 0, y: 120), animated: true)
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        incomeScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    @objc func clearButtonPressed(){
        incomeInfoTextField.text = ""
    }
    
    @objc func doneButtonPressed(){
        self.view.endEditing(true)
        
        
        
    }
    

}
