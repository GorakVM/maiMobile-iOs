//
//  TowTruckViewController.swift
//  maiMobile-iOS
//
//  Created by Gil Lopes on 19/05/16.
//  Copyright © 2016 WATERDOG mobile. All rights reserved.
//

import UIKit

class TowTruckViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textFieldsMaskView: UIView!
    
    @IBOutlet weak var textFieldFirstTwindDigits: UITextField!
    @IBOutlet weak var textFieldSecondTwinDigits: UITextField!
    @IBOutlet weak var textFieldThirdTwinDigits: UITextField!
    
    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var plateNumber = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let navigationBarHeight = navigationController?.navigationBar.frame.height, tabBarHeight = tabBarController?.tabBar.frame.height {
            scrollView.contentInset = UIEdgeInsetsMake(navigationBarHeight, 0.0, tabBarHeight, 0.0)
        }
        
        searchButton.layer.cornerRadius = CGFloat(8)
        
        textFieldFirstTwindDigits.delegate = self
        textFieldSecondTwinDigits.delegate = self
        textFieldThirdTwinDigits.delegate = self
        
        textFieldsMaskView.layer.cornerRadius = CGFloat(8)
        textFieldsMaskView.layer.borderColor = UIColor.whiteColor().CGColor
        textFieldsMaskView.layer.borderWidth = CGFloat(1)
        textFieldFirstTwindDigits.becomeFirstResponder()
        
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if textField.text?.characters.count > 1 {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        switch textField {
        case textFieldFirstTwindDigits: textFieldSecondTwinDigits.becomeFirstResponder()
        case textFieldSecondTwinDigits: textFieldThirdTwinDigits.becomeFirstResponder()
        default:
            break
            
        }
    }
    
    @IBAction func searchButtonAction(sender: UIButton) {
        
    }
    
}
