//
//  Position.swift
//  ManagerPersonel
//
//  Created by NGOC IT on 5/13/22.
//

import Foundation

class Position{
    //MARK: Properties
    var codePosition:String
    var namePosition:String
    var countPersonnel : Int
    //MARK: Contructor
    init?(codePosition: String,namePosition: String,countPersonnel:Int) {
        if (codePosition.isEmpty || namePosition.isEmpty){
            return nil
        }
        self .codePosition = codePosition
        self .namePosition = namePosition
        self .countPersonnel = countPersonnel
        
    }
    
}
