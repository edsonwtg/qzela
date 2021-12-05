// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class HealthQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query Health {
      health
    }
    """

  public let operationName: String = "Health"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("health", type: .nonNull(.scalar(Bool.self))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(health: Bool) {
      self.init(unsafeResultMap: ["__typename": "Query", "health": health])
    }

    public var health: Bool {
      get {
        return resultMap["health"]! as! Bool
      }
      set {
        resultMap.updateValue(newValue, forKey: "health")
      }
    }
  }
}
