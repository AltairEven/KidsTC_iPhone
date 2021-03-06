//
//  StoreDetailBottomView.h
//  KidsTC
//
//  Created by 钱烨 on 7/17/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    StoreDetailBottomSubviewTagPhone = 100,
    StoreDetailBottomSubviewTagFavourate,
    StoreDetailBottomSubviewTagComment,
    StoreDetailBottomSubviewTagAppointment
}StoreDetailBottomSubviewTag;

@class StoreDetailBottomView;

@protocol  StoreDetailBottomViewDelegate <NSObject>

- (void)storeDetailBottomView:(StoreDetailBottomView *)bottomView didClickedButtonWithTag:(StoreDetailBottomSubviewTag)tag;

@end

@interface StoreDetailBottomView : UIView

@property (nonatomic, assign) id<StoreDetailBottomViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *phoneButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *favourateButton;
@property (weak, nonatomic) IBOutlet UIButton *appointmentButton;


- (void)setFavourite:(BOOL)isFavourite;

- (void)hidePhone:(BOOL)bHidden;

@end
