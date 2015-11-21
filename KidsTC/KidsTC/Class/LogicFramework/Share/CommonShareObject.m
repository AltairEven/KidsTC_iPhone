//
//  CommonShareObject.m
//  KidsTC
//
//  Created by Altair on 11/20/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "CommonShareObject.h"

@implementation CommonShareObject

+ (instancetype)shareObjectWithTitle:(NSString *)title
                         description:(NSString *)description
                          thumbImage:(UIImage *)thumb
                           urlString:(NSString *)urlString {
    if (title && ![title isKindOfClass:[NSString class]]) {
        return nil;
    }
    if (description && ![description isKindOfClass:[NSString class]]) {
        return nil;
    }
    if (thumb && ![thumb isKindOfClass:[UIImage class]]) {
        return nil;
    }
    if (!urlString || ![urlString isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    CommonShareObject *object = [[CommonShareObject alloc] init];
    object.title = title;
    object.shareDescription = description;
    object.thumbImage = thumb;
    object.webPageUrlString = urlString;
    return object;
}

@end
