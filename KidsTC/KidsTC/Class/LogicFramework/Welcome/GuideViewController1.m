//
//  GuideViewController.m
//  ICSON
//
//  Created by ivy on 15/3/10.
//  Copyright (c) ivy. All rights reserved.
//

#import "GuideViewController1.h"


@interface GuideViewController1 ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *guidView1;
@property (weak, nonatomic) IBOutlet UIView *guidView3;
@property (weak, nonatomic) IBOutlet UIView *guidView2;
//@property (weak, nonatomic) IBOutlet UIView *guidView4;

//@property (weak, nonatomic) IBOutlet UIPageControl *pageControl
;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScroll;

@property (weak, nonatomic) IBOutlet UIImageView *view2Image;
@property (weak, nonatomic) IBOutlet UIImageView *view3Image;
//@property (weak, nonatomic) IBOutlet UIImageView *view4Image;
@property (weak, nonatomic) IBOutlet UIImageView *view1Image;

@property (nonatomic) CGFloat bottomDistance;

//- (IBAction)clickPageControl:(id)sender;
//- (IBAction)clickToFinish:(id)sender;
//@property (weak, nonatomic) IBOutlet UIButton *finishBtn;



@property (nonatomic, strong)NSMutableArray *pic;
@property (nonatomic, strong)NSMutableArray *Standtime;
@end

@implementation GuideViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mainScroll.delegate = self;
//    self.pageControl.hidden = YES;
    [self customizeImage];
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(scrollTimer0) userInfo:nil repeats:NO];
}


/**
 *  通过屏幕分辨率，适配4个屏幕显示的4套图片
 */
-(void) customizeImage{
    NSArray * imageViewTags =[NSArray arrayWithObjects: @1001, @1002, @1003, nil];
    self.pic = [[NSMutableArray alloc]init];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    //NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *cachesPath =NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSArray *fileNames = [manager contentsOfDirectoryAtPath:cachesPath error:nil];
    for (NSString *fileName in fileNames) {
        //if ([fileName hasSuffix:@"jpg"]||[fileName hasSuffix:@"JPG"]||[fileName hasSuffix:@"png"]||[fileName hasSuffix:@"PNG"]) {
        if ([fileName isEqualToString:@"1.png"] || [fileName isEqualToString:@"2.png"] || [fileName isEqualToString:@"0.png"]) {
            NSString *imagePath = [cachesPath stringByAppendingPathComponent:fileName];// 路径，自动加上斜杠。
            [self.pic addObject:imagePath]; // 所有图片路径
        }
    }
   // [self.pic addObject:@"1"];
   // [self.pic addObject:@"2"];
    //[self.pic addObject:@"3"];
    //[self.pic addObject:@"4"];
    CGSize size = CGSizeMake(self.pic.count * [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    self.mainScroll.contentSize = size;
    for (int i = 0; i < self.pic.count; i++) {
        
        ((UIImageView*)[self.view viewWithTag:[[imageViewTags objectAtIndex: i] intValue]]).image
        = [UIImage imageWithContentsOfFile:self.pic[i]];
       // = [UIImage imageNamed:[NSString stringWithFormat:@"welcome_page%d_1242_2208.png", (i+1)]];
       //  = [UIImage imageNamed:@"12345.jpg"];
    }
}

- (void) scrollTimer0 {
    NSLog(@"111111");//self.scrollView.contentOffset = CGPointMake([UIScreen mainScreen].bounds.size.width, 0);
    //[self scrollViewDidScroll:self.mainScroll];
    self.scrollView.contentOffset = CGPointMake([UIScreen mainScreen].bounds.size.width, 0);
}
- (void) scrollTimer1 {
    NSLog(@"111111");//self.scrollView.contentOffset = CGPointMake([UIScreen mainScreen].bounds.size.width, 0);
    //[self scrollViewDidScroll:self.mainScroll];
    self.scrollView.contentOffset = CGPointMake([UIScreen mainScreen].bounds.size.width*2, 0);
}
- (void) scrollTimer2 {
    NSLog(@"111111");//self.scrollView.contentOffset = CGPointMake([UIScreen mainScreen].bounds.size.width, 0);
    //[self scrollViewDidScroll:self.mainScroll];
    self.scrollView.contentOffset = CGPointMake([UIScreen mainScreen].bounds.size.width*3, 0);
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
 
    //定时器进来的，那么如果在1屏则调到2屏，2屏则调到主页
    bool mytime = true;
    if (mytime) {
    if (scrollView.contentOffset.x == [UIScreen mainScreen].bounds.size.width) {
        if (self.pic.count == 1) {
             _guide_complete();
        }else{
            [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(scrollTimer1) userInfo:nil repeats:NO];                     // self.scrollView.contentOffset = CGPointMake([UIScreen mainScreen].bounds.size.width*2, 0);
                        //self.scrollView.contentOffset.x = ;
        }
    }else if (scrollView.contentOffset.x == [UIScreen mainScreen].bounds.size.width*2)
    {
        if (self.pic.count == 2) {
               _guide_complete();
        }else{
           [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(scrollTimer2) userInfo:nil repeats:NO];
        }
    }else if (scrollView.contentOffset.x == [UIScreen mainScreen].bounds.size.width*3)
    {
        if (self.pic.count == 3) {
                _guide_complete();
        }
    }
   }
else {
        //加上80是拖曳的上限限制，以免刚拖一下第四屏，就没了
           if(_guide_complete && scrollView.contentOffset.x > ((self.pic.count-1) * [UIScreen mainScreen].bounds.size.width+80)){
               _guide_complete();
           }
    }
  
}



/**
 *  page control被点击时的响应
 *
 *  @param sender <#sender description#>
 *//*
- (IBAction)clickPageControl:(id)sender {
    CGFloat offset = self.pageControl.currentPage * [UIScreen mainScreen].bounds.size.width;
    self.scrollView.contentOffset = CGPointMake(offset, 0);
}
*/
/**
 *  第四屏的按钮，点击后进入主页
 *
 *  @param sender <#sender description#>
 *//*
- (IBAction)clickToFinish:(id)sender {
    if (_guide_complete) {
        _guide_complete();
    }
}

*/

@end
