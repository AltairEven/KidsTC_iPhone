//
//  PlaceHolderTextView.h
//  iPhone51Buy
//
//  Created by Bai Haoquan on 13-4-23.
//  Copyright (c) 2013年 icson. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class PlaceHolderTextView;
//@protocol PlaceHolderTextViewDelegate <NSObject>
//@optional
//- (BOOL)placeHolderTextViewShouldBeginEditing:(PlaceHolderTextView *)placeHolderTextView;
//- (BOOL)placeHolderTextViewShouldEndEditing:(PlaceHolderTextView *)placeHolderTextView;
//- (void)placeHolderTextViewDidBeginEditing:(PlaceHolderTextView *)placeHolderTextView;
//- (void)placeHolderTextViewDidEndEditing:(PlaceHolderTextView *)placeHolderTextView;
//- (BOOL)placeHolderTextView:(PlaceHolderTextView *)placeHolderTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
//- (void)placeHolderTextViewDidChange:(PlaceHolderTextView *)placeHolderTextView;
//- (void)placeHolderTextViewDidChangeSelection:(PlaceHolderTextView *)placeHolderTextView;

//@end
@interface PlaceHolderTextView : UITextView <UITextViewDelegate>
@property (nonatomic, copy) NSString *placeHolderStr;
@property (nonatomic, strong) UIFont *placeHolderFont;
@property (nonatomic, strong) UIColor *placeHolderColor;
@property (nonatomic, strong) UIFont *contentFont;
@property (nonatomic, strong) UIColor *contentColor;
@property (nonatomic) BOOL isPlaceHolderState;

@end
