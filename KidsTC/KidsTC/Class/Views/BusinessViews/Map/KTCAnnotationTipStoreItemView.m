//
//  KTCAnnotationTipStoreItemView.m
//  KidsTC
//
//  Created by Altair on 12/11/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "KTCAnnotationTipStoreItemView.h"
#import "FiveStarsView.h"
#import "StoreListItemModel.h"
#import "StoreDetailModel.h"

@interface KTCAnnotationTipStoreItemView ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet FiveStarsView *starsView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)didClickedGotoButton:(id)sender;
- (IBAction)didClickedGoDetailButton:(id)sender;

@end

@implementation KTCAnnotationTipStoreItemView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"KTCAnnotationTipStoreItemView" owner:self options: nil];
        if(arrayOfViews.count < 1) {
            return nil;
        }
        if(![[arrayOfViews objectAtIndex:0] isKindOfClass:[KTCAnnotationTipStoreItemView class]]){
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
        KTCAnnotationTipStoreItemView *view = [GConfig getObjectFromNibWithView:self];
        return view;
    }
    bLoad = NO;
    return self;
}

- (void)setStoreItem:(KTCAnnotationTipStoreItem *)storeItem {
    _storeItem = storeItem;
    [self.nameLabel setText:storeItem.storeName];
    [self.starsView setStarNumber:storeItem.starNumber];
    [self.imageView setImageWithURL:storeItem.imageUrl placeholderImage:PLACEHOLDERIMAGE_SMALL];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)didClickedGotoButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedGotoButtonOnAnnotationTipStoreItemView:)]) {
        [self.delegate didClickedGotoButtonOnAnnotationTipStoreItemView:self];
    }
}

- (IBAction)didClickedGoDetailButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedGoDetailButtonOnAnnotationTipStoreItemView:)]) {
        [self.delegate didClickedGoDetailButtonOnAnnotationTipStoreItemView:self];
    }
}

@end

@implementation KTCAnnotationTipStoreItem

+ (instancetype)annotationStoreItemFromStoreListItemModel:(StoreListItemModel *)model {
    if (!model) {
        return nil;
    }
    KTCAnnotationTipStoreItem *item = [[KTCAnnotationTipStoreItem alloc] init];
    item.identifier = model.identifier;
    item.imageUrl = model.imageUrl;
    item.storeName = model.storeName;
    item.starNumber = model.starNumber;
    return item;
}

+ (instancetype)annotationStoreItemFromStoreDetailModel:(StoreDetailModel *)model {
    if (!model) {
        return nil;
    }
    KTCAnnotationTipStoreItem *item = [[KTCAnnotationTipStoreItem alloc] init];
    item.identifier = model.storeId;
    item.imageUrl = [model.imageUrls firstObject];
    item.storeName = model.storeName;
    item.starNumber = model.starNumber;
    return item;
}


@end
