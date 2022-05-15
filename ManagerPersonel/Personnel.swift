//
//  Personnel.swift
//  ManagerPersonel
//
//  Created by NGOC IT on 5/13/22.
//

import UIKit

class Personnel{
    //MARK: Properties
    var personnelName: String
    var personnelBirthday:Date
    var personnelGender:Bool
    var codeProject:String
    var codePosition:Int
    var codeDerpartment:String
    var personnelImage: UIImage?
    
    //MARK: Contructor
    init?(personnelName: String,personnelBirthday: Date, personnelGender: Bool,codeProject: String,codePosition: Int,codeDerpartment: String,personnelImage: UIImage?)
    {
        if personnelName.isEmpty || codeProject.isEmpty || codeDerpartment.isEmpty{
            return nil
        }
        self .personnelName = personnelName
        self .personnelBirthday = personnelBirthday
        self .personnelGender = personnelGender
        self .codeProject = codeProject
        self .codePosition = codePositio
        self .codeDerpartment = codeDerpartment
        self .personnelImage = personnelImage
    }
}
