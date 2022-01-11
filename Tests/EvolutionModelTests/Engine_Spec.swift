//
// Created by Konstantin Zabelin on 03.01.2022.
//

import XCTest
import EvolutionModel


final class Engine_Spec: XCTestCase {

    func test_Empty_space_produces_no_space_changes() throws {

        let sut = Engine.make()
        let state = State(space: [], behaviours: [:])

        XCTAssertTrue(sut.determineSpaceChanges(for: state).isEmpty)
    }

    func test_Empty_state_produces_empty_behaviours() throws {

        let sut = Engine.make()
        let state = State(space: [], behaviours: [:])

        let behaviours = sut.determineNewBehaviours(for: state)

        XCTAssertTrue(behaviours.isEmpty)
    }

    func test_Space_with_no_agents_produces_empty_behaviours() throws {

        let sut = Engine.make()
        let state = State(space: [[.empty, .empty]], behaviours: [:])

        let newBehaviours = sut.determineNewBehaviours(for: state)

        XCTAssertTrue(newBehaviours.isEmpty)
    }

    func test_Behaviour_that_has_no_agents_extincts() throws {

        let sut = Engine.make()
        let state = State(space: [[1]], behaviours: [2: ["" : []]])

        let newBehaviours = sut.determineNewBehaviours(for: state)

        XCTAssertNil(newBehaviours[2])
    }

    func test_No_new_behaviour_is_generated_for_known_agents_in_known_cells() throws {

        let sut = Engine.make()
        let state = State(
            space: [["2, 3"]],
            behaviours: [
                2:["2, 3": [.remove(4)]],
                3:["2, 3": [.remove(5)]]
            ]
        )

        let newBehaviours = sut.determineNewBehaviours(for: state)

        XCTAssertEqual(
            newBehaviours,
            [
                2:["2, 3": [.remove(4)]],
                3:["2, 3": [.remove(5)]]
            ]
        )
    }

    func test_New_behaviour_is_generated_for_unknown_agents() throws {

        let sut = Engine.make()
        let state = State(space: [[2]], behaviours: [:])

        let newBehaviours = sut.determineNewBehaviours(for: state)

        XCTAssertEqual(Array<Agent>(newBehaviours.keys), [2])
    }

    func test_When_new_behaviour_is_generated_it_matches_current_agents_cell() throws {

        let sut = Engine.make()
        let state = State(space: [["2, 3"]], behaviours: [2: ["2, 3" : []]])

        let newBehaviours = sut.determineNewBehaviours(for: state)

        XCTAssertEqual(Array<Cell>(newBehaviours[3, default: [:]].keys), ["2, 3"])
    }

    func test_When_behaviour_for_new_agent_is_generated__action_is_taken_from_behaviour_expander() throws {

        let sut = Engine.make(behaviourExpander: { _, _ in [.change(3, to: 9)] })
        let state = State(space: [[2]], behaviours: [:])

        let newBehaviours = sut.determineNewBehaviours(for: state)

        XCTAssertEqual(newBehaviours[2, default: [:]][2, default: []], [Action.change(3, to: 9)])
    }
}

private extension Engine {
    static func make(
        behaviourExpander: @escaping (Cell, [Cell:Behaviour]) -> Behaviour = { _, _ in [.remove(-1)] }
    ) -> Engine {
        Engine(behaviourExpander: behaviourExpander)
    }
}

