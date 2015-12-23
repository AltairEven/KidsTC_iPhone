//
//  TRViewController.m
//  day05-4
//
//  Created by chenlei on 15-3-5.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "TRViewController.h"

@interface TRViewController ()<UIScrollViewDelegate>
@property(nonatomic,strong)NSArray* imageNames;
@property(nonatomic,strong) UIPageControl* pageControl;
@end

@implementation TRViewController
//重写getter方法
-(NSArray *)imageNames{
    //!_imageNames为空的时候 没有初值
    if (!_imageNames) {
        _imageNames = @[@"Welcome_1.png",@"Welcome_2.png",@"Welcome_3.png",@"Welcome_4.png"];
    }
    return _imageNames;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIScrollView* scrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    scrollView.delegate = self;
    
    for (int i = 0; i<self.imageNames.count; i++) {
        UIImage* image = [UIImage imageNamed:self.imageNames[i]];
        UIImageView* imageView = [[UIImageView alloc]initWithImage:image];
        CGRect frame = CGRectZero;
        frame.origin.x = i * scrollView.frame.size.width;
        frame.origin.y = 0;
        frame.size = scrollView.frame.size;
        imageView.frame = frame;
        [scrollView addSubview:imageView];
    }
    //设置相关属性
    CGSize size = CGSizeMake(scrollView.frame.size.width*self.imageNames.count, scrollView.frame.size.height);
    scrollView.contentSize = size;
    //翻页的时候 只能翻整页
    scrollView.pagingEnabled = YES;
    //隐藏滚动条
    //水平
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    
    //加入页面指示控件PageControl
    UIPageControl* pageControl = [[UIPageControl alloc]init];
    self.pageControl = pageControl;
    pageControl.frame = CGRectMake(0, self.view.frame.size.height - 80, self.view.frame.size.width, 20);
    pageControl.numberOfPages = self.imageNames.count;
    pageControl.pageIndicatorTintColor = [UIColor blackColor];
    pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    [self.view addSubview:pageControl];
    
    //添加一个按钮
    UIButton* button = [UIButton buttonWithType:UIButtonTypeSystem];
    
    //button.backgroundColor = [UIColor redColor];
   //// UIImage* image = [UIImage imageNamed:@"welcome_action_btn.png"];
   // [button setImage:image forState:UIControlStateNormal];
     CGRect frame = self.view.frame;
  
    //最后页面的首位置
    frame.origin.x = scrollView.frame.size.width* (self.imageNames.count - 1);
   
    button.frame = frame;
    
    [scrollView addSubview:button];
    [button addTarget:self action:@selector(enter) forControlEvents:UIControlEventTouchUpInside];
}
-(void)enter{
    NSLog(@"进入主页");
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //滑动鼠标的偏移量
    CGPoint offset = scrollView.contentOffset;
    NSLog(@"offset x:%lf y:%lf",offset.x,offset.y);
    
    if (offset.x<=0) {
        offset.x = 0;
        scrollView.contentOffset = offset;
    }
    //进行四舍五入
    NSUInteger index = round(offset.x/scrollView.frame.size.width);
    self.pageControl.currentPage = index;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
