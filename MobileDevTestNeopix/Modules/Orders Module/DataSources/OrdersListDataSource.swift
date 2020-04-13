import Foundation
import RxSwift

class OrdersListDataSource: NSObject {
    private var data: [Order] = []
    private let tableView: UITableView
    private let bag = DisposeBag()
    
    init(withTableView tableView: UITableView,
         orders: Observable<[Order]>) {
        self.tableView = tableView
        super.init()
        setupTableView()
        setupUpdate(withData: orders)
    }
    
    private func setupUpdate(withData data: Observable<[Order]>) {
        data
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {
                self.reload(withData: $0)
            })
            .disposed(by: bag)
    }
    
    private func setupTableView() {
        self.tableView.dataSource = self
    }
    
    private func reload(withData data: [Order]) {
        self.data = data
        self.reload()
    }
    
    private func reload() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension OrdersListDataSource {
    func getItem(atIndexPath indexPath: IndexPath) -> Order? {
        guard data.count > indexPath.row else { return nil }
        return data[indexPath.row]
    }
}

extension OrdersListDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let order = getItem(atIndexPath: indexPath) else { return UITableViewCell() }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: OrderTableViewCell.identifier, for: indexPath) as! OrderTableViewCell
        cell.setup(withOrder: order)
        
        return cell
    }
}
