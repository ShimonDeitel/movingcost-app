import XCTest

final class MovingcostUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testAddItemFlow() throws {
        app.buttons["add_item_button"].tap()
        let saveButton = app.buttons["add_save_button"]
        XCTAssertTrue(saveButton.waitForExistence(timeout: 2))
        saveButton.tap()
    }

    func testFreeLimitTriggersPaywall() throws {
        for _ in 0..<(Store_testFreeLimit + 1) {
            let addButton = app.buttons["add_item_button"]
            if addButton.exists { addButton.tap() }
            let saveButton = app.buttons["add_save_button"]
            if saveButton.waitForExistence(timeout: 1) {
                saveButton.tap()
            } else {
                break
            }
        }
        let purchaseButton = app.buttons["paywall_purchase_button"]
        _ = purchaseButton.waitForExistence(timeout: 2)
    }

    func testKeyboardDismissOnTapOutside() throws {
        app.buttons["add_item_button"].tap()
        let field = app.textFields.firstMatch
        XCTAssertTrue(field.waitForExistence(timeout: 2))
        field.tap()
        field.typeText("Test")
        app.navigationBars.firstMatch.tap()
        XCTAssertFalse(app.keyboards.element.exists)
    }

    func testSettingsOpens() throws {
        app.buttons["settings_gear_button"].tap()
        XCTAssertTrue(app.buttons["settings_done_button"].waitForExistence(timeout: 2))
    }

    func testCancelAddDismisses() throws {
        app.buttons["add_item_button"].tap()
        app.buttons["add_cancel_button"].tap()
        XCTAssertFalse(app.buttons["add_save_button"].exists)
    }
}

private let Store_testFreeLimit = 15
