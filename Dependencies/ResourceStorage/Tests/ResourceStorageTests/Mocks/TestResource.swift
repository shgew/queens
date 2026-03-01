import Foundation
import ResourceStorage

struct TestResource: Resource {
  let id = "test-resource"
  let defaultValue: [Int: TimeInterval] = [:]
}
