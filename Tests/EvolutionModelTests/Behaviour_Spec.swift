//
// Created by Konstantin Zabelin on 07.01.2022.
//

import XCTest
import EvolutionModel


final class Behaviour_Spec: XCTestCase {

    func test_Behaviour_created_from_array_literal_contains_actions_described_in_literal() throws {

        let sut: Behaviour = [.remove(5), .add(3, .up), .change(1, to: 4)]

        XCTAssertEqual(
            sut.actions,
            [
                Behaviour.Action.remove(5),
                Behaviour.Action.add(3, .up),
                Behaviour.Action.change(1, to: 4)
            ]
        )
    }

    func test_When_behaviour_is_expanded_it_returns_result_of_mutator_execution() throws {

        let sut = Behaviour.makeExpander(
            mutator: { _ in [.change(10, to: 90)]}
        )

        XCTAssertEqual(
            sut("1", ["2": [.remove(99)]]),
            [.change(10, to: 90)]
        )
    }

    func test_When_there_are_no_known_behaviours__expander_provides_nothing_to_mutator() throws {

        let sut = Behaviour.makeExpander(
            mutator: {
                XCTAssertNil($0)
                return [.remove(100)]
            }
        )

        XCTAssertEqual(
            sut("1, 2", [:]),
            [.remove(100)]
        )
    }

    func test_When_there_is_one_known_behaviour_it_is_provided_to_mutator() throws {

        let sut = Behaviour.makeExpander(
            mutator: {
                XCTAssertEqual($0, .some([.add(90, .up)]))
                return [.remove(100)]
            }
        )

        XCTAssertEqual(
            sut("1, 2", ["3, 1": [.add(90, .up)]]),
            [.remove(100)]
        )
    }

    func test_When_there_are_multiple_known_behaviours__mutator_is_provided_with_one_from_the_closest_in_terms_of_sum_of_agents_attributes() throws {

        let sut = Behaviour.makeExpander(
            mutator: {
                XCTAssertEqual($0, .some([.add(6, .up)]))
                return [.remove(101)]
            }
        )

        XCTAssertEqual(
            sut(
                "12",
                [
                    "0": [.add(1, .up)],
                    "11": [.add(3, .up)],
                    "3, 3, 3, 3": [.add(6, .up)],
                    "2, 1, 9": [.add(6, .up)],
                    "120": [.add(4, .up)],
                    "10, 3": [.add(5, .up)],
                    "3, 1": [.add(7, .up)]
                ]
        ),
            [.remove(101)]
        )
    }
}


