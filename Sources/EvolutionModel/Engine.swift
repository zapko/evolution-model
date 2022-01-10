//
// Created by Konstantin Zabelin on 03.01.2022.
//

import Foundation


public final class Engine {

    public typealias Behaviours = [Agent: [Cell: Behaviour]]

    public struct State: Equatable {
        var space: [[Cell]]
        var behaviours: Behaviours

        public init(space: [[Cell]], behaviours: Behaviours) {
            self.space      = space
            self.behaviours = behaviours
        }
    }

    public enum Action: Equatable {
        case remove(Agent)
        case add(Agent, Direction)
        case change(Agent, to: Agent)
    }

    public typealias SpaceChanges = [[[Action]]]


    // MARK: - Private State

    private let behaviourExpander: ([Cell: Behaviour]) -> Behaviour

    // MARK: - Initialization / Deinitialization

    public init(behaviourExpander: @escaping ([Cell: Behaviour]) -> Behaviour) {
        self.behaviourExpander = behaviourExpander
    }


    // MARK: - Engine

    public func determineNewBehaviours(for state: State) -> Behaviours {

        let existingAgents = Set(state.space.flatMap { $0.flatMap { $0.agents } })
        let knownAgents = Set(state.behaviours.keys)

        var result = state.behaviours

        // Removing extincted agents
        knownAgents
            .subtracting(existingAgents)
            .forEach { result.removeValue(forKey: $0) }

        for row in state.space {
            for cell in row {
                for agent in cell.agents {

                    guard let agentBehaviours = result[agent] else {
                        result[agent] = [cell: behaviourExpander([:])]
                        continue
                    }

                    if agentBehaviours[cell] != nil {
                        continue
                    }

                    result[agent, default: [:]][cell] = behaviourExpander(agentBehaviours)
                }
            }
        }

        return result
    }

    public func determineSpaceChanges(for state: State) -> SpaceChanges {
        state.space.map {
            row in
            row.map {
                cell in
                cell.agents.flatMap {
                    agent in
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
                            let (newI, newJ) = direction.adjust(i, j, width: row.count, height: spaceChanges.count)
                            newState.space[newI][newJ].add(agent: agent)
                        case .remove(let agent):
                            newState.space[i][j].remove(agent: agent)
                        case .change(let from, to: let to):
                            newState.space[i][j].remove(agent: from)
                            newState.space[i][j].add(agent: to)
                    }
                }
            }
        }
        return newState
    }

    public func iterate(state: State) -> State {
        let halfChangedState = State(
            space: state.space,
            behaviours: determineNewBehaviours(for: state)
        )
        let spaceChanges = determineSpaceChanges(for: halfChangedState)
        return apply(spaceChanges: spaceChanges, to: halfChangedState)
    }
}
