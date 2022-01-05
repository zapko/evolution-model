//
// Created by Konstantin Zabelin on 03.01.2022.
//

import Foundation


public final class Engine {

    public struct State: Equatable {
        var space: [[Cell]]
        var behaviours: Behaviours

        public init(space: [[Cell]], behaviours: Behaviours) {
            self.space      = space
            self.behaviours = behaviours
        }
    }

    public struct Behaviour: Equatable {
        let actions: [Action]
    }

    public typealias Behaviours = [Agent: [Cell: Behaviour]]

    public enum Action: Equatable {
        case remove(Agent)
        case add(Agent, Direction)
        case change(Agent, to: Agent)
    }

    public typealias SpaceChanges = [[[Action]]]
    public struct BehaviourChanges {
        let extincted: [Agent]
        let new: Behaviours

        public init(extincted: [Agent], new: Behaviours) {
            self.extincted = extincted
            self.new       = new
        }
    }


    // MARK: - Private State


    // MARK: - Initialization / Deinitialization

    public init() {

    }


    // MARK: - Engine

    public func determineBehaviourChanges(for state: State) -> BehaviourChanges {
        // TODO: implement
        return .init(extincted: [], new: [:])
    }

    public func apply(behaviourChanges: BehaviourChanges, to state: State) -> State {
        // TODO: implement
        return state
    }

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
        let behaviourChanges = determineBehaviourChanges(for: state)
        let halfChangedState = apply(behaviourChanges: behaviourChanges, to: state)
        let spaceChanges = determineSpaceChanges(for: halfChangedState)
        return apply(spaceChanges: spaceChanges, to: halfChangedState)
    }
}
