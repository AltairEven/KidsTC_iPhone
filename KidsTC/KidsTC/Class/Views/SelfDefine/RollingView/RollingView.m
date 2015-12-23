/*
 * Copyright (c) 2012,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：RollingView.m
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：qitao
 * 完成日期：12-11-5
 */

#import "RollingView.h"

#define NUM_ROWS            1000
#define ROW_HEIGHT          58//53


@interface RollingView ()

- (void)snap;
- (NSInteger)indexOfId:(NSInteger)rollId;

@end


@implementation RollingView
@synthesize selectedIdx;
@synthesize rollInfos;
@synthesize tableView;
@synthesize delegate;

@synthesize isSpinning, isAnimating;

static NSString *CellIdentifier = @"RollCell";

- (void)dealloc
{
    self.tableView.delegate = nil;
}

- (id)initWithFrame:(CGRect)frame andInfos:(NSArray *)infos {
    self = [super initWithFrame:frame];
    if (self != nil) {
        self.isSpinning = NO;
        isAnimating = NO;
        
        self.backgroundColor = [UIColor clearColor];
        self.rollInfos = infos;
        _cellHeight = ROW_HEIGHT;
        _stepDuration = 0.1f;

        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.showsHorizontalScrollIndicator = NO;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.tableView];    
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
    }
    
    return self;
}

/*
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect bounds = self.bounds;
    if (!CGRectEqualToRect(bounds, self.tableView.frame)) {
        self.tableView.frame = bounds;
        _bgImageView.frame = bounds;
        [self.tableView reloadData];
    }
}*/

- (void)spinToRandom
{
    RollingInfo * info = [self.rollInfos objectAtIndex:arc4random() % [self.rollInfos count]];
    [self spinToId:info.rollId repeatCnt:(arc4random() % 5 + 2) * (10/[self.rollInfos count] + 1)];
}

- (void)spinToId:(NSInteger)idx repeatCnt:(NSUInteger)repeat
{
    if ([[self.tableView visibleCells] count] == 0) {
        return;
    }

    double verticalPadding = (self.tableView.frame.size.height - _cellHeight) * .5;
    __block RollingCell *cell = [[self.tableView visibleCells] lastObject];
    [[self.tableView visibleCells] enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        RollingCell *oneCell = (RollingCell*)obj;
        BOOL selected = CGRectContainsPoint(CGRectMake(0, self.tableView.contentOffset.y + verticalPadding, self.tableView.frame.size.width, _cellHeight), oneCell.center);
        if (selected) {
            cell = oneCell;
            *stop = YES;
        }
    }];

    NSInteger difference = [self indexOfId:idx] - [self indexOfId:cell.info.rollId];

    CGFloat spinMax = _spinCount + difference + repeat * self.rollInfos.count - 1;
    while (spinMax < _spinCount ) {
        spinMax += self.rollInfos.count;
    }
	_spinMax = spinMax;
    
    //NSLog(@"roll = %d, %d, %d, %d (%d, %d)", cell.info.rollId, [self indexOfId:idx], _spinMax, _spinCount, _spinMax-_spinCount, difference);
    
    if (!self.isSpinning) {
        [self setWheel];
    }
    
    //[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.tableView indexPathForCell:cell].row + difference + 10*(idx+1) inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

- (void)keepSpinning
{
    NSTimeInterval duratioin = 0.04 + (rand()%10 + rand()%10)/200.0;
    [self keepSpinningWithStepDuration:duratioin];
}

- (void)keepSpinningWithStepDuration:(NSTimeInterval)duration
{
    _spinMax = INT32_MAX;
    _stepDuration = duration;
    //NSLog(@"duration = %f", _stepDuration);
    if (!self.isSpinning) {
        [self setWheel];
    }
}

- (void)setBgImage:(UIImage*)img
{
    if (nil == _bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:_bgImageView];
        [self sendSubviewToBack:_bgImageView];
    }
    _bgImageView.image = img;
}

- (NSInteger)getRamdonId
{
    if (self.rollInfos.count > 0) {
        NSUInteger randIdx = rand()%self.rollInfos.count;
        RollingInfo * info = [self.rollInfos objectAtIndex:randIdx];
        return info.rollId;
    }
    return -1;
}

- (void) setWheel
{
    isAnimating = YES;
    self.isSpinning = YES;
    
    CGPoint offset = self.tableView.contentOffset;
    offset.y += _cellHeight;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    if (_spinCount == 0) {
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDuration:1];
    } else if (_spinCount == _spinMax) {
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDuration:1];
    } else {
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        [UIView setAnimationDuration:_stepDuration];
        //[UIView setAnimationDuration:(fabsf(_spinCount-_spinMax/2.0) / (_spinMax/2.0) / 17.0 + 0.08)];
    }
    [UIView setAnimationDelegate:self];
    self.tableView.contentOffset = offset;
    [UIView commitAnimations];
    
    _spinCount++;
}

-(void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)finished
{
    if (_spinCount <= _spinMax) {
        [self setWheel];
    } else {
        self.isSpinning = NO;
        isAnimating = NO;
        _spinCount = 0;
        [self snap];
    }
}


- (void)snap
{
    if (isAnimating) return;
    isAnimating = YES;
    
    self.isSpinning = NO;
    
    //calculate vertical padding
    double verticalPadding = (self.tableView.frame.size.height - _cellHeight) * .5;
    
    //for each cell, check if it is in view and set it to selected accordingly
    for (int i=0; i<[[self.tableView visibleCells] count]; i++) {
        RollingCell *cell = [[self.tableView visibleCells] objectAtIndex:i];
        BOOL selected = CGRectContainsPoint(CGRectMake(0, self.tableView.contentOffset.y + verticalPadding, self.tableView.frame.size.width, _cellHeight), cell.center);
        //[cell setSelected:selected];
        if (selected) {
            isAnimating = YES;
            self.isSpinning = NO;
            //self.selectedValue = [self.values objectAtIndex:[label.text intValue]];
            self.selectedIdx = cell.info.rollId;
            [self.tableView scrollToRowAtIndexPath:[self.tableView indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            
            //check if snappin will not result in an animation. in that case, call the delegate here
            if ([self.tableView rectForRowAtIndexPath:[self.tableView indexPathForCell:cell]].origin.y == self.tableView.contentOffset.y + (self.tableView.frame.size.height - _cellHeight) * .5) {
                NSLog(@"snap will not animate! %f, %lu", _cellHeight, (unsigned long)self.selectedIdx);

                [self.delegate rollingView:self didSnapToIdx:self.selectedIdx];
                isAnimating = NO;
                
                [self.rollInfos enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    RollingInfo * info = (RollingInfo*)obj;
                    if (info.rollId == self.selectedIdx) {
                        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:idx+self.rollInfos.count inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
                        *stop = YES;
                    }
                }];
            }
        }
    }
}


#pragma mark UITableViewDataSource methods

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger cellNumber = indexPath.row % [self.rollInfos count];
    
    RollingCell *cell = (RollingCell *)[aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[RollingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    if (cellNumber < self.rollInfos.count) {
        cell.info = [self.rollInfos objectAtIndex:cellNumber];
    }
    
//    static int kkkk = 0;
//    if (kkkk++ % 100 == 0) {
//        NSLog(@"row = %d", indexPath.row);
//    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return NUM_ROWS;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _cellHeight;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
}


#pragma mark UIScrollViewDelegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {    
    self.isSpinning = isAnimating;
    [self.delegate rollingViewDidSpin:self];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        self.isSpinning = NO;
        isAnimating = NO;
        [self snap];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.isSpinning = NO;
    isAnimating = NO;
    [self snap];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (isAnimating) {
        isAnimating = NO;
        self.isSpinning = NO;
        [self.delegate rollingView:self didSnapToIdx:self.selectedIdx];
    } else {
        [self snap];
    }
}

#pragma mark Helper methods

- (NSInteger)indexOfId:(NSInteger)rollId
{
    __block NSUInteger retIdx = 0;
    [self.rollInfos enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        RollingInfo * info = obj;
        if (rollId == info.rollId) {
            retIdx = idx;
            *stop = YES;
        }
    }];
    return retIdx;
}

@end
