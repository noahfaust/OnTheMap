//
//  InformationPostingButton.swift
//  On The Map
//
//  Created by Alexandre Gonzalo on 12/12/2015.
//  Copyright © 2015 Agito Cloud. All rights reserved.
//

import Foundation
import UIKit

class InformationPostingButton: UIButton {
    
    struct Constants {
        static let Find = "Find on the Map"
        static let Submit = "Submit"
    }
    
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
        layer.cornerRadius = 10
        layer.borderWidth = 10
        layer.borderColor = UIColor.whiteColor().CGColor
    }
    
    func switchStage() {
        setStageToSubmit()
    }
    
    func setStageToSubmit() {
        stage = .Submit
        setTitle(Constants.Submit, forState: state)
    }
    
    func setStageToFind() {
        stage = .Find
        setTitle(Constants.Find, forState: state)
    }
}
