import Foundation
import RxSwift
import UIKit

class OrdersListDataSource: NSObject {
    var selected: Observable<Int>!
    private var data: [OrdersSection] = []
    private let tableView: UITableView
    private let bag = DisposeBag()
    private let fetchMoreOrdersSubject: PublishSubject<Void>
    private let headerViewPositionUpdateSubject: PublishSubject<(CGFloat, Bool)>
    
    private var lastContentOffset: CGFloat
    
    init(withTableView tableView: UITableView,
         orders: Observable<[OrdersSection]>,
         fetchMoreOrdersTrigger: PublishSubject<Void>,
         headerViewPositionUpdateTrigger: PublishSubject<(CGFloat, Bool)>) {
        self.tableView = tableView
        self.fetchMoreOrdersSubject = fetchMoreOrdersTrigger
        self.headerViewPositionUpdateSubject = headerViewPositionUpdateTrigger
        self.lastContentOffset = 0
        super.init()
        setupTableView()
        setupUpdate(withData: orders)
        bindSelection()
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
        let nib = UINib(nibName: "OrderTableViewSectionHeader", bundle: nil)
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
    
    private func bindSelection() {
        selected = tableView.rx.itemSelected.asObservable()
            .do(onNext: { indexPath in
                self.tableView.deselectRow(at: indexPath, animated: true)
            })
            .map { [weak self] in
                self?.getItem(atIndexPath: $0)
        }
        .filter {
            $0 != nil
        }
        .map {
            $0!.id
        }
        .share(replay: 1, scope: .whileConnected)
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
        let header = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: "customSectionHeader") as! OrderTableViewSectionHeader
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
        
        if self.lastContentOffset < scrollView.contentOffset.y {
            headerViewPositionUpdateSubject.onNext((scrollView.contentOffset.y - self.lastContentOffset, true))
        } else if self.lastContentOffset > scrollView.contentOffset.y {
            headerViewPositionUpdateSubject.onNext((self.lastContentOffset-scrollView.contentOffset.y, false))
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.lastContentOffset = scrollView.contentOffset.y
    }
}
