//
//  ParentingStrategyDetailView.m
//  KidsTC
//
//  Created by 钱烨 on 10/8/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "ParentingStrategyDetailView.h"
#import "ParentingStrategyDetailViewCell.h"

static NSString *const kCellIdentifier = @"kCellIdentifier";

@interface ParentingStrategyDetailView () <UITableViewDataSource, UITableViewDelegate, ParentingStrategyDetailViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

//header view
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIImageView *mainImageView;
@property (nonatomic, strong) UIView *titleBGView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *tagBGView;
@property (nonatomic, strong) UIView *descriptionBGView;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UIView *descriptionBottomLineView;


@property (nonatomic, strong) UINib *cellNib;

@property (nonatomic, strong) ParentingStrategyDetailModel *detailModel;

- (UIView *)buildHeaderView;

- (void)buildTagView;

@end

@implementation ParentingStrategyDetailView

#pragma mark Initialization


- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    static BOOL bLoad;
    if (!bLoad)
    {
        bLoad = YES;
        ParentingStrategyDetailView *view = [GConfig getObjectFromNibWithView:self];
        [view buildSubviews];
        return view;
    }
    bLoad = NO;
    return self;
}

- (void)buildSubviews {
    self.tableView.backgroundView = nil;
    [self.tableView setBackgroundColor:[AUITheme theme].globalBGColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self setBackgroundColor:[AUITheme theme].globalBGColor];
   
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    if (!self.cellNib) {
        self.cellNib = [UINib nibWithNibName:NSStringFromClass([ParentingStrategyDetailViewCell class]) bundle:nil];
        [self.tableView registerNib:self.cellNib forCellReuseIdentifier:kCellIdentifier];
    }
    
    //header
    self.headerView = [[UIView alloc] init];
    [self.headerView setBackgroundColor:[AUITheme theme].globalBGColor];
    //main image
    self.mainImageView = [[UIImageView alloc] init];
    [self.headerView addSubview:self.mainImageView];
    //title
    self.titleBGView = [[UIView alloc] init];
    [self.titleBGView setBackgroundColor:[UIColor clearColor]];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 30)];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.titleLabel setTextColor:[AUITheme theme].globalThemeColor];
    [self.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.titleBGView addSubview:self.titleLabel];
    [self.headerView addSubview:self.titleBGView];
    //tag
    self.tagBGView = [[UIView alloc] init];
    [self.tagBGView setBackgroundColor:[UIColor clearColor]];
    [self.headerView addSubview:self.tagBGView];
    //des
    self.descriptionBGView = [[UIView alloc] init];
    [self.descriptionBGView setBackgroundColor:[UIColor clearColor]];
    
    UIView *descLine1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 40, 2)];
    [descLine1 setBackgroundColor:[UIColor lightGrayColor]];
    [self.descriptionBGView addSubview:descLine1];
    
    self.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH - 40, 20)];
    [self.descriptionLabel setBackgroundColor:[UIColor clearColor]];
    [self.descriptionLabel setTextColor:[UIColor lightGrayColor]];
    [self.descriptionLabel setFont:[UIFont systemFontOfSize:14]];
    [self.descriptionLabel setTextAlignment:NSTextAlignmentLeft];
    [self.descriptionLabel setLineBreakMode:NSLineBreakByCharWrapping];
    [self.descriptionBGView addSubview:self.descriptionLabel];
    [self.headerView addSubview:self.descriptionBGView];
    
    self.descriptionBottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 40, 2)];
    [self.descriptionBottomLineView setBackgroundColor:[UIColor lightGrayColor]];
    [self.descriptionBGView addSubview:self.descriptionBottomLineView];
    
    [self.headerView addSubview:self.descriptionBGView];
}


#pragma mark UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.detailModel.cellModels count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ParentingStrategyDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell =  [[[NSBundle mainBundle] loadNibNamed:@"ParentingStrategyDetailViewCell" owner:nil options:nil] objectAtIndex:0];
    }
    cell.indexPath = indexPath;
    [cell configWithDetailCellModel:[self.detailModel.cellModels objectAtIndex:indexPath.section]];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ParentingStrategyDetailCellModel *model = [self.detailModel.cellModels objectAtIndex:indexPath.section];
    CGFloat height = [model cellHeight];
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    ParentingStrategyDetailCellModel *model = [self.detailModel.cellModels objectAtIndex:section];
    CGFloat height = 0.01;
    if ([model.title length] > 0 || section == 0) {
        height = 50;
    } else {
        height = 20;
    }
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGFloat viewHeight = [self tableView:self.tableView heightForHeaderInSection:section];
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, viewHeight)];
    [bgView setBackgroundColor:[AUITheme theme].globalBGColor];
    //sign
    CGFloat leftMargin = 30;
    CGFloat circleDiameter = 20;
    UIView *signBGView = [[UIView alloc] initWithFrame:CGRectMake(leftMargin, 0, circleDiameter, viewHeight)];
    [signBGView setBackgroundColor:[UIColor clearColor]];
    [signBGView setAlpha:0.5];
    [bgView addSubview:signBGView];
    
    CGFloat lineHeight = 10;
    if (viewHeight >= 50) {
        lineHeight = 16;
    }
    CGFloat width = 6;
    //下方竖线
    CGFloat lineXPosition = (circleDiameter - width) / 2;
    CGFloat yPosition = viewHeight - lineHeight;
    UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(lineXPosition, yPosition, width, lineHeight)];
    [bottomLineView setBackgroundColor:[AUITheme theme].globalThemeColor];
    [signBGView addSubview:bottomLineView];
    //标题
    ParentingStrategyDetailCellModel *model = [self.detailModel.cellModels objectAtIndex:section];
    if ([model.title length] > 0 || section == 0) {
        //圆圈
        yPosition = (viewHeight - circleDiameter) / 2;
        UIView *circleView = [[UIView alloc] initWithFrame:CGRectMake(0, yPosition, circleDiameter, circleDiameter)];
        [circleView setBackgroundColor:[AUITheme theme].globalBGColor];
        circleView.layer.borderColor = [AUITheme theme].globalThemeColor.CGColor;
        circleView.layer.borderWidth = width;
        circleView.layer.cornerRadius = circleDiameter / 2;
        circleView.layer.masksToBounds = YES;
        [signBGView addSubview:circleView];
        
        //标题
        CGFloat xPosition = leftMargin + circleDiameter + 10;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(xPosition, circleView.frame.origin.y, SCREEN_WIDTH - (10 + xPosition), circleDiameter)];
        CGPoint center =  CGPointMake(label.center.x, label.center.y);
        [label setTextColor:[AUITheme theme].globalThemeColor];
        [label setFont:[UIFont systemFontOfSize:17]];
        [label setLineBreakMode:NSLineBreakByCharWrapping];
        [label setText:model.title];
        [label sizeToFitWithMaximumNumberOfLines:2];
        [label setCenter:center];
        [label setFrame:CGRectMake(xPosition, label.frame.origin.y, label.frame.size.width, label.frame.size.height)];
        [bgView addSubview:label];
    }
    //上方竖线
    if (section > 0) {
        UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(lineXPosition, 0, width, lineHeight)];
        [topLineView setBackgroundColor:[AUITheme theme].globalThemeColor];
        [signBGView addSubview:topLineView];
    }
    return bgView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(parentingStrategyDetailView:didSelectedItemAtIndex:)]) {
        [self.delegate parentingStrategyDetailView:self didSelectedItemAtIndex:indexPath.section];
    }
}

#pragma mark ParentingStrategyDetailViewCellDelegate

- (void)didClickedLocationButtonOnParentingStrategyDetailViewCell:(ParentingStrategyDetailViewCell *)cell {
    if (self.delegate && [self.delegate respondsToSelector:@selector(parentingStrategyDetailView:didClickedLocationButtonAtIndex:)]) {
        [self.delegate parentingStrategyDetailView:self didClickedLocationButtonAtIndex:cell.indexPath.section];
    }
}

- (void)didClickedCommentButtonOnParentingStrategyDetailViewCell:(ParentingStrategyDetailViewCell *)cell {
    if (self.delegate && [self.delegate respondsToSelector:@selector(parentingStrategyDetailView:didClickedCommentButtonAtIndex:)]) {
        [self.delegate parentingStrategyDetailView:self didClickedCommentButtonAtIndex:cell.indexPath.section];
    }
}

- (void)didClickedRelatedInfoButtonOnParentingStrategyDetailViewCell:(ParentingStrategyDetailViewCell *)cell {
    if (self.delegate && [self.delegate respondsToSelector:@selector(parentingStrategyDetailView:didClickedRelatedInfoButtonAtIndex:)]) {
        [self.delegate parentingStrategyDetailView:self didClickedRelatedInfoButtonAtIndex:cell.indexPath.section];
    }
}

#pragma mark Private methods

- (UIView *)buildHeaderView {
    CGFloat mainImageViewHeight = [self.detailModel mainImageHeight];
    CGFloat titleViewHeight = [self.detailModel titleHeight];
    CGFloat tagViewHeight = [self.detailModel tagViewHeight];
    CGFloat strategyDescriptionViewHeight = [self.detailModel strategyDescriptionViewHeight];
    
    CGFloat viewHeight = mainImageViewHeight + titleViewHeight + tagViewHeight + strategyDescriptionViewHeight;
    [self.headerView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, viewHeight)];
    
    CGFloat yPosition = 0;
    //main image
    [self.mainImageView setFrame:CGRectMake(0, yPosition, SCREEN_WIDTH, mainImageViewHeight)];
    [self.mainImageView setImageWithURL:self.detailModel.mainImageUrl];
    yPosition += mainImageViewHeight;
    //title
    [self.titleBGView setFrame:CGRectMake(0, yPosition, SCREEN_WIDTH, titleViewHeight)];
    [self.titleLabel setText:self.detailModel.title];
    yPosition += titleViewHeight;
    //tag
    if (tagViewHeight > 0) {
        [self.tagBGView setFrame:CGRectMake(20, yPosition, SCREEN_WIDTH - 40, tagViewHeight)];
        [self buildTagView];
        yPosition += tagViewHeight;
    }
    //desc
    if (strategyDescriptionViewHeight > 0) {
        [self.descriptionBGView setFrame:CGRectMake(20, yPosition, SCREEN_WIDTH - 40, strategyDescriptionViewHeight)];
        NSString *wholeString = [NSString stringWithFormat:@"攻略描述：%@", self.detailModel.strategyDescription];
        NSMutableAttributedString *labelString = [[NSMutableAttributedString alloc] initWithString:wholeString];
        NSDictionary *attribute = [NSDictionary dictionaryWithObject:[AUITheme theme].globalThemeColor forKey:NSForegroundColorAttributeName];
        [labelString setAttributes:attribute range:NSMakeRange(0, 5)];
        [self.descriptionLabel setAttributedText:labelString];
        [self.descriptionLabel sizeOfSizeToFitWithMaximumNumberOfLines:0];
        [self.descriptionBottomLineView setFrame:CGRectMake(0, strategyDescriptionViewHeight - 2, SCREEN_WIDTH - 40, 2)];
    }
    
    return self.headerView;
}

- (void)buildTagView {
    for (UIView *subview in self.tagBGView.subviews) {
        [subview removeFromSuperview];
    }
    UIView *tagLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 40, 1)];
    [tagLine setBackgroundColor:[UIColor lightGrayColor]];
    [tagLine setAlpha:0.1];
    [self.tagBGView addSubview:tagLine];
    
    CGFloat leftMargin = 0;
    CGFloat rightMargin = 0;
    CGFloat cellHMargin = 5;
    CGFloat cellVMargin = 10;
    CGFloat topMargin = 10;
    
    CGFloat xPosition = leftMargin;
    CGFloat yPosition = topMargin;
    CGFloat buttonHeight = 20;
    CGFloat height = 0;
    for (NSUInteger index = 0; index < [self.detailModel.tagNames count]; index ++) {
        NSString *title = [self.self.detailModel.tagNames objectAtIndex:index];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(xPosition, yPosition, 10, 10)];
        [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
//        [button setTitleColor:[AUITheme theme].globalThemeColor forState:UIControlStateNormal];
        [button setTitleColor:[AUITheme theme].highlightTextColor forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor clearColor]];
        [button sizeToFit];
        [self.tagBGView addSubview:button];
        
        //加点边距
        [button setFrame:CGRectMake(xPosition, yPosition, button.frame.size.width + 10, buttonHeight)];
        
        [button.layer setCornerRadius:10];
        [button.layer setBorderWidth:1];
//        [button.layer setBorderColor:[AUITheme theme].globalThemeColor.CGColor];
        [button.layer setBorderColor:[AUITheme theme].highlightTextColor.CGColor];
        [button.layer setMasksToBounds:YES];
        
        CGFloat nextCellWidth = 0;
        if (index + 1 < [self.detailModel.tagNames count]) {
            NSString *nextTitle = [self.detailModel.tagNames objectAtIndex:index + 1];
            nextCellWidth = 15 * [nextTitle length] + 10;
            //下一个按钮位置调整
            xPosition += button.frame.size.width + cellHMargin;
        }
        CGFloat rightM = button.frame.origin.x + button.frame.size.width + cellHMargin + nextCellWidth;
        CGFloat rightLimit = SCREEN_WIDTH - 40 - leftMargin - rightMargin;
        if (rightM > rightLimit) {
            xPosition = leftMargin;
            yPosition += cellVMargin + buttonHeight;
            height = yPosition + buttonHeight + topMargin;
        }
    }
}

#pragma mark Public methods

- (void)reloadData {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(detailModelForParentingStrategyDetailView:)]) {
        self.detailModel = [self.dataSource detailModelForParentingStrategyDetailView:self];
    }
    self.tableView.tableHeaderView = [self buildHeaderView];
    [self.tableView reloadData];
    if (!self.detailModel) {
        self.tableView.backgroundView = [[KTCEmptyDataView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.tableView.frame.size.height) image:[UIImage imageNamed:@""] description:@"啥都木有啊···"];
    } else {
        self.tableView.backgroundView = nil;
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
