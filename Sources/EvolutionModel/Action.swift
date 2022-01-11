//
// Created by Konstantin Zabelin on 10.01.2022.
//

import Foundation


public enum Action: Equatable, Hashable {
    case remove(Agent)
    case add(Agent, Direction)
    case change(Agent, to: Agent)
}

