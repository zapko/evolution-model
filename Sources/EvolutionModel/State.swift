//
// Created by Konstantin Zabelin on 10.01.2022.
//

import Foundation


public struct State: Equatable, Hashable, Codable {
    public var space: [[Cell]]
    public var behaviours: Behaviours

    public init(space: [[Cell]], behaviours: Behaviours) {
        self.space      = space
        self.behaviours = behaviours
    }

    public static func make(rows: Int, columns: Int) -> State {
        .init(
            space: Array<Array<Cell>>(
                repeating: Array<Cell>(repeating: .empty, count: columns),
                count: rows),
            behaviours: [:])
    }
}

