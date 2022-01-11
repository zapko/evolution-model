//
// Created by Konstantin Zabelin on 10.01.2022.
//

import Foundation


public enum Action: Equatable, Hashable {
    case add(Agent, Direction)
    case remove(Agent)
    case change(Agent, to: Agent)

    public static func makeGenerator(attributesRange range: ClosedRange<Agent.Attribute>)
            -> () -> Action {
        {
            switch Int.random(in: 1...3) {
            case 1: return .add(.make(with: range), .allCases.randomElement() ?? .none)
            case 2: return .remove(.make(with: range))
            case 3: return .change(.make(with: range), to: .make(with: range))
            case let x: fatalError("Unexpected output of Int.random(in: 1...3): \(x)")
            }
        }
    }
}

private extension Agent {
    static func make(with range: ClosedRange<Attribute>) -> Agent {
        .init(attribute: .random(in: range))
    }
}

