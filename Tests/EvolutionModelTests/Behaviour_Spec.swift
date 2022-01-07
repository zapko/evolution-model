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
                Engine.Action.remove(5),
                .add(3, .up),
                .change(1, to: 4)
            ]
        )
    }
}


