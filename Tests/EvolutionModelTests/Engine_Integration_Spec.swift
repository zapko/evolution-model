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
        let initialWorld = World.make(rows: 10, columns: 10)

        measure {

            var world = initialWorld
            world.space[0][0] = 1

            for _ in 1...50 {
                world = engine.iterate(world: world)
            }
        }
    }
}



