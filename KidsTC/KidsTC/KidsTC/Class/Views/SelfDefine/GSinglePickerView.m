//
//  GSinglePickerView.m
//  iphone51buy
//
//  Created by icson apple on 12-7-2.
//  Copyright (c) 2012年 icson. All rights reserved.
//

#import "GSinglePickerView.h"
#import "GBarButtonItem.h"

@implementation GSinglePickerView
@synthesize delegate;

- (id)init
{
    self = [super initWithFrame: CGRectMake(0.0, 480.0, [UIScreen mainScreen].bounds.size.width, 216.0)];
    if (self) {
        CGFloat toolbarHeight = 44.0f;
		toolbar = [[GToolbar alloc] initWithFrame: CGRectMake(0.0, 0.0, 0.0, toolbarHeight)];
		[toolbar setAutoresizingMask: UIViewAutoresizingFlexibleWidth];
		[toolbar setBackgroundColor: [UIColor clearColor]];
		[toolbar setTintColor:RGBA(208.0f, 235.0f, 253.0f, 1.0f)];
		
		UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target: nil action: nil];
		GBarButtonItem *cancelBtn = [[GBarButtonItem alloc] initWithTitle: @"取消" target: self action:@selector(actionCancel:)];
		GBarButtonItem *doneBtn = [[GBarButtonItem alloc] initWithTitle: @"确定" target: self action: @selector(actionDone:)];
		
		NSArray *toolItems = [NSArray arrayWithObjects: spaceItem, cancelBtn, doneBtn, nil];
		[toolbar setItems: toolItems];
		
		actionSheet = [[UIActionSheet alloc] initWithTitle:nil 
												  delegate:nil
										 cancelButtonTitle:nil
									destructiveButtonTitle:nil
										 otherButtonTitles:nil];
		
		[actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
		[actionSheet setFrame:CGRectZero];
        
		picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44.0, [UIScreen mainScreen].bounds.size.width, 0)];
		picker.dataSource = self;
		picker.delegate = self;
		picker.showsSelectionIndicator = YES;
        
		[actionSheet addSubview: toolbar];
		[actionSheet addSubview: picker];
//        actionSheet.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height-toolbarHeight-pickerHeight, CGRectGetWidth(actionSheet.frame), toolbarHeight+pickerHeight);
		currentRow = -1;
    }
    
    return self;
}

- (void)actionCancel:(id)sender
{
	BOOL killSelf = YES;
	if (delegate && [delegate respondsToSelector: @selector(gSinglePickerViewCanceled:)]) {
		killSelf = [delegate gSinglePickerViewCanceled: self];
	}

	if (killSelf) {
		[actionSheet dismissWithClickedButtonIndex: [actionSheet cancelButtonIndex] animated: YES];
	}
}

- (void)actionDone:(id)sender
{
	BOOL killSelf = YES;
	if (delegate && currentRow != -1 && [delegate respondsToSelector: @selector(gSinglePickerView:selectedRow:)]) {
		killSelf = [delegate gSinglePickerView: self selectedRow: currentRow];
	}
	
	if (killSelf) {
		[actionSheet dismissWithClickedButtonIndex: [actionSheet cancelButtonIndex] animated: YES];
	}
}

- (void)dealloc
{
	 actionSheet = nil;
}

- (void)selectPickerRow:(NSInteger)row
{
	dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.001);
	dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
		[picker selectRow: row inComponent: 0 animated: YES];
	});
}

- (void)show
{
    [self showWithRow:0];
}

- (void)showWithRow:(int)row
{
    [picker reloadAllComponents];
    
	currentRow = row;
	[self selectPickerRow:currentRow];
    
	UIWindow *wd = [[UIApplication sharedApplication] keyWindow];
	[actionSheet showInView: wd];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat toolBarHeight = 44.0f;
    CGFloat pickerHeight = 216.0f;
    [actionSheet setFrame:CGRectMake(0, screenHeight-toolBarHeight-pickerHeight, screenWidth, toolBarHeight+pickerHeight)];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
		currentRow = row;
    }
}

#pragma mark UIPickerViewDataSource

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
	if (delegate) {
		return [delegate gSinglePickerView: self viewForRow: row reuseView: view];
	}
	
    return nil;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        if (delegate) {
			return [delegate rowCountForGSinglePickerView: self];
		}

		return 0;
    }

    return 0;
	
}

@end
