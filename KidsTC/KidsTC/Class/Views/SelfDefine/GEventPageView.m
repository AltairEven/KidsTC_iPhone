//
//  GEventPageView.m
//  iphone51buy
//
//  Created by icson apple on 12-6-11.
//  Copyright (c) 2012年 icson. All rights reserved.
//

#import "GEventPageView.h"


@implementation GEventPageView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame template:(GEventTemplate)_template data:(NSDictionary *)_data
{
    self = [super initWithFrame:frame];
    if (self) {
        gtemplate = _template;
		data = _data;

		listTable = [[UITableView alloc] initWithFrame: CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height) style: UITableViewStylePlain];
		[listTable setDelegate: self];
		[listTable setDataSource: self];
		[listTable setSeparatorStyle: UITableViewCellSeparatorStyleNone];
		[self addSubview: listTable];

		[self reloadEventPage];
    }
    return self;
}

- (void)dealloc
{
    advImage.imgDelegate = nil;
	 advImage = nil;
	 data = nil;
	if (baseColor) {
		 baseColor = nil;
	}
}

- (void)imageViewLoaded:(IcsonImageView *)gImageView size:(CGSize)_size
{
	
	_imageHeight = _size.height *  self.frame.size.width / _size.width;
 
	[advImage setFrame: CGRectMake(0.0, 0.0, self.frame.size.width, _imageHeight )];

	showImageAtHeader = 2;
	
	[listTable setTableHeaderView:advImage];
	
	//	[listTable reloadData];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (gtemplate != GEventTemplateType3) {
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 1)];
        view.backgroundColor = RGBA(233.0, 233.0, 233.0, 1.0);
        return  view;
    }
	return nil;
	
	
	if( showImageAtHeader ){
		if (showImageAtHeader == 1) {
			[advImage loadAsyncImage: [data objectForKey: @"advertise_url"]];
		}
		
		return advImage;
	}
	
	return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (gtemplate != GEventTemplateType3) {
        return  1;
    }
	return  0;// showImageAtHeader == 2 ? _imageHeight : 0.5;
}


- (void)reloadEventPage
{
	[listTable setFrame: CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height)];
	showImageAtHeader = 0;

	if (baseColor) {
		 baseColor = nil;
	}

	if(gtemplate == GEventTemplateType2 || gtemplate == GEventTemplateType3){
		if (![GToolUtil isEmpty: [data objectForKey: @"advertise_url"]]) {
			showImageAtHeader = 1;
		}
	}

	if (gtemplate == GEventTemplateType3) {
		if (![GToolUtil isEmpty: [data objectForKey: @"background"]]) {
			baseColor = [UIColor colorWithNSInteger: [[data objectForKey: @"background"] unsignedIntegerValue]];
		}
	}
 

	if( showImageAtHeader ){
		 
        if (nil == advImage) {
            advImage = [[IcsonImageView alloc] initWithFrame: CGRectZero];
            advImage.imgDelegate = self;
            listTable.tableHeaderView = advImage;
        }
        advImage.clickDownloadMode = YES;
        [advImage loadAsyncImage: [data objectForKey: @"advertise_url"]];
	}
	
	[listTable setBackgroundColor: baseColor ? baseColor : [UIColor whiteColor]];
	[listTable reloadData];
}

- (void)setTemplate:(GEventTemplate)_template data:(NSDictionary *)_data
{
	gtemplate = _template;

	 data = nil;
	data = _data;

	[self reloadEventPage];
}

- (void)clickProduct:(UIGestureRecognizer*)sender
{
	GEventPageViewCell1View *itemView = (GEventPageViewCell1View*)sender.view;
	if (delegate && [itemView.itemInfo objectForKey: @"product_id"]) {
        [delegate gEventPageView:self goProduct:IDTOSTRING(itemView.itemInfo[@"product_id"]) atItem:itemView];
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//	if (showImageAtHeader && [indexPath row] == 0) {
//		return advImage.frame.size.height;
//	}

	if (gtemplate == GEventTemplateType2) {
		return 80.0;
	} else {
        if ([indexPath row] == ceilf([[data objectForKey: @"products"] count] / 3.0f))
        {
            return 40.0f;
        }
        else
        {
            return 160.0;
        }
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (![data objectForKey: @"products"]) {
		return 0;
	}

	NSInteger count = [[data objectForKey: @"products"] count];
	if (gtemplate == GEventTemplateType2) {
		//return count + (showImageAtHeader ? 1 : 0);
		return count;
	} else {
		//+ (showImageAtHeader ? 1 : 0);
        if ([delegate respondsToSelector:@selector(currentPageForGEventPage:)] && [delegate respondsToSelector:@selector(pageCountForGEventPage:)])
        {
            if ([delegate currentPageForGEventPage:self] < [delegate pageCountForGEventPage:self])
            {
                return count / 3 + 1;
            }
        }

        return ceilf(count / 3.0f);
	}
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSUInteger row = [indexPath row];
//	if (showImageAtHeader && row == 0) {
//		static NSString *EventPageTableCellIdentifierImg = @"EventPageTableCellIdentifierImg";
//		GTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: EventPageTableCellIdentifierImg];
//		if (!cell) {
//			cell = [[GTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: EventPageTableCellIdentifierImg widthNoCustomBorder: NO];
//			[cell.contentView addSubview: advImage];
//		}
//
//		if (showImageAtHeader == 1) {
//			[advImage loadAsyncImage: [data objectForKey: @"advertise_url"]];
//		}
//		return cell;
//	} else if(showImageAtHeader){
//		row --;
//	}

	if (gtemplate == GEventTemplateType2) {
		static NSString *EventPageTableCellIdentifier2 = @"EventPageTableCellIdentifier2";
		GEventPageViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier: EventPageTableCellIdentifier2];
		if (!cell) {
			cell = [[GEventPageViewCell2 alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: EventPageTableCellIdentifier2 widthNoCustomBorder: NO];
		}
		
		if ([data objectForKey: @"products"] && [[data objectForKey: @"products"] count] > row) {
			[cell setEventRowData: [[data objectForKey: @"products"] objectAtIndex: row]];
		}
        
		return cell;
	} else {
        NSUInteger row = [indexPath row];
        NSInteger count = ceilf([[data objectForKey: @"products"] count] / 3.0f);
        
        if (row == count) {
            static NSString *CellIdentifierMore = @"searchCellMore";
            UITableViewCell *loadmoreCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierMore];
            if (!loadmoreCell)
            {
                loadmoreCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierMore];
            }
            
            [loadmoreCell.contentView showLoading: @"正在加载中..." size: GViewLoadingSizeSmall];
            
            if ([delegate respondsToSelector:@selector(getNextPageForEventPage:)])
            {
                [delegate getNextPageForEventPage:self];
            }
            
            return loadmoreCell;
        } else if( row > count){
            return nil;
        }
        
		static NSString *EventPageTableCellIdentifier1 = @"EventPageTableCellIdentifier1";
		GEventPageViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier: EventPageTableCellIdentifier1];
		if (!cell) {
			cell = [[GEventPageViewCell1 alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: EventPageTableCellIdentifier1 widthNoCustomBorder: NO];
		}

		if ([data objectForKey: @"products"] && [[data objectForKey: @"products"] count] > row * 3) {
			//warnning !!! may be crash
            //NSLog(@"%d",[[data objectForKey: @"products"] count]);
            //NSLog(@"row = %d",row);
            
			NSArray *productArr =nil;
            if (row*3+3 <= [[data objectForKey: @"products"] count]) {
                productArr = [((NSArray *)[data objectForKey: @"products"]) subarrayWithRange: NSMakeRange(row * 3, 3)];
            }
            
            else
            {
                productArr = [((NSArray *)[data objectForKey: @"products"]) subarrayWithRange: NSMakeRange(row * 3, [[data objectForKey: @"products"] count] - row *3)];
            }
			NSInteger pCount = [productArr count];
            [cell clearItemViews];
            for (NSInteger i = 0; i < pCount; i++) {
                /*
                 PV UV 埋点格式:
                 起始位置： 1011
                 格式 例如 02013， 02（行号）01（标识）3 （列） 
                 */
                NSInteger targetID = (row +1)* 1000 + i + 1;
				GEventPageViewCell1View *itemView = [[GEventPageViewCell1View alloc] initWithFrame: CGRectMake(0.0, 0.0, tableView.frame.size.width / 3.0, 160.0) withRightBorder: i == 2 ? NO : YES];
                itemView.targetID = (int)targetID;
				NSMutableDictionary *itemInfo = [NSMutableDictionary dictionaryWithDictionary: [productArr objectAtIndex: i]];
				[itemInfo setObject: [GToolUtil getProductPic: [itemInfo objectForKey: @"product_char_id"] type: @"middle" index: 0] forKey: @"pic_url"];
				[itemView setItemInfo: itemInfo];
				if (baseColor) {
					itemView.rightBorderLayer.backgroundColor = [baseColor CGColor];
				}
                UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickProduct:)];
                [itemView addGestureRecognizer:tap];
				//[itemView addTarget: self action: @selector(clickProduct:) forControlEvents: UIControlEventTouchUpInside];
				[cell addItemView: itemView];
			}
		}

		if (baseColor) {
			cell.borderLayer.backgroundColor = [baseColor CGColor];
		}
		return cell;
	}

	return nil;
}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//	return NO;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
	NSUInteger row = [indexPath row];

	if (gtemplate == GEventTemplateType2) {
		if ([data objectForKey: @"products"] && [[data objectForKey: @"products"] count] > row) {
			NSDictionary *dic = [[data objectForKey: @"products"] objectAtIndex: row];
			if (![GToolUtil isEmpty: [dic objectForKey: @"list_url"]]) {
				NSDictionary *searchCondition = [GToolUtil convertCategoryArrayToDictionary: [dic objectForKey: @"list_url"]];
				if (delegate) {
					[delegate gEventPageView: self goSearch: searchCondition withTitle: [dic objectForKey: @"title"] atIndexPath:indexPath];
				}
			}
		}
	}
}

@end
