//
//  AUIKeyboardAdhesiveView.h
//  KidsTC
//
//  Created by 钱烨 on 10/29/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AUIKeyboardAdhesiveViewExtensionFunction;
@class AUIKeyboardAdhesiveView;

typedef enum {
    AUIKeyboardAdhesiveViewExtensionFunctionTypeEmotionEdit,
    AUIKeyboardAdhesiveViewExtensionFunctionTypeImageUpload
}AUIKeyboardAdhesiveViewExtensionFunctionType;

@protocol AUIKeyboardAdhesiveViewDelegate <NSObject>

@optional

- (void)keyboardAdhesiveViewWillShrink:(AUIKeyboardAdhesiveView *)view;

- (void)keyboardAdhesiveViewDidShrink:(AUIKeyboardAdhesiveView *)view;

- (void)keyboardAdhesiveView:(AUIKeyboardAdhesiveView *)view didClickedExtensionFunctionButtonWithType:(AUIKeyboardAdhesiveViewExtensionFunctionType)type;

- (void)didClickedSendButtonOnKeyboardAdhesiveView:(AUIKeyboardAdhesiveView *)view;

- (void)keyboardAdhesiveView:(AUIKeyboardAdhesiveView *)view didClickedUploadImageAtIndex:(NSUInteger)index;

@end


@interface AUIKeyboardAdhesiveView : UIView

@property (nonatomic, assign) id<AUIKeyboardAdhesiveViewDelegate> delegate;

@property (nonatomic, copy) NSString *placeholder; //default nil

@property (nonatomic, assign) NSUInteger textLimitLength; //default INT64_MAX

@property (nonatomic, copy) NSString *text;

@property (nonatomic, assign) NSUInteger uploadImageLimitCount; //default 10

@property (nonatomic, strong) NSArray *uploadImages;

@property (nonatomic, strong, readonly) NSArray<AUIKeyboardAdhesiveViewExtensionFunction *> *availableExtFuntions;

- (instancetype)initWithAvailableFuntions:(NSArray<AUIKeyboardAdhesiveViewExtensionFunction *> *)funtions;

- (void)setHeaderBGColor:(UIColor *)color;

- (void)expand;

- (void)shrink;

- (void)destroy;

@end


@interface AUIKeyboardAdhesiveViewExtensionFunction : NSObject

@property (nonatomic, assign) AUIKeyboardAdhesiveViewExtensionFunctionType type;

@property (nonatomic, copy) NSString *functionName;

@property (nonatomic, strong) UIImage *icon;

+ (instancetype)funtionWithType:(AUIKeyboardAdhesiveViewExtensionFunctionType)type;

@end