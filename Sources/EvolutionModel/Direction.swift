//
// Created by Konstantin Zabelin on 04.01.2022.
//

import Foundation


public enum Direction: Equatable,
                       Hashable,
                       Codable,
                       CaseIterable {
    case none
    case up
    case down
    case left
    case right

    public func adjust(_ i: Int, _ j: Int, width: Int, height: Int) -> (i: Int, j: Int) {
        ((i + change.di + height) % height,
         (j + change.dj + width) % width)
    }

    private var change: (di: Int, dj: Int) {
        switch self {
        case .none:  return ( 0,  0)
        case .up:    return (-1,  0)
        case .down:  return ( 1,  0)
        case .left:  return ( 0, -1)
        case .right: return ( 0,  1)
        }
    }
}

