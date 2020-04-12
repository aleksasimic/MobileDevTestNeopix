import UIKit
import RxSwift
import RxCocoa

class OrdersListViewController: UIViewController, Storyboarded {
    static var storyboardName = "Orders"
    
    var coordinator: Orderable?
    var viewModelBuilder: OrdersListViewModelBuilder?
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

private extension OrdersListViewController {
    func setup() {
        if let viewModel = createViewModel() {
            bindViewModel(viewModel)
        }
    }
    
    func createViewModel() -> OrdersListViewModel? {
        return viewModelBuilder?(loadTrigger)
    }
    
    func bindViewModel(_ viewModel: OrdersListViewModel) {
        viewModel.distributorLogoUrl
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {
                print("Logo\($0)")
            })
            .disposed(by: bag)
    }
}
