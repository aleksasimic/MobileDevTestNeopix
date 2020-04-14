import UIKit
import RxSwift
import RxCocoa

class OrdersListViewController: UIViewController, Storyboarded {
    static var storyboardName = "Orders"
    
    var coordinator: Orderable?
    var viewModelBuilder: OrdersListViewModelBuilder?
    
    private let bag = DisposeBag()
    let fetchMoreOrdersTrigger = PublishSubject<Void>()
    
    @IBOutlet weak var ordersTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

private extension OrdersListViewController {
    func setup() {
        if let viewModel = createViewModel() {
            bindViewModel(viewModel)
            setupDataSource(withData: viewModel.orders)
        }
    }
    
    func createViewModel() -> OrdersListViewModel? {
        return viewModelBuilder?(loadTrigger, fetchMoreOrdersTrigger)
    }
    
    func bindViewModel(_ viewModel: OrdersListViewModel) {
        viewModel.distributorLogoUrl
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {
                print("Logo\($0)")
            })
            .disposed(by: bag)
        
        viewModel.orders
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {
                print("priv")
                print($0.count)
            })
            .disposed(by: bag)
        
        viewModel.errors
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: {
            print("priv")
            print($0)
        })
        .disposed(by: bag)
        
//        viewModel.moreOrders
//        .observeOn(MainScheduler.instance)
//        .subscribe(onNext: {
//            print("More")
//            print($0.count)
//        })
//        .disposed(by: bag)
    }
    
    func setupDataSource(withData data: Observable<[Order]>) {
        _ = OrdersListDataSource(withTableView: ordersTableView, orders: data, fetchMoreOrdersTrigger: fetchMoreOrdersTrigger)
    }
}
