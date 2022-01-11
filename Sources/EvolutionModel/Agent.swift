//
// Created by Konstantin Zabelin on 04.01.2022.
//

import Foundation


public struct Agent: Equatable,
                     Hashable,
                     Codable,
                     ExpressibleByIntegerLiteral {

    public typealias Attribute = Int

    public let attribute: Attribute


    // MARK: - Initialization / Deinitialization

    public init(attribute: Attribute) {
        self.attribute = attribute
    }


    // MARK: - ExpressibleByIntegerLiteral

    public init(integerLiteral value: Int) {
        self.attribute = value
    }
}

