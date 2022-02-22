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

public final class GetIncidentByIdQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query GetIncidentById($id: ID!) {
      getIncidentById(incidentId: $id) {
        __typename
        _id
        _idOpenCitizen
        closureConfirms
        likes
        dislikes
        dtOpen
        updatedAt
        dtClose
        stIncident
        dcAddress
        nrAddress
        dcNeighborhood
        qtUpInteraction
        qtDownInteraction
        vlLatitude
        vlLongitude
        cdSegment
        segments {
          __typename
          dcSegment
          dcOccurrence
        }
        txComment
        tpImage
        mediaUrls
      }
    }
    """

  public let operationName: String = "GetIncidentById"

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("getIncidentById", arguments: ["incidentId": GraphQLVariable("id")], type: .nonNull(.object(GetIncidentById.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(getIncidentById: GetIncidentById) {
      self.init(unsafeResultMap: ["__typename": "Query", "getIncidentById": getIncidentById.resultMap])
    }

    /// Exibe o Incidente pelo ID.
    public var getIncidentById: GetIncidentById {
      get {
        return GetIncidentById(unsafeResultMap: resultMap["getIncidentById"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "getIncidentById")
      }
    }

    public struct GetIncidentById: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Incident"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("_id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("_idOpenCitizen", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("closureConfirms", type: .nonNull(.list(.nonNull(.scalar(String.self))))),
          GraphQLField("likes", type: .nonNull(.list(.nonNull(.scalar(String.self))))),
          GraphQLField("dislikes", type: .nonNull(.list(.nonNull(.scalar(String.self))))),
          GraphQLField("dtOpen", type: .nonNull(.scalar(ISODate.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(ISODate.self))),
          GraphQLField("dtClose", type: .scalar(ISODate.self)),
          GraphQLField("stIncident", type: .nonNull(.scalar(Int.self))),
          GraphQLField("dcAddress", type: .nonNull(.scalar(String.self))),
          GraphQLField("nrAddress", type: .scalar(String.self)),
          GraphQLField("dcNeighborhood", type: .nonNull(.scalar(String.self))),
          GraphQLField("qtUpInteraction", type: .nonNull(.scalar(Int.self))),
          GraphQLField("qtDownInteraction", type: .nonNull(.scalar(Int.self))),
          GraphQLField("vlLatitude", type: .nonNull(.scalar(Double.self))),
          GraphQLField("vlLongitude", type: .nonNull(.scalar(Double.self))),
          GraphQLField("cdSegment", type: .nonNull(.scalar(Int.self))),
          GraphQLField("segments", type: .nonNull(.list(.nonNull(.object(Segment.selections))))),
          GraphQLField("txComment", type: .scalar(String.self)),
          GraphQLField("tpImage", type: .nonNull(.scalar(String.self))),
          GraphQLField("mediaUrls", type: .list(.nonNull(.scalar(String.self)))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(_id: GraphQLID, _idOpenCitizen: GraphQLID, closureConfirms: [String], likes: [String], dislikes: [String], dtOpen: ISODate, updatedAt: ISODate, dtClose: ISODate? = nil, stIncident: Int, dcAddress: String, nrAddress: String? = nil, dcNeighborhood: String, qtUpInteraction: Int, qtDownInteraction: Int, vlLatitude: Double, vlLongitude: Double, cdSegment: Int, segments: [Segment], txComment: String? = nil, tpImage: String, mediaUrls: [String]? = nil) {
        self.init(unsafeResultMap: ["__typename": "Incident", "_id": _id, "_idOpenCitizen": _idOpenCitizen, "closureConfirms": closureConfirms, "likes": likes, "dislikes": dislikes, "dtOpen": dtOpen, "updatedAt": updatedAt, "dtClose": dtClose, "stIncident": stIncident, "dcAddress": dcAddress, "nrAddress": nrAddress, "dcNeighborhood": dcNeighborhood, "qtUpInteraction": qtUpInteraction, "qtDownInteraction": qtDownInteraction, "vlLatitude": vlLatitude, "vlLongitude": vlLongitude, "cdSegment": cdSegment, "segments": segments.map { (value: Segment) -> ResultMap in value.resultMap }, "txComment": txComment, "tpImage": tpImage, "mediaUrls": mediaUrls])
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

      public var _idOpenCitizen: GraphQLID {
        get {
          return resultMap["_idOpenCitizen"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "_idOpenCitizen")
        }
      }

      public var closureConfirms: [String] {
        get {
          return resultMap["closureConfirms"]! as! [String]
        }
        set {
          resultMap.updateValue(newValue, forKey: "closureConfirms")
        }
      }

      public var likes: [String] {
        get {
          return resultMap["likes"]! as! [String]
        }
        set {
          resultMap.updateValue(newValue, forKey: "likes")
        }
      }

      public var dislikes: [String] {
        get {
          return resultMap["dislikes"]! as! [String]
        }
        set {
          resultMap.updateValue(newValue, forKey: "dislikes")
        }
      }

      public var dtOpen: ISODate {
        get {
          return resultMap["dtOpen"]! as! ISODate
        }
        set {
          resultMap.updateValue(newValue, forKey: "dtOpen")
        }
      }

      public var updatedAt: ISODate {
        get {
          return resultMap["updatedAt"]! as! ISODate
        }
        set {
          resultMap.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var dtClose: ISODate? {
        get {
          return resultMap["dtClose"] as? ISODate
        }
        set {
          resultMap.updateValue(newValue, forKey: "dtClose")
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

      public var dcAddress: String {
        get {
          return resultMap["dcAddress"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "dcAddress")
        }
      }

      public var nrAddress: String? {
        get {
          return resultMap["nrAddress"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "nrAddress")
        }
      }

      public var dcNeighborhood: String {
        get {
          return resultMap["dcNeighborhood"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "dcNeighborhood")
        }
      }

      public var qtUpInteraction: Int {
        get {
          return resultMap["qtUpInteraction"]! as! Int
        }
        set {
          resultMap.updateValue(newValue, forKey: "qtUpInteraction")
        }
      }

      public var qtDownInteraction: Int {
        get {
          return resultMap["qtDownInteraction"]! as! Int
        }
        set {
          resultMap.updateValue(newValue, forKey: "qtDownInteraction")
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

      public var txComment: String? {
        get {
          return resultMap["txComment"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "txComment")
        }
      }

      public var tpImage: String {
        get {
          return resultMap["tpImage"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "tpImage")
        }
      }

      public var mediaUrls: [String]? {
        get {
          return resultMap["mediaUrls"] as? [String]
        }
        set {
          resultMap.updateValue(newValue, forKey: "mediaUrls")
        }
      }

      public struct Segment: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Occurrence"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("dcSegment", type: .nonNull(.scalar(String.self))),
            GraphQLField("dcOccurrence", type: .nonNull(.scalar(String.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(dcSegment: String, dcOccurrence: String) {
          self.init(unsafeResultMap: ["__typename": "Occurrence", "dcSegment": dcSegment, "dcOccurrence": dcOccurrence])
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
      }
    }
  }
}

public final class GetOccurrencesQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query getOccurrences($segId: Int!) {
      getOccurrencesBySegmentCode(cdSegment: $segId, stActive: true) {
        __typename
        _id
        dcOccurrence
      }
    }
    """

  public let operationName: String = "getOccurrences"

  public var segId: Int

  public init(segId: Int) {
    self.segId = segId
  }

  public var variables: GraphQLMap? {
    return ["segId": segId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("getOccurrencesBySegmentCode", arguments: ["cdSegment": GraphQLVariable("segId"), "stActive": true], type: .nonNull(.list(.nonNull(.object(GetOccurrencesBySegmentCode.selections))))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(getOccurrencesBySegmentCode: [GetOccurrencesBySegmentCode]) {
      self.init(unsafeResultMap: ["__typename": "Query", "getOccurrencesBySegmentCode": getOccurrencesBySegmentCode.map { (value: GetOccurrencesBySegmentCode) -> ResultMap in value.resultMap }])
    }

    /// Lista Ocorrências pelo código do Segmento (cdSegment)
    public var getOccurrencesBySegmentCode: [GetOccurrencesBySegmentCode] {
      get {
        return (resultMap["getOccurrencesBySegmentCode"] as! [ResultMap]).map { (value: ResultMap) -> GetOccurrencesBySegmentCode in GetOccurrencesBySegmentCode(unsafeResultMap: value) }
      }
      set {
        resultMap.updateValue(newValue.map { (value: GetOccurrencesBySegmentCode) -> ResultMap in value.resultMap }, forKey: "getOccurrencesBySegmentCode")
      }
    }

    public struct GetOccurrencesBySegmentCode: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Occurrence"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("_id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("dcOccurrence", type: .nonNull(.scalar(String.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(_id: GraphQLID, dcOccurrence: String) {
        self.init(unsafeResultMap: ["__typename": "Occurrence", "_id": _id, "dcOccurrence": dcOccurrence])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// Propriedades que compõem o corpo da Ocorrência.
      public var _id: GraphQLID {
        get {
          return resultMap["_id"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "_id")
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
