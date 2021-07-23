//
//  Intro1ViewController.swift
//  Maimon
//
//  Created by Ramona Lily Artha Lubis on 22/07/21.
//

import UIKit

class Intro1ViewController: UIViewController {
    
    @IBOutlet weak var skipButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeFunc(gesture:)))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
  
    @IBAction func goToBudget(_ sender: Any) {
        print("skip")
        
//        let vc = self.storyboard?.instantiateViewController(identifier: "introThird") as! Intro3ViewController
//        vc.modalPresentationStyle = .fullScreen
//        self.present(vc, animated: true)
        
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
        
//        performSegue(withIdentifier: "firstToThird", sender: self)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "firstToThird"{
//            guard segue.destination is Intro3ViewController else {return}
//
//
//        }
//    }
    
    @objc func swipeFunc(gesture:UISwipeGestureRecognizer) {
        if gesture.direction == .left {
            print("swiped left")
//            performSegue(withIdentifier: "Second Instructions", sender: self)
            
            let vc = storyboard?.instantiateViewController(identifier: "introSecond") as! IntroViewController
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
        }

    
    }

//extension UIButton{
//    @IBAction func goToBudget(_ sender: Any) {
//           print("skip")
//   //            performSegue(withIdentifier: "Second Instructions", sender: self)
//   
//           let vc = storyboard?.instantiateViewController(identifier: "introThird") as! Intro3ViewController
//           vc.modalPresentationStyle = .fullScreen
//   //            present(vc,animated: true)
//   
//           let transition = CATransition()
//           transition.duration = 0.5
//           transition.type = CATransitionType.push
//           transition.subtype = CATransitionSubtype.fromRight
//           transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
//           view.window!.layer.add(transition, forKey: kCATransition)
//           present(vc, animated: false, completion: nil)
//           }
//       }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
//}
