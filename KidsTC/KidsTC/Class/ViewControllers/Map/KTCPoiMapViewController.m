//
//  KTCPoiMapViewController.m
//  KidsTC
//
//  Created by Altair on 1/21/16.
//  Copyright © 2016 KidsTC. All rights reserved.
//

#import "KTCPoiMapViewController.h"
#import "KTCMapService.h"
#import "RouteAnnotation.h"
#import "KTCMapUtil.h"
#import "KTCAnnotationTipPoiView.h"

@interface KTCPoiMapViewController () <BMKMapViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet BMKMapView *mapView;

@property (nonatomic, strong) NSArray<KTCLocation *> *poiLocations;

- (void)initializeMapView;

- (void)initOtherSubviews;

- (IBAction)didClickedBackButton:(id)sender;

- (void)resetPoiAnnotations;

@end

@implementation KTCPoiMapViewController

- (instancetype)initWithLocations:(NSArray<KTCLocation *> *)locations {
    self = [super initWithNibName:@"KTCPoiMapViewController" bundle:nil];
    if (self) {
        self.poiLocations = locations;
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
    [self resetPoiAnnotations];
}

- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate {
    [self.view endEditing:YES];
}

- (void)mapview:(BMKMapView *)mapView onLongClick:(CLLocationCoordinate2D)coordinate {
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation {
    // 生成重用标示identifier
    NSString *AnnotationViewID = @"AnnotationViewID";
    
    // 检查是否有重用的缓存
    BMKAnnotationView* annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    
    // 缓存没有命中，自己构造一个，一般首次添加annotation代码会运行到此处
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        // 设置重天上掉下的效果(annotation)
        ((BMKPinAnnotationView*)annotationView).animatesDrop = NO;
    }
    ((BMKPinAnnotationView*)annotationView).image = [KTCMapUtil poiAnnotationImage];
    
    // 设置位置
    annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
    // 单击弹出泡泡，弹出泡泡前提annotation必须实现title属性
    annotationView.canShowCallout = YES;
    //泡泡
    //泡泡
    NSUInteger index = ((RouteAnnotation *)annotation).tag;
    if ([self.poiLocations count] > index) {
        KTCLocation *item = [self.poiLocations objectAtIndex:index];
        KTCAnnotationTipPoiView *tipView = [[KTCAnnotationTipPoiView alloc] initWithFrame:CGRectMake(0, 0, 200, 120)];
        [tipView.poiDescriptionLabel setText:item.locationDescription];
        annotationView.paopaoView = [[BMKActionPaopaoView alloc] initWithCustomView:tipView];
        // 设置是否可以拖拽
        annotationView.draggable = NO;
    }
    
    return annotationView;
}

- (BMKOverlayView*)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay {
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor alloc] initWithRed:0 green:1 blue:1 alpha:1];
        polylineView.strokeColor = [[KTCThemeManager manager] defaultTheme].highlightTextColor;
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
}

#pragma mark Private methods

- (void)initializeMapView {
    [self.mapView setMapType:BMKMapTypeStandard];
    [self.mapView setShowsUserLocation:YES];
    [self.mapView setShowMapScaleBar:YES];
    [self.mapView setIsSelectedAnnotationViewFront:YES];
    
    [self.mapView setMapScaleBarPosition:CGPointMake(5, SCREEN_HEIGHT - 50)];
}

- (void)initOtherSubviews {
    [self.view bringSubviewToFront:self.topView];
    
    [self.backButton setAlpha:0.7];
}

- (void)showBottomViewWithRouteLines:(NSArray *)routeLines {
    
}

- (IBAction)didClickedBackButton:(id)sender {
    [self goBackController:nil];
}

- (void)resetPoiAnnotations {
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (NSUInteger index = 0; index < [self.poiLocations count]; index ++) {
        KTCLocation *location = [self.poiLocations objectAtIndex:index];
        RouteAnnotation *annotation = [[RouteAnnotation alloc]init];
        if (CLLocationCoordinate2DIsValid(location.location.coordinate)) {
            [annotation setCoordinate:location.location.coordinate];
            annotation.tag = index;
            [self.mapView addAnnotation:annotation];
            [tempArray addObject:location.location];
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
