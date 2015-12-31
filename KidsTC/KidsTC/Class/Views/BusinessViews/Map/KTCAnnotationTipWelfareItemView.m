//
//  KTCAnnotationTipWelfareItemView.m
//  KidsTC
//
//  Created by Altair on 12/11/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "KTCAnnotationTipWelfareItemView.h"
#import "LoveHouseListItemModel.h"
#import "HospitalListItemModel.h"

@interface KTCAnnotationTipWelfareItemView ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *gotoButton;
@property (weak, nonatomic) IBOutlet UIButton *nearbyButton;

- (IBAction)didClickedGotoButton:(id)sender;
- (IBAction)didClickedGoDetailButton:(id)sender;

@end

@implementation KTCAnnotationTipWelfareItemView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"KTCAnnotationTipWelfareItemView" owner:self options: nil];
        if(arrayOfViews.count < 1) {
            return nil;
        }
        if(![[arrayOfViews objectAtIndex:0] isKindOfClass:[KTCAnnotationTipWelfareItemView class]]){
            return nil;
        }
        self = [arrayOfViews objectAtIndex:0];
        self.frame = frame;
    }
    return self;
}

- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    static BOOL bLoad;
    if (!bLoad)
    {
        bLoad = YES;
        KTCAnnotationTipWelfareItemView *view = [GConfig getObjectFromNibWithView:self];
        [view buildSubView];
        return view;
    }
    bLoad = NO;
    return self;
}

- (void)buildSubView {
    [self.gotoButton setTitleColor:[[KTCThemeManager manager] defaultTheme].globalThemeColor forState:UIControlStateNormal];
    [self.nearbyButton setTitleColor:[[KTCThemeManager manager] defaultTheme].globalThemeColor forState:UIControlStateNormal];
}

- (void)setItemModel:(KTCAnnotationTipWelfareItem *)itemModel {
    _itemModel = itemModel;
    [self.nameLabel setText:itemModel.name];
    [self.descriptionLabel setText:itemModel.welfareDescription];
    [self.imageView setImageWithURL:itemModel.imageUrl placeholderImage:PLACEHOLDERIMAGE_SMALL];
}

- (IBAction)didClickedGotoButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedGotoButtonOnAnnotationTipWelfareItemView:)]) {
        [self.delegate didClickedGotoButtonOnAnnotationTipWelfareItemView:self];
    }
}

- (IBAction)didClickedGoDetailButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedGoDetailButtonOnAnnotationTipWelfareItemView:)]) {
        [self.delegate didClickedGoDetailButtonOnAnnotationTipWelfareItemView:self];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end


@implementation KTCAnnotationTipWelfareItem

+ (instancetype)welfareItemFromLoveHouseListItemModel:(LoveHouseListItemModel *)itemModel {
    if (!itemModel) {
        return nil;
    }
    KTCAnnotationTipWelfareItem *item = [[KTCAnnotationTipWelfareItem alloc] init];
    item.identifier = itemModel.identifier;
    item.name = itemModel.name;
    item.welfareDescription = itemModel.houseDescription;
    item.imageUrl = itemModel.imageUrl;
    item.distanceDescription = itemModel.distanceDescription;
    item.coordinate = itemModel.coordinate;
    return item;
}

+ (instancetype)welfareItemFromHospitalListItemModel:(HospitalListItemModel *)itemModel {
    if (!itemModel) {
        return nil;
    }
    KTCAnnotationTipWelfareItem *item = [[KTCAnnotationTipWelfareItem alloc] init];
    item.identifier = itemModel.identifier;
    item.name = itemModel.name;
    item.welfareDescription = itemModel.hospitalDescription;
    item.imageUrl = itemModel.imageUrl;
    item.distanceDescription = itemModel.distanceDescription;
    item.coordinate = itemModel.coordinate;
    return item;
}

@end
