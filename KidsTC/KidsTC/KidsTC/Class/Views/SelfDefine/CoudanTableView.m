//
//  CoudanTableView.m
//  iPhone51Buy
//
//  Created by Bai Haoquan on 13-9-4.
//  Copyright (c) 2013年 icson. All rights reserved.
//

#import "CoudanTableView.h"
#import "TTTAttributedLabel.h"
#import "NSAttributedString+Attributes.h"

static const int kBGImageViewTag = 31415;
static const CGFloat kXSidePadding = 10.0f;
static const CGFloat kYSidePadding = 10.0f;
static const CGFloat kLabelFontSize = 15.0f;

@interface CoudanTableView ()
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSMutableArray *seperateLineArr;
@property (nonatomic) CoudanTableViewType coudanType;
@end

@implementation CoudanTableView

+ (NSString *)combineCoudanStrWith:(NSDictionary *)itemInfo
{
    NSMutableString *mutableStr= [NSMutableString string];
	NSString *string = @"仅需再消费";
	[mutableStr appendString:string];
    
	NSInteger buyMore= [[itemInfo objectForKey:@"buy_more"] integerValue];
	string = [NSString stringWithFormat:@"%.2f",buyMore/100.0f];
	[mutableStr appendString:string];
	
	string = @"元即可参与";
	[mutableStr appendString:string];
    
	string = [itemInfo objectForKey:@"name"];
	string = [NSString stringWithFormat:@"%@  ",string];//add space
	[mutableStr appendString:string];
    
	NSString *lastString = [NSString stringWithFormat:@"%@", mutableStr];
    return lastString;
}

+ (CGFloat)getCoudanTableViewHeightWithData:(NSArray *)data coudanType:(CoudanTableViewType)type andConstraintWidth:(CGFloat)width {
    
    CGFloat totalHeight = 0;
    for (NSDictionary *item in data)
    {
        NSString *ruleName = @"";
        if (type == CoudanTypeProductDetail)
        {
            ruleName = [item objectForKey:@"name"];
        }
        else
        {
            ruleName = [[self class] combineCoudanStrWith:item];
        }
        CGSize labelSize = [ruleName boundingRectWithSize:CGSizeMake(width-3*kXSidePadding, width) options:(NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]} context:NULL].size;
        totalHeight += 2*kYSidePadding + labelSize.height + 15;
    }
    
    return totalHeight;
}

- (id)initWithData:(NSArray *)data delegate:(id<CoudanTableViewDelegate>)delegate coudanType:(CoudanTableViewType)type andConstraintWidth:(CGFloat)width {
    
    if (self = [super init])
    {
        CGRect oldRect = self.frame;
        oldRect.size.width = CGRectGetWidth([[UIScreen mainScreen] bounds]);
        self.frame = oldRect;
        self.data = data;
        self.seperateLineArr = [NSMutableArray array];
        self.delegate = delegate;
        self.coudanType = type;
        
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCoudanCell:)];
        [self addGestureRecognizer:tapGR];
        
        [self setWidth:width];
        [self layoutSubviewsWithData:data];
    }
    return self;
}

- (void)layoutSubviewsWithData:(NSArray *)data {
    
    self.data = data;
    [self.seperateLineArr removeAllObjects];
    for (UIView *subView in self.subviews)
    {
        [subView removeFromSuperview];
    }
    
    CGFloat totalHeight = 0;
    for (NSDictionary *item in self.data)
    {
        NSString *ruleName = @"";
        UILabel *contentLabel = nil;
        CGSize labelSize;
        if (self.coudanType == CoudanTypeProductDetail)
        {
            ruleName = [item objectForKey:@"name"];
            labelSize = [ruleName boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.frame)-3*kXSidePadding, 1000) options:(NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]} context:NULL].size;
            contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(kXSidePadding, totalHeight+kYSidePadding, labelSize.width, labelSize.height)];
            contentLabel.numberOfLines = 0;
            [contentLabel setTextColor:COLOR_EBLACK];
            [contentLabel setFont:[UIFont systemFontOfSize:kLabelFontSize]];
            [contentLabel setText:ruleName];
            [contentLabel setBackgroundColor:[UIColor clearColor]];
            [self addSubview:contentLabel];
        }
        else
        {
            ruleName = [[self class] combineCoudanStrWith:item];
            
            TTTAttributedLabel *label = [[TTTAttributedLabel alloc] init];
            label.lineBreakMode = NSLineBreakByCharWrapping;
            label.numberOfLines = 0;
            label.backgroundColor = [UIColor clearColor];
            label.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;
            NSMutableAttributedString *morePromoRule = [[NSMutableAttributedString alloc] initWithString:@""];
            labelSize = [ruleName boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.frame)-2*kXSidePadding, 1000) options:(NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:8.0f]} context:NULL].size;
            
            NSString *string = @"仅需再消费";
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
            [attrString setTextColor:[UIColor colorWithRed:51.0f/255 green:51.0f/255 blue:51.0f/255 alpha:1.0f]];
            [attrString setFont:[UIFont systemFontOfSize:14.0f]];
            [morePromoRule appendAttributedString:attrString];
            
            NSInteger buyMore = [[item objectForKey:@"buy_more"] integerValue];
            string = [NSString stringWithFormat:@"%.2f",buyMore/100.0f];
            attrString = [[NSMutableAttributedString alloc] initWithString:string];
            [attrString setTextColor:[UIColor colorWithRed:255.0f/255 green:102.0f/255 blue:0/255 alpha:1.0f]];
            [attrString setFont:[UIFont systemFontOfSize:14.0f]];
            [morePromoRule appendAttributedString:attrString];
            
            string = @"元即可参与";
            attrString = [[NSMutableAttributedString alloc] initWithString:string];
            [attrString setTextColor:[UIColor colorWithRed:51.0f/255 green:51.0f/255 blue:51.0f/255 alpha:1.0f]];
            [attrString setFont:[UIFont systemFontOfSize:14.0f]];
            [morePromoRule appendAttributedString:attrString];
            
            string = [item objectForKey:@"name"];
            string = [NSString stringWithFormat:@"%@  ",string];//add space
            attrString = [[NSMutableAttributedString alloc] initWithString:string];
            [attrString setTextColor:[UIColor colorWithRed:255.0f/255 green:102.0f/255 blue:0/255 alpha:1.0f]];
            [attrString setFont:[UIFont systemFontOfSize:14.0f]];
            [morePromoRule appendAttributedString:attrString];
            
            label.text = morePromoRule;
            [label sizeToFit];
            labelSize = [label sizeThatFits:labelSize];
            
            label.frame = CGRectMake(kXSidePadding, totalHeight+kYSidePadding, CGRectGetWidth(self.frame)-2*kXSidePadding,labelSize.height);
            [self addSubview:label];
            contentLabel = label;
        }
        totalHeight += 2*kYSidePadding + labelSize.height;
        
        if (item != [self.data lastObject]) {
            
            UILabel *seperateLine = [[UILabel alloc]initWithFrame:CGRectMake(0,0, self.frame.size.width, 0.5f)];
            seperateLine.backgroundColor = [UIColor colorWithRed:226.0f/255 green:225.0f/255 blue:230.0f/255 alpha:1];
            [seperateLine setWidth:CGRectGetWidth(self.frame)-kXSidePadding height:0.5];
            [self addSubview:seperateLine];
            [seperateLine moveToHorizontal:CGRectGetWidth([[UIScreen mainScreen] bounds])/2-CGRectGetWidth(seperateLine.frame)/2 toVertical:CGRectGetMaxY(contentLabel.frame)+kYSidePadding];
            
            [self.seperateLineArr addObject:seperateLine];
        }
    }
    
    [self setWidth:CGRectGetWidth([[UIScreen mainScreen] bounds]) height:totalHeight];
}

- (void)tapCoudanCell:(UIGestureRecognizer *)tapGR {
    
    //edit by Altair, 20141125, don't jump to web view
}

@end

