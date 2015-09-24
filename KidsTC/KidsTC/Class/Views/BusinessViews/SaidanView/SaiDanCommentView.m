//
//  SaiDanCommentView.m
//  ICSON
//
//  Created by 肖晓春 on 15/5/13.
//  Copyright (c) 2015年 肖晓春. All rights reserved.
//

#import "SaiDanCommentView.h"
static const int kMaxCommentWordCount = 1000;
@interface SaiDanCommentView ()



@end
@implementation SaiDanCommentView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)keyboardDismiss:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(commentkeyBoardDismiss)]) {
        [self.delegate commentkeyBoardDismiss];
    }
    
}

- (void)refresh
{
//    if (!self.starView) {
        self.starView = [[GCommentStarView alloc] initWithStarWidth:18.0f andPadding:4.0f];
        [self.starView setStarValue:0];
        self.starView.frame = CGRectMake(60, 19,200, 30);
        [self addSubview:self.starView];
//    }
    
    
    self.inputTextView.delegate = self;
    if (!self.placeholdLabel) {
         [self addPlaceHoldLabel];
    }
//    [self addPlaceHoldLabel];
}

- (void)addPlaceHoldLabel
{
   UILabel *placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(5,11,self.bounds.size.width - 16,10)];
    placeHolderLabel.backgroundColor = [UIColor clearColor];
    placeHolderLabel.textColor = RGBA(153.0, 153.0, 153.0, 1.0);
    placeHolderLabel.tag = 999;
    placeHolderLabel.font = [UIFont systemFontOfSize:15.0];
    placeHolderLabel.text = @"快点分享商品体验给大家吧";
    self.placeholdLabel = placeHolderLabel;
    [self.inputTextView addSubview:self.placeholdLabel];

}

#pragma mark UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    self.placeholdLabel.hidden = YES;
//    int unitCount = [GToolUtil gCountWord:textView.text];
    NSUInteger unitCount =  textView.text.length;

    self.countNumberLabel.text = [NSString stringWithFormat:@"%lu/%d", (unsigned long)unitCount, kMaxCommentWordCount];
    
    if (unitCount > kMaxCommentWordCount)
    {
        
        textView.text = [textView.text substringToIndex:1000];
        NSUInteger unitCountNow =  textView.text.length;
        self.countNumberLabel.text = [NSString stringWithFormat:@"%lu/%d", (unsigned long)unitCountNow, kMaxCommentWordCount];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"评论内容不能超过%d个字", kMaxCommentWordCount] message:nil delegate:nil cancelButtonTitle:@"好的，我知道了" otherButtonTitles:nil, nil];
        [alert show];
         return;
    }
    
    if (unitCount > 0) {
        self.placeholdLabel.hidden = YES;
    }
    else
    {
        self.placeholdLabel.hidden = NO;
    }
}
#pragma mark Initialization

- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    static BOOL bLoad;
    if (!bLoad)
    {
        bLoad = YES;
        SaiDanCommentView *saiDanCommentView = [self getObjectFromNibWithClass:[self class]];
        [self replaceAutolayoutConstrainsFromView:self toView:saiDanCommentView];
//        [saiDanCommentView buildSubviews];
        return saiDanCommentView;
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
#pragma mark Self Methods

- (int) getStarValue
{
    return self.starView.starValue;
}
//- (void)resetLines {
//    NSArray *upperLineConstraintsArray = [self.upperLine constraints];
//    for (NSLayoutConstraint *constraint in upperLineConstraintsArray) {
//        if (constraint.firstAttribute == NSLayoutAttributeHeight) {
//            //height constraint
//            //new
//            constraint.constant = BORDER_WIDTH;
//            break;
//        }
//    }
//}

@end
