import Foundation

struct ExpenseItem: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var category: String
    var details: String
    var amount: Double
    var dateAdded: Date = Date()
}
