//
//  ImageTrimViewController.m
//  KidsTC
//
//  Created by Altair on 11/13/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "ImageTrimViewController.h"

@interface ImageTrimViewController ()

@property (nonatomic, strong) UIImage *sourceImage;

@property (nonatomic, assign) CGSize targetSize;

@property (strong, nonatomic) UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIView *trimView;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;

- (void)buildImageView;
- (void)buildGestures;

- (void)didPinched:(id)sender;
- (void)didPaned:(id)sender;

- (IBAction)didClickedCancelButton:(id)sender;
- (IBAction)didClickedSelectButton:(id)sender;

- (void)adjustPosition;

- (UIView *)snapshotTrimmedView;

@end

@implementation ImageTrimViewController

- (instancetype)initWithImage:(UIImage *)image targetSize:(CGSize)size {
    self = [super initWithNibName:@"ImageTrimViewController" bundle:nil];
    if (self) {
        self.sourceImage = image;
        self.targetSize = size;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self buildImageView];
    
    [self buildGestures];
    
    self.trimView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.trimView.layer.borderWidth = 1;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark Private methods

- (void)buildImageView {
    
    CGFloat width = SCREEN_WIDTH;
    CGFloat height = self.sourceImage.size.height / self.sourceImage.size.width * width;
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    [self.imageView setImage:self.sourceImage];
    [self.view addSubview:self.imageView];
    [self.view sendSubviewToBack:self.imageView];
    
    [self.imageView setCenter:CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2)];
}

- (void)buildGestures {
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(didPinched:)];
    [self.view addGestureRecognizer:pinch];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPaned:)];
    pan.maximumNumberOfTouches = 1;
    [self.view addGestureRecognizer:pan];
}

- (void)didPinched:(id)sender {
    UIPinchGestureRecognizer *gesture = (UIPinchGestureRecognizer *)sender;
    CGFloat scale = gesture.scale;
    if (gesture.state == UIGestureRecognizerStateBegan || gesture.state == UIGestureRecognizerStateChanged) {
        [self.selectButton setEnabled:NO];
        self.imageView.transform = CGAffineTransformScale(self.imageView.transform, scale, scale);
        gesture.scale = 1;
    } else if (self.imageView.frame.size.width < SCREEN_WIDTH) {
        CGFloat returnScale = SCREEN_WIDTH / self.imageView.frame.size.width;
        [UIView animateWithDuration:0.5 animations:^{
            self.imageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.imageView.frame.size.height * returnScale);
            [self.imageView setCenter:self.view.center];
        } completion:^(BOOL finished) {
            [self.selectButton setEnabled:YES];
        }];
    } else {
        [self adjustPosition];
    }
}

- (void)didPaned:(id)sender {
    UIPanGestureRecognizer *gesture = (UIPanGestureRecognizer *)sender;
    CGPoint translation = [gesture translationInView:gesture.view];
    
    if (gesture.state == UIGestureRecognizerStateBegan || gesture.state == UIGestureRecognizerStateChanged) {
        [self.selectButton setEnabled:NO];
        [self.imageView setCenter:CGPointMake(self.imageView.center.x + translation.x, self.imageView.center.y + translation.y)];
        [gesture setTranslation:CGPointZero inView:gesture.view];
    } else {
        [self adjustPosition];
    }
}

- (IBAction)didClickedCancelButton:(id)sender {
    [self goBackController:nil];
}

- (IBAction)didClickedSelectButton:(id)sender {
    UIImage *fullImage = [GToolUtil takeSnapshotForView:self.view];
    CGFloat x = self.trimView.frame.origin.x + 1;
    CGFloat y = self.trimView.frame.origin.y + 1;
    CGFloat width = self.trimView.frame.size.width - 2;
    CGFloat height = self.trimView.frame.size.height - 2;
    CGRect showingRect = CGRectMake(x, y, width, height);
    UIImage *trimmedImage = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(fullImage.CGImage, showingRect)];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(imageTrimViewController:didFinishedTrimmingWithNewImage:)]) {
        [self.delegate imageTrimViewController:self didFinishedTrimmingWithNewImage:trimmedImage];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)adjustPosition {
    CGFloat hEdgeLeft = self.imageView.frame.origin.x - self.trimView.frame.origin.x;
    CGFloat hEdgeRight = self.imageView.frame.origin.x + self.imageView.frame.size.width - (self.trimView.frame.origin.x + self.trimView.frame.size.width);
    CGFloat vEdgeTop = self.imageView.frame.origin.y - self.trimView.frame.origin.y;
    CGFloat vEdgeBottom = self.imageView.frame.origin.y + self.imageView.frame.size.height - (self.trimView.frame.origin.y + self.trimView.frame.size.height);
    CGFloat xPosition = self.imageView.frame.origin.x;
    CGFloat yPosition = self.imageView.frame.origin.y;
    
    if (hEdgeLeft > 0 && hEdgeRight > 0) {
        xPosition = self.trimView.frame.origin.x;
    } else if (hEdgeLeft < 0 && hEdgeRight < 0){
        xPosition = self.trimView.frame.origin.x +  self.trimView.frame.size.width - self.imageView.frame.size.width;
    }
    
    if (vEdgeTop > 0 && vEdgeBottom > 0) {
        yPosition = self.trimView.frame.origin.y;
    } else if (vEdgeTop < 0 && vEdgeBottom < 0){
        yPosition = self.trimView.frame.origin.y +  self.trimView.frame.size.height - self.imageView.frame.size.height;
    }
    
    if (self.imageView.frame.size.height < self.trimView.frame.size.height) {
        yPosition = (SCREEN_HEIGHT - self.imageView.frame.size.height) / 2;
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        self.imageView.frame = CGRectMake(xPosition, yPosition, self.imageView.frame.size.width, self.imageView.frame.size.height);
    } completion:^(BOOL finished) {
        [self.selectButton setEnabled:YES];
    }];
}

- (UIView *)snapshotTrimmedView {
    CGFloat x = self.trimView.frame.origin.x - self.imageView.frame.origin.x;
    CGFloat y = self.trimView.frame.origin.y - self.imageView.frame.origin.y;
    CGFloat width = self.trimView.frame.size.width;
    CGFloat height = self.trimView.frame.size.height;
    
    CGRect showingRect = CGRectMake(x, y, width, height);
    UIView *trimmedView = [self.imageView resizableSnapshotViewFromRect:showingRect afterScreenUpdates:YES withCapInsets:UIEdgeInsetsZero];
    return trimmedView;
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
