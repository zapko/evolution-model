//
// Created by Konstantin Zabelin on 10.01.2022.
//

import Foundation


public enum Mutation: Equatable, Hashable {
    case add(Action, at: Int)
    case remove(at: Int)
    case replace(at: Int, with: Action)

    public static func makeMutator(picker: @escaping (Int) -> Mutation)
            -> (Behaviour?) -> Behaviour {
        {
            possibleBehaviorToMutate in

            var behaviourToMutate = possibleBehaviorToMutate ?? []

            switch picker(behaviourToMutate.actions.count) {
            case .add(let action, let index):
                behaviourToMutate.actions.insert(action, at: index)
                
            case .remove(let index):
                behaviourToMutate.actions.remove(at: index)

            case .replace(let index, let action):
                behaviourToMutate.actions[index] = action
            }

            return behaviourToMutate
        }
    }

    public static func makeMutationPicker(actionGenerator: @escaping () -> Action)
            -> (Int) -> Mutation {
        {
            length in

            if length == 0 {
                return .add(actionGenerator(), at: .random(in: 0...length))
            }

            switch Int.random(in: 1...3) {
            case 1: return .add(actionGenerator(), at: .random(in: 0...length))
            case 2: return .remove(at: .random(in: 0..<length))
            case 3: return .replace(at: .random(in: 0..<length), with: actionGenerator())
            case let x: fatalError("Int.random has generated unexpected value: \(x)")
            }
        }
    }
}

