//
//  GCommonFilterView.m
//  iphone51buy
//
//  Created by CGS on 12-5-23.
//  Copyright (c) 2012年 icson. All rights reserved.
//

#import "GCommonFilterView.h"
#import "GCommonFilterOption.h"

#define GCommonFilterViewCellHeight 50.0

@implementation GCommonFilterViewCell
@synthesize attrInfo, titleLabel, contentLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	if (self = [super initWithStyle: style reuseIdentifier: reuseIdentifier widthNoCustomBorder:YES]) {
		titleLabel = MAKE_LABEL(CGRectMake(28.0, 15.0, 120.0, GCommonFilterViewCellHeight), @"", COLOR_BLUE, 16.0);
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.shadowColor = [UIColor blackColor];
        titleLabel.shadowOffset = CGSizeMake(0, -1);
		contentLabel = MAKE_LABEL(CGRectMake(128.0, 15.0, 128.0, GCommonFilterViewCellHeight), @"", COLOR_BLUE, 15.0);
        contentLabel.backgroundColor = [UIColor clearColor];
        contentLabel.shadowColor = [UIColor blackColor];
        contentLabel.shadowOffset = CGSizeMake(0, -1);
		
		[self.contentView addSubview: titleLabel];
		[self.contentView addSubview: contentLabel];
        
        _sepLineImg = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"filter_line1.png"]] autorelease];
        _sepLineImg.frame = CGRectMake(0.0, 50.0, 270, 1);
        [self.contentView addSubview: _sepLineImg];
        
        _selArrow = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"filter_arrow_4.png"]] autorelease];
        _selArrow.frame = CGRectMake(10.0, 20.0, 11, 10);
        [self.contentView addSubview: _selArrow];
        
        _accessImg = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"filter_arrow_2.png"]] autorelease];
        _accessImg.frame = CGRectMake(0, 0, 13, 9);
		UIView *custom = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 23, 10)];
		custom.backgroundColor = [UIColor clearColor];
		[custom addSubview:_accessImg];
        self.accessoryView = custom;
		[custom release];
	}
	
	return self;
}

@end

@implementation GCommonFilterView
@synthesize controllerDelegate;

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
	if (self = [super initWithFrame: frame style: style]) {
		[self setDataSource: self];
		[self setDelegate: self];
		
		[self setSeparatorStyle: UITableViewCellSeparatorStyleNone];
		[self setBackgroundColor: [UIColor whiteColor]];
	}
	
	return self;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return GCommonFilterViewCellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (controllerDelegate) {
		return [[controllerDelegate filterListForGCommonFilterView: self] count];
	}
    
	return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSArray *filterList = nil;
	if (controllerDelegate) {
		filterList = [controllerDelegate filterListForGCommonFilterView: self];
	}
    
	if (!filterList) {
		return nil;
	}
    
	NSUInteger row = [indexPath row];
	if (row >= [filterList count]) {
		return nil;
	}

    GCommonFilterAttr *attrInfo = [filterList objectAtIndex: row];
    
	static NSString *CellWithIdentifierFilterCell = @"CellWithIdentifierFilterCell";
	GCommonFilterViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellWithIdentifierFilterCell];
	if (cell == nil) {
		cell = [[[GCommonFilterViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: CellWithIdentifierFilterCell] autorelease];
	}

	[cell.titleLabel setText: [attrInfo attrName]];
    [cell.titleLabel sizeToFit];

    NSMutableArray *optionValueTxt = [NSMutableArray array];
    if ([attrInfo optionList]) {
        for (NSInteger i = 0; i < [[attrInfo optionList] count]; i++) {
            GCommonFilterOption *optionValue = [[attrInfo optionList] objectAtIndex: i];
            if (optionValue.selected) {
                [optionValueTxt addObject: optionValue.optionName];
            }
        }
    }

    NSString *optionValueTxtStr = [optionValueTxt componentsJoinedByString: @"、"];
    if ([optionValueTxt count] == 0) {
        optionValueTxtStr = @"";
    } else {
        optionValueTxtStr = [NSString stringWithFormat: @"(%@)", optionValueTxtStr];
    }
    
    [cell.contentLabel setText: optionValueTxtStr];
    [cell.contentLabel sizeToFit];
    CGRect oldContentRect = cell.contentLabel.frame;
    oldContentRect.origin.x = cell.titleLabel.frame.origin.x + cell.titleLabel.frame.size.width + 8.0;
    oldContentRect.size.width = 240.0 - oldContentRect.origin.x;
    [cell.contentLabel setFrame: oldContentRect];

	return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSUInteger row = [indexPath row];
	if (controllerDelegate) {
		[controllerDelegate gCommonFilterView: self selectedRow: row];
	}
}
@end
