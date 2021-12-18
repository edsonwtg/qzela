// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class GetHealthQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query GetHealth {
      health
    }
    """

  public let operationName: String = "GetHealth"

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

public final class GetSegmentsQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query GetSegments {
      getSegments(stActive: true) {
        __typename
        cdSegment
        dcSegment
        stActive
      }
    }
    """

  public let operationName: String = "GetSegments"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("getSegments", arguments: ["stActive": true], type: .nonNull(.list(.nonNull(.object(GetSegment.selections))))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(getSegments: [GetSegment]) {
      self.init(unsafeResultMap: ["__typename": "Query", "getSegments": getSegments.map { (value: GetSegment) -> ResultMap in value.resultMap }])
    }

    /// Lista todos os Segmentos.
    public var getSegments: [GetSegment] {
      get {
        return (resultMap["getSegments"] as! [ResultMap]).map { (value: ResultMap) -> GetSegment in GetSegment(unsafeResultMap: value) }
      }
      set {
        resultMap.updateValue(newValue.map { (value: GetSegment) -> ResultMap in value.resultMap }, forKey: "getSegments")
      }
    }

    public struct GetSegment: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["SegmentLabel"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("cdSegment", type: .nonNull(.scalar(Int.self))),
          GraphQLField("dcSegment", type: .nonNull(.scalar(String.self))),
          GraphQLField("stActive", type: .nonNull(.scalar(Bool.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(cdSegment: Int, dcSegment: String, stActive: Bool) {
        self.init(unsafeResultMap: ["__typename": "SegmentLabel", "cdSegment": cdSegment, "dcSegment": dcSegment, "stActive": stActive])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var cdSegment: Int {
        get {
          return resultMap["cdSegment"]! as! Int
        }
        set {
          resultMap.updateValue(newValue, forKey: "cdSegment")
        }
      }

      public var dcSegment: String {
        get {
          return resultMap["dcSegment"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "dcSegment")
        }
      }

      public var stActive: Bool {
        get {
          return resultMap["stActive"]! as! Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "stActive")
        }
      }
    }
  }
}

public final class GetViewportQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query GetViewport($neCoord: Coordinate!, $swCoord: Coordinate!, $already: [ID]!, $isOpen: Boolean) {
      getIncidentsByViewport(
        northEastCoordinates: $neCoord
        southWestCoordinates: $swCoord
        incidentIdsAlreadyObtained: $already
        isOpen: $isOpen
      ) {
        __typename
        data {
          __typename
          _id
          stIncident
          vlLatitude
          vlLongitude
          cdSegment
          segments {
            __typename
            dcSegment
            dcOccurrence
            stActive
          }
        }
      }
    }
    """

  public let operationName: String = "GetViewport"

  public var neCoord: Coordinate
  public var swCoord: Coordinate
  public var already: [GraphQLID?]
  public var isOpen: Bool?

  public init(neCoord: Coordinate, swCoord: Coordinate, already: [GraphQLID?], isOpen: Bool? = nil) {
    self.neCoord = neCoord
    self.swCoord = swCoord
    self.already = already
    self.isOpen = isOpen
  }

  public var variables: GraphQLMap? {
    return ["neCoord": neCoord, "swCoord": swCoord, "already": already, "isOpen": isOpen]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("getIncidentsByViewport", arguments: ["northEastCoordinates": GraphQLVariable("neCoord"), "southWestCoordinates": GraphQLVariable("swCoord"), "incidentIdsAlreadyObtained": GraphQLVariable("already"), "isOpen": GraphQLVariable("isOpen")], type: .nonNull(.object(GetIncidentsByViewport.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(getIncidentsByViewport: GetIncidentsByViewport) {
      self.init(unsafeResultMap: ["__typename": "Query", "getIncidentsByViewport": getIncidentsByViewport.resultMap])
    }

    /// Lista os Incidentes pelas coordenadas do Viewport.
    public var getIncidentsByViewport: GetIncidentsByViewport {
      get {
        return GetIncidentsByViewport(unsafeResultMap: resultMap["getIncidentsByViewport"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "getIncidentsByViewport")
      }
    }

    public struct GetIncidentsByViewport: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["IncidentPagination"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("data", type: .nonNull(.list(.nonNull(.object(Datum.selections))))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(data: [Datum]) {
        self.init(unsafeResultMap: ["__typename": "IncidentPagination", "data": data.map { (value: Datum) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// Propriedades que compõem o corpo das informações da Paginação.
      public var data: [Datum] {
        get {
          return (resultMap["data"] as! [ResultMap]).map { (value: ResultMap) -> Datum in Datum(unsafeResultMap: value) }
        }
        set {
          resultMap.updateValue(newValue.map { (value: Datum) -> ResultMap in value.resultMap }, forKey: "data")
        }
      }

      public struct Datum: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Incident"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("_id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("stIncident", type: .nonNull(.scalar(Int.self))),
            GraphQLField("vlLatitude", type: .nonNull(.scalar(Double.self))),
            GraphQLField("vlLongitude", type: .nonNull(.scalar(Double.self))),
            GraphQLField("cdSegment", type: .nonNull(.scalar(Int.self))),
            GraphQLField("segments", type: .nonNull(.list(.nonNull(.object(Segment.selections))))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(_id: GraphQLID, stIncident: Int, vlLatitude: Double, vlLongitude: Double, cdSegment: Int, segments: [Segment]) {
          self.init(unsafeResultMap: ["__typename": "Incident", "_id": _id, "stIncident": stIncident, "vlLatitude": vlLatitude, "vlLongitude": vlLongitude, "cdSegment": cdSegment, "segments": segments.map { (value: Segment) -> ResultMap in value.resultMap }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// Propriedades que compõem o corpo do Incidente.
        public var _id: GraphQLID {
          get {
            return resultMap["_id"]! as! GraphQLID
          }
          set {
            resultMap.updateValue(newValue, forKey: "_id")
          }
        }

        public var stIncident: Int {
          get {
            return resultMap["stIncident"]! as! Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "stIncident")
          }
        }

        public var vlLatitude: Double {
          get {
            return resultMap["vlLatitude"]! as! Double
          }
          set {
            resultMap.updateValue(newValue, forKey: "vlLatitude")
          }
        }

        public var vlLongitude: Double {
          get {
            return resultMap["vlLongitude"]! as! Double
          }
          set {
            resultMap.updateValue(newValue, forKey: "vlLongitude")
          }
        }

        public var cdSegment: Int {
          get {
            return resultMap["cdSegment"]! as! Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "cdSegment")
          }
        }

        public var segments: [Segment] {
          get {
            return (resultMap["segments"] as! [ResultMap]).map { (value: ResultMap) -> Segment in Segment(unsafeResultMap: value) }
          }
          set {
            resultMap.updateValue(newValue.map { (value: Segment) -> ResultMap in value.resultMap }, forKey: "segments")
          }
        }

        public struct Segment: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Occurrence"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("dcSegment", type: .nonNull(.scalar(String.self))),
              GraphQLField("dcOccurrence", type: .nonNull(.scalar(String.self))),
              GraphQLField("stActive", type: .nonNull(.scalar(Bool.self))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(dcSegment: String, dcOccurrence: String, stActive: Bool) {
            self.init(unsafeResultMap: ["__typename": "Occurrence", "dcSegment": dcSegment, "dcOccurrence": dcOccurrence, "stActive": stActive])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var dcSegment: String {
            get {
              return resultMap["dcSegment"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "dcSegment")
            }
          }

          public var dcOccurrence: String {
            get {
              return resultMap["dcOccurrence"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "dcOccurrence")
            }
          }

          public var stActive: Bool {
            get {
              return resultMap["stActive"]! as! Bool
            }
            set {
              resultMap.updateValue(newValue, forKey: "stActive")
            }
          }
        }
      }
    }
  }
}
