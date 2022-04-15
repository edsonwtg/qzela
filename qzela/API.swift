// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public enum IncidentType: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  /// Status do incident para o dashboard do usuario do APP.
  case all
  case `open`
  case close
  case closeregistered
  case registered
  case interaction
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "ALL": self = .all
      case "OPEN": self = .open
      case "CLOSE": self = .close
      case "CLOSEREGISTERED": self = .closeregistered
      case "REGISTERED": self = .registered
      case "INTERACTION": self = .interaction
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .all: return "ALL"
      case .open: return "OPEN"
      case .close: return "CLOSE"
      case .closeregistered: return "CLOSEREGISTERED"
      case .registered: return "REGISTERED"
      case .interaction: return "INTERACTION"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: IncidentType, rhs: IncidentType) -> Bool {
    switch (lhs, rhs) {
      case (.all, .all): return true
      case (.open, .open): return true
      case (.close, .close): return true
      case (.closeregistered, .closeregistered): return true
      case (.registered, .registered): return true
      case (.interaction, .interaction): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [IncidentType] {
    return [
      .all,
      .open,
      .close,
      .closeregistered,
      .registered,
      .interaction,
    ]
  }
}

public enum CLOSE_ACTION_ENUM: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case close
  case closeConfirm
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "close": self = .close
      case "close_confirm": self = .closeConfirm
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .close: return "close"
      case .closeConfirm: return "close_confirm"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: CLOSE_ACTION_ENUM, rhs: CLOSE_ACTION_ENUM) -> Bool {
    switch (lhs, rhs) {
      case (.close, .close): return true
      case (.closeConfirm, .closeConfirm): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [CLOSE_ACTION_ENUM] {
    return [
      .close,
      .closeConfirm,
    ]
  }
}

public enum TPMEDIA_ENUM: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case photo
  case video
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "photo": self = .photo
      case "video": self = .video
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .photo: return "photo"
      case .video: return "video"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: TPMEDIA_ENUM, rhs: TPMEDIA_ENUM) -> Bool {
    switch (lhs, rhs) {
      case (.photo, .photo): return true
      case (.video, .video): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [TPMEDIA_ENUM] {
    return [
      .photo,
      .video,
    ]
  }
}

public final class GetCitizenByIdQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query getCitizenById($id: ID!) {
      getCitizenById(_id: $id) {
        __typename
        dcCitizen
        qtQZelas
        qtOpen
        qtClose
        qtInteraction
        subscribedEvents {
          __typename
          idEvent
          totalQtEarnedEvents
        }
        earningsHistory {
          __typename
          _idIncident
          dcAction
        }
      }
    }
    """

  public let operationName: String = "getCitizenById"

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
        GraphQLField("getCitizenById", arguments: ["_id": GraphQLVariable("id")], type: .nonNull(.object(GetCitizenById.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(getCitizenById: GetCitizenById) {
      self.init(unsafeResultMap: ["__typename": "Query", "getCitizenById": getCitizenById.resultMap])
    }

    /// Lista o cidadao pelo ID.
    public var getCitizenById: GetCitizenById {
      get {
        return GetCitizenById(unsafeResultMap: resultMap["getCitizenById"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "getCitizenById")
      }
    }

    public struct GetCitizenById: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Citizen"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("dcCitizen", type: .nonNull(.scalar(String.self))),
          GraphQLField("qtQZelas", type: .nonNull(.scalar(Int.self))),
          GraphQLField("qtOpen", type: .nonNull(.scalar(Int.self))),
          GraphQLField("qtClose", type: .nonNull(.scalar(Int.self))),
          GraphQLField("qtInteraction", type: .nonNull(.scalar(Int.self))),
          GraphQLField("subscribedEvents", type: .list(.object(SubscribedEvent.selections))),
          GraphQLField("earningsHistory", type: .list(.object(EarningsHistory.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(dcCitizen: String, qtQZelas: Int, qtOpen: Int, qtClose: Int, qtInteraction: Int, subscribedEvents: [SubscribedEvent?]? = nil, earningsHistory: [EarningsHistory?]? = nil) {
        self.init(unsafeResultMap: ["__typename": "Citizen", "dcCitizen": dcCitizen, "qtQZelas": qtQZelas, "qtOpen": qtOpen, "qtClose": qtClose, "qtInteraction": qtInteraction, "subscribedEvents": subscribedEvents.flatMap { (value: [SubscribedEvent?]) -> [ResultMap?] in value.map { (value: SubscribedEvent?) -> ResultMap? in value.flatMap { (value: SubscribedEvent) -> ResultMap in value.resultMap } } }, "earningsHistory": earningsHistory.flatMap { (value: [EarningsHistory?]) -> [ResultMap?] in value.map { (value: EarningsHistory?) -> ResultMap? in value.flatMap { (value: EarningsHistory) -> ResultMap in value.resultMap } } }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var dcCitizen: String {
        get {
          return resultMap["dcCitizen"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "dcCitizen")
        }
      }

      public var qtQZelas: Int {
        get {
          return resultMap["qtQZelas"]! as! Int
        }
        set {
          resultMap.updateValue(newValue, forKey: "qtQZelas")
        }
      }

      public var qtOpen: Int {
        get {
          return resultMap["qtOpen"]! as! Int
        }
        set {
          resultMap.updateValue(newValue, forKey: "qtOpen")
        }
      }

      public var qtClose: Int {
        get {
          return resultMap["qtClose"]! as! Int
        }
        set {
          resultMap.updateValue(newValue, forKey: "qtClose")
        }
      }

      public var qtInteraction: Int {
        get {
          return resultMap["qtInteraction"]! as! Int
        }
        set {
          resultMap.updateValue(newValue, forKey: "qtInteraction")
        }
      }

      public var subscribedEvents: [SubscribedEvent?]? {
        get {
          return (resultMap["subscribedEvents"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [SubscribedEvent?] in value.map { (value: ResultMap?) -> SubscribedEvent? in value.flatMap { (value: ResultMap) -> SubscribedEvent in SubscribedEvent(unsafeResultMap: value) } } }
        }
        set {
          resultMap.updateValue(newValue.flatMap { (value: [SubscribedEvent?]) -> [ResultMap?] in value.map { (value: SubscribedEvent?) -> ResultMap? in value.flatMap { (value: SubscribedEvent) -> ResultMap in value.resultMap } } }, forKey: "subscribedEvents")
        }
      }

      public var earningsHistory: [EarningsHistory?]? {
        get {
          return (resultMap["earningsHistory"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [EarningsHistory?] in value.map { (value: ResultMap?) -> EarningsHistory? in value.flatMap { (value: ResultMap) -> EarningsHistory in EarningsHistory(unsafeResultMap: value) } } }
        }
        set {
          resultMap.updateValue(newValue.flatMap { (value: [EarningsHistory?]) -> [ResultMap?] in value.map { (value: EarningsHistory?) -> ResultMap? in value.flatMap { (value: EarningsHistory) -> ResultMap in value.resultMap } } }, forKey: "earningsHistory")
        }
      }

      public struct SubscribedEvent: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Events"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("idEvent", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("totalQtEarnedEvents", type: .nonNull(.scalar(Int.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(idEvent: GraphQLID, totalQtEarnedEvents: Int) {
          self.init(unsafeResultMap: ["__typename": "Events", "idEvent": idEvent, "totalQtEarnedEvents": totalQtEarnedEvents])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var idEvent: GraphQLID {
          get {
            return resultMap["idEvent"]! as! GraphQLID
          }
          set {
            resultMap.updateValue(newValue, forKey: "idEvent")
          }
        }

        public var totalQtEarnedEvents: Int {
          get {
            return resultMap["totalQtEarnedEvents"]! as! Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "totalQtEarnedEvents")
          }
        }
      }

      public struct EarningsHistory: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Earnings"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("_idIncident", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("dcAction", type: .nonNull(.scalar(String.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(_idIncident: GraphQLID, dcAction: String) {
          self.init(unsafeResultMap: ["__typename": "Earnings", "_idIncident": _idIncident, "dcAction": dcAction])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var _idIncident: GraphQLID {
          get {
            return resultMap["_idIncident"]! as! GraphQLID
          }
          set {
            resultMap.updateValue(newValue, forKey: "_idIncident")
          }
        }

        public var dcAction: String {
          get {
            return resultMap["dcAction"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "dcAction")
          }
        }
      }
    }
  }
}

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

public final class GetIncidentByCitizenDashboardQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query GetIncidentByCitizenDashboard($citizenId: ID!, $tpIncident: IncidentType!) {
      getIncidentsByCitizenId(citizenId: $citizenId, tpIncident: $tpIncident) {
        __typename
        data {
          __typename
          _id
          stIncident
          dtDate
          segments {
            __typename
            dcSegment
          }
          mediaUrls
        }
      }
    }
    """

  public let operationName: String = "GetIncidentByCitizenDashboard"

  public var citizenId: GraphQLID
  public var tpIncident: IncidentType

  public init(citizenId: GraphQLID, tpIncident: IncidentType) {
    self.citizenId = citizenId
    self.tpIncident = tpIncident
  }

  public var variables: GraphQLMap? {
    return ["citizenId": citizenId, "tpIncident": tpIncident]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("getIncidentsByCitizenId", arguments: ["citizenId": GraphQLVariable("citizenId"), "tpIncident": GraphQLVariable("tpIncident")], type: .nonNull(.object(GetIncidentsByCitizenId.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(getIncidentsByCitizenId: GetIncidentsByCitizenId) {
      self.init(unsafeResultMap: ["__typename": "Query", "getIncidentsByCitizenId": getIncidentsByCitizenId.resultMap])
    }

    /// Exibe o Incidente pelo ID do Cidadão (citizenId).
    public var getIncidentsByCitizenId: GetIncidentsByCitizenId {
      get {
        return GetIncidentsByCitizenId(unsafeResultMap: resultMap["getIncidentsByCitizenId"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "getIncidentsByCitizenId")
      }
    }

    public struct GetIncidentsByCitizenId: GraphQLSelectionSet {
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
            GraphQLField("dtDate", type: .scalar(ISODate.self)),
            GraphQLField("segments", type: .nonNull(.list(.nonNull(.object(Segment.selections))))),
            GraphQLField("mediaUrls", type: .list(.nonNull(.scalar(String.self)))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(_id: GraphQLID, stIncident: Int, dtDate: ISODate? = nil, segments: [Segment], mediaUrls: [String]? = nil) {
          self.init(unsafeResultMap: ["__typename": "Incident", "_id": _id, "stIncident": stIncident, "dtDate": dtDate, "segments": segments.map { (value: Segment) -> ResultMap in value.resultMap }, "mediaUrls": mediaUrls])
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

        public var dtDate: ISODate? {
          get {
            return resultMap["dtDate"] as? ISODate
          }
          set {
            resultMap.updateValue(newValue, forKey: "dtDate")
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
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(dcSegment: String) {
            self.init(unsafeResultMap: ["__typename": "Occurrence", "dcSegment": dcSegment])
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
        }
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

public final class LoginCitizenMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation LoginCitizen($email: String!, $password: String!, $deviceId: String!, $devicePlatform: String!, $language: String!, $notificationId: String!) {
      loginCitizen(
        email: $email
        pass: $password
        deviceId: $deviceId
        devicePlatform: $devicePlatform
        language: $language
        notificationId: $notificationId
      ) {
        __typename
        accessToken
        userId
      }
    }
    """

  public let operationName: String = "LoginCitizen"

  public var email: String
  public var password: String
  public var deviceId: String
  public var devicePlatform: String
  public var language: String
  public var notificationId: String

  public init(email: String, password: String, deviceId: String, devicePlatform: String, language: String, notificationId: String) {
    self.email = email
    self.password = password
    self.deviceId = deviceId
    self.devicePlatform = devicePlatform
    self.language = language
    self.notificationId = notificationId
  }

  public var variables: GraphQLMap? {
    return ["email": email, "password": password, "deviceId": deviceId, "devicePlatform": devicePlatform, "language": language, "notificationId": notificationId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("loginCitizen", arguments: ["email": GraphQLVariable("email"), "pass": GraphQLVariable("password"), "deviceId": GraphQLVariable("deviceId"), "devicePlatform": GraphQLVariable("devicePlatform"), "language": GraphQLVariable("language"), "notificationId": GraphQLVariable("notificationId")], type: .nonNull(.object(LoginCitizen.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(loginCitizen: LoginCitizen) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "loginCitizen": loginCitizen.resultMap])
    }

    public var loginCitizen: LoginCitizen {
      get {
        return LoginCitizen(unsafeResultMap: resultMap["loginCitizen"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "loginCitizen")
      }
    }

    public struct LoginCitizen: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Token"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("accessToken", type: .nonNull(.scalar(String.self))),
          GraphQLField("userId", type: .nonNull(.scalar(String.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(accessToken: String, userId: String) {
        self.init(unsafeResultMap: ["__typename": "Token", "accessToken": accessToken, "userId": userId])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// Propriedades que compõem o corpo do Token.
      public var accessToken: String {
        get {
          return resultMap["accessToken"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "accessToken")
        }
      }

      public var userId: String {
        get {
          return resultMap["userId"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "userId")
        }
      }
    }
  }
}

public final class LogoutMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation Logout($citizenId: ID!) {
      logoutCitizen(citizenId: $citizenId)
    }
    """

  public let operationName: String = "Logout"

  public var citizenId: GraphQLID

  public init(citizenId: GraphQLID) {
    self.citizenId = citizenId
  }

  public var variables: GraphQLMap? {
    return ["citizenId": citizenId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("logoutCitizen", arguments: ["citizenId": GraphQLVariable("citizenId")], type: .nonNull(.scalar(Bool.self))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(logoutCitizen: Bool) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "logoutCitizen": logoutCitizen])
    }

    public var logoutCitizen: Bool {
      get {
        return resultMap["logoutCitizen"]! as! Bool
      }
      set {
        resultMap.updateValue(newValue, forKey: "logoutCitizen")
      }
    }
  }
}

public final class SetCloseIncidentMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation SetCloseIncident($incidentId: ID!, $dtClose: ISODate!, $mediaData: [Upload!], $tpAction: CLOSE_ACTION_ENUM!, $tpMedia: TPMEDIA_ENUM!, $citizenId: ID!) {
      closeIncident(
        incidentId: $incidentId
        dtClose: $dtClose
        mediaData: $mediaData
        tpAction: $tpAction
        tpMedia: $tpMedia
        citizenId: $citizenId
      )
    }
    """

  public let operationName: String = "SetCloseIncident"

  public var incidentId: GraphQLID
  public var dtClose: ISODate
  public var mediaData: [Upload]?
  public var tpAction: CLOSE_ACTION_ENUM
  public var tpMedia: TPMEDIA_ENUM
  public var citizenId: GraphQLID

  public init(incidentId: GraphQLID, dtClose: ISODate, mediaData: [Upload]?, tpAction: CLOSE_ACTION_ENUM, tpMedia: TPMEDIA_ENUM, citizenId: GraphQLID) {
    self.incidentId = incidentId
    self.dtClose = dtClose
    self.mediaData = mediaData
    self.tpAction = tpAction
    self.tpMedia = tpMedia
    self.citizenId = citizenId
  }

  public var variables: GraphQLMap? {
    return ["incidentId": incidentId, "dtClose": dtClose, "mediaData": mediaData, "tpAction": tpAction, "tpMedia": tpMedia, "citizenId": citizenId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("closeIncident", arguments: ["incidentId": GraphQLVariable("incidentId"), "dtClose": GraphQLVariable("dtClose"), "mediaData": GraphQLVariable("mediaData"), "tpAction": GraphQLVariable("tpAction"), "tpMedia": GraphQLVariable("tpMedia"), "citizenId": GraphQLVariable("citizenId")], type: .nonNull(.scalar(Bool.self))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(closeIncident: Bool) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "closeIncident": closeIncident])
    }

    public var closeIncident: Bool {
      get {
        return resultMap["closeIncident"]! as! Bool
      }
      set {
        resultMap.updateValue(newValue, forKey: "closeIncident")
      }
    }
  }
}

public final class SetOpenIncidentMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation SetOpenIncident($cdSegment: Int!, $locCoord: Coordinate!, $dcAddress: String!, $dcCity: String!, $dcState: String!, $dcCountry: String!, $dcNeighborhood: String!, $dcZipCode: String!, $occurrencesIds: [ID!]!, $citizenId: ID!, $dtOpen: ISODate!, $txComment: String!, $tpMedia: TPMEDIA_ENUM!, $mediaData: [Upload!]) {
      openIncident(
        cdSegment: $cdSegment
        locationCoordinates: $locCoord
        locationText: {dcAddress: $dcAddress, nrAddress: " ", dcCity: $dcCity, dcState: $dcState, dcCountry: $dcCountry, dcNeighborhood: $dcNeighborhood, dcZipCode: $dcZipCode}
        occurrencesIds: $occurrencesIds
        citizenId: $citizenId
        dtOpen: $dtOpen
        txComment: $txComment
        tpMedia: $tpMedia
        mediaData: $mediaData
      )
    }
    """

  public let operationName: String = "SetOpenIncident"

  public var cdSegment: Int
  public var locCoord: Coordinate
  public var dcAddress: String
  public var dcCity: String
  public var dcState: String
  public var dcCountry: String
  public var dcNeighborhood: String
  public var dcZipCode: String
  public var occurrencesIds: [GraphQLID]
  public var citizenId: GraphQLID
  public var dtOpen: ISODate
  public var txComment: String
  public var tpMedia: TPMEDIA_ENUM
  public var mediaData: [Upload]?

  public init(cdSegment: Int, locCoord: Coordinate, dcAddress: String, dcCity: String, dcState: String, dcCountry: String, dcNeighborhood: String, dcZipCode: String, occurrencesIds: [GraphQLID], citizenId: GraphQLID, dtOpen: ISODate, txComment: String, tpMedia: TPMEDIA_ENUM, mediaData: [Upload]?) {
    self.cdSegment = cdSegment
    self.locCoord = locCoord
    self.dcAddress = dcAddress
    self.dcCity = dcCity
    self.dcState = dcState
    self.dcCountry = dcCountry
    self.dcNeighborhood = dcNeighborhood
    self.dcZipCode = dcZipCode
    self.occurrencesIds = occurrencesIds
    self.citizenId = citizenId
    self.dtOpen = dtOpen
    self.txComment = txComment
    self.tpMedia = tpMedia
    self.mediaData = mediaData
  }

  public var variables: GraphQLMap? {
    return ["cdSegment": cdSegment, "locCoord": locCoord, "dcAddress": dcAddress, "dcCity": dcCity, "dcState": dcState, "dcCountry": dcCountry, "dcNeighborhood": dcNeighborhood, "dcZipCode": dcZipCode, "occurrencesIds": occurrencesIds, "citizenId": citizenId, "dtOpen": dtOpen, "txComment": txComment, "tpMedia": tpMedia, "mediaData": mediaData]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("openIncident", arguments: ["cdSegment": GraphQLVariable("cdSegment"), "locationCoordinates": GraphQLVariable("locCoord"), "locationText": ["dcAddress": GraphQLVariable("dcAddress"), "nrAddress": " ", "dcCity": GraphQLVariable("dcCity"), "dcState": GraphQLVariable("dcState"), "dcCountry": GraphQLVariable("dcCountry"), "dcNeighborhood": GraphQLVariable("dcNeighborhood"), "dcZipCode": GraphQLVariable("dcZipCode")], "occurrencesIds": GraphQLVariable("occurrencesIds"), "citizenId": GraphQLVariable("citizenId"), "dtOpen": GraphQLVariable("dtOpen"), "txComment": GraphQLVariable("txComment"), "tpMedia": GraphQLVariable("tpMedia"), "mediaData": GraphQLVariable("mediaData")], type: .nonNull(.scalar(Bool.self))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(openIncident: Bool) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "openIncident": openIncident])
    }

    public var openIncident: Bool {
      get {
        return resultMap["openIncident"]! as! Bool
      }
      set {
        resultMap.updateValue(newValue, forKey: "openIncident")
      }
    }
  }
}
