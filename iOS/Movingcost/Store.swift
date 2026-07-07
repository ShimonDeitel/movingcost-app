import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published var items: [ExpenseItem] = []
    @Published var isPro: Bool = false

    static let freeLimit = 15

    private let fileName = "movingcost_items.json"

    private var fileURL: URL {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir.appendingPathComponent(fileName)
    }

    init() {
        load()
    }

    func load() {
        guard let data = try? Data(contentsOf: fileURL),
              let decoded = try? JSONDecoder().decode([ExpenseItem].self, from: data) else {
            items = [
        ExpenseItem(category: "Truck Rental", details: "U-Haul 20ft", amount: 189.0),
        ExpenseItem(category: "Packing Supplies", details: "Boxes & tape", amount: 64.5),
        ExpenseItem(category: "Movers", details: "Two-man crew, 4hrs", amount: 320.0)
            ]
            save()
            return
        }
        items = decoded
    }

    func save() {
        guard let data = try? JSONEncoder().encode(items) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }

    var canAddMore: Bool {
        isPro || items.count < Store.freeLimit
    }

    @discardableResult
    func add(_ item: ExpenseItem) -> Bool {
        guard canAddMore else { return false }
        items.append(item)
        save()
        return true
    }

    func update(_ item: ExpenseItem) {
        guard let idx = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[idx] = item
        save()
    }

    func delete(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        save()
    }

    func delete(_ item: ExpenseItem) {
        items.removeAll(where: { $0.id == item.id })
        save()
    }
}
