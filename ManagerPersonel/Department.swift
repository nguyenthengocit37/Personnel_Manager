//
//  Department.swift
//  ManagerPersonel
//
//  Created by NGOC IT on 5/13/22.
//

import Foundation
class Department{
    //MARK: Properties
    var codeDepartment:String
    var nameDepartment:String
    //MARK: Contructor
    init?(codeDepartment: String,nameDepartment: String) {
        if(codeDepartment.isEmpty || nameDepartment.isEmpty){
            return nil
        }
        self .codeDepartment = codeDepartment
        self .nameDepartment = nameDepartment
    }
    
}
