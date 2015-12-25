//
//  KTCMapViewController.m
//  KidsTC
//
//  Created by 钱烨 on 8/27/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "KTCMapViewController.h"
#import "KTCAnnotationTipConfirmLocationView.h"
#import "KTCAnnotationTipDestinationView.h"
#import "KTCMapService.h"
#import "AUIPickerView.h"
#import "RouteAnnotation.h"
#import "KTCMapUtil.h"

@interface KTCMapViewController () <BMKMapViewDelegate, UITextFieldDelegate, KTCAnnotationTipConfirmViewDelegate, KTCAnnotationTipDestinationViewDelegate, AUIPickerViewDataSource, AUIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (strong, nonatomic) IBOutlet BMKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *routeTypeButton;

@property (nonatomic, strong) AUIPickerView *pickerView;

@property (nonatomic, strong) BMKPointAnnotation* startAnnotation;

@property (nonatomic, strong) BMKPointAnnotation* destinationAnnotation;

@property (nonatomic, assign) KTCMapType type;

@property (nonatomic, strong) KTCLocation *startLocation;

@property (nonatomic, strong) KTCLocation *destLocation;

@property (nonatomic, strong) NSArray *pickerDataArray;

- (void)initializeMapView;

- (void)initOtherSubviews;

- (void)showBottomViewWithRouteLines:(NSArray *)routeLines;

- (IBAction)didClickedBackButton:(id)sender;
- (IBAction)didClickedRouteTypeButton:(id)sender;

- (void)setStartAnnotationCoordinate:(CLLocationCoordinate2D)coordinate;

- (void)setDestinationAnnotationCoordinate:(CLLocationCoordinate2D)coordinate;

- (void)startSearchWithAddress:(NSString *)address;

- (void)startSearchWithCoordinate:(CLLocationCoordinate2D)coordinate;

- (void)fullFillPickerViewWithReverseGeoCodeSearchResult:(BMKReverseGeoCodeResult *)result;

- (void)selectRouteSearchType;

- (void)resetRouteTypeButtonWithType:(KTCRouteSearchType)type;

- (void)startRouteSearchWithType:(KTCRouteSearchType)type;

- (NSDictionary *)drawRouteLineDetailWithSearchResult:(id)result;

@end

@implementation KTCMapViewController

- (instancetype)initWithMapType:(KTCMapType)type destination:(KTCLocation *)destination {
    self = [super initWithNibName:@"KTCMapViewController" bundle:nil];
    if (self) {
        self.type = type;
        if (type == KTCMapTypeStoreGuide) {
            self.destLocation = destination;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _pageIdentifier = @"pv_map";
    // Do any additional setup after loading the view from its nib.
    [self initializeMapView];
    [self initOtherSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.mapView viewWillAppear];
    self.mapView.delegate = self;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.mapView viewWillDisappear];
//    self.mapView.delegate = nil;
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)dealloc {
    [KTCMapUtil cleanMap:self.mapView];
    if (self.mapView) {
        self.mapView = nil;
    }
}

#pragma mark - BMKMapViewDelegate

- (void)mapViewDidFinishLoading:(BMKMapView *)mapView {
    //指南针必须在加载完成后设置
    [self.mapView setCompassPosition:CGPointMake(SCREEN_WIDTH - 50, 70)];
    if (self.type == KTCMapTypeLocate) {
        [self setStartAnnotationCoordinate:[GConfig sharedConfig].currentLocation.location.coordinate];
        [self.mapView setZoomLevel:18];
    } else {
        [self setStartAnnotationCoordinate:[GConfig sharedConfig].currentLocation.location.coordinate];
        if (self.destLocation) {
            [self setDestinationAnnotationCoordinate:self.destLocation.location.coordinate];
        }
        [KTCMapUtil resetMapView:self.mapView toFitStart:self.startLocation.location.coordinate andDestination:self.destLocation.location.coordinate];
    }
}

- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate {
    [self.view endEditing:YES];
}

- (void)mapview:(BMKMapView *)mapView onLongClick:(CLLocationCoordinate2D)coordinate {
    if ([self.routeTypeButton isHidden]) {
        [self setStartAnnotationCoordinate:coordinate];
    } else {
        [self.routeTypeButton setHidden:YES];
        [KTCMapUtil cleanMap:self.mapView];
        [self setStartAnnotationCoordinate:coordinate];
        [self setDestinationAnnotationCoordinate:self.destLocation.location.coordinate];
    }
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation {
    // 生成重用标示identifier
    NSString *AnnotationViewID = @"AnnotationViewID";
    
    // 检查是否有重用的缓存
    BMKAnnotationView* annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    
    // 缓存没有命中，自己构造一个，一般首次添加annotation代码会运行到此处
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        if (annotation == self.startAnnotation) {
            ((BMKPinAnnotationView*)annotationView).image = [KTCMapUtil startAnnotationImage];
        } else {
            ((BMKPinAnnotationView*)annotationView).image = [KTCMapUtil endAnnotationImage];
        }
        // 设置重天上掉下的效果(annotation)
        ((BMKPinAnnotationView*)annotationView).animatesDrop = NO;
    }
    
    // 设置位置
    annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
    // 单击弹出泡泡，弹出泡泡前提annotation必须实现title属性
    annotationView.canShowCallout = YES;
    //泡泡
    if (annotation == self.startAnnotation) {
        KTCAnnotationTipConfirmLocationView *tipView = [[KTCAnnotationTipConfirmLocationView alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
        if (self.type == KTCMapTypeStoreGuide) {
            [tipView.tipLabel setText:@"从这里去店"];
        } else {
            [tipView.tipLabel setText:@"这里是我的位置"];
        }
        tipView.annotation = annotation;
        tipView.delegate = self;
        annotationView.paopaoView = [[BMKActionPaopaoView alloc] initWithCustomView:tipView];
        // 设置是否可以拖拽
        annotationView.draggable = YES;
    } else {
        KTCAnnotationTipDestinationView *tipView = [[KTCAnnotationTipDestinationView alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        [tipView setContentText:self.destLocation.locationDescription];
        annotationView.paopaoView = [[BMKActionPaopaoView alloc] initWithCustomView:tipView];
        // 设置是否可以拖拽
        annotationView.draggable = NO;
        tipView.delegate = self;
    }
    if ([annotation isKindOfClass:[RouteAnnotation class]]) {
        return [RouteAnnotation routeAnnotationView:mapView viewForAnnotation:(RouteAnnotation*)annotation];
    }
    
    return annotationView;
}

- (BMKOverlayView*)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay {
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor alloc] initWithRed:0 green:1 blue:1 alpha:1];
        polylineView.strokeColor = [[KTCThemeManager manager] currentTheme].highlightTextColor;
        polylineView.lineWidth = 5.0;
        return polylineView;
    }
    return nil;
}

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
//    [mapView bringSubviewToFront:view];
//    [mapView setNeedsDisplay];
}

- (void)mapView:(BMKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    if ([self.routeTypeButton isHidden]) {
        for (BMKAnnotationView *view in views) {
            [self.mapView selectAnnotation:view.annotation animated:YES];
        }
    }
}

#pragma mark KTCAnnotationTipConfirmViewDelegate

- (void)didClickedCancelButtonOnAnnotationTipConfirmView:(KTCAnnotationTipConfirmLocationView *)view {
    [self.mapView deselectAnnotation:view.annotation animated:YES];
}

- (void)didClickedConfirmButtonOnAnnotationTipConfirmView:(KTCAnnotationTipConfirmLocationView *)view {
    [self.mapView deselectAnnotation:view.annotation animated:YES];
    if (self.type == KTCMapTypeLocate) {
        [self startSearchWithCoordinate:view.annotation.coordinate];
    } else {
    }
}

#pragma mark KTCAnnotationTipDestinationViewDelegate

- (void)didClickedConfirmButtonOnAnnotationTipDestinationView:(KTCAnnotationTipDestinationView *)view {
    [self selectRouteSearchType];
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self startSearchWithAddress:textField.text];
    [self.view endEditing:YES];
    return NO;
}

#pragma mark AUIPickerViewDataSource & AUIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(AUIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(AUIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.pickerDataArray count];
}

- (UIView *)pickerView:(AUIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        //adjustsFontSizeToFitWidth property to YES
        pickerLabel.minimumScaleFactor = 0.5;
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
    }
    // Fill the label text here
    pickerLabel.text = [self.pickerDataArray objectAtIndex:row];
    return pickerLabel;
}

- (void)didCanceledPickerView:(AUIPickerView *)pickerView {
    self.pickerDataArray = nil;
}

- (void)pickerView:(AUIPickerView *)pickerView didConfirmedWithSelectedIndexArrayOfAllComponent:(NSArray *)indexArray {
    NSString *pickedString = [self.pickerDataArray objectAtIndex:[[indexArray firstObject] integerValue]];
    if (self.type == KTCMapTypeLocate) {
        //如果地图用于定位，则给全局变量赋值完以后pop
        [self.startLocation setLocationDescription:pickedString];
        [[KTCMapService sharedService] stopUpdateLocation];
        [[GConfig sharedConfig] setCurrentLocation:[self.startLocation copy]];
        [self goBackController:nil];
    }
}

#pragma mark Private methods

- (void)initializeMapView {
    [self.mapView setMapType:BMKMapTypeStandard];
    [self.mapView setShowsUserLocation:YES];
    [self.mapView setShowMapScaleBar:YES];
    [self.mapView setIsSelectedAnnotationViewFront:YES];
    
    [self.mapView setMapScaleBarPosition:CGPointMake(5, SCREEN_HEIGHT - 50)];
    
    if (self.type == KTCMapTypeLocate) {
        [self.mapView setCenterCoordinate:[[GConfig sharedConfig] currentLocation].location.coordinate];
    } else {
        if (self.destLocation) {
            [self.mapView setCenterCoordinate:self.destLocation.location.coordinate];
        }
    }
}

- (void)initOtherSubviews {
    [self.view bringSubviewToFront:self.topView];
    
    [self.backButton setAlpha:0.7];
    
    self.searchField.delegate = self;
    if (self.type == KTCMapTypeStoreGuide) {
        [self.searchField setPlaceholder:@"请搜索或长按地图选择起始点"];
    }
    [self.searchField setBackgroundColor:[[[KTCThemeManager manager] currentTheme].globalThemeColor colorWithAlphaComponent:0.5]];
    [self.searchField setLeftView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)]];
    [self.searchField setRightView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)]];
    [self.searchField setLeftViewMode:UITextFieldViewModeAlways];
    [self.searchField setRightViewMode:UITextFieldViewModeAlways];
    
    self.pickerView = [[AUIPickerView alloc] initWithDataSource:self delegate:self];
    
    [self.routeTypeButton setBackgroundColor:[[KTCThemeManager manager] currentTheme].globalThemeColor forState:UIControlStateNormal];
    self.routeTypeButton.layer.cornerRadius = 20;
    self.routeTypeButton.layer.masksToBounds = YES;
}

- (void)showBottomViewWithRouteLines:(NSArray *)routeLines {
    
}

- (IBAction)didClickedBackButton:(id)sender {
    [self goBackController:nil];
}

- (IBAction)didClickedRouteTypeButton:(id)sender {
    [self selectRouteSearchType];
}

- (void)setStartAnnotationCoordinate:(CLLocationCoordinate2D)coordinate {
    if (!self.startAnnotation) {
        self.startAnnotation = [[BMKPointAnnotation alloc]init];
    }
    NSArray *annos = [self.mapView annotations];
    if ([annos indexOfObject:self.startAnnotation] == NSNotFound) {
        [self.mapView addAnnotation:self.startAnnotation];
    }
    if (CLLocationCoordinate2DIsValid(coordinate)) {
        [self.startAnnotation setCoordinate:coordinate];
        self.startLocation = [[KTCLocation alloc] initWithLocation:[[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude] locationDescription:nil];
    }
}

- (void)setDestinationAnnotationCoordinate:(CLLocationCoordinate2D)coordinate {
    if (!self.destinationAnnotation) {
        self.destinationAnnotation = [[BMKPointAnnotation alloc]init];
    }
    NSArray *annos = [self.mapView annotations];
    if ([annos indexOfObject:self.destinationAnnotation] == NSNotFound) {
        [self.mapView addAnnotation:self.destinationAnnotation];
    }
    if (CLLocationCoordinate2DIsValid(coordinate)) {
        [self.destinationAnnotation setCoordinate:coordinate];
    }
}

- (void)startSearchWithAddress:(NSString *)address {
    NSString *searchText = [address stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([searchText length] > 0) {
        [[GAlertLoadingView sharedAlertLoadingView] show];
        __weak KTCMapViewController *weakSelf = self;
        [[KTCMapService sharedService] getCoordinateWithCity:@"上海" address:address succeed:^(BMKGeoCodeResult *result) {
            [weakSelf setStartAnnotationCoordinate:result.location];
            [[GAlertLoadingView sharedAlertLoadingView] hide];
        } failure:^(NSError *error) {
            [[iToast makeText:@"查询失败"] show];
            [[GAlertLoadingView sharedAlertLoadingView] hide];
        }];
    }
}

- (void)startSearchWithCoordinate:(CLLocationCoordinate2D)coordinate {
    if (CLLocationCoordinate2DIsValid(coordinate)) {
        [[GAlertLoadingView sharedAlertLoadingView] show];
        __weak KTCMapViewController *weakSelf = self;
        [[KTCMapService sharedService] getAddressDescriptionWithCoordinate:coordinate succeed:^(BMKReverseGeoCodeResult *result) {
            [weakSelf fullFillPickerViewWithReverseGeoCodeSearchResult:result];
            [[GAlertLoadingView sharedAlertLoadingView] hide];
        } failure:^(NSError *error) {
            [[GAlertLoadingView sharedAlertLoadingView] hide];
        }];
    }
}

- (void)fullFillPickerViewWithReverseGeoCodeSearchResult:(BMKReverseGeoCodeResult *)result {
    self.startLocation = [[KTCLocation alloc] initWithLocation:[[CLLocation alloc] initWithLatitude:result.location.latitude longitude:result.location.longitude] locationDescription:result.address];
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (BMKPoiInfo *poi in result.poiList) {
        [tempArray addObject:poi.address];
    }
    self.pickerDataArray = [NSArray arrayWithArray:tempArray];
    if ([self.pickerDataArray count] > 0) {
        [self.pickerView show];
    } else {
        [[iToast makeText:@"查询失败"] show];
    }
}

- (void)selectRouteSearchType {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"请选择路径规划方式" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *driveAction = [UIAlertAction actionWithTitle:@"驾车" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self startRouteSearchWithType:KTCRouteSearchTypeDrive];
    }];
    UIAlertAction *busAction = [UIAlertAction actionWithTitle:@"公交" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self startRouteSearchWithType:KTCRouteSearchTypeBus];
    }];
    UIAlertAction *walkAction = [UIAlertAction actionWithTitle:@"步行" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self startRouteSearchWithType:KTCRouteSearchTypeWalk];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [controller addAction:driveAction];
    [controller addAction:busAction];
    [controller addAction:walkAction];
    [controller addAction:cancelAction];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)resetRouteTypeButtonWithType:(KTCRouteSearchType)type {
    [self.routeTypeButton setHidden:NO];
    switch (type) {
        case KTCRouteSearchTypeDrive:
        {
            [self.routeTypeButton setTitle:@"驾车" forState:UIControlStateNormal];
        }
            break;
        case KTCRouteSearchTypeBus:
        {
            [self.routeTypeButton setTitle:@"公交" forState:UIControlStateNormal];
        }
            break;
        case KTCRouteSearchTypeWalk:
        {
            [self.routeTypeButton setTitle:@"步行" forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
}

- (void)startRouteSearchWithType:(KTCRouteSearchType)type {
    [self resetRouteTypeButtonWithType:type];
    [[GAlertLoadingView sharedAlertLoadingView] show];
    __weak KTCMapViewController *weakSelf = self;
    [[KTCMapService sharedService] startRouteSearchWithType:type startCoordinate:self.startLocation.location.coordinate endCoordinate:self.destLocation.location.coordinate succeed:^(id result) {
        [weakSelf drawRouteLineDetailWithSearchResult:result];
        [[GAlertLoadingView sharedAlertLoadingView] hide];
    } failure:^(NSError *error) {
        [[GAlertLoadingView sharedAlertLoadingView] hide];
        [[iToast makeText:@"没有找到合适的路线"] show];
    }];
}

- (NSDictionary *)drawRouteLineDetailWithSearchResult:(id)result {
    NSDictionary *routeLineDic = nil;
    //解析
    if ([result isKindOfClass:[BMKDrivingRouteResult class]]) {
        //驾车
        routeLineDic = [KTCMapUtil drawRoutePolyLineOnMapView:self.mapView withStartCoord:self.startLocation.location.coordinate endCoord:self.destLocation.location.coordinate andDrivingRouteResult:result autoResetToFit:YES];
    } else if ([result isKindOfClass:[BMKTransitRouteResult class]]) {
        //公交
        routeLineDic = [KTCMapUtil drawRoutePolyLineOnMapView:self.mapView withStartCoord:self.startLocation.location.coordinate endCoord:self.destLocation.location.coordinate andTransitRouteResult:result autoResetToFit:YES];
    } else if ([result isKindOfClass:[BMKWalkingRouteResult class]]) {
        //步行
        routeLineDic = [KTCMapUtil drawRoutePolyLineOnMapView:self.mapView withStartCoord:self.startLocation.location.coordinate endCoord:self.destLocation.location.coordinate andWalkingRouteResult:result autoResetToFit:YES];
    }
    return routeLineDic;
}

#pragma mark Super methods

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
