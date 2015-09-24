//
//  AutoFlashImagesView.m
//  ICSON
//
//  Created by 钱烨 on 4/9/15.
//  Copyright (c) 2015 肖晓春. All rights reserved.
//

#import "AutoFlashImagesView.h"

@interface AutoFlashImagesView ()

- (void)startLoading;

@end


@implementation AutoFlashImagesView
@synthesize imagesArray = _imagesArray;


- (instancetype)initWithFrame:(CGRect)frame andImageUrlStrings:(NSArray *)urlStrings {
    self = [super initWithFrame:frame];
    if (self) {
        self.imageUrlsArray = urlStrings;
        [self startLoading];
    }
    return self;
}


- (void)startLoading {
    if (!self.imageUrlsArray || [self.imageUrlsArray count] == 0) {
        return;
    }
    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity:[self.imageUrlsArray count]];
    for (NSString *urlString in self.imageUrlsArray) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.frame];
        NSURL *imgUrl = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:imgUrl];
        [imgView setImageWithURLRequest:request placeholderImage:nil
                                success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        }
                                failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        }];
    }
    _imagesArray = [NSArray arrayWithArray:tempArray];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
