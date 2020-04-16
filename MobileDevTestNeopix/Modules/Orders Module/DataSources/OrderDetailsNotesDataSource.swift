import RxSwift

class OrderDetailsNotesDataSource: NSObject, UITableViewDataSource {
    private var data: [Note] = []
    private let tableView: UITableView
    private let bag = DisposeBag()
    
    private var distributorLogoUrl: String?
    private var distributorName: String?
    
    init(withTableView tableView: UITableView,
         notes: Observable<[Note]>,
         distributorLogoUrl: Observable<String>,
         distributorName: Observable<String>) {
        self.tableView = tableView
        super.init()
        setupTableView()
        setupUpdate(withData: notes, distributorLogoData: distributorLogoUrl, distributorNameData: distributorName)
    }
    
    private func setupUpdate(withData data: Observable<[Note]>,
                             distributorLogoData: Observable<String>,
                             distributorNameData: Observable<String>) {
        data
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {
                self.reload(withData: $0)
            })
            .disposed(by: bag)
        
        distributorLogoData
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.distributorLogoUrl = $0
            })
            .disposed(by: bag)
        
        distributorNameData
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.distributorName = $0
            })
            .disposed(by: bag)
    }
    
    private func setupTableView() {
        self.tableView.dataSource = self
    }
    
    private func reload(withData data: [Note]) {
        self.data = data
        self.reload()
    }
    
    private func reload() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension OrderDetailsNotesDataSource {
    func getItem(atIndexPath indexPath: IndexPath) -> Note? {
        guard data.count > indexPath.row else { return nil }
        return data[indexPath.row]
    }
}

extension OrderDetailsNotesDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let note = getItem(atIndexPath: indexPath) else { return UITableViewCell() }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.identifier, for: indexPath) as! NoteTableViewCell
        
        cell.setup(withNote: note, distributorName: distributorName ?? "", distributorImageUrl: distributorLogoUrl ?? "")
        
        return cell
    }
}

