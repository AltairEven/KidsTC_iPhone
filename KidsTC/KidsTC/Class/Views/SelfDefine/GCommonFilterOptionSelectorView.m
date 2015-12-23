//
//  GCommonFilterOptionSelectorView.m
//  iphone51buy
//
//  Created by CGS on 12-5-23.
//  Copyright (c) 2012年 icson. All rights reserved.
//

#import "GCommonFilterOptionSelectorView.h"

@implementation GCommonFilterOptionSelectorViewCell
@synthesize optionInfo, gTableView;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier widthNoCustomBorder:YES];
    if (self) {
		self.textLabel.font = [UIFont systemFontOfSize: 15.0];
		self.textLabel.highlightedTextColor = self.textLabel.textColor = [UIColor colorWithWhite:190.0/255.0 alpha:1];
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor colorWithRed:34.0f/255.0f green:34.0f/255.0f blue:34.0f/255.0f alpha:1.0f];
        _sepLineImg = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"filter_line2.png"]] autorelease];
        _sepLineImg.frame = CGRectMake(10.0, 50.0, 250, 1);
        [self.contentView addSubview:_sepLineImg];
        
		GCheckBox *accView = [[GCheckBox alloc] initWithFrame: CGRectMake(0.0, 0.0, 28.0, 28.0)];
		[accView addTarget: self action: @selector(accessoryButtonTapped:withEvent:) forControlEvents: UIControlEventTouchUpInside];
		self.accessoryView = accView;
        [accView release];
    }
    
    return self;
}

- (void)setAccessoryType:(UITableViewCellAccessoryType)accessoryType
{
    [super setAccessoryType: accessoryType];

    if (accessoryType != UITableViewCellAccessoryCheckmark) {
		[((GCheckBox *)self.accessoryView) setChecked: NO];

        if (optionInfo) {
            [optionInfo setSelected: NO];
        }
		self.textLabel.highlightedTextColor = self.textLabel.textColor = [UIColor colorWithWhite:190.0/255.0 alpha:1];
    } else {
		[((GCheckBox *)self.accessoryView) setChecked: YES];
		self.textLabel.highlightedTextColor = self.textLabel.textColor = COLOR_BLUE;

        if (optionInfo) {
            [optionInfo setSelected: YES];
        }
    }
}

- (void) accessoryButtonTapped: (UIControl *) button withEvent: (UIEvent *) event
{
    if (!gTableView) {
        return;
    }

    NSIndexPath * indexPath = [gTableView indexPathForRowAtPoint: [[[event touchesForView: button] anyObject] locationInView: gTableView]];
    if ( indexPath == nil )
        return;

	if (gTableView.delegate && [gTableView.delegate respondsToSelector: @selector(tableView:accessoryButtonTappedForRowWithIndexPath:)]) {
		[gTableView.delegate tableView: gTableView accessoryButtonTappedForRowWithIndexPath: indexPath];
	}
}

- (void)toggleAccessoryType
{
    UITableViewCellAccessoryType type = self.accessoryType == UITableViewCellAccessoryCheckmark ? UITableViewCellAccessoryNone : UITableViewCellAccessoryCheckmark;
    [self setAccessoryType: type];
}

- (void)setOptionInfo:(GCommonFilterOption *)_optionInfo
{
    if (optionInfo) {
        [optionInfo release];
    }

    optionInfo = [_optionInfo retain];

    NSString * str = [NSString stringWithFormat:@"     %@", [optionInfo optionName]];
    [self.textLabel setText:str];
    if (optionInfo.selected) {
        [self setAccessoryType: UITableViewCellAccessoryCheckmark];
    } else {
        [self setAccessoryType: UITableViewCellAccessoryNone];
    }
}


- (void)dealloc
{
    if (optionInfo) {
        [optionInfo release]; optionInfo = nil;
    }

    [super dealloc];
}

@end

@implementation GCommonFilterOptionSelectorView
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
	return 55.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (controllerDelegate) {
		return [[controllerDelegate optionsListForGCommonFilterOptionSelectorView: self] count];
	}
    
	return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSArray *optionsList = nil;
	if (controllerDelegate) {
		optionsList = [controllerDelegate optionsListForGCommonFilterOptionSelectorView: self];
	}
    
	if (!optionsList) {
		return nil;
	}
    
	NSUInteger row = [indexPath row];
	if (row >= [optionsList count]) {
		return nil;
	}
    
    GCommonFilterOption *optionInfo = [optionsList objectAtIndex: row];
    if (!optionInfo) {
        return nil;
    }

	static NSString *CellWithIdentifierFilterSelectorCell = @"CellWithIdentifierFilterSelectorCell";
	GCommonFilterOptionSelectorViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellWithIdentifierFilterSelectorCell];
	if (cell == nil) {
		cell = [[[GCommonFilterOptionSelectorViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: CellWithIdentifierFilterSelectorCell] autorelease];
        [cell setGTableView: self];
	}

    [cell setOptionInfo: optionInfo];
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
		[controllerDelegate gCommonFilterOptionSelectorView: self selectedRow: row];
	}

    [(GCommonFilterOptionSelectorViewCell *)[tableView cellForRowAtIndexPath: indexPath] toggleAccessoryType];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [(GCommonFilterOptionSelectorViewCell *)[tableView cellForRowAtIndexPath: indexPath] toggleAccessoryType];
}
@end
