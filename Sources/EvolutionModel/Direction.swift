//
// Created by Konstantin Zabelin on 04.01.2022.
//

import Foundation


public enum Direction: Equatable {
    case none
    case up
    case down
    case left
    case right

    public func adjust(_ i: Int, _ j: Int) -> (i: Int, j: Int) {
        switch self {
        case .none:  return (i, j)
        case .up:    return (i - 1, j)
        case .down:  return (i + 1, j)
        case .left:  return (i, j - 1)
        case .right: return (i, j + 1)
        }
    }
}

