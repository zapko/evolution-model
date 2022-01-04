//
// Created by Konstantin Zabelin on 04.01.2022.
//

import Foundation


public struct Agent: Equatable,
                     Hashable,
                     ExpressibleByIntegerLiteral {

    public let attribute: Int


    // MARK: - Initialization / Deinitialization

    public init(attribute: Int) {
        self.attribute = attribute
    }


    // MARK: - ExpressibleByIntegerLiteral

    public init(integerLiteral value: Int) {
        self.attribute = value
    }
}

