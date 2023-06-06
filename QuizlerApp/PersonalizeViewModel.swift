//
//  PersonalizeViewModel.swift
//  QuizlerApp
//
//  Created by Petar Sakotic on 5/31/23.
//

import UIKit

enum PersonalizeViewModel: Equatable {
    case homeView(HomeViewModel)
    case quizView(QuizViewModel)
    
    static func == (lhs: PersonalizeViewModel, rhs: PersonalizeViewModel) -> Bool {
        switch lhs {
        case .homeView(let lhsVal):
            switch rhs {
            case .homeView(let rhsValue):      return lhsVal == rhsValue
            default:                           return false
            }
        case .quizView(let lhsValue):
            switch rhs {
            case .quizView(let rhsValue): return lhsValue == rhsValue
            default:                      return false
            }
        }
    }

}


struct HomeViewModel: Equatable {
    let name: String
    let image: UIImage
    let color: UIColor
    
    static func == (lhs: HomeViewModel, rhs: HomeViewModel) -> Bool {
        return lhs.name == rhs.name
    }
}

struct QuizViewModel: Equatable {
    let name: String
    let image: UIImage
    let color: UIColor
    
    static func == (lhs: QuizViewModel, rhs: QuizViewModel) -> Bool {
        return lhs.name == rhs.name
    }
    
}
