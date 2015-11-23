//
//  KTCSearchResultView.m
//  KidsTC
//
//  Created by 钱烨 on 7/20/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "KTCSearchResultView.h"
#import "ServiceListView.h"
#import "StoreListView.h"
#import "AUISegmentView.h"
#import "KTCSearchResultSortCell.h"
#import "KTCSearchAreaFilterView.h"
#import "KTCSearchSortFilterView.h"


static NSString *const kSortIdentifier = @"kSortIdentifier";
static NSString *const kServiceCellIdentifier = @"kServiceCellIdentifier";
static NSString *const kStoreCellIdentifier = @"kStoreCellIdentifier";

@interface KTCSearchResultView () <ServiceListViewDataSource, ServiceListViewDelegate, StoreListViewDataSource, StoreListViewDelegate, AUISegmentViewDataSource, AUISegmentViewDelegate, KTCSearchAreaFilterViewDelegate, KTCSearchSortFilterViewDelegate, KTCSearchFilterViewDelegate>

//lines height
@property (weak, nonatomic) IBOutlet UIView *line1;
@property (weak, nonatomic) IBOutlet UIView *line2;
@property (weak, nonatomic) IBOutlet UIView *line3;

//header
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
//sort
@property (weak, nonatomic) IBOutlet UIView *sortBGView;
@property (weak, nonatomic) IBOutlet AUISegmentView *sortView;
//filter
@property (nonatomic, assign) CGFloat maxFilterHeight;
@property (weak, nonatomic) IBOutlet UIView *filterBackGround;
@property (weak, nonatomic) IBOutlet UIView *filterBGView;
@property (weak, nonatomic) IBOutlet UIView *tapArea;
@property (nonatomic, strong) KTCSearchFilterView *filterView;
@property (nonatomic, strong) KTCSearchAreaFilterView *areaFilterView;
@property (nonatomic, strong) KTCSearchSortFilterView *sortFilterView;
//list
@property (weak, nonatomic) IBOutlet ServiceListView *serviceTable;
@property (weak, nonatomic) IBOutlet StoreListView *storeTable;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;


@property (nonatomic, strong) UINib *sortNib;
@property (nonatomic, strong) UINib *serviceCellNib;
@property (nonatomic, strong) UINib *storeCellNib;

@property (nonatomic, strong) NSArray *serviceItemModelArray;
@property (nonatomic, strong) NSArray *storeItemModelArray;

@property (nonatomic, copy) NSString *currentAreaName;
@property (nonatomic, copy) NSString *currentSortString;

@property (nonatomic, assign) KTCSearchResultFilterCoordinate areaFilterCoordinate;

@property (nonatomic, assign) KTCSearchResultFilterCoordinate sortFilterCoordinate;

@property (nonatomic, assign) KTCSearchResultFilterCoordinate ageFilterCoordinate;
@property (nonatomic, assign) KTCSearchResultFilterCoordinate categoryFilterCoordinate;

@property (nonatomic, assign) BOOL displayingFilter;



- (IBAction)didClickedBackButton:(id)sender;
- (IBAction)didClickedSearchButton:(id)sender;

- (void)segmentControlDidChangedSelectedIndex:(id)sender;

- (void)showAreaFilterView;

- (void)showSortFilterView;

- (void)showFilterView;

- (void)dismissFilterView;

- (BOOL)hasFiltered;

- (void)resetTapAreaWithFilterHeight:(CGFloat)height;

- (void)setAreaButtonTitle:(NSString *)title;

- (void)setSortButtonTitle:(NSString *)title;

- (void)bringFilterViewToFront:(UIView *)filterView;

- (IBAction)didClickedLocationButton:(id)sender;

@end

@implementation KTCSearchResultView

#pragma mark Initialization


- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    static BOOL bLoad;
    if (!bLoad)
    {
        bLoad = YES;
        KTCSearchResultView *view = [GConfig getObjectFromNibWithView:self];
        [view buildSubviews];
        return view;
    }
    bLoad = NO;
    return self;
}

- (void)buildSubviews {
    //top
    self.topView.backgroundColor = [AUITheme theme].navibarBGColor;
    //lines
    [GConfig resetLineView:self.line1 withLayoutAttribute:NSLayoutAttributeHeight];
    [GConfig resetLineView:self.line2 withLayoutAttribute:NSLayoutAttributeHeight];
    [GConfig resetLineView:self.line3 withLayoutAttribute:NSLayoutAttributeHeight];
    //header
    [self.segmentControl addTarget:self action:@selector(segmentControlDidChangedSelectedIndex:) forControlEvents:UIControlEventValueChanged];
    [self.segmentControl setSelectedSegmentIndex:0];
    _searchType = KTCSearchTypeService;
    
    [self.segmentControl setTintColor:[UIColor whiteColor]];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName,[UIColor whiteColor], NSForegroundColorAttributeName, nil];
    [self.segmentControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObject:[AUITheme theme].buttonBGColor_Normal forKey:NSForegroundColorAttributeName];
    [self.segmentControl setTitleTextAttributes:highlightedAttributes forState:UIControlStateHighlighted];
    //sort
    self.sortView.dataSource = self;
    self.sortView.delegate = self;
    [self.sortView setShowSeparator:YES];
    if (!self.sortNib) {
        self.sortNib = [UINib nibWithNibName:NSStringFromClass([KTCSearchResultSortCell class]) bundle:nil];
        [self.sortView registerNib:self.sortNib forCellReuseIdentifier:kSortIdentifier];
    }
    //filter
    self.maxFilterHeight = SCREEN_HEIGHT - 104 - 100;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissFilterView)];
    [self.tapArea addGestureRecognizer:tap];
    
    self.areaFilterCoordinate = FilterCoordinateMake(-1, -1);
    self.sortFilterCoordinate = FilterCoordinateMake(-1, -1);
    self.ageFilterCoordinate = FilterCoordinateMake(-1, -1);
    self.categoryFilterCoordinate = FilterCoordinateMake(-1, -1);
    //list
    self.serviceTable.dataSource = self;
    self.serviceTable.delegate = self;
    
    self.storeTable.dataSource = self;
    self.storeTable.delegate = self;
    [self.listBG bringSubviewToFront:self.serviceTable];
    
    //bottom
    
}

- (void)setAreaFilterModel:(KTCSearchResultFilterModel *)areaFilterModel {
    _areaFilterModel = areaFilterModel;
    if (_areaFilterModel) {
        if (self.displayingFilter) {
            [self dismissFilterView];
        }
        self.currentAreaName = nil;
        [self.sortView reloadData];
    }
}

- (void)setSortFilterModel:(KTCSearchResultFilterModel *)sortFilterModel {
    _sortFilterModel = sortFilterModel;
    if (_sortFilterModel) {
        if (self.displayingFilter) {
            [self dismissFilterView];
        }
        self.currentSortString = nil;
        [self.sortView reloadData];
    }
}

- (NSUInteger)serviceListPageSize {
    return [self.serviceTable pageSize];
}

- (NSUInteger)storeListPageSize {
    return [self.storeTable pageSize];
}

#pragma mark AUISegmentViewDataSource & AUISegmentViewDelegate

- (NSUInteger)numberOfCellsForSegmentView:(AUISegmentView *)segmentView {
    return 3;
}

- (UITableViewCell *)segmentView:(AUISegmentView *)segmentView cellAtIndex:(NSUInteger)index {
    
    KTCSearchResultSortCell *cell = [segmentView dequeueReusableCellWithIdentifier:kSortIdentifier forIndex:index];
    if (!cell) {
        cell =  [[[NSBundle mainBundle] loadNibNamed:@"KTCSearchResultSortCell" owner:nil options:nil] objectAtIndex:0];
    }
    switch (index) {
        case 0:
        {
            NSString *title = self.areaFilterModel.name;
            if ([self.currentAreaName length] > 0) {
                title = self.currentAreaName;
            }
            [cell.titleLabel setText:title];
        }
            break;
        case 1:
        {
            NSString *title = self.sortFilterModel.name;
            if ([self.currentSortString length] > 0) {
                title = self.currentSortString;
            }
            [cell.titleLabel setText:title];
        }
            break;
        case 2:
        {
            [cell.titleLabel setText:@"筛选"];
            [cell hideDot:![self hasFiltered]];
        }
            break;
        default:
            break;
    }
    return cell;
}

- (void)segmentView:(AUISegmentView *)segmentView didSelectedAtIndex:(NSUInteger)index {
    switch (index) {
        case 0:
        {
            [self showAreaFilterView];
        }
            break;
        case 1:
        {
            [self showSortFilterView];
        }
            break;
        case 2:
        {
            [self showFilterView];
        }
            break;
        default:
            break;
    }
}

#pragma mark KTCSearchAreaFilterViewDelegate

- (void)searchAreaFilterView:(KTCSearchAreaFilterView *)filterView didSelectedAtIndex:(NSUInteger)index {
    _areaFilterCoordinate = FilterCoordinateMake(0, index);
    KTCSearchResultFilterModel *filter = [self.areaFilterModel.subArray objectAtIndex:index];
    [self setAreaButtonTitle:filter.name];
    [self dismissFilterView];
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchResultView:didSelectedFilterWithCoordinate:forAreaOfSearchType:)]) {
        [self.delegate searchResultView:self didSelectedFilterWithCoordinate:self.areaFilterCoordinate forAreaOfSearchType:self.searchType];
    }
}

- (void)searchAreaFilterViewNeedDismiss:(KTCSearchAreaFilterView *)filterView {
    [self dismissFilterView];
}


#pragma mark KTCSearchSortFilterViewDelegate

- (void)searchSortFilterView:(KTCSearchSortFilterView *)filterView didSelectedAtIndex:(NSUInteger)index {
    _sortFilterCoordinate = FilterCoordinateMake(0, index);
    KTCSearchResultFilterModel *model = [self.sortFilterModel.subArray objectAtIndex:index];
    [self setSortButtonTitle:model.name];
    [self dismissFilterView];
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchResultView:didSelectedFilterWithCoordinate:forSortOfSearchType:)]) {
        [self.delegate searchResultView:self didSelectedFilterWithCoordinate:self.sortFilterCoordinate forSortOfSearchType:self.searchType];
    }
}

- (void)searchSortFilterViewNeedDismiss:(KTCSearchSortFilterView *)filterView {
    [self dismissFilterView];
}

#pragma mark KTCSearchFilterViewDelegate

- (void)didClickedConfirmButtonOnSearchFilterView:(KTCSearchFilterView *)filterView {
    self.ageFilterCoordinate = filterView.peopleFilterCoordinate;
    self.categoryFilterCoordinate = filterView.categoryFilterCoordinate;
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchResultView:didConfirmedAgeCoordinate:categoryCoordinate:forSearchType:)]) {
        [self.delegate searchResultView:self didConfirmedAgeCoordinate:self.ageFilterCoordinate categoryCoordinate:self.categoryFilterCoordinate forSearchType:self.searchType];
    }
    [self.sortView reloadData];
    [self dismissFilterView];
}

- (void)filterViewNeedDismiss:(KTCSearchFilterView *)filterView {
    [self dismissFilterView];
}


#pragma mark ServiceListViewDataSource & ServiceListViewDelegate

- (NSArray *)itemModelsForServiceListView:(ServiceListView *)listView {
    return self.serviceItemModelArray;
}

- (void)serviceListView:(ServiceListView *)listView didSelectedItemAtIndex:(NSUInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchResultView:didSelectedServiceAtIndex:)]) {
        [self.delegate searchResultView:self didSelectedServiceAtIndex:index];
    }
}

- (void)serviceListViewDidPulledDownToRefresh:(ServiceListView *)listView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchResultView:needRefreshTableWithSearchType:)]) {
        [self.delegate searchResultView:self needRefreshTableWithSearchType:KTCSearchTypeService];
    }
}

- (void)serviceListViewDidPulledUpToloadMore:(ServiceListView *)listView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchResultView:needLoadMoreWithSearchType:)]) {
        [self.delegate searchResultView:self needLoadMoreWithSearchType:KTCSearchTypeService];
    }
}

#pragma mark StoreListViewDataSource & StoreListViewDelegate

- (NSArray *)itemModelsForStoreListView:(StoreListView *)listView {
    return self.storeItemModelArray;
}

- (void)storeListView:(StoreListView *)listView didSelectedItemAtIndex:(NSUInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchResultView:didSelectedStoreAtIndex:)]) {
        [self.delegate searchResultView:self didSelectedStoreAtIndex:index];
    }
}

- (void)storeListViewDidPulledDownToRefresh:(StoreListView *)listView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchResultView:needRefreshTableWithSearchType:)]) {
        [self.delegate searchResultView:self needRefreshTableWithSearchType:KTCSearchTypeStore];
    }
}

- (void)storeListViewDidPulledUpToloadMore:(StoreListView *)listView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchResultView:needLoadMoreWithSearchType:)]) {
        [self.delegate searchResultView:self needLoadMoreWithSearchType:KTCSearchTypeStore];
    }
}


#pragma mark Private methods

- (IBAction)didClickedBackButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedBackButtonOnSearchResultView:)]) {
        [self.delegate didClickedBackButtonOnSearchResultView:self];
    }
}

- (IBAction)didClickedSearchButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedSearchButtonOnSearchResultView:)]) {
        [self.delegate didClickedSearchButtonOnSearchResultView:self];
    }
}

- (void)segmentControlDidChangedSelectedIndex:(id)sender {
    UISegmentedControl *control = sender;
    _searchType = (KTCSearchType)(control.selectedSegmentIndex + 1);
    switch (self.searchType) {
        case KTCSearchTypeService:
        {
            [self.listBG bringSubviewToFront:self.serviceTable];
        }
            break;
        case KTCSearchTypeStore:
        {
            [self.listBG bringSubviewToFront:self.storeTable];
        }
            break;
        default:
            break;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchResultView:didClickedSegmentControlWithSearchType:)]) {
        [self.delegate searchResultView:self didClickedSegmentControlWithSearchType:self.searchType];
    }
}


- (void)showAreaFilterView {
    if (!self.areaFilterView) {
        self.areaFilterView = [[KTCSearchAreaFilterView alloc] init];
        [self.areaFilterView setFrame:CGRectMake(0, 0, self.filterBGView.frame.size.width, self.filterBGView.frame.size.height)];
        self.areaFilterView.delegate = self;
        [self.filterBGView addSubview:self.areaFilterView];
    }
    [self bringFilterViewToFront:self.areaFilterView];
    [self.areaFilterView setFilterModel:self.areaFilterModel];
    CGFloat areaHeight = [self.areaFilterView showWithSelectedIndex:self.areaFilterCoordinate.level2Index maxHeight:self.maxFilterHeight];
    [self.areaFilterView setFrame:CGRectMake(0, 0, self.filterBGView.frame.size.width, areaHeight)];
    [self resetTapAreaWithFilterHeight:areaHeight];
    self.displayingFilter = YES;
}

- (void)showSortFilterView {
    if (!self.sortFilterView) {
        self.sortFilterView = [[KTCSearchSortFilterView alloc] init];
        [self.sortFilterView setFrame:CGRectMake(0, 0, self.filterBGView.frame.size.width, self.filterBGView.frame.size.height)];
        self.sortFilterView.delegate = self;
        [self.filterBGView addSubview:self.sortFilterView];
    }
    [self bringFilterViewToFront:self.sortFilterView];
    [self.sortFilterView setFilterModel:self.sortFilterModel];
    CGFloat sortHeight = [self.sortFilterView showWithSelectedIndex:self.sortFilterCoordinate.level2Index maxHeight:self.maxFilterHeight];
    [self.sortFilterView setFrame:CGRectMake(0, 0, self.filterBGView.frame.size.width, sortHeight)];
    [self resetTapAreaWithFilterHeight:sortHeight];
    self.displayingFilter = YES;
}

- (void)showFilterView {
    if (!self.filterView) {
        self.filterView = [[KTCSearchFilterView alloc] init];
        [self.filterView setFrame:CGRectMake(0, 0, self.filterBGView.frame.size.width, self.maxFilterHeight)];
        self.filterView.delegate = self;
        [self.filterBGView addSubview:self.filterView];
    }
    [self bringFilterViewToFront:self.filterView];
    [self.filterView setPeopleFilterModel:self.peopleFilterModel];
    [self.filterView setCategoriesFilterModelArray:self.categoriesFilterModelArray];
    [self.filterView showWithPeopleFilterCoordinate:self.ageFilterCoordinate categoryFilterCoordinate:self.categoryFilterCoordinate];
    [self resetTapAreaWithFilterHeight:self.maxFilterHeight];
    self.displayingFilter = YES;
}

- (void)dismissFilterView {
    [self sendSubviewToBack:self.filterBackGround];
    [self.sortView deselectAll];
    self.displayingFilter = NO;
}

- (BOOL)hasFiltered {
    BOOL bfiltered = NO;
    if (self.ageFilterCoordinate.level2Index >= 0 || self.categoryFilterCoordinate.level2Index >= 0) {
        bfiltered = YES;
    }
    return bfiltered;
}

- (void)resetTapAreaWithFilterHeight:(CGFloat)height {
    CGFloat tapHeight = SCREEN_HEIGHT - 104 - height;
    
    NSArray *constraintsArray = [self.tapArea constraints];
    for (NSLayoutConstraint *constraint in constraintsArray) {
        if (constraint.firstAttribute == NSLayoutAttributeHeight) {
            constraint.constant = tapHeight;
            break;
        }
    }
    [self.filterBackGround updateConstraintsIfNeeded];
    [self.filterBackGround layoutIfNeeded];
}

- (void)setAreaButtonTitle:(NSString *)title {
    self.currentAreaName = title;
    [self.sortView reloadData];
}

- (void)setSortButtonTitle:(NSString *)title {
    self.currentSortString = title;
    [self.sortView reloadData];
}


- (void)bringFilterViewToFront:(UIView *)filterView {
    if (filterView == self.areaFilterView) {
        [self.sortFilterView setHidden:YES];
        [self.filterView setHidden:YES];
        
        [self bringSubviewToFront:self.filterBackGround];
        [self.filterBGView bringSubviewToFront:self.areaFilterView];
        [self.areaFilterView setHidden:NO];
    }
    if (filterView == self.sortFilterView) {
        [self.areaFilterView setHidden:YES];
        [self.filterView setHidden:YES];
        
        [self bringSubviewToFront:self.filterBackGround];
        [self.filterBGView bringSubviewToFront:self.sortFilterView];
        [self.sortFilterView setHidden:NO];
    }
    if (filterView == self.filterView) {
        [self.areaFilterView setHidden:YES];
        [self.sortFilterView setHidden:YES];
        
        [self bringSubviewToFront:self.filterBackGround];
        [self.filterBGView bringSubviewToFront:self.filterView];
        [self.filterView setHidden:NO];
    }
}

- (IBAction)didClickedLocationButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedLocateButtonOnSearchResultView:)]) {
        [self.delegate didClickedLocateButtonOnSearchResultView:self];
    }
}


#pragma mark Public methods

- (void)setCurrentSearchType:(KTCSearchType)type {
    _searchType = type;
    switch (type) {
        case KTCSearchTypeService:
        {
            [self.segmentControl setSelectedSegmentIndex:0];
            [self.listBG bringSubviewToFront:self.serviceTable];
        }
            break;
        case KTCSearchTypeStore:
        {
            [self.segmentControl setSelectedSegmentIndex:1];
            [self.listBG bringSubviewToFront:self.storeTable];
        }
            break;
        default:
            break;
    }
}

- (void)reloadDataForSearchType:(KTCSearchType)type {
    if (self.dataSource) {
        switch (type) {
            case KTCSearchTypeService:
            {
                if ([self.dataSource respondsToSelector:@selector(serviceItemModelArrayForSearchResultView:)]) {
                    self.serviceItemModelArray = [self.dataSource serviceItemModelArrayForSearchResultView:self];
                }
                [self.serviceTable reloadData];
            }
                break;
            case KTCSearchTypeStore:
            {
                if ([self.dataSource respondsToSelector:@selector(storeItemModelArrayForSearchResultView:)]) {
                    self.storeItemModelArray = [self.dataSource storeItemModelArrayForSearchResultView:self];
                }
                [self.storeTable reloadData];
            }
                break;
            default:
                break;
        }
    }
}


- (void)startRefreshWithSearchType:(KTCSearchType)type {
    switch (type) {
        case KTCSearchTypeService:
        {
            [self.serviceTable startRefresh];
        }
            break;
        case KTCSearchTypeStore:
        {
            [self.storeTable startRefresh];
        }
            break;
        default:
            break;
    }
}

- (void)endRefreshWithSearchType:(KTCSearchType)type {
    switch (type) {
        case KTCSearchTypeService:
        {
            [self.serviceTable endRefresh];
        }
            break;
        case KTCSearchTypeStore:
        {
            [self.storeTable endRefresh];
        }
            break;
        default:
            break;
    }
}

- (void)endLoadMoreWithSearchType:(KTCSearchType)type {
    switch (type) {
        case KTCSearchTypeService:
        {
            [self.serviceTable endLoadMore];
        }
            break;
        case KTCSearchTypeStore:
        {
            [self.storeTable endLoadMore];
        }
            break;
        default:
            break;
    }
}

- (void)noMoreDataWithSearchType:(KTCSearchType)type {
    switch (type) {
        case KTCSearchTypeService:
        {
            [self.serviceTable noMoreLoad];
        }
            break;
        case KTCSearchTypeStore:
        {
            [self.storeTable noMoreLoad];
        }
            break;
        default:
            break;
    }
}

- (void)hideLoadMoreFooter:(BOOL)hidden forSearchType:(KTCSearchType)type {
    switch (type) {
        case KTCSearchTypeService:
        {
            [self.serviceTable hideLoadMoreFooter:hidden];
        }
            break;
        case KTCSearchTypeStore:
        {
            [self.storeTable hideLoadMoreFooter:hidden];
        }
            break;
        default:
            break;
    }
}

- (void)setLocation:(NSString *)locationString {
    if ([locationString length] == 0) {
        [self.locationButton setImage:[UIImage imageNamed:@"unlocated"] forState:UIControlStateNormal];
        [self.locationButton setTitle:@"还没有定位哦..." forState:UIControlStateNormal];
    } else {
        [self.locationButton setImage:[UIImage imageNamed:@"located"] forState:UIControlStateNormal];
        [self.locationButton setTitle:locationString forState:UIControlStateNormal];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
