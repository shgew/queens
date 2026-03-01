import ResourceStorage
import Testing

struct CacheTests {
  let cache = Cache()

  @Test func `returns nil for missing key`() async {
    let value: Int? = await cache.value(forKey: "missing")
    #expect(value == nil)
  }

  @Test func `stores and retrieves value`() async {
    await cache.setValue(42, forKey: "answer")
    let value: Int? = await cache.value(forKey: "answer")
    #expect(value == 42)
  }

  @Test func `overwrites existing value`() async {
    await cache.setValue(1, forKey: "key")
    await cache.setValue(2, forKey: "key")
    let value: Int? = await cache.value(forKey: "key")
    #expect(value == 2)
  }

  @Test func `returns nil for wrong type`() async {
    await cache.setValue(42, forKey: "key")
    let value: String? = await cache.value(forKey: "key")
    #expect(value == nil)
  }
}
