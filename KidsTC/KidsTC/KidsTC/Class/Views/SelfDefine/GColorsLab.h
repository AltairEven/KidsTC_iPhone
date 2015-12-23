//
//  GColorsLab.h
//  iphone51buy
//
//  Created by gene chu on 9/10/12.
//  Copyright (c) 2012 icson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GColorsLab : UIView
@property (nonatomic,strong)UIFont *font;
@property (strong, nonatomic,readonly)NSString *text;
@property (nonatomic,readonly)int numberOfLine;
@property (nonatomic)float lineHeight;
@property (nonatomic)BOOL autoFitHeight;

- (void)setTextAndColor:(id)firstArg,... NS_REQUIRES_NIL_TERMINATION;
- (void)setTexts:(NSArray *)texts andColors:(NSArray *)colors;
- (float)fitHeight;
@end
