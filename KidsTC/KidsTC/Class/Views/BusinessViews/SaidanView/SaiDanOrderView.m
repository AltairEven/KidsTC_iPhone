//
//  SaiDanOrderView.m
//  ICSON
//
//  Created by 肖晓春 on 15/5/13.
//  Copyright (c) 2015年 肖晓春. All rights reserved.
//

#import "SaiDanOrderView.h"
@interface SaiDanOrderView()

@property (strong, nonatomic) IBOutlet IcsonImageView *productImage;
@property (strong, nonatomic) IBOutlet UILabel *productTitle;
@property (strong, nonatomic) IBOutlet UIView *seperateView;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;

@end
@implementation SaiDanOrderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
#pragma mark Initialization

- (void)reloadData : (NSDictionary *)dicInfo
{
    [self.productImage loadAsyncImage: [GToolUtil getProductPic: [dicInfo objectForKey: @"product_char_id"] type: @"small" index: 0]];
    [self.productTitle setText: [dicInfo objectForKey: @"name"]];
    NSString *priceString = [NSString stringWithFormat:@"¥%g",[[dicInfo objectForKey: @"price"] floatValue]/100];
    [self.priceLabel setText:priceString];
    [self resetLines];
}

- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    static BOOL bLoad;
    if (!bLoad)
    {
        bLoad = YES;
        SaiDanOrderView *saiDanOrderView = [self getObjectFromNibWithClass:[self class]];
        [self replaceAutolayoutConstrainsFromView:self toView:saiDanOrderView];
//                [saiDanCommentView buildSubviews];
        return saiDanOrderView;
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
- (void)resetLines {
    NSArray *upperLineConstraintsArray = [self.seperateView constraints];
    for (NSLayoutConstraint *constraint in upperLineConstraintsArray) {
        if (constraint.firstAttribute == NSLayoutAttributeHeight) {
            //height constraint
            //new
            constraint.constant = BORDER_WIDTH;
            break;
        }
    }
}

@end
