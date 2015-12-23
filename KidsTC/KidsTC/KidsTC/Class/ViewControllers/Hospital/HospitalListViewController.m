//
//  HospitalListViewController.m
//  KidsTC
//
//  Created by 钱烨 on 10/14/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "HospitalListViewController.h"
#import "HospitalListViewModel.h"
#import "KTCMapViewController.h"
#import "KTCSegueMaster.h"
#import "KTCMapService.h"
#import "KTCMapUtil.h"
#import "RouteAnnotation.h"
#import "KTCAnnotationTipWelfareItemView.h"

@interface HospitalListViewController () <HospitalListViewDelegate, BMKMapViewDelegate, KTCAnnotationTipWelfareItemViewDelegate>

@property (weak, nonatomic) IBOutlet HospitalListView *listView;

@property (nonatomic, strong) HospitalListViewModel *viewModel;

@property (nonatomic, strong) BMKMapView *mapView;

@property (nonatomic, assign) BOOL mapOnTop;

- (void)didClickedNavigationRightBar;

- (void)initializeMapView;

- (void)resetAnnotations;

@end

@implementation HospitalListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _navigationTitle = @"医院";
    _pageIdentifier = @"pv_healthcare_rooms";
    // Do any additional setup after loading the view from its nib.
    self.listView.delegate = self;
    
    self.viewModel = [[HospitalListViewModel alloc] initWithView:self.listView];
    [[GAlertLoadingView sharedAlertLoadingView] show];
    [self.viewModel startUpdateDataWithSucceed:^(NSDictionary *data) {
        [[GAlertLoadingView sharedAlertLoadingView] hide];
    } failure:^(NSError *error) {
        [[GAlertLoadingView sharedAlertLoadingView] hide];
    }];
    
    [self setupRightBarButton:@"" target:self action:@selector(didClickedNavigationRightBar) frontImage:@"navigation_locate" andBackImage:@"navigation_locate"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.mapView viewWillAppear];
    self.mapView.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.mapView viewWillDisappear];
}

- (void)dealloc {
    [KTCMapUtil cleanMap:self.mapView];
    if (self.mapView) {
        self.mapView = nil;
    }
}

#pragma mark HospitalListViewDelegate

- (void)didPullUpToLoadMoreForHospitalListView:(HospitalListView *)listView {
    [self.viewModel getMoreHospitals];
}

- (void)hospitalListView:(HospitalListView *)listView didClickedPhoneButtonAtIndex:(NSUInteger)index {
    HospitalListItemModel *model = [[self.viewModel resutlItemModels] objectAtIndex:index];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", model.phoneNumber]]];
}

- (void)hospitalListView:(HospitalListView *)listView didClickedGotoButtonAtIndex:(NSUInteger)index {
    HospitalListItemModel *model = [[self.viewModel resutlItemModels] objectAtIndex:index];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:model.coordinate.latitude longitude:model.coordinate.longitude];
    KTCLocation *destination = [[KTCLocation alloc] initWithLocation:location locationDescription:model.name];
    if (destination) {
        KTCMapViewController *controller = [[KTCMapViewController alloc] initWithMapType:KTCMapTypeStoreGuide destination:destination];
        [controller setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)hospitalListView:(HospitalListView *)listView didClickedNearbyButtonAtIndex:(NSUInteger)index {
    HospitalListItemModel *model = [[self.viewModel resutlItemModels] objectAtIndex:index];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithInteger:0], @"a",
                           [NSNumber numberWithInteger:0], @"c",
                           @"", @"k",
                           [NSNumber numberWithInteger:0], @"s",
                           [NSNumber numberWithInteger:KTCSearchResultStoreSortTypeDistance], @"st",
                           [GToolUtil stringFromCoordinate:model.coordinate], @"mapaddr", nil];
    HomeSegueModel *segueModel = [[HomeSegueModel alloc] initWithDestination:HomeSegueDestinationStoreList paramRawData:param];
    [KTCSegueMaster makeSegueWithModel:segueModel fromController:self];
}

#pragma mark BMKMapViewDelegate

- (void)mapViewDidFinishLoading:(BMKMapView *)mapView {
    //指南针必须在加载完成后设置
    [self.mapView setCompassPosition:CGPointMake(SCREEN_WIDTH - 50, 70)];
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation {
    // 生成重用标示identifier
    NSString *AnnotationViewID = @"AnnotationViewID";
    
    // 检查是否有重用的缓存
    BMKAnnotationView* annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    
    // 缓存没有命中，自己构造一个，一般首次添加annotation代码会运行到此处
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        ((BMKPinAnnotationView*)annotationView).image = [KTCMapUtil poiAnnotationImage];
        // 设置重天上掉下的效果(annotation)
        ((BMKPinAnnotationView*)annotationView).animatesDrop = NO;
    }
    
    // 设置位置
    annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
    // 单击弹出泡泡，弹出泡泡前提annotation必须实现title属性
    annotationView.canShowCallout = YES;
    //泡泡
    NSArray *itemModels = [self.viewModel resutlItemModels];
    NSUInteger index = ((RouteAnnotation *)annotation).tag;
    if ([itemModels count] > index) {
        HospitalListItemModel *item = [itemModels objectAtIndex:index];
        KTCAnnotationTipWelfareItemView *tipView = [[KTCAnnotationTipWelfareItemView alloc] initWithFrame:CGRectMake(0, 0, 200, 120)];
        [tipView setItemModel:[KTCAnnotationTipWelfareItem welfareItemFromHospitalListItemModel:item]];
        annotationView.paopaoView = [[BMKActionPaopaoView alloc] initWithCustomView:tipView];
        // 设置是否可以拖拽
        annotationView.draggable = NO;
        tipView.delegate = self;
    }
    
    return annotationView;
}

#pragma mark KTCAnnotationTipWelfareItemViewDelegate

- (void)didClickedGotoButtonOnAnnotationTipWelfareItemView:(KTCAnnotationTipWelfareItemView *)view {
    KTCAnnotationTipWelfareItem *item = view.itemModel;
    CLLocation *location = [[CLLocation alloc] initWithLatitude:item.coordinate.latitude longitude:item.coordinate.longitude];
    KTCLocation *destination = [[KTCLocation alloc] initWithLocation:location locationDescription:item.name];
    if (destination) {
        KTCMapViewController *controller = [[KTCMapViewController alloc] initWithMapType:KTCMapTypeStoreGuide destination:destination];
        [controller setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)didClickedGoDetailButtonOnAnnotationTipWelfareItemView:(KTCAnnotationTipWelfareItemView *)view {
    KTCAnnotationTipWelfareItem *item = view.itemModel;
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithInteger:0], @"a",
                           [NSNumber numberWithInteger:0], @"c",
                           @"", @"k",
                           [NSNumber numberWithInteger:0], @"s",
                           [NSNumber numberWithInteger:KTCSearchResultStoreSortTypeDistance], @"st",
                           [GToolUtil stringFromCoordinate:item.coordinate], @"mapaddr", nil];
    HomeSegueModel *segueModel = [[HomeSegueModel alloc] initWithDestination:HomeSegueDestinationStoreList paramRawData:param];
    [KTCSegueMaster makeSegueWithModel:segueModel fromController:self];
}

#pragma mark Private methods

- (void)didClickedNavigationRightBar {
    if (!self.mapOnTop) {
        self.mapOnTop = YES;
        [self initializeMapView];
        [self.view bringSubviewToFront:self.mapView];
        [self setRightBarButtonTitle:@"" frontImage:@"navigation_list" andBackImage:@"navigation_list"];
        [self resetAnnotations];
    } else {
        self.mapOnTop = NO;
        [self.view bringSubviewToFront:self.listView];
        [self setRightBarButtonTitle:@"" frontImage:@"navigation_locate" andBackImage:@"navigation_locate"];
    }
}

- (void)initializeMapView {
    if (!self.mapView) {
        self.mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        self.mapView.delegate = self;
        [self.mapView setMapType:BMKMapTypeStandard];
        [self.mapView setShowsUserLocation:YES];
        [self.mapView setShowMapScaleBar:YES];
        [self.mapView setIsSelectedAnnotationViewFront:YES];
        
        [self.mapView setMapScaleBarPosition:CGPointMake(5, SCREEN_HEIGHT - 50)];
        [self.view addSubview:self.mapView];
    }
}

- (void)resetAnnotations {
    [KTCMapUtil cleanMap:self.mapView];
    NSArray *itemModels = [self.viewModel resutlItemModels];
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (NSUInteger index = 0; index < [itemModels count]; index ++) {
        HospitalListItemModel *model = [itemModels objectAtIndex:index];
        if (CLLocationCoordinate2DIsValid(model.coordinate)) {
            RouteAnnotation *annotation = [[RouteAnnotation alloc]init];
            if (CLLocationCoordinate2DIsValid(model.coordinate)) {
                [annotation setCoordinate:model.coordinate];
                annotation.tag = index;
                [self.mapView addAnnotation:annotation];
                [tempArray addObject:[[CLLocation alloc] initWithLatitude:model.coordinate.latitude longitude:model.coordinate.longitude]];
            }
        }
    }
    [KTCMapUtil resetMapView:self.mapView toFitLocations:[NSArray arrayWithArray:tempArray]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
