//
//  InformationPostingTextField.swift
//  On The Map
//
//  Created by Alexandre Gonzalo on 12/12/2015.
//  Copyright © 2015 Agito Cloud. All rights reserved.
//

import Foundation
import UIKit

class InformationPostingTextField: UITextField {
    
    private var stage: InformationPostingStage = .Find
    
    override init (frame : CGRect) {
        super.init(frame : frame)
        customSetup()
    }
    
    convenience init () {
        self.init(frame:CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customSetup()
    }
    
    private func customSetup() {
        setStageToFind()
    }
    
    func setStageToFind() {
        stage = .Find
        attributedPlaceholder = NSAttributedString(string:"Enter your location here",
            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
    }
    
    func setStageToSubmit() {
        stage = .Submit
        text = ""
        attributedPlaceholder = NSAttributedString(string:"Enter a link to share here",
            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
    }
}
