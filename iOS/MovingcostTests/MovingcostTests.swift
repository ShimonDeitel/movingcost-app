import XCTest
@testable import Movingcost

final class MovingcostTests: XCTestCase {
    @MainActor
    func makeEmptyStore() -> Store {
        let store = Store()
        store.items = []
        return store
    }

    @MainActor
    func testAddIncreasesCount() {
        let store = makeEmptyStore()
        let item = ExpenseItem(category: "Test", details: "Test", amount: 1.0)
        _ = store.add(item)
        XCTAssertEqual(store.items.count, 1)
    }

    @MainActor
    func testFreeLimitBlocksAdd() {
        let store = makeEmptyStore()
        for _ in 0..<Store.freeLimit {
            _ = store.add(ExpenseItem(category: "Test", details: "Test", amount: 1.0))
        }
        let result = store.add(ExpenseItem(category: "Test", details: "Test", amount: 1.0))
        XCTAssertFalse(result)
        XCTAssertEqual(store.items.count, Store.freeLimit)
    }

    @MainActor
    func testProBypassesFreeLimit() {
        let store = makeEmptyStore()
        store.isPro = true
        for _ in 0..<(Store.freeLimit + 5) {
            _ = store.add(ExpenseItem(category: "Test", details: "Test", amount: 1.0))
        }
        XCTAssertEqual(store.items.count, Store.freeLimit + 5)
    }

    @MainActor
    func testDeleteRemovesItem() {
        let store = makeEmptyStore()
        let item = ExpenseItem(category: "Test", details: "Test", amount: 1.0)
        _ = store.add(item)
        store.delete(item)
        XCTAssertTrue(store.items.isEmpty)
    }

    @MainActor
    func testDeleteAtOffsets() {
        let store = makeEmptyStore()
        _ = store.add(ExpenseItem(category: "Test", details: "Test", amount: 1.0))
        _ = store.add(ExpenseItem(category: "Test", details: "Test", amount: 1.0))
        store.delete(at: IndexSet(integer: 0))
        XCTAssertEqual(store.items.count, 1)
    }

    @MainActor
    func testUpdateModifiesItem() {
        let store = makeEmptyStore()
        let item = ExpenseItem(category: "Test", details: "Test", amount: 1.0)
        _ = store.add(item)
        var updated = item
        updated.category = "Updated"
        store.update(updated)
        XCTAssertEqual(store.items.first?.category, "Updated")
    }

    @MainActor
    func testCanAddMoreTrueWhenUnderLimit() {
        let store = makeEmptyStore()
        XCTAssertTrue(store.canAddMore)
    }
}
