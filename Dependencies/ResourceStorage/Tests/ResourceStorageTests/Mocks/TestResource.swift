import Foundation
import ResourceStorage

struct TestResource: StorageResource {
  let id = "test-resource"
  let defaultValue: [Int: TimeInterval] = [:]
}
