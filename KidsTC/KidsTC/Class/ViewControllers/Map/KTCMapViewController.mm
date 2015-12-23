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



@interface RouteAnnotation : BMKPointAnnotation
{
    int _type; ///<0:起点 1：终点 2：公交 3：地铁 4:驾乘 5:途经点
    int _degree;
}

@property (nonatomic) int type;
@property (nonatomic) int degree;
@end

@implementation RouteAnnotation

@synthesize type = _type;
@synthesize degree = _degree;
@end

#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]

NSString *const kRouteDescriptionKey = @"kRouteDescriptionKey";
NSString *const kRouteDurationDescriptionKey = @"kRouteDurationDescriptionKey";
NSString *const kRouteLineStepsKey = @"kRouteLineStepsKey";

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

- (NSDictionary *)routeLineDetailWithSearchResult:(id)result;

- (void)drawRouteWithRouteLineSteps:(NSArray *)steps;

- (void)clearMap;

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
    [self clearMap];
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
        [self mapViewFitStart:self.startLocation.location.coordinate destination:self.destLocation.location.coordinate];
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
        [self clearMap];
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
            ((BMKPinAnnotationView*)annotationView).image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_start.png"]];
        } else {
            ((BMKPinAnnotationView*)annotationView).image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_end.png"]];
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
        return [self getRouteAnnotationView:mapView viewForAnnotation:(RouteAnnotation*)annotation];
    }
    
    return annotationView;
}

- (BMKOverlayView*)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay {
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor alloc] initWithRed:0 green:1 blue:1 alpha:1];
        polylineView.strokeColor = [AUITheme theme].highlightTextColor;
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

//- (NSString *)pickerView:(AUIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
//    return [self.pickerDataArray objectAtIndex:row];
//}

//- (NSAttributedString *)pickerView:(AUIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
//    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[self.pickerDataArray objectAtIndex:row]];
//    NSDictionary *attribute = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:13] forKey:NSFontAttributeName];
//    [string setAttributes:attribute range:NSMakeRange(0, [string length])];
//    return string;
//}

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
    [self.searchField setBackgroundColor:[[AUITheme theme].globalThemeColor colorWithAlphaComponent:0.5]];
    [self.searchField setLeftView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)]];
    [self.searchField setRightView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)]];
    [self.searchField setLeftViewMode:UITextFieldViewModeAlways];
    [self.searchField setRightViewMode:UITextFieldViewModeAlways];
    
    self.pickerView = [[AUIPickerView alloc] initWithDataSource:self delegate:self];
    
    [self.routeTypeButton setBackgroundColor:[AUITheme theme].globalThemeColor forState:UIControlStateNormal];
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
        NSDictionary *detailDic = [weakSelf routeLineDetailWithSearchResult:result];
        [self drawRouteWithRouteLineSteps:[detailDic objectForKey:kRouteLineStepsKey]];
        [[GAlertLoadingView sharedAlertLoadingView] hide];
    } failure:^(NSError *error) {
        [[GAlertLoadingView sharedAlertLoadingView] hide];
        [[iToast makeText:@"没有找到合适的路线"] show];
    }];
}

- (NSDictionary *)routeLineDetailWithSearchResult:(id)result {
    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];
    //解析
    if ([result isKindOfClass:[BMKDrivingRouteResult class]]) {
        //驾车
        BMKDrivingRouteLine *routeLine = [((BMKDrivingRouteResult *)result).routes firstObject];
        [tempDic setObject:[NSString stringWithFormat:@"距离%@", [GToolUtil distanceDescriptionWithMeters:routeLine.distance]] forKey:kRouteDescriptionKey];
        [tempDic setObject:[NSString stringWithFormat:@"预计耗时%@", [KTCMapService timeDescriptionWithBMKTime:routeLine.duration]] forKey:kRouteDurationDescriptionKey];
        if ([routeLine.steps count] > 0) {
            [tempDic setObject:routeLine.steps forKey:kRouteLineStepsKey];
        }
    } else if ([result isKindOfClass:[BMKTransitRouteResult class]]) {
        //公交
        BMKTransitRouteLine *routeLine = [((BMKTransitRouteResult *)result).routes firstObject];
        [tempDic setObject:[NSString stringWithFormat:@"距离%@", [GToolUtil distanceDescriptionWithMeters:routeLine.distance]] forKey:kRouteDescriptionKey];
        [tempDic setObject:[NSString stringWithFormat:@"预计耗时%@", [KTCMapService timeDescriptionWithBMKTime:routeLine.duration]] forKey:kRouteDurationDescriptionKey];
        if ([routeLine.steps count] > 0) {
            [tempDic setObject:routeLine.steps forKey:kRouteLineStepsKey];
        }
    } else if ([result isKindOfClass:[BMKWalkingRouteResult class]]) {
        //步行
        BMKWalkingRouteLine *routeLine = [((BMKWalkingRouteResult *)result).routes firstObject];
        [tempDic setObject:[NSString stringWithFormat:@"距离%@", [GToolUtil distanceDescriptionWithMeters:routeLine.distance]] forKey:kRouteDescriptionKey];
        [tempDic setObject:[NSString stringWithFormat:@"预计耗时%@", [KTCMapService timeDescriptionWithBMKTime:routeLine.duration]] forKey:kRouteDurationDescriptionKey];
        if ([routeLine.steps count] > 0) {
            [tempDic setObject:routeLine.steps forKey:kRouteLineStepsKey];
        }
    } else {
        NSLog(@"无法解析的路径搜索结果类型");
    }
    return [NSDictionary dictionaryWithDictionary:tempDic];
}

- (void)drawRouteWithRouteLineSteps:(NSArray *)steps {
    [self clearMap];
    if (![steps isKindOfClass:[NSArray class]] || [steps count] == 0) {
        return;
    }
    
    // 计算路线方案中的路段数目
    NSInteger size = [steps count];
    int planPointCounts = 0;
    for (int i = 0; i < size; i++) {
        if(i==0){
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = self.startLocation.location.coordinate;
            item.title = @"起点";
            item.type = 0;
            [_mapView addAnnotation:item]; // 添加起点标注
            
        }else if(i==size-1){
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = self.destLocation.location.coordinate;
            item.title = @"终点";
            item.type = 1;
            [_mapView addAnnotation:item]; // 添加起点标注
        }
        BMKRouteStep* step = [steps objectAtIndex:i];
        if ([step isKindOfClass:[BMKDrivingStep class]]) {
            BMKDrivingStep *stepOver = (BMKDrivingStep *)step;
            //添加annotation节点
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = stepOver.entrace.location;
            item.title = stepOver.entraceInstruction;
            item.degree = stepOver.direction * 30;
            item.type = 4;
            [_mapView addAnnotation:item];
        } else if ([step isKindOfClass:[BMKTransitStep class]]) {
            BMKTransitStep *stepOver = (BMKTransitStep *)step;
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = stepOver.entrace.location;
            item.title = stepOver.instruction;
            item.type = 3;
            [_mapView addAnnotation:item];
        } else if ([step isKindOfClass:[BMKWalkingStep class]]) {
            BMKWalkingStep *stepOver = (BMKWalkingStep *)step;
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = stepOver.entrace.location;
            item.title = stepOver.entraceInstruction;
            item.degree = stepOver.direction * 30;
            item.type = 4;
            [_mapView addAnnotation:item];
        }
        
        //轨迹点总数累计
        planPointCounts += step.pointsCount;
    }
    //轨迹点
    BMKMapPoint *temppoints = new BMKMapPoint[planPointCounts];
    int i = 0;
    for (int j = 0; j < size; j++) {
        BMKRouteStep* transitStep = [steps objectAtIndex:j];
        int k=0;
        for(k=0;k<transitStep.pointsCount;k++) {
            temppoints[i].x = transitStep.points[k].x;
            temppoints[i].y = transitStep.points[k].y;
            i++;
        }
        
    }
    // 通过points构建BMKPolyline
    BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
    [_mapView addOverlay:polyLine]; // 添加路线overlay
    delete []temppoints;
    [self mapViewFitPolyLine:polyLine];
}

//根据起始和结束点设置地图范围
- (void)mapViewFitStart:(CLLocationCoordinate2D)start destination:(CLLocationCoordinate2D)destinate {
    CGFloat ltX, ltY, rbX, rbY;
    BMKMapPoint startPt = BMKMapPointForCoordinate(start);
    ltX = startPt.x, ltY = startPt.y;
    rbX = startPt.x, rbY = startPt.y;
    BMKMapPoint endPt = BMKMapPointForCoordinate(destinate);
    if (endPt.x < ltX) {
        ltX = endPt.x;
    }
    if (endPt.x > rbX) {
        rbX = endPt.x;
    }
    if (endPt.y > ltY) {
        ltY = endPt.y;
    }
    if (endPt.y < rbY) {
        rbY = endPt.y;
    }
    BMKMapRect rect;
    rect.origin = BMKMapPointMake(ltX , ltY);
    rect.size = BMKMapSizeMake(rbX - ltX, rbY - ltY);
    [_mapView setVisibleMapRect:rect];
    _mapView.zoomLevel = _mapView.zoomLevel - 0.3;
}

//根据polyline设置地图范围
- (void)mapViewFitPolyLine:(BMKPolyline *) polyLine {
    CGFloat ltX, ltY, rbX, rbY;
    if (polyLine.pointCount < 1) {
        return;
    }
    BMKMapPoint pt = polyLine.points[0];
    ltX = pt.x, ltY = pt.y;
    rbX = pt.x, rbY = pt.y;
    for (int i = 1; i < polyLine.pointCount; i++) {
        BMKMapPoint pt = polyLine.points[i];
        if (pt.x < ltX) {
            ltX = pt.x;
        }
        if (pt.x > rbX) {
            rbX = pt.x;
        }
        if (pt.y > ltY) {
            ltY = pt.y;
        }
        if (pt.y < rbY) {
            rbY = pt.y;
        }
    }
    BMKMapRect rect;
    rect.origin = BMKMapPointMake(ltX , ltY);
    rect.size = BMKMapSizeMake(rbX - ltX, rbY - ltY);
    [_mapView setVisibleMapRect:rect];
    _mapView.zoomLevel = _mapView.zoomLevel - 0.3;
}

- (NSString*)getMyBundlePath1:(NSString *)filename
{
    
    NSBundle * libBundle = MYBUNDLE ;
    if ( libBundle && filename ){
        NSString * s=[[libBundle resourcePath ] stringByAppendingPathComponent : filename];
        return s;
    }
    return nil ;
}

- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview viewForAnnotation:(RouteAnnotation*)routeAnnotation
{
    BMKAnnotationView* view = nil;
    switch (routeAnnotation.type) {
        case 0:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"start_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"start_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_start.png"]];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 1:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"end_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"end_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_end.png"]];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 2:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"bus_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"bus_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_bus.png"]];
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 3:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"rail_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"rail_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_rail.png"]];
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 4:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"route_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"route_node"];
                view.canShowCallout = TRUE;
            } else {
                [view setNeedsDisplay];
            }
            
            UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_direction.png"]];
            view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
            view.annotation = routeAnnotation;
            
        }
            break;
        case 5:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"waypoint_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"waypoint_node"];
                view.canShowCallout = TRUE;
            } else {
                [view setNeedsDisplay];
            }
            
            UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_waypoint.png"]];
            view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
            view.annotation = routeAnnotation;
        }
            break;
        default:
            break;
    }
    
    return view;
}

- (void)clearMap {
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
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
