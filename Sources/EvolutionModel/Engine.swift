//
// Created by Konstantin Zabelin on 03.01.2022.
//

import Foundation


public class Engine {

    public struct State: Equatable {
        var space: [[Cell]]
        var behaviours: [Agent: [Cell: Behaviour]]

        public init(space: [[Cell]], behaviours: [Agent: [Cell: Behaviour]]) {
            self.space      = space
            self.behaviours = behaviours
        }
    }

    public struct Agent: Equatable, Hashable {
        let attribute: Int
    }

    public struct Cell: Equatable, Hashable {
        public private(set) var agents: [Agent]

        mutating func add(agent: Agent) {
            agents.append(agent)
        }

        mutating func remove(agent: Agent) {
//            agents.remove(agent)
        }
    }

    public struct Behaviour: Equatable {
        let actions: [Action]
    }

    public enum Direction: Equatable {
        case none
        case up
        case down
        case left
        case right
        
        func adjusted(_ i: Int, _ j: Int) -> (Int, Int) {
            switch self {
            case .none:  return (i, j)
            case .up:    return (i - 1, j)
            case .down:  return (i + 1, j)
            case .left:  return (i, j - 1)
            case .right: return (i, j + 1)
            }
        }
    }

    public enum Action: Equatable {
        case remove(Agent)
        case add(Agent, Direction)
        case change(Agent, to: Agent)
    }

    public struct Location: Equatable {
        let i: Int
        let j: Int
    }

    public typealias SpaceChanges = [[[Action]]]



    // MARK: - Private State


    // MARK: - Initialization / Deinitialization

    public init() {

    }


    // MARK: - Engine

    public func determineSpaceChanges(for state: State) -> SpaceChanges {
        state.space.map {
            row in
            row.map {
                cell in
                cell.agents.flatMap {
                    agent in
                    // TODO: implement new behaviour allocation
                    state.behaviours[agent]?[cell]?.actions ?? []
                }
            }
        }
    }
    
    public func apply(spaceChanges: SpaceChanges, to state: State) -> State {
        var newState = state
        for (i, row) in spaceChanges.enumerated() {
            for (j, actions) in row.enumerated() {
                for action in actions {
                    switch action {
                        case .add(let agent, let direction):
                            let (newI, newJ) = direction.adjusted(i, j)
                            // TODO: add coordinates wrapping
//                            newState.space[newI][newJ].add agents.insert(agent)
                        case .remove(let agent):
                            break
//                            newState.space[i][j].agents.remove(agent)
                        case .change(let from, to: let to):
                            break
//                            newState.space[i][j].agents.remove(from)
//                            newState.space[i][j].agents.insert(to)
                    }
                }
            }
        }
        return newState
    }

    public func interate(state: State) -> State {
        // TODO: consider changes in behaviours
        let spaceChanges = determineSpaceChanges(for: state)
        return apply(spaceChanges: spaceChanges, to: state)
    }
}
