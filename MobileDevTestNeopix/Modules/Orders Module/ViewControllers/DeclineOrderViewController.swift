import UIKit
import RxSwift
import RxCocoa

class DeclineOrderViewController: UIViewController, Storyboarded {
    static var storyboardName = "Orders"
    
    var coordintor: Orderable?
    
    private let bag = DisposeBag()
    
    @IBOutlet weak var declineOrderButton: UIButton!
    @IBOutlet weak var cancelOrderButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

private extension DeclineOrderViewController {
    func setup() {
        setupUI()
        bindActions()
    }
    
    func bindActions() {
        declineOrderButton.rx.tap.asObservable()
            .subscribe(onNext: { [weak self] in
                self?.coordintor?.declineOrder()
            })
            .disposed(by: bag)
        
        cancelOrderButton.rx.tap.asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.coordintor?.cancelDeclineOrder()
            })
            .disposed(by: bag)
    }
}

private extension DeclineOrderViewController {
    func setupUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        declineOrderButton.setTitle(String.Decline, for: .normal)
        cancelOrderButton.setTitle(String.Cancel, for: .normal)
    }
}

private extension String {
    static let Decline = "Decline Order"
    static let Cancel  = "Cancel"
}
