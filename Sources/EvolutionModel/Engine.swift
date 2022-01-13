//
// Created by Konstantin Zabelin on 03.01.2022.
//

import Foundation


public final class Engine {

    public typealias SpaceChanges = [[[Action]]]


    // MARK: - Private State

    private let behaviourExpander: (Cell, [Cell: Behaviour]) -> Behaviour


    // MARK: - Initialization / Deinitialization

    public init(behaviourExpander: @escaping (Cell, [Cell: Behaviour]) -> Behaviour) {
        self.behaviourExpander = behaviourExpander
    }

    public static func make(agentAttributeRange: ClosedRange<Agent.Attribute>) -> Engine {
        .init(
            behaviourExpander: Behaviour.makeExpander(
                mutator: Mutation.makeMutator(
                    picker: Mutation.makeMutationPicker(
                        actionGenerator: Action.makeGenerator(
                            attributesRange: agentAttributeRange)))))
    }


    // MARK: - Engine

    public func determineNewBehaviours(for state: World) -> Behaviours {

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
                        result[agent] = [cell: behaviourExpander(cell, [:])]
                        continue
                    }

                    if agentBehaviours[cell] != nil {
                        continue
                    }

                    result[agent, default: [:]][cell] = behaviourExpander(cell, agentBehaviours)
                }
            }
        }

        return result
    }

    public func determineSpaceChanges(for state: World) -> SpaceChanges {
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
    
    public func apply(spaceChanges: SpaceChanges, to state: World) -> World {
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

    public func iterate(world: World) -> World {
        let halfChangedWorld = World(
            space: world.space,
            behaviours: determineNewBehaviours(for: world)
        )
        let spaceChanges = determineSpaceChanges(for: halfChangedWorld)
        return apply(spaceChanges: spaceChanges, to: halfChangedWorld)
    }
}
