//
//  GEventPageView.h
//  iphone51buy
//
//  Created by icson apple on 12-6-11.
//  Copyright (c) 2012年 icson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GEventHome.h"
#import "IcsonImageView.h"
#import "GTableViewCell.h"
#import "GEventPageViewCell1View.h"
#import "GEventPageViewCell1.h"
#import "GEventPageViewCell2.h"

@class GEventPageView;
@protocol GEventPageViewDelegate <NSObject>
@optional
-(void)gEventPageView:(GEventPageView *)gEventPageView goProduct:(NSString *)productId atItem:(GEventPageViewCell1View *)itemView;
-(void)gEventPageView:(GEventPageView *)gEventPageView goSearch:(NSDictionary *) seachCondition withTitle:(NSString *)title atIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)currentPageForGEventPage:(GEventPageView *)gEventPage;
- (NSInteger)pageCountForGEventPage:(GEventPageView *)gEventPage;
- (void)getNextPageForEventPage:(GEventPageView *)gEventPage;
@end

@interface GEventPageView : UIView<UITableViewDelegate, UITableViewDataSource, IcsonImageDelegate>
{
	GEventTemplate gtemplate;
	NSDictionary *data;

	// template为1，商品列表
	UITableView *listTable;

	// template为2，图+入口列表
	IcsonImageView *advImage;
	// listTable

	// template为3，背景+商品列表
	// advImage
	// listTable

	NSUInteger showImageAtHeader;
	UIColor *baseColor;
	
	CGFloat _imageHeight;
}

@property (weak, nonatomic) id<GEventPageViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame template:(GEventTemplate)_template data:(NSDictionary *)_data;
- (void)reloadEventPage;
- (void)setTemplate:(GEventTemplate)_template data:(NSDictionary *)_data;
@end
