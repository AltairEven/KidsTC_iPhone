//
//  MultiSelView.h
//  iPhone51Buy
//
//  Created by alex tao on 3/27/13.
//  Copyright (c) 2013 icson. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MultiSelView;

@protocol MultiSelDelegate <NSObject>

-(void) multiSel:(MultiSelView*)sel didSelectObject:(id)obj adIndex:(NSInteger)idx;

@end

///////////////////////////////////////////////////////////////////////////////////////////

@interface MultiSelView : UIView {
    
    UIView *                _contentView;
    NSMutableArray *        _objArr;
    NSInteger               _selIdx;
    
    NSMutableSet *          _disableIdx;
    CGFloat                 _contentOffset;
    
}

@property (nonatomic, weak) id<MultiSelDelegate>    selDelegate;
@property (nonatomic) BOOL                          allowMultiSel;      // default NO
@property (nonatomic, strong) UILabel *             selTitle;

- (void) setTitleLabel:(NSString*)title withOffset:(CGFloat)offset;

- (void) appendSelStrings:(NSArray*)strArr;
- (void) resetView;

- (void) setSelectedForObj:(id)obj;
- (void) setSelectedForIdx:(NSInteger)idx;

- (void) setDisableForIdxArr:(NSArray*)idArr;

@end
