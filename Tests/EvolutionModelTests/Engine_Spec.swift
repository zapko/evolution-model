//
// Created by Konstantin Zabelin on 03.01.2022.
//

import XCTest
import EvolutionModel


final class Engine_Spec: XCTestCase {

    func test_Empty_space_produces_no_space_changes() throws {

        let sut = Engine.make()
        let state = Engine.State(space: [], behaviours: [:])

        XCTAssertTrue(sut.determineSpaceChanges(for: state).isEmpty)
    }

    func test_Empty_space_produces_no_behaviour_changes() throws {

        let sut = Engine.make()
        let state = Engine.State(space: [], behaviours: [:])

        let changes = sut.determineBehaviourChanges(for: state)

        XCTAssertTrue(changes.extincted.isEmpty)
        XCTAssertTrue(changes.new.isEmpty)
    }

    func test_Space_with_no_agents_produces_no_behaviour_changes() throws {

        let sut = Engine.make()
        let state = Engine.State(space: [[.empty, .empty]], behaviours: [:])

        let changes = sut.determineBehaviourChanges(for: state)

        XCTAssertTrue(changes.extincted.isEmpty)
        XCTAssertTrue(changes.new.isEmpty)
    }

    func test_Behaviour_that_has_no_agents_extincts() throws {

        let sut = Engine.make()
        let state = Engine.State(space: [[1]], behaviours: [2: ["" : []]])

        let changes = sut.determineBehaviourChanges(for: state)

        XCTAssertEqual(changes.extincted, [2])
    }

    func test_No_new_behaviour_is_generated_for_known_agents_in_known_cells() throws {

        let sut = Engine.make()
        let state = Engine.State(space: [[2]], behaviours: [2:[2: [.remove(3)]]])

        let changes = sut.determineBehaviourChanges(for: state)

        XCTAssertTrue(changes.new.isEmpty)
    }

    func test_New_behaviour_is_generated_for_unknown_agents() throws {

        let sut = Engine.make()
        let state = Engine.State(space: [[2]], behaviours: [:])

        let changes = sut.determineBehaviourChanges(for: state)

        XCTAssertEqual(Array<Agent>(changes.new.keys), [2])
    }

    func test_When_new_behaviour_is_generated_it_matches_current_agents_cell() throws {

        let sut = Engine.make()
        let state = Engine.State(space: [["2, 3"]], behaviours: [2: ["2, 3" : []]])

        let changes = sut.determineBehaviourChanges(for: state)

        XCTAssertEqual(Array<Cell>(changes.new[3, default: [:]].keys), ["2, 3"])
    }

    func test_When_behaviour_for_new_agent_is_generated_action_is_taken_from_the_generator() throws {

        let sut = Engine.make(actionsGenerator: { .change(3, to: 9) })
        let state = Engine.State(space: [[2]], behaviours: [:])

        let changes = sut.determineBehaviourChanges(for: state)

        XCTAssertEqual(changes.new[2, default: [:]][2, default: []], [Engine.Action.change(3, to: 9)])
    }
}

private extension Engine {
    static func make(
        actionsGenerator: @escaping () -> Action = { .remove(-1) }
    ) -> Engine {
        Engine(actionsGenerator: actionsGenerator)
    }
}

