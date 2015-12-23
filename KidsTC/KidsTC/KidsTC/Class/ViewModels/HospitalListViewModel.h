//
//  HospitalListViewModel.h
//  KidsTC
//
//  Created by 钱烨 on 10/14/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "BaseViewModel.h"
#import "HospitalListView.h"
#import "HospitalListItemModel.h"

@interface HospitalListViewModel : BaseViewModel

- (NSArray *)resutlItemModels;

-(void)getMoreHospitals;

@end
