//
// Created by Konstantin Zabelin on 07.01.2022.
//

import Foundation


public struct Behaviour: Equatable,
                         ExpressibleByArrayLiteral {

    public let actions: [Engine.Action]

    public init(actions: [Engine.Action]) {
        self.actions = actions
    }


    // MARK: - ExpressibleByArrayLiteral

    public init(arrayLiteral elements: Engine.Action...) {
        self.actions = elements
    }
}
