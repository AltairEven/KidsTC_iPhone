//
//  GuideViewController.m
//  ICSON
//
//  Created by ivy on 15/3/10.
//  Copyright (c) ivy. All rights reserved.
//

#import "GuideViewController.h"

#define kHasDisplayedGuideKey   @"kHasDisplayedGuideKey"

//若有改动，则修改这个值，从1开始递增
#define GuideValue (1)

const CGFloat BottomDistanceForIphone4 = 0.2;
const CGFloat BottomDistanceForIphone5 = 0.22;
const CGFloat BottomDistanceForIphone6 = 0.26;
const CGFloat BottomDistanceForIphone6plus = 0.26;

const CGFloat DeviceMultiplierNot6plus = 2.0;
const CGFloat DeviceMultiplier6plus = 3.0;

const CGFloat multiplierDistance = 0.3;

@interface GuideViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *guidView1;
@property (weak, nonatomic) IBOutlet UIView *guidView3;
@property (weak, nonatomic) IBOutlet UIView *guidView2;
//@property (weak, nonatomic) IBOutlet UIView *guidView4;

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl
;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScroll;

@property (weak, nonatomic) IBOutlet UIImageView *view2Image;
@property (weak, nonatomic) IBOutlet UIImageView *view3Image;
//@property (weak, nonatomic) IBOutlet UIImageView *view4Image;
@property (weak, nonatomic) IBOutlet UIImageView *view1Image;

@property (nonatomic) CGFloat bottomDistance;

- (IBAction)clickPageControl:(id)sender;
- (IBAction)clickToFinish:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;



@end

@implementation GuideViewController

+ (BOOL)needShow {
    BOOL bNeed = YES;
    NSInteger value = [[[NSUserDefaults standardUserDefaults] objectForKey:kHasDisplayedGuideKey] integerValue];
    if (value == GuideValue) {
        bNeed = NO;
    }
    return bNeed;
}

+ (void)setHasDisplayed {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:GuideValue] forKey:kHasDisplayedGuideKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.mainScroll.delegate = self;
    self.pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:29.0/255.0 green:122.0/255.0 blue:217.0/255.0 alpha:1];
    
    //按钮的边框颜色 选中颜色
    self.finishBtn.layer.borderWidth = 1.0;
    self.finishBtn.layer.borderColor = [UIColor colorWithRed:66.0/255.0f green:158.0/255. blue:255.0/255.0 alpha:1 ].CGColor;
    [self.finishBtn setBackgroundColor:[UIColor colorWithRed:66.0/255.0 green:158.0/255.0 blue:255.0/255.0 alpha:1] forState:UIControlStateHighlighted];
    [self.finishBtn setBackgroundColor:[UIColor colorWithRed:66.0/255.0 green:158.0/255.0 blue:255.0/255.0 alpha:1] forState:UIControlStateSelected];
    
    [self customizeImage];
}

/**
 *  通过屏幕分辨率，适配4个屏幕显示的4套图片
 */
-(void) customizeImage{
    NSArray * imageViewTags =[NSArray arrayWithObjects: @1001, @1002, @1003, nil];
    
    //根据分辨率组合图片的名字-这是自定义规则
    CGFloat multiplier = DeviceMultiplierNot6plus;
    
    //iphone6 plus必须写3倍
    if ([UIScreen mainScreen].bounds.size.width == 414.0 &&
        [UIScreen mainScreen].bounds.size.height == 736.0) {
        multiplier = DeviceMultiplier6plus;
    }
    
    for (int i = 0; i < 3; i++) {
        NSString * imageName = [NSString stringWithFormat:@"welcome_page%i_%d_%d", i+1, (int)([UIScreen mainScreen].bounds.size.width*multiplier),(int)([UIScreen mainScreen].bounds.size.height * multiplier)];
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:@".png"];
       
        ((UIImageView*)[self.view viewWithTag:[[imageViewTags objectAtIndex: i] intValue]]).image = [UIImage imageWithContentsOfFile:imagePath];
    }
    
    //设置pageControl和底部的距离 iphone4是0.2 iphone5是0.22 iphone6是0.26 iphone6 plus是0.26
    [self setBottomDistanceForDevices];
}

-(void) setBottomDistanceForDevices{
    //iphone4s, iphone4
    if ([UIScreen mainScreen].bounds.size.width == 320.0 &&
        [UIScreen mainScreen].bounds.size.height == 480.0) {
//        self.bottomDistance = multiplierDistance *BottomDistanceForIphone4 * [UIScreen mainScreen].bounds.size.height ;
        self.bottomDistance = 0;
        
        [self updateViewBottomDistance:self.bottomDistance updateView:self.pageControl class:[UIPageControl class]];
        
        
    }else if ([UIScreen mainScreen].bounds.size.width == 320.0 &&
              [UIScreen mainScreen].bounds.size.height == 568.0){ //iphone5, iphone5c, iphone5s
//        self.bottomDistance =multiplierDistance *BottomDistanceForIphone5 * [UIScreen mainScreen].bounds.size.height;
        self.bottomDistance = 20;
         [self updateViewBottomDistance:self.bottomDistance updateView:self.pageControl class:[UIPageControl class]];
        
    }else if ([UIScreen mainScreen].bounds.size.width == 375.0 &&
              [UIScreen mainScreen].bounds.size.height == 667.0){//iphone6
//        self.bottomDistance =multiplierDistance *BottomDistanceForIphone6 * [UIScreen mainScreen].bounds.size.height ;
        
        self.bottomDistance = 30;
        [self updateViewBottomDistance:self.bottomDistance updateView:self.pageControl class:[UIPageControl class]];
        
    }else if([UIScreen mainScreen].bounds.size.width == 414.0 &&
             [UIScreen mainScreen].bounds.size.height == 736.0){ //iphone6 plus
//        self.bottomDistance =multiplierDistance *BottomDistanceForIphone6plus * [UIScreen mainScreen].bounds.size.height;
        self.bottomDistance = 40;
        [self updateViewBottomDistance:self.bottomDistance   updateView:self.pageControl class:[UIPageControl class]];
    }
    
    //更改按钮和底部的位置
    [self updateViewBottomDistance:self.bottomDistance updateView:self.finishBtn class:[UIButton class]];
}


/*-(void) setViewBackgroundImage:(NSString*)imageName forImageView:(UIImageView*) imageView
                    imageWidth:(CGFloat)imageWidth imageHeight:(CGFloat)imageHeight topDistance:(CGFloat)topDistance{
    imageView.image =[UIImage imageNamed:imageName];
}


-(void) updateViewHeight:(CGFloat)viewHeight updateView:(UIImageView* )updateView{
    NSArray * constraints = updateView.constraints;
    for (NSLayoutConstraint* constraint  in constraints) {
        if ([constraint.firstItem isKindOfClass:[UIImageView class]] && constraint.secondItem == nil && constraint.firstAttribute == NSLayoutAttributeHeight) {
            constraint.constant = viewHeight;
            break;
        }
    }
}

-(void) updateViewWidth:(CGFloat)viewWidth updateView:(UIImageView* )updateView{
    NSArray * constraints = updateView.constraints;
    for (NSLayoutConstraint* constraint  in constraints) {
        if ([constraint.firstItem isKindOfClass:[UIImageView class]] && constraint.secondItem == nil && constraint.firstAttribute == NSLayoutAttributeWidth) {
            constraint.constant = viewWidth;
            break;
        }
    }
}

-(void) updateViewTopDistance:(CGFloat)viewTopDistance updateView:(UIImageView* )updateView{
    NSArray * constraints = updateView.superview.constraints;
    for (NSLayoutConstraint* constraint  in constraints) {
        NSLog(@"约束：%@",constraint);
        if ([constraint.firstItem isKindOfClass:[UIImageView class]]
            && constraint.secondAttribute == NSLayoutAttributeTop) {
            constraint.constant = viewTopDistance;
            break;
        }
    }
}
*/

/**
 *  更新pageControl和底部的距离
 *
 *  @param viewBottonDistance <#viewBottonDistance description#>
 *  @param updateControl      <#updateControl description#>
 */
-(void) updateViewBottomDistance:(CGFloat)viewBottonDistance updateView:(UIView*)updateControl class:(Class)controlClass{
    //一定要是父窗口哟，因为是和服窗口的距离
    NSArray * constraints = updateControl.superview.constraints;
    for (NSLayoutConstraint * constraint in constraints) {
        NSLog(@"约束：%@", constraint);
        if ([constraint.secondItem isKindOfClass:controlClass]
            && constraint.secondAttribute == NSLayoutAttributeBottom) {
            constraint.constant = viewBottonDistance;
            NSLog(@"底部的距离：%f,设备：%f" ,viewBottonDistance, [UIScreen mainScreen].bounds.size.height );
            break;
        }
    }
    
}


#pragma mark -
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    //加上80是拖曳的上限限制，以免刚拖一下第四屏，就没了
    if(_guide_complete && scrollView.contentOffset.x > (2 * [UIScreen mainScreen].bounds.size.width + 80)){
        _guide_complete();
    }else{
        CGFloat pageIndex =scrollView.contentOffset.x / [UIScreen mainScreen].bounds.size.width;
        
        //如果是第四屏，隐藏分页控件
        if (pageIndex >= 2.5) {
            [self.pageControl setHidden:YES];

        }else{
            [self.pageControl setHidden:NO];
        }
        
        self.pageControl.currentPage = pageIndex;
    }
}



/**
 *  page control被点击时的响应
 *
 *  @param sender <#sender description#>
 */
- (IBAction)clickPageControl:(id)sender {
    CGFloat offset = self.pageControl.currentPage * [UIScreen mainScreen].bounds.size.width;
    self.scrollView.contentOffset = CGPointMake(offset, 0);
}

/**
 *  第四屏的按钮，点击后进入主页
 *
 *  @param sender <#sender description#>
 */
- (IBAction)clickToFinish:(id)sender {
    if (_guide_complete) {
        _guide_complete();
    }
}
@end
