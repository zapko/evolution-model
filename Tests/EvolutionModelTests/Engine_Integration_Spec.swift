//
//  Engine_Integration_Spec.swift
//  
//
//  Created by Konstantin Zabelin on 10.01.2022.
//


import XCTest
import EvolutionModel

final class Engine_Integration_Spec: XCTestCase {

    func test_Composed_system_evolution_takes_reasonable_time() {

        let engine = Engine.make(agentAttributeRange: 1...10)
        let initialState = State.make(rows: 100, columns: 100)

        measure {

            var state = initialState
            state.space[0][0] = 1

            for _ in 1...5 {
                state = engine.iterate(state: state)
            }
        }
    }
}



