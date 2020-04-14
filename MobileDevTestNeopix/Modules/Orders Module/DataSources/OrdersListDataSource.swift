import Foundation
import RxSwift

class OrdersListDataSource: NSObject {
    private var data: [OrdersSection] = []
    private let tableView: UITableView
    private let bag = DisposeBag()
    private let fetchMoreOrdersSubject: PublishSubject<Void>
    
    init(withTableView tableView: UITableView,
         orders: Observable<[OrdersSection]>,
         fetchMoreOrdersTrigger: PublishSubject<Void>) {
        self.tableView = tableView
        self.fetchMoreOrdersSubject = fetchMoreOrdersTrigger
        super.init()
        setupTableView()
        setupUpdate(withData: orders)
    }
    
    private func setupUpdate(withData data: Observable<[OrdersSection]>) {
        data
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {
                self.reload(withData: $0)
            })
            .disposed(by: bag)
    }
    
    private func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        let nib = UINib(nibName: "OrderTableViewHeader", bundle: nil)
        self.tableView.register(nib, forHeaderFooterViewReuseIdentifier: "customSectionHeader")
    }
    
    private func reload(withData data: [OrdersSection]) {
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
        guard data[indexPath.section].orders.count > indexPath.row else { return nil }
        return data[indexPath.section].orders[indexPath.row]
    }
}

extension OrdersListDataSource: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data[section].orders.count
    }
    
   func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: "customSectionHeader") as! OrderTableViewHeader
        header.monthAndYearLabel.text = data[section].monthAndYearData.monthAndYearString
        
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let order = getItem(atIndexPath: indexPath) else { return UITableViewCell() }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: OrderTableViewCell.identifier, for: indexPath) as! OrderTableViewCell
        cell.setup(withOrder: order)
        
        if indexPath.section == data.count - 1 && indexPath.row == data[indexPath.section].orders.count - 1 {
            self.fetchMoreOrdersSubject.onNext(())
        }
        
        return cell
    }
}

extension OrdersListDataSource: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let sectionHeaderHeight: CGFloat = 32
        if scrollView.contentOffset.y <= sectionHeaderHeight &&
           scrollView.contentOffset.y >= 0 {
            scrollView.contentInset = UIEdgeInsets(top: -scrollView.contentOffset.y, left: 0, bottom: 0, right: 0)
        } else if scrollView.contentOffset.y >= sectionHeaderHeight {
            scrollView.contentInset = UIEdgeInsets(top: -sectionHeaderHeight, left: 0, bottom: 0, right: 0)
        }
    }
}
