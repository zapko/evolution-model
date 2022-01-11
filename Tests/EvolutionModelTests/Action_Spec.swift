//
// Created by Konstantin Zabelin on 10.01.2022.
//

import XCTest
import EvolutionModel


final class Action_Spec: XCTestCase {

    func test_Action_generator_makes_all_kind_of_actions_with_agents_within_a_given_range() {

        struct Accumulator {
            var addedAgents = Set<Agent>()
            var addedDirections = Set<Direction>()
            var removedAgents = Set<Agent>()
            var changedToAgents = Set<Agent>()
            var changedFromAgents = Set<Agent>()
        }

        let sut = Action.makeGenerator(attributesRange: -2...3)

        let accumulator = (0...5000)
            .map { _ in sut() }
            .reduce(into: Accumulator()) {
                switch $1 {
                case .remove(let agent):
                    $0.removedAgents.insert(agent)
                case .add(let agent, let direction):
                    $0.addedAgents.insert(agent)
                    $0.addedDirections.insert(direction)
                case .change(let fromAgent, let toAgent):
                    $0.changedFromAgents.insert(fromAgent)
                    $0.changedToAgents.insert(toAgent)
                }
            }

        XCTAssertEqual(accumulator.addedDirections, Set(Direction.allCases))
        XCTAssertEqual(accumulator.addedAgents, Set([-2, -1, 0, 1, 2, 3]))
        XCTAssertEqual(accumulator.removedAgents, Set([-2, -1, 0, 1, 2, 3]))
        XCTAssertEqual(accumulator.changedToAgents, Set([-2, -1, 0, 1, 2, 3]))
        XCTAssertEqual(accumulator.changedFromAgents, Set([-2, -1, 0, 1, 2, 3]))
    }
}
