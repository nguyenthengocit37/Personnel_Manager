//
//  Personnel.swift
//  ManagerPersonel
//
//  Created by NGOC IT on 5/13/22.
//

import UIKit

class Personnel{
    //MARK: Properties
    var personnelCode:String
    var personnelName: String
    var personnelBirthday:Date
    var personnelGender:Bool //true : Male false : Female
    var codeProject:String
    var codePosition:String
    var codeDepartment:String
    var personnelImage: UIImage?
    
    //MARK: Contructor
    init?(personnelCode:String,personnelName: String,personnelBirthday: Date, personnelGender: Bool,codeProject: String,codePosition: String,codeDepartment: String,personnelImage: UIImage?)
    {
        if personnelCode.isEmpty||personnelName.isEmpty || codeProject.isEmpty || codeDepartment.isEmpty{
            return nil
        }
        self .personnelCode = personnelCode
        self .personnelName = personnelName
        self .personnelBirthday = personnelBirthday
        self .personnelGender = personnelGender
        self .codeProject = codeProject
        self .codePosition = codePosition
        self .codeDepartment = codeDepartment
        self .personnelImage = personnelImage
    }
}
