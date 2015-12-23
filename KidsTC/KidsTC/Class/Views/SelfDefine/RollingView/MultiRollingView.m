/*
 * Copyright (c) 2012,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：MultiRollingView.m
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：qitao
 * 完成日期：12-11-5
 */


#import "MultiRollingView.h"
#import "RollingView.h"

#define ROLL_OFFSET_X               8
#define ROLL_OFFSET_Y               5
#define ROLL_GAP_X                  21

static const int kRollDuration = 1;

@interface MultiRollingView ()
@property (nonatomic, strong) NSArray *curPresetArr;
@end

@implementation MultiRollingView

@synthesize presetIdGroups;
@synthesize delegate = _delegate;


- (void)internalInit
{
    CGRect bounds = self.bounds;
    self.backgroundColor = [UIColor clearColor];
    _rollContainer = [[UIView alloc] initWithFrame:bounds];
    _rollContainer.backgroundColor = [UIColor clearColor];
    [self addSubview:_rollContainer];
    
    // set slot machine
    NSArray *presetGood = @[
  @[INT2NUMBER(CouponPrizeType), INT2NUMBER(CouponPrizeType), INT2NUMBER(CouponPrizeType)],
  @[INT2NUMBER(QQPrizeType), INT2NUMBER(QQPrizeType), INT2NUMBER(QQPrizeType)],
  @[INT2NUMBER(GoldPrizeType), INT2NUMBER(GoldPrizeType), INT2NUMBER(GoldPrizeType)],
  @[INT2NUMBER(ProductPrize), INT2NUMBER(ProductPrize), INT2NUMBER(ProductPrize)]
  ];
    
    NSArray *infos = @[[[RollingInfo alloc] initWithId:CouponPrizeType textString:nil andImageName:[NSString stringWithFormat:@"type_%d_s.png", CouponPrizeType]],
                       [[RollingInfo alloc] initWithId:QQPrizeType textString:nil andImageName:[NSString stringWithFormat:@"type_%d_s.png", QQPrizeType]],
                       [[RollingInfo alloc] initWithId:GoldPrizeType textString:nil andImageName:[NSString stringWithFormat:@"type_%d_s.png", GoldPrizeType]],
                       [[RollingInfo alloc] initWithId:ProductPrize textString:nil andImageName:[NSString stringWithFormat:@"type_%d_s.png", ProductPrize]]];
    
    _bgImageView.frame = bounds;
    CGFloat width = (bounds.size.width - ROLL_OFFSET_X*2 + ROLL_GAP_X)/3 - ROLL_GAP_X;
    CGFloat height = bounds.size.height - ROLL_OFFSET_Y*2;
    
    for (int i = 0; i < 3; i++) {
        RollingView * rollView = [[RollingView alloc] initWithFrame:CGRectMake(ROLL_OFFSET_X+(width+ROLL_GAP_X)*i, ROLL_OFFSET_Y, width, height) andInfos:infos];
        rollView.delegate = self;
        [_rollContainer addSubview:rollView];
        //[self addRollingView:rollView];
    }
    
    self.presetIdGroups = presetGood;
    
    static int randIndexArr[] = {CouponPrizeType, QQPrizeType, GoldPrizeType, ProductPrize};
    int size = sizeof(randIndexArr)/sizeof(randIndexArr[0]);
    for (int i=0; i<size; i++)
    {
        int rand = random()%(size-i);
        int temp = randIndexArr[i];
        randIndexArr[i] = randIndexArr[i+rand];
        randIndexArr[i+rand] = temp;
    }
    
    [_rollContainer.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        RollingView * rollView = obj;
        [rollView.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:randIndexArr[idx] inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
    }];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [self internalInit];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self != nil) {
        [self internalInit];
    }
    return self;
}

- (void)dealloc
{
    for (RollingView * view in _rollContainer.subviews) {
        view.delegate = nil;
    }
    
    self.delegate = nil;
    
}

/*
- (void)addRollingView:(RollingView*)rollView
{
    if (rollView != nil) {
        rollView.delegate = self;
        [_rollContainer addSubview:rollView];
        [self setNeedsLayout];
    }
}*/

#pragma mark -

- (void)removeAllRollingViews
{
    NSArray * views = _rollContainer.subviews;
    for (RollingView * view in views) {
        view.delegate = nil;
        [view removeFromSuperview];
    }
}

- (void)setBackgroundImage:(UIImage*)img
{
    if (nil == _bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:_bgImageView];
        [self sendSubviewToBack:_bgImageView];
    }
    _bgImageView.image = img;
}

- (BOOL)isEqualToPreset:(NSArray*)ids
{
    for (NSArray * presetIds in self.presetIdGroups) {
        if ([presetIds isEqualToArray:ids]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isSpinning
{
    for (RollingView * view in _rollContainer.subviews) {
        if (view.isSpinning) {
            return YES;
        }
    }
    return NO;
}

- (NSArray*)selectedIds
{
    NSMutableArray *ids = [NSMutableArray array];
    for (RollingView * view in _rollContainer.subviews) {
        [ids addObject:[NSNumber numberWithInteger:view.selectedIdx]];
    }
    return ids;
}


//spin to random string
//is "preset" is true, spin to random preset string
- (void)spinRandom
{
    _isPreset = NO;
    for (RollingView * rollView in _rollContainer.subviews) {
        [rollView spinToRandom];
    }
}

- (void)spinPreset:(PrizeType)prizeType
{
    if (0 == [self.presetIdGroups count]) {
        [self spinRandom];
        return;
    }
    
    _isPreset = !(prizeType == NonPrize) && (prizeType != UnKnownPrizeType);
    NSMutableArray * presetArr = [NSMutableArray arrayWithCapacity:4];
    if (_isPreset)
    {
        int presetIndex = prizeType-CouponPrizeType;
        if (presetIndex < [self.presetIdGroups count])
        {
            [presetArr addObjectsFromArray:[self.presetIdGroups objectAtIndex:prizeType-CouponPrizeType]];
        }
    }
    else
    {
        NSInteger protectLimit = 10;
        while (presetArr.count == 0 || [self isEqualToPreset:presetArr])
        {
            [presetArr removeAllObjects];
            for (RollingView * rollView in _rollContainer.subviews)
            {
                NSInteger randIdx = [rollView getRamdonId];
                if (randIdx >= 0)
                {
                    [presetArr addObject:[NSNumber numberWithInteger:randIdx]];
                }
            }
            
            if (presetArr.count == 0 || --protectLimit <= 0)
            {
                break;
            }
        }
    }
    
    self.curPresetArr = presetArr;
    
    [_rollContainer.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
    {
        RollingView * rollView = obj;
        if (presetArr.count > 0)
        {
            [rollView spinToId:[[presetArr objectAtIndex:idx] integerValue] repeatCnt:(idx+3)*kRollDuration];
        }
        else
        {
            [rollView spinToRandom];
        }
    }];
}

- (void)keepSpinning
{
    NSInteger cnt = 0;
    for (RollingView * rollView in _rollContainer.subviews) {
        float delayInSeconds = 0.2 * cnt++;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [rollView keepSpinningWithStepDuration:0.04];
        });
    }
}

- (BOOL)isAnimating
{
    for (RollingView * view in _rollContainer.subviews) {
        if (view.isAnimating) {
            return YES;
        }
    }
    return NO;
}

/*
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect bounds = self.bounds;
    _bgImageView.frame = bounds;
    _rollContainer.frame = bounds;
    NSLog(@"self.bounds:%f :%f", self.bounds.size.width, self.bounds.size.height);
    
    NSUInteger rollCnt = _rollContainer.subviews.count;
    NSLog(@"roll cnt:%d", rollCnt);
    if (rollCnt > 0) {
        CGFloat width = (bounds.size.width - ROLL_OFFSET_X*2 + ROLL_GAP_X)/rollCnt - ROLL_GAP_X;
        CGFloat height = bounds.size.height - ROLL_OFFSET_Y*2;
        NSLog(@"width:%f height:%f", width, height);
        
        static int randIndexArr[] = {CouponPrizeType, QQPrizeType, GoldPrizeType, ProductPrize};
        int size = sizeof(randIndexArr)/sizeof(randIndexArr[0]);
        for (int i=0; i<size; i++)
        {
            int rand = random()%(size-i);
            int temp = randIndexArr[i];
            randIndexArr[i] = randIndexArr[i+rand];
            randIndexArr[i+rand] = temp;
        }
        
        [_rollContainer.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            RollingView * rollView = obj;
            rollView.frame = CGRectMake(ROLL_OFFSET_X+(width+ROLL_GAP_X)*idx, ROLL_OFFSET_Y, width, height);
            [rollView setNeedsLayout];
            [rollView.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:randIndexArr[idx] inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
        }];
    }
}*/


- (void)rollingViewDidSpin:(RollingView *)roll {
    //...
}

- (void)rollingView:(RollingView *)roll didSnapToIdx:(NSInteger)idx
{
    if (![self isSpinning]) {
        [_delegate multiRollingView:self didStopWithSlotIndex:(int)[_rollContainer.subviews indexOfObject:roll] andCurPresetArr:self.curPresetArr];
        NSArray *selectedIds = [self selectedIds];
        //NSLog(@"selected ids = %@", selectedIds);
        
        //if our preset strings are not nil, we want to snap to those
        if (_isPreset && self.presetIdGroups != nil) {
            //check if the string is part of our strings
            int stringIndex = -1;
            for (int i=0; i<[self.presetIdGroups count]; i++) {
                if ([(NSArray*)[self.presetIdGroups objectAtIndex:i] isEqualToArray:selectedIds]) {
                    stringIndex = i;
                    break;
                }
            }
            if (stringIndex > -1) {
                //if the selected string was in the presets, select it
                [_delegate multiRollingView:self didSelectIds:selectedIds];
            } else {
                //if it wasn't, spin to one of the presets
                [self spinPreset:YES];
            }
        }
        else {
            //select that string
            [_delegate multiRollingView:self didSelectIds:selectedIds];
        }
    }
    else {
        [_delegate multiRollingView:self didStopWithSlotIndex:[_rollContainer.subviews indexOfObject:roll] andCurPresetArr:self.curPresetArr];
    }
}

@end