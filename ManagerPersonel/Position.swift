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
    var arrayPosition: Array<Int> = [1,3,5] // 1: personnel,3: leader ,5: boss
    //MARK: Contructor
    init?(codePosition: Int,namePosition: String) {
        if (arrayPosition.contains(codePosition) || namePosition.isEmpty){
            return nil
        }
        self .codePosition = codePosition
        self .namePosition = namePosition
    }
    
}
