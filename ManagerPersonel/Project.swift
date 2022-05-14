//
//  Project.swift
//  ManagerPersonel
//
//  Created by NGOC IT on 5/13/22.
//

import Foundation

class Project{
    //MARK: Properties
    var codeProject:String
    var nameProject:String
    //MARK: Contructor
    init?(codeProject: String,nameProject: String) {
        if(codeProject.isEmpty || nameProject.isEmpty)
        {
            return nil
        }
        self .codeProject = codeProject
        self .nameProject = nameProject
    }
    
}
