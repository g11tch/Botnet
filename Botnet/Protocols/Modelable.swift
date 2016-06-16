import Firebase
import Argo

protocol Modelable: Decodable, Encodable, Equatable {
  static var refName: String { get }
  static var ref: FIRDatabaseReference { get }
  static func getChildRef(id: String) -> FIRDatabaseReference

  /// The key stored in Firebase. This is also used to tell if an object is persisted or not by 
  /// it being empty.
  var id: String { get }
  var childRef: FIRDatabaseReference { get }
  var isPersisted: Bool { get }
}

extension Modelable {
  static var refName: String {
    return "\(self)s"
  }

  static var ref: FIRDatabaseReference {
    return FIRDatabase.database().reference().child(refName)
  }

  static func getChildRef(id: String) -> FIRDatabaseReference {
    return ref.child(id)
  }

  var childRef: FIRDatabaseReference {
    if isPersisted {
      return Self.ref.child(id)
    } else {
      return Self.ref.childByAutoId()
    }
  }

  var isPersisted: Bool {
    return id != ""
  }
}

func == <Model: Modelable>(lhs: Model, rhs: Model) -> Bool {
  return lhs.id == rhs.id
}
