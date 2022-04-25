class NftCollectionsMultiSortHeaderViewModel {
    private let service: MarketNftTopCollectionsService
    private let decorator: MarketListNftCollectionDecorator

    init(service: MarketNftTopCollectionsService, decorator: MarketListNftCollectionDecorator) {
        self.service = service
        self.decorator = decorator
    }

}

extension NftCollectionsMultiSortHeaderViewModel: IMarketMultiSortHeaderViewModel {

    var sortItems: [String] {
        MarketNftTopCollectionsModule.SortType.allCases.map { $0.title }
    }
    var sortIndex: Int {
        MarketNftTopCollectionsModule.SortType.allCases.firstIndex(of: service.sortType) ?? 0
    }

    var leftSelectorItems: [String] {
        []
    }
    var leftSelectorIndex: Int {
        0
    }

    var rightSelectorItems: [String] {
        MarketNftTopCollectionsModule.VolumeRange.allCases.map { $0.title }
    }
    var rightSelectorIndex: Int {
        MarketNftTopCollectionsModule.VolumeRange.allCases.firstIndex(of: service.volumeRange) ?? 0
    }

    func onSelectSort(index: Int) {
        service.sortType = MarketNftTopCollectionsModule.SortType.allCases[index]
    }

    func onSelectLeft(index: Int) {
    }

    func onSelectRight(index: Int) {
        let volumeRange = MarketNftTopCollectionsModule.VolumeRange.allCases[index]

        decorator.volumeRange = volumeRange
        service.volumeRange = volumeRange
    }

}
