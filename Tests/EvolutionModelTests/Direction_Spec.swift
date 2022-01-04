//
// Created by Konstantin Zabelin on 04.01.2022.
//

import XCTest
import EvolutionModel


final class Direction_Spec: XCTestCase {

    func test_Coordinates_adjusted_up_reduces_row_index_and_does_not_change_column_index() throws {

        let result = Direction.up.adjust(3, 4)

        XCTAssertEqual(result.i, 2)
        XCTAssertEqual(result.j, 4)
    }

}

