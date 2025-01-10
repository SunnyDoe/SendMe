import XCTest
@testable import SendMe
import FirebaseAuth

class LoginViewModelTests: XCTestCase {
    var sut: LoginViewModel!
    
    override func setUp() {
        super.setUp()
        sut = LoginViewModel()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testLoginWithEmptyCredentials() {
        var receivedModel: LoginModel?
        sut.onStateChanged = { model in
            receivedModel = model
        }
        
        sut.login(email: "", password: "")
        
        XCTAssertFalse(receivedModel?.isLoading ?? true)
        XCTAssertEqual(receivedModel?.error, "Please fill in all fields")
    }
    
    func testLoginWithWhitespaceCredentials() {
        var receivedModel: LoginModel?
        sut.onStateChanged = { model in
            receivedModel = model
        }
        
        sut.login(email: "   ", password: "   ")
        
        XCTAssertFalse(receivedModel?.isLoading ?? true)
        XCTAssertEqual(receivedModel?.error, "Please fill in all fields")
    }
    
    func testLoginStartsLoading() {
        var receivedModel: LoginModel?
        sut.onStateChanged = { model in
            receivedModel = model
        }
        
        sut.login(email: "test@example.com", password: "password")
        
        XCTAssertTrue(receivedModel?.isLoading ?? false)
    }
} 
