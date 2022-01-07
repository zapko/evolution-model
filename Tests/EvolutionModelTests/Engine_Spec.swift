//
// Created by Konstantin Zabelin on 03.01.2022.
//

import XCTest
import EvolutionModel


final class Engine_Spec: XCTestCase {

    func test_Empty_space_produces_no_space_changes() throws {

        let sut = Engine()
        let state = Engine.State(space: [], behaviours: [:])

        XCTAssertTrue(sut.determineSpaceChanges(for: state).isEmpty)
    }

    func test_Empty_space_produces_no_behaviour_changes() throws {

        let sut = Engine()
        let state = Engine.State(space: [], behaviours: [:])

        let changes = sut.determineBehaviourChanges(for: state)

        XCTAssertTrue(changes.extincted.isEmpty)
        XCTAssertTrue(changes.new.isEmpty)
    }

    func test_Space_with_no_agents_produces_no_behaviour_changes() throws {

        let sut = Engine()
        let state = Engine.State(
            space: [[.empty, .empty]],
            behaviours: [:]
        )

        let changes = sut.determineBehaviourChanges(for: state)

        XCTAssertTrue(changes.extincted.isEmpty)
        XCTAssertTrue(changes.new.isEmpty)
    }

    func test_Behaviour_that_has_no_agents_extincts() throws {

        let sut = Engine()
        let state = Engine.State(
            space: [[1]],
            behaviours: [
                2: ["2, 1, 3" : [Engine.Action.remove(5)]]
            ]
        )

        let changes = sut.determineBehaviourChanges(for: state)

        XCTAssertEqual(changes.extincted, [2])
    }
}
