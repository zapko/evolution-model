//
// Created by Konstantin Zabelin on 07.01.2022.
//

import Foundation


public typealias Behaviours = [Agent: [Cell: Behaviour]]

public struct Behaviour: Equatable,
                         ExpressibleByArrayLiteral {

    public enum Action: Equatable {
        case remove(Agent)
        case add(Agent, Direction)
        case change(Agent, to: Agent)
    }


    // MARK: - Private State

    public var actions: [Action]


    // MARK: - Initialization / Deinitialization

    public init(actions: [Action]) {
        self.actions = actions
    }


    // MARK: - Behaviour

    public static func makeExpander(mutator: @escaping (Behaviour?) -> Behaviour)
            -> (Cell, [Cell: Behaviour]) -> Behaviour {
        {
            cell, knownBehaviours in

            let targetSum = cell.agents.map(\.attribute).reduce(0, +)

            let behaviourToMutate = knownBehaviours
                .map {
                    (cell, behaviour) in
                    (dif: abs(cell.agents.map(\.attribute).reduce(0, +) - targetSum), behaviour: behaviour)
                }
                .sorted { lhs, rhs in lhs.dif < rhs.dif }
                .map { $0.behaviour }
                .first

            return mutator(behaviourToMutate)
        }
    }


    // MARK: - ExpressibleByArrayLiteral

    public init(arrayLiteral elements: Action...) {
        self.actions = elements
    }
}
