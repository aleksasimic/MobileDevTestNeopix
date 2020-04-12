import RxSwift
import RxCocoa

public extension UIViewController {
    var loadTrigger: Observable<Void> {
        return rx.sentMessage(#selector(viewWillAppear(_:))).map { _ in }
    }
}
