import XCTest
@testable import SendMe

final class SignInViewModelTests: XCTestCase {
    private var sut: SignInViewModel! 
    
    override func setUp() {
        super.setUp()
        sut = SignInViewModel()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testNavigateToEmailSignUp() {
        var receivedAction: SignInViewModel.NavigationAction?
        sut.onNavigationRequested = { action in
            receivedAction = action
        }
        
        sut.navigateToEmailSignUp()
        
        XCTAssertEqual(receivedAction, .emailSignUp)
    }
    
    func testHandleAppleSignIn() {
        var receivedAction: SignInViewModel.NavigationAction?
        sut.onNavigationRequested = { action in
            receivedAction = action
        }
        
        sut.handleAppleSignIn()
        
        XCTAssertEqual(receivedAction, .appleSignIn)
    }
    
    func testHandleExistingUserSignIn() {
        var receivedAction: SignInViewModel.NavigationAction?
        sut.onNavigationRequested = { action in
            receivedAction = action
        }
        
        sut.handleExistingUserSignIn()
        
        XCTAssertEqual(receivedAction, .existingUserSignIn)
    }
} 
