//
//  TwinklingElfCell.m
//  ICSON
//
//  Created by 钱烨 on 4/13/15.
//  Copyright (c) 2015 肖晓春. All rights reserved.
//

#import "TwinklingElfCell.h"

@interface TwinklingElfCell ()


@end


NSString *const kTwinklingElfCellIdentifier = @"TwinklingElfCell";

@implementation TwinklingElfCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"TwinklingElfCell" owner:self options: nil];
        if(arrayOfViews.count < 1) {
            return nil;
        }
        if(![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]){
            return nil;
        }
        self = [arrayOfViews objectAtIndex:0];
    }
    return self;
}


- (void)awakeFromNib {
    // Initialization code
}


@end
