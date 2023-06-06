//
//  SettingsActionModel.swift
//  QuizlerApp
//
//  Created by Petar Sakotic on 5/29/23.
//

import UIKit

struct SettingsActionModel: Equatable {
    
    let name: String
    let section: String
    let icon: UIImage
    let action: ()->Swift.Void
    
    init(name: String, section: String, icon: UIImage, action: @escaping () -> Void) {
        self.name = name
        self.section = section
        self.icon = icon
        self.action = action
    }
    
    //MARK: - Equeatable
    
    static func == (lhs: SettingsActionModel, rhs: SettingsActionModel) -> Bool {
        lhs.name == rhs.name
    }
    
    
    
}
