import RxSwift

typealias VenueInfoViewModelBuilder = () -> VenueInfoViewModel

struct VenueInfoViewModel {
    let primaryContactName: Observable<String>
    let primaryContactPhone: Observable<String>
    let secondaryContactName: Observable<String>
    let secondaryContactPhone: Observable<String>
    let address: Observable<String>
    
    init(venue: Observable<Venue>) {
        primaryContactName = venue
            .map {
                $0.primaryContactName ?? ""
            }
        
        primaryContactPhone = venue
            .map {
                $0.primaryContactPhone ?? ""
            }
        
        secondaryContactName = venue
            .map {
                $0.secondaryContactName ?? ""
            }
        
        secondaryContactPhone = venue
            .map {
                $0.secondaryContactPhone ?? ""
            }
        
        address = venue
            .map {
                $0.address ?? ""
            }
    }
}
