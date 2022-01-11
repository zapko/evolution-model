//
// Created by Konstantin Zabelin on 10.01.2022.
//

import Foundation


public enum Mutation: Equatable, Hashable {
    case remove(at: Int)
    case add(Action, at: Int)

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

    public static func makeMutationPicker(actionGenerator: @escaping () -> Action)
            -> (Int) -> Mutation {
        {
            length in

            if length == 0 || Bool.random() {
                let index = Int.random(in: 0...length)
                return .add(actionGenerator(), at: index)
            } else {
                let index = Int.random(in: 0..<length)
                return .remove(at: index)
            }
        }
    }
}

