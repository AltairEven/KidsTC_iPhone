//
//  TextSegueModel.h
//  KidsTC
//
//  Created by Altair on 1/16/16.
//  Copyright © 2016 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeSegueModel.h"

@interface TextSegueModel : NSObject

@property (nonatomic, copy, readonly) NSString *linkWords;

@property (nonatomic, strong, readonly) HomeSegueModel *segueModel;

@property (nonatomic, copy, readonly) NSString *promotionWords;

@property (nonatomic, readonly) NSRange linkRange;

- (instancetype)initWithLinkParam:(NSDictionary *)param promotionWords:(NSString *)words;

@end
