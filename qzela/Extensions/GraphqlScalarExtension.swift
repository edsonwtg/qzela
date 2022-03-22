//
// Created by Edson Rocha on 06/01/22.
//

import Apollo

public typealias Coordinate = [Double]
public typealias Upload = String

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

public typealias ISODate = Foundation.Date

extension ISODate: JSONDecodable, JSONEncodable {

    public init(jsonValue value: JSONValue) throws {
        guard let isoString = value as? String else {
            throw JSONDecodingError.couldNotConvert(value: value, to: String.self)
        }

//        let formatter = ISO8601DateFormatter()
//        formatter.formatOptions = [.withFractionalSeconds]
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        guard let date = formatter.date(from: isoString) else {
            throw JSONDecodingError.couldNotConvert(value: value, to: Date.self)
        }

        self = date
    }

    public var jsonValue: JSONValue {
        return ISO8601DateFormatter().string(from: self)
    }
}

