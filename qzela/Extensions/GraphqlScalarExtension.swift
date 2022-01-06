//
// Created by Edson Rocha on 06/01/22.
//

import Apollo

public typealias Coordinate = [Double]
extension Array: JSONDecodable {
    /// Custom `init` extension so Apollo can decode custom scalar type `CurrentMissionChallenge `
    public init(jsonValue value: JSONValue) throws {
        guard let array = value as? Array else {
            throw JSONDecodingError.couldNotConvert(value: value, to: Array.self)
        }
        self = array
        return
    }
}

public typealias ISODate = Date

extension ISODate: JSONDecodable, JSONEncodable {

    public init(jsonValue value: JSONValue) throws {
        guard let string = value as? String else {
            throw JSONDecodingError.couldNotConvert(value: value, to: String.self)
        }

        guard let date = ISO8601DateFormatter().date(from: string) else {
            throw JSONDecodingError.couldNotConvert(value: value, to: Date.self)
        }

        self = date
    }

    public var jsonValue: JSONValue {
        return ISO8601DateFormatter().string(from: self)
    }
}