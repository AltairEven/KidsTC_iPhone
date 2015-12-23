//
//  GSinglePickerView.h
//  iphone51buy
//
//  Created by icson apple on 12-7-2.
//  Copyright (c) 2012年 icson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GToolbar.h"

@class GSinglePickerView;
@protocol GSinglePickerViewDelegate <NSObject>

@required
- (UIView *)gSinglePickerView:(GSinglePickerView *)_gSinglePickerView viewForRow:(NSInteger)row reuseView:(UIView *)view;
- (BOOL)gSinglePickerView:(GSinglePickerView *)_gSinglePickerView selectedRow:(NSInteger)row;
- (NSInteger)rowCountForGSinglePickerView:(GSinglePickerView *)_gSinglePickerView;

@optional
- (BOOL)gSinglePickerViewCanceled:(GSinglePickerView *)_gSinglePickerView;

@end

@interface GSinglePickerView : UIView<UIPickerViewDelegate, UIPickerViewDataSource>
{
	GToolbar *toolbar;
	UIActionSheet *actionSheet;
	UIPickerView *picker;

	NSInteger currentRow;
}

@property (weak, nonatomic) id<GSinglePickerViewDelegate> delegate;
- (void)show;
- (void) showWithRow:(int) row;
- (void)selectPickerRow:(NSInteger)row;
@end
