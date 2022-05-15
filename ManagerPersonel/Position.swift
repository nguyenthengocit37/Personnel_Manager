//
//  Position.swift
//  ManagerPersonel
//
//  Created by NGOC IT on 5/13/22.
//

import Foundation

class Position{
    //MARK: Properties
    var codePosition:Int
    var namePosition:String
    var arrayPosition: Array<Int> = [0,1,2] // 0: personnel,1: leader ,2: boss
    //MARK: Contructor
    init?(codePosition: Int,namePosition: String) {
        if (!arrayPosition.contains(codePosition) || namePosition.isEmpty){
            return nil
        }
        self .codePosition = codePosition
        self .namePosition = namePosition
    }
    
}
