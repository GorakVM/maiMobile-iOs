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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchButton.layer.cornerRadius = CGFloat(8)
        
        textFieldsMaskView.layer.cornerRadius = CGFloat(8)
        textFieldsMaskView.layer.borderColor = UIColor.whiteColor().CGColor
        textFieldsMaskView.layer.borderWidth = CGFloat(1)
//        textFieldFirstTwindDigits.becomeFirstResponder()
        
    }
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    @IBAction func searchButtonAction(sender: UIButton) {
        
    }
    
}
