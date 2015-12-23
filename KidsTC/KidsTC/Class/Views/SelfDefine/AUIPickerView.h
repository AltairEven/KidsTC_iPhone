//
//  AUIPickerView.h
//  KidsTC
//
//  Created by 钱烨 on 7/16/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AUIPickerView;

@protocol AUIPickerViewDataSource <NSObject>

@required
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(AUIPickerView *)pickerView;

// returns the # of rows in each component..
- (NSInteger)pickerView:(AUIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;

@optional

// returns width of column and height of row for each component.
- (CGFloat)pickerView:(AUIPickerView *)pickerView widthForComponent:(NSInteger)component;
- (CGFloat)pickerView:(AUIPickerView *)pickerView rowHeightForComponent:(NSInteger)component;

// these methods return either a plain NSString, a NSAttributedString, or a view (e.g UILabel) to display the row for the component.
// for the view versions, we cache any hidden and thus unused views and pass them back for reuse.
// If you return back a different object, the old one will be released. the view will be centered in the row rect
- (NSString *)pickerView:(AUIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
- (NSAttributedString *)pickerView:(AUIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component NS_AVAILABLE_IOS(6_0); // attributed title is favored if both methods are implemented
- (UIView *)pickerView:(AUIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view;

@end

@protocol AUIPickerViewDelegate <NSObject>

@optional

- (void)didCanceledPickerView:(AUIPickerView *)pickerView;

- (void)pickerView:(AUIPickerView *)pickerView didConfirmedWithSelectedIndexArrayOfAllComponent:(NSArray *)indexArray;

@end

@interface AUIPickerView : UIView

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) UIFont *font;

@property (nonatomic, assign) id<AUIPickerViewDataSource> dataSource;

@property (nonatomic, assign) id<AUIPickerViewDelegate> delegate;

- (instancetype)initWithDataSource:(id<AUIPickerViewDataSource>)dataSource delegate:(id<AUIPickerViewDelegate>)delegate;

- (void)show;

@end
