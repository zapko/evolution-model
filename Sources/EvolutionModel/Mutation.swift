//
// Created by Konstantin Zabelin on 10.01.2022.
//

import Foundation


public enum Mutation: Equatable {
    case remove(at: Int)
    case add(Behaviour.Action, at: Int)

    public static func makeMutator(picker: @escaping (Int) -> Mutation)
            -> (Behaviour?) -> Behaviour {
        {
            possibleBehaviorToMutate in

            var behaviourToMutate = possibleBehaviorToMutate ?? []

            switch picker(behaviourToMutate.actions.count) {
            case .remove(let index):
                behaviourToMutate.actions.remove(at: index)

            case .add(let action, let index):
                behaviourToMutate.actions.insert(action, at: index)
            }

            return behaviourToMutate
        }
    }
}

