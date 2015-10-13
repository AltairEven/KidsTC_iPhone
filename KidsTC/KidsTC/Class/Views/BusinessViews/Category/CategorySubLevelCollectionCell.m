//
//  CategorySubLevelCollectionCell.m
//  KidsTC
//
//  Created by 钱烨 on 7/27/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "CategorySubLevelCollectionCell.h"

NSString *const kCategorySubLevelCollectionCellIdentifier = @"CategorySubLevelCollectionCell";

@interface CategorySubLevelCollectionCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation CategorySubLevelCollectionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"CategorySubLevelCollectionCell" owner:self options: nil];
        if(arrayOfViews.count < 1) {
            return nil;
        }
        if(![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]){
            return nil;
        }
        self = [arrayOfViews objectAtIndex:0];
        [self.bgView setBackgroundColor:[AUITheme theme].globalCellBGColor];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

@end
