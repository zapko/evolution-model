//
// Created by Konstantin Zabelin on 04.01.2022.
//

import XCTest
import EvolutionModel


final class Direction_Spec: XCTestCase {

    func test_Coordinates_adjusted_nowhere_do_not_change_column_or_row_idices() throws {

        let result = Direction.none.adjust(3, 4, width: 6, height: 6)

        XCTAssertEqual(result.i, 3)
        XCTAssertEqual(result.j, 4)
    }

    func test_Coordinates_adjusted_up_reduces_row_index_and_does_not_change_column_index() throws {

        let result = Direction.up.adjust(3, 4, width: 6, height: 6)

        XCTAssertEqual(result.i, 2)
        XCTAssertEqual(result.j, 4)
    }

    func test_Coordinates_adjusted_down_increase_row_index_and_does_not_change_column_index() throws {

        let result = Direction.down.adjust(3, 4, width: 6, height: 6)

        XCTAssertEqual(result.i, 4)
        XCTAssertEqual(result.j, 4)
    }

    func test_Coordinates_adjusted_left_decrease_column_index_and_does_not_change_row_index() throws {

        let result = Direction.left.adjust(3, 4, width: 6, height: 6)

        XCTAssertEqual(result.i, 3)
        XCTAssertEqual(result.j, 3)
    }

    func test_Coordinates_adjusted_right_inccrease_column_index_and_does_not_change_row_index() throws {

        let result = Direction.right.adjust(3, 4, width: 6, height: 6)

        XCTAssertEqual(result.i, 3)
        XCTAssertEqual(result.j, 5)
    }

    func test_Coordinates_on_boarders_adjusted_in_boarder_direction_wrap_to_the_opposite_side() throws {

        let leftWrap = Direction.left.adjust(3,0, width: 5, height: 5)
        XCTAssertEqual(leftWrap.i, 3)
        XCTAssertEqual(leftWrap.j, 4)

        let rightWrap = Direction.right.adjust(3,4, width: 5, height: 5)
        XCTAssertEqual(rightWrap.i, 3)
        XCTAssertEqual(rightWrap.j, 0)

        let upWrap = Direction.up.adjust(0,4, width: 5, height: 5)
        XCTAssertEqual(upWrap.i, 4)
        XCTAssertEqual(upWrap.j, 4)

        let downWrap = Direction.down.adjust(4,4, width: 5, height: 5)
        XCTAssertEqual(downWrap.i, 0)
        XCTAssertEqual(downWrap.j, 4)
    }
}

