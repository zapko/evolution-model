//
// Created by Konstantin Zabelin on 04.01.2022.
//

import XCTest
import EvolutionModel


final class Cell_Spec: XCTestCase {

    func test_Cell_created_from_integer_literal_has_one_agent_with_attribute_that_matches_integer_value() throws {
        let cell: Cell = 3
        XCTAssertEqual(cell.agents.map(\.attribute), [3])
    }

    func test_Cell_created_from_string_literal_with_commaSeparated_list_of_integers_has_agents_matching_that_list() throws {
        let cell: Cell = "2, 3, 2"
        XCTAssertEqual(cell.agents.map(\.attribute), [2, 3, 2])
    }

    func test_When_commaSeparated_list_contains_nonInteger_items_they_are_skipped() throws {
        let cell: Cell = "2, 3 hey 5, yo, 2"
        XCTAssertEqual(cell.agents.map(\.attribute), [2, 2])
    }
}
