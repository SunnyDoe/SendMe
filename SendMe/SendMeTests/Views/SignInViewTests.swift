import XCTest
@testable import SendMe

final class SignInViewTests: XCTestCase {
    var sut: SignInView!
    
    override func setUp() {
        super.setUp()
        sut = SignInView()
        sut.loadViewIfNeeded()
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.1))
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testEmailSignInTappedTriggersNavigation() {
        let expectation = XCTestExpectation(description: "Navigation callback called")
        
        sut.viewModel.onNavigationRequested = { action in
            if action == .emailSignUp {
                expectation.fulfill()
            }
        }
        
        DispatchQueue.main.async {
            self.sut.emailSignInTapped()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testSignInTappedTriggersNavigation() {
        let expectation = XCTestExpectation(description: "Navigation callback called")
        
        sut.viewModel.onNavigationRequested = { action in
            if action == .existingUserSignIn {
                expectation.fulfill()
            }
        }
        
        DispatchQueue.main.async {
            self.sut.signInTapped()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testAppleSignInTappedTriggersNavigation() {
        let expectation = XCTestExpectation(description: "Navigation callback called")
        
        sut.viewModel.onNavigationRequested = { action in
            if action == .appleSignIn {
                expectation.fulfill()
            }
        }
        
        DispatchQueue.main.async {
            self.sut.appleSignInTapped()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
} 
