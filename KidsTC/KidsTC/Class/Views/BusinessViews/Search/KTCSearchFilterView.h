//
//  KTCSearchFilterView.h
//  KidsTC
//
//  Created by 钱烨 on 7/31/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KTCSearchResultFilterModel.h"

struct KTCSearchResultFilterCoordinate {
    NSInteger level1Index;
    NSInteger level2Index;
};
typedef struct KTCSearchResultFilterCoordinate KTCSearchResultFilterCoordinate;

extern KTCSearchResultFilterCoordinate FilterCoordinateMake(NSInteger level1Index, NSInteger level2Index);

@class KTCSearchFilterView;

@protocol KTCSearchFilterViewDelegate <NSObject>

- (void)didClickedConfirmButtonOnSearchFilterView:(KTCSearchFilterView *)filterView;

- (void)filterViewNeedDismiss:(KTCSearchFilterView *)filterView;

@end

@interface KTCSearchFilterView : UIView

@property (nonatomic, assign) id<KTCSearchFilterViewDelegate> delegate;

@property (nonatomic, strong) KTCSearchResultFilterModel *peopleFilterModel;

@property (nonatomic, strong) NSArray *categoriesFilterModelArray;

@property (nonatomic, readonly) KTCSearchResultFilterCoordinate peopleFilterCoordinate;

@property (nonatomic, readonly) KTCSearchResultFilterCoordinate categoryFilterCoordinate;

- (void)showWithPeopleFilterCoordinate:(KTCSearchResultFilterCoordinate)peopleFilterCoordinate categoryFilterCoordinate:(KTCSearchResultFilterCoordinate)categoryFilterCoordinate;

@end
