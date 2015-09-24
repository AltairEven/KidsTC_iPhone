//
//  KTCSearchHistoryView.m
//  KidsTC
//
//  Created by 钱烨 on 7/20/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "KTCSearchHistoryView.h"

@interface KTCSearchHistoryView () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

//view1
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITableViewCell *hotKeyCell;

@property (weak, nonatomic) IBOutlet UIScrollView *hotKeyScrollView;

//view2
@property (weak, nonatomic) IBOutlet UIView *hotKeyView;
@property (weak, nonatomic) IBOutlet UIView *hotKeyContentView;


@property (nonatomic, strong) NSArray *hotKeysArray;
@property (nonatomic, strong) NSArray *historiesArray;


- (void)didClickedHotKeyButton:(UIButton *)button;

//view1
- (void)configHotKeyCell;

- (void)didClickedClearHistoryButton;

//view2
- (void)setupHotKeyButtons;

@end

@implementation KTCSearchHistoryView

#pragma mark Initialization


- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    static BOOL bLoad;
    if (!bLoad)
    {
        bLoad = YES;
        KTCSearchHistoryView *view = [GConfig getObjectFromNibWithView:self];
        [view buildSubviews];
        return view;
    }
    bLoad = NO;
    return self;
}

- (void)buildSubviews {
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    [footerView setBackgroundColor:RGBA(230, 230, 230, 1)];
    UIButton *clearHistoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [clearHistoryButton setFrame:CGRectMake(40, 10, SCREEN_WIDTH - 80, 30)];
    [clearHistoryButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [clearHistoryButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [clearHistoryButton setTitle:@"清除历史记录" forState:UIControlStateNormal];
    [clearHistoryButton setBackgroundColor:[UIColor lightGrayColor]];
    [clearHistoryButton addTarget:self action:@selector(didClickedClearHistoryButton) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:clearHistoryButton];
    self.tableView.tableFooterView = footerView;
}


#pragma mark UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSUInteger number = 0;
    if ([self.hotKeysArray count] > 0) {
        number ++;
    }
    if ([self.historiesArray count] > 0) {
        number ++;
    }
    return number;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger number = 0;
    switch (section) {
        case 0:
        {
            if ([self.hotKeysArray count] > 0) {
                //热搜
                number = 1;
            } else {
                //历史
                number = [self.historiesArray count];
            }
        }
            break;
        case 1:
        {
            //历史记录
            number = [self.historiesArray count];
        }
            break;
        default:
            break;
    }
    return number;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    switch (indexPath.section) {
        case 0:
        {
            if ([self.hotKeysArray count] > 0) {
                //热搜
                [self configHotKeyCell];
                cell = self.hotKeyCell;
                
            } else {
                //历史
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                [cell.textLabel setText:[self.historiesArray objectAtIndex:indexPath.row]];
            }
        }
            break;
        case 1:
        {
            //历史
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            [cell.textLabel setText:[self.historiesArray objectAtIndex:indexPath.row]];
        }
            break;
        default:
            break;
    }
    [cell setBackgroundColor:RGBA(230, 230, 230, 1)];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
        {
            if ([self.hotKeysArray count] > 0) {
                //热搜
                return;
            } else {
                //历史
                if (self.delegate && [self.delegate respondsToSelector:@selector(searchHistoryView:didSelectedHistoryAtIndex:)]) {
                    [self.delegate searchHistoryView:self didSelectedHistoryAtIndex:indexPath.row];
                }
            }
        }
            break;
        case 1:
        {
            //历史
            if (self.delegate && [self.delegate respondsToSelector:@selector(searchHistoryView:didSelectedHistoryAtIndex:)]) {
                [self.delegate searchHistoryView:self didSelectedHistoryAtIndex:indexPath.row];
            }
        }
            break;
        default:
            break;
    }
}


#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchHistoryViewDidScroll:)]) {
        [self.delegate searchHistoryViewDidScroll:self];
    }
}


#pragma mark Private methods


- (void)didClickedHotKeyButton:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchHistoryView:didSelectedHotKeyAtIndex:)]) {
        NSLog(@"%d", button.tag);
        [self.delegate searchHistoryView:self didSelectedHotKeyAtIndex:button.tag];
    }
}

- (void)configHotKeyCell {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(hotKeysArrayForKTCSearchHistoryView:)]) {
        NSArray *array = [self.dataSource hotKeysArrayForKTCSearchHistoryView:self];
        CGFloat xPosition = 0;
        CGFloat yPosition = (self.hotKeyScrollView.frame.size.height - 20) / 2;
        CGFloat width = 0;
        for (NSUInteger index = 0; index < [array count]; index ++) {
            NSString *title = [array objectAtIndex:index];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(xPosition, yPosition, 10, 10)];
            [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
            [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [button setTitle:title forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor whiteColor]];
            button.tag = index;
            [button addTarget:self action:@selector(didClickedHotKeyButton:) forControlEvents:UIControlEventTouchUpInside];
            [button sizeToFit];
            [self.hotKeyScrollView addSubview:button];
            
            //加点边距
            [button setFrame:CGRectMake(xPosition, yPosition, button.frame.size.width + 4, 20)];
        
            [button.layer setCornerRadius:5];
            [button.layer setBorderWidth:0.5];
            [button.layer setBorderColor:[UIColor lightGrayColor].CGColor];
            [button.layer setMasksToBounds:YES];
            xPosition += button.frame.size.width + 10;
        }
        width = xPosition;
        [self.hotKeyScrollView setContentSize:CGSizeMake(width, 0)];
    }
}


- (void)didClickedClearHistoryButton {
    self.historiesArray = nil;
    [self bringSubviewToFront:self.hotKeyView];
    [self setupHotKeyButtons];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedClearHistoryButton)]) {
        [self.delegate didClickedClearHistoryButton];
    }
}

- (void)setupHotKeyButtons {
    for (UIView *subview in self.hotKeyContentView.subviews) {
        [subview removeFromSuperview];
    }
    
    CGFloat xPosition = 0;
    CGFloat yPosition = 0;
    for (NSUInteger index = 0; index < [self.hotKeysArray count]; index ++) {
        NSString *title = [self.hotKeysArray objectAtIndex:index];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(xPosition, yPosition, 10, 10)];
        [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor whiteColor]];
        button.tag = index;
        [button addTarget:self action:@selector(didClickedHotKeyButton:) forControlEvents:UIControlEventTouchUpInside];
        [button sizeToFit];
        [self.hotKeyContentView addSubview:button];
        
        //加点边距
        [button setFrame:CGRectMake(xPosition, yPosition, button.frame.size.width + 4, 20)];
        
        [button.layer setCornerRadius:5];
        [button.layer setBorderWidth:0.5];
        [button.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        [button.layer setMasksToBounds:YES];
        //下一个按钮位置调整
        xPosition += button.frame.size.width + 10;
        CGFloat rightMargin = button.frame.origin.x + button.frame.size.width;
        CGFloat rightLimit = self.hotKeyContentView.frame.size.width - 10;
        if (rightMargin > rightLimit) {
            xPosition = 0;
            yPosition += 30;
        }
    }
}


#pragma mark Public methods

- (void)reloadData {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(hotKeysArrayForKTCSearchHistoryView:)]) {
        self.hotKeysArray = [self.dataSource hotKeysArrayForKTCSearchHistoryView:self];
    }
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(historiesArrayForKTCSearchHistoryView:)]) {
        self.historiesArray = [self.dataSource historiesArrayForKTCSearchHistoryView:self];
    }
    if ([self.historiesArray count] > 0) {
        [self bringSubviewToFront:self.tableView];
        [self.tableView reloadData];
    } else {
        [self bringSubviewToFront:self.hotKeyView];
        [self setupHotKeyButtons];
    }
}


- (void)clearContent {
    self.hotKeysArray = nil;
    self.historiesArray = nil;
    [self bringSubviewToFront:self.hotKeyView];
    [self setupHotKeyButtons];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
