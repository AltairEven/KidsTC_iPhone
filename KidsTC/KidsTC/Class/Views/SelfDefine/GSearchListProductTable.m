//
//  GSearchListProductTable.m
//  iphone
//
//  Created by icson apple on 12-3-14.
//  Copyright (c) 2012年 icson. All rights reserved.
//

#import "GSearchListProductTable.h"

@implementation GSearchListProductTable
@synthesize controllerDelegate, loadmoreCell;

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
	if (self = [super initWithFrame: frame style: style]) {
		[self setDelegate: self];
		[self setDataSource: self];
	}
	
	return self;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSArray *arrList = nil;
    if (controllerDelegate) {
        arrList = [controllerDelegate productListForGSearchListProductTable: self];
    }

    if (!arrList) {
        return 0.0;
    }
	
	NSUInteger row = [indexPath row];
    NSInteger count = [arrList count];
    if (row == count) {
        return 40.0;
    } else if(row > count){
        return 0.0;
    } else {
        return 100;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{	
	NSArray *arrList = nil;
    if (controllerDelegate) {
        arrList = [controllerDelegate productListForGSearchListProductTable: self];
    }

    if (!arrList) {
        return 0;
    }

    if (controllerDelegate) {
        if ([controllerDelegate currentPageForGSearchListProductTable: self] < [controllerDelegate pageCountForGSearchListProductTable: self]) {
            return [arrList count] + 1;
        }
    }

    return [arrList count];
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSArray *arrList = nil;
    if (controllerDelegate) {
        arrList = [controllerDelegate productListForGSearchListProductTable: self];
    }
    if (!arrList) {
        return nil;
    }

	NSUInteger row = [indexPath row];
    NSInteger count = [arrList count];
	
    if (row == count) {
        static NSString *CellIdentifierMore = @"searchCellMore";
        if (!loadmoreCell) {
            loadmoreCell = [_tableView dequeueReusableCellWithIdentifier: CellIdentifierMore];
            if (loadmoreCell == nil) {
                loadmoreCell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: CellIdentifierMore];
            }
        }

		[loadmoreCell.contentView showLoading: @"正在加载中..." size: GViewLoadingSizeSmall];
		if (controllerDelegate) {
			[controllerDelegate nextPageForGSearchListProductTable: self];
		}

        return loadmoreCell;
    } else if( row > count){
        return nil;
    }
	
    static NSString *CellIdentifier = @"searchCell";
	NSDictionary *productInfo = [arrList objectAtIndex: row];
    SearchListViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SearchListViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
	[cell setProductInfo: productInfo];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSUInteger row = [indexPath row];
    if (controllerDelegate) {
        [controllerDelegate gSearchListProductTable: self selectedRow: row];
    }
}

@end
