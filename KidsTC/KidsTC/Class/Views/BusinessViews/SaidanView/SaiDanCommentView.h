//
//  SaiDanCommentView.h
//  ICSON
//
//  Created by 肖晓春 on 15/5/13.
//  Copyright (c) 2015年 肖晓春. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCommentStarView.h"
@protocol SaiDanCommentViewDelegate <NSObject>

@optional
//- (void) commentCellSubmitButtonDidTouched;
- (void) commentkeyBoardDismiss;

@end

@interface SaiDanCommentView : UIView<UITextViewDelegate>
@property (strong, nonatomic) IBOutlet GCommentStarView *starView;
@property (strong, nonatomic) IBOutlet UITextView *inputTextView;
@property (strong, nonatomic) IBOutlet UILabel *countNumberLabel;
@property (strong, nonatomic) IBOutlet UIButton *keboardDismiss;
@property (strong, nonatomic) IBOutlet UIButton *keboardCancel;
@property (nonatomic,strong)UILabel *placeholdLabel;
@property (nonatomic, assign) id<SaiDanCommentViewDelegate> delegate;
- (IBAction)keyboardDismiss:(id)sender;
- (void)refresh;
- (int) getStarValue;
@end
