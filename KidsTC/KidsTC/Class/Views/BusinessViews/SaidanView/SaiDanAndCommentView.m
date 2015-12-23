//
//  SaiDanAndCommentView.m
//  ICSON
//
//  Created by 肖晓春 on 15/5/13.
//  Copyright (c) 2015年 肖晓春. All rights reserved.
//

#import "SaiDanAndCommentView.h"

@interface SaiDanAndCommentView()


@end
@implementation SaiDanAndCommentView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
#pragma mark Initialization
- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    static BOOL bLoad;
    if (!bLoad)
    {
        bLoad = YES;
        SaiDanAndCommentView *saiDanAndCommentView = [self getObjectFromNibWithClass:[self class]];
        [self replaceAutolayoutConstrainsFromView:self toView:saiDanAndCommentView];
        [saiDanAndCommentView buildSubviews];
        return saiDanAndCommentView;
    }
    bLoad = NO;
    return self;
}


- (id)getObjectFromNibWithClass:(Class)class {
    
    NSString *className = NSStringFromClass(class);
    
    NSArray *topObjArray = [[NSBundle mainBundle] loadNibNamed:className owner:nil options:nil];
    
    for (id anObj in topObjArray) {
        if ([anObj isKindOfClass:class]) {
            return anObj;
        }
    }
    
    return nil;
}




- (void)replaceAutolayoutConstrainsFromView:(UIView *)placeholderView toView:(UIView *)realView
{
    realView.autoresizingMask = placeholderView.autoresizingMask;
    realView.translatesAutoresizingMaskIntoConstraints = placeholderView.translatesAutoresizingMaskIntoConstraints;
    
    // Copy autolayout constrains from placeholder view to real view
    if (placeholderView.constraints.count > 0) {
        
        // We only need to copy "self" constraints (like width/height constraints)
        // from placeholder to real view
        for (NSLayoutConstraint *constraint in placeholderView.constraints) {
            
            NSLayoutConstraint* newConstraint;
            
            // "Height" or "Width" constraint
            // "self" as its first item, no second item
            if (!constraint.secondItem) {
                newConstraint =
                [NSLayoutConstraint constraintWithItem:realView
                                             attribute:constraint.firstAttribute
                                             relatedBy:constraint.relation
                                                toItem:nil
                                             attribute:constraint.secondAttribute
                                            multiplier:constraint.multiplier
                                              constant:constraint.constant];
            }
            // "Aspect ratio" constraint
            // "self" as its first AND second item
            else if ([constraint.firstItem isEqual:constraint.secondItem]) {
                newConstraint =
                [NSLayoutConstraint constraintWithItem:realView
                                             attribute:constraint.firstAttribute
                                             relatedBy:constraint.relation
                                                toItem:realView
                                             attribute:constraint.secondAttribute
                                            multiplier:constraint.multiplier
                                              constant:constraint.constant];
            }
            
            // Copy properties to new constraint
            if (newConstraint) {
                newConstraint.shouldBeArchived = constraint.shouldBeArchived;
                newConstraint.priority = constraint.priority;
                if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0f) {
                    newConstraint.identifier = constraint.identifier;
                }
                [realView addConstraint:newConstraint];
            }
        }
    }
}



- (void)buildSubviews
{
//    self.saiDanPhotoView.delegate = self;
}
#pragma mark Self Methods

- (void)refresh  : (NSDictionary *)dicInfo{
//    //calculate content size
//    CGFloat viewHeight = 0;
//    CGFloat saiDanOrder = 111;
//    CGFloat saiDanComment = 187;
//    CGFloat saiDanPhoto = 60;
//    if(self.saiDanPhotoView.saiDanPhotoViewHeight)
//    {
//         saiDanPhoto = self.saiDanPhotoView.saiDanPhotoViewHeight;
//    }
//    
//    CGFloat saiDanCommit = 170;
//    self.saiDanOrderView.frame = CGRectMake(0, viewHeight, SCREEN_WIDTH, saiDanOrder);
//    viewHeight += saiDanOrder;
//    self.saiDanCommentView.frame = CGRectMake(0, viewHeight, SCREEN_WIDTH, saiDanComment);
//    viewHeight += saiDanComment;
//    self.saiDanPhotoView.frame = CGRectMake(0, viewHeight, SCREEN_WIDTH, saiDanPhoto);
//    viewHeight += saiDanPhoto;
//    if(self.saiDanPhotoView.saiDanPhotoViewHeight)
//    {
//        self.saiDancomitView.frame = CGRectMake(0, viewHeight , SCREEN_WIDTH, saiDanCommit);
//    }
//    else
//    {
//        self.saiDancomitView.frame = CGRectMake(0, viewHeight + 50, SCREEN_WIDTH, saiDanCommit);
//    }
////    self.saiDancomitView.frame = CGRectMake(0, viewHeight, SCREEN_WIDTH, saiDanCommit);
//    viewHeight += saiDanCommit;
//
//    
//
//    self.contentSize = CGSizeMake(0, viewHeight);
//    self.showsVerticalScrollIndicator = NO;
    
    [self reloadData];
    [self.saiDanOrderView reloadData:dicInfo];
    [self.saiDanCommentView refresh];
}

- (void)reloadData{
    //calculate content size
    CGFloat viewHeight = 0;
    CGFloat saiDanOrder = 111;
    CGFloat saiDanComment = 187;
    CGFloat saiDanPhoto = 60;
    if(self.saiDanPhotoView.saiDanPhotoViewHeight)
    {
        saiDanPhoto = self.saiDanPhotoView.saiDanPhotoViewHeight;
    }
    
    CGFloat saiDanCommit = 170;
    self.saiDanOrderView.frame = CGRectMake(0, viewHeight, SCREEN_WIDTH, saiDanOrder);
    viewHeight += saiDanOrder;
    self.saiDanCommentView.frame = CGRectMake(0, viewHeight, SCREEN_WIDTH, saiDanComment);
    viewHeight += saiDanComment;
//    self.saiDanPhotoView = [[SaiDanPhotoView alloc]init];
    self.saiDanPhotoView.frame = CGRectMake(0, viewHeight, SCREEN_WIDTH, saiDanPhoto);
    viewHeight += saiDanPhoto;
//    [self addSubview:self.saiDanPhotoView];
    
    if(self.saiDanPhotoView.saiDanPhotoViewHeight)
    {
        self.saiDancomitView.frame = CGRectMake(0, viewHeight , SCREEN_WIDTH, saiDanCommit);
    }
    else
    {
        self.saiDancomitView.frame = CGRectMake(0, viewHeight + 40, SCREEN_WIDTH, saiDanCommit);
    }
//        self.saiDancomitView.frame = CGRectMake(0, viewHeight, SCREEN_WIDTH, saiDanCommit);
    viewHeight += saiDanCommit;
    
    
    self.contentSize = CGSizeMake(0, viewHeight);
    self.showsVerticalScrollIndicator = NO;
    
}


@end
