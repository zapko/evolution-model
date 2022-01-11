//
// Created by Konstantin Zabelin on 10.01.2022.
//

import Foundation


public struct State: Equatable {
    var space: [[Cell]]
    var behaviours: Behaviours

    public init(space: [[Cell]], behaviours: Behaviours) {
        self.space      = space
        self.behaviours = behaviours
    }
}

