//
//  ParentingStrategyDetailView.m
//  KidsTC
//
//  Created by 钱烨 on 10/8/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "ParentingStrategyDetailView.h"
#import "ParentingStrategyDetailViewCell.h"
#import "StrategyDetailRelatedServiceCell.h"
#import "TTTAttributedLabel.h"

#define ServiceMaxDisplayCount (3)

static NSString *const kCellIdentifier = @"kCellIdentifier";
static NSString *const kRelatedServiceCellIdentifier = @"kRelatedServiceCellIdentifier";


@interface ParentingStrategyDetailView () <UITableViewDataSource, UITableViewDelegate, ParentingStrategyDetailViewCellDelegate, TTTAttributedLabelDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITableViewCell *moreServiceCell;

//header view
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIImageView *mainImageView;
@property (nonatomic, strong) UIView *titleBGView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *tagBGView;
@property (nonatomic, strong) UIView *descriptionBGView;
@property (nonatomic, strong) TTTAttributedLabel *descriptionLabel;
@property (nonatomic, strong) UIView *descriptionBottomLineView;


@property (strong, nonatomic) UIView *storeBriefAlphaView;
@property (strong, nonatomic) UIView *storeBriefBGView;
@property (strong, nonatomic) UILabel *storeBriefLabel;
@property (nonatomic, strong) UILabel *moreStoreLabel;
@property (nonatomic, strong) UIImageView *storeBriefMoreImageView;


@property (nonatomic, strong) UINib *cellNib;
@property (nonatomic, strong) UINib *relatedServiceCellNib;

@property (nonatomic, strong) ParentingStrategyDetailModel *detailModel;

- (UIView *)buildHeaderView;

- (void)buildTagView;

- (void)didClickedAtRelatedStores:(id)sender;

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
    [self.tableView setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalBGColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalBGColor];
   
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    if (!self.cellNib) {
        self.cellNib = [UINib nibWithNibName:NSStringFromClass([ParentingStrategyDetailViewCell class]) bundle:nil];
        [self.tableView registerNib:self.cellNib forCellReuseIdentifier:kCellIdentifier];
    }
    if (!self.relatedServiceCellNib) {
        self.relatedServiceCellNib = [UINib nibWithNibName:NSStringFromClass([StrategyDetailRelatedServiceCell class]) bundle:nil];
        [self.tableView registerNib:self.relatedServiceCellNib forCellReuseIdentifier:kRelatedServiceCellIdentifier];
    }
    
    //header
    self.headerView = [[UIView alloc] init];
    [self.headerView setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalBGColor];
    //main image
    self.mainImageView = [[UIImageView alloc] init];
    [self.headerView addSubview:self.mainImageView];
    //store
    self.storeBriefAlphaView = [[UIView alloc] init];
    [self.storeBriefAlphaView setBackgroundColor:[UIColor blackColor]];
    [self.storeBriefAlphaView setAlpha:0.5];
    [self.headerView addSubview:self.storeBriefAlphaView];
    
    self.storeBriefBGView = [[UIView alloc] init];
    [self.storeBriefBGView setBackgroundColor:[UIColor clearColor]];
    [self.headerView addSubview:self.storeBriefBGView];
    
    
    [self.storeBriefAlphaView setBackgroundColor:[UIColor clearColor]];
    [GToolUtil renderGradientForView:self.storeBriefAlphaView displayFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.storeBriefAlphaView.frame.size.height) startPoint:CGPointMake(0.5, 0) endPoint:CGPointMake(0.5, 1) colors:[NSArray arrayWithObjects:RGBA(0, 0, 0, 0), RGBA(0, 0, 0, 1), nil] locations:nil];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickedAtRelatedStores:)];
    [self.storeBriefBGView addGestureRecognizer:tap];
    
    
    CGFloat xPos = 10;
    CGFloat width = SCREEN_WIDTH - 90;
    self.storeBriefLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPos, 0, width, 30)];
    [self.storeBriefLabel setBackgroundColor:[UIColor clearColor]];
    [self.storeBriefLabel setTextColor:[UIColor whiteColor]];
    [self.storeBriefLabel setFont:[UIFont systemFontOfSize:13]];
    [self.storeBriefBGView addSubview:self.storeBriefLabel];
    
    xPos = SCREEN_WIDTH - 80;
    self.moreStoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPos, 0, 50, 30)];
    [self.moreStoreLabel setBackgroundColor:[UIColor clearColor]];
    [self.moreStoreLabel setTextColor:[UIColor whiteColor]];
    [self.moreStoreLabel setFont:[UIFont systemFontOfSize:12]];
    [self.moreStoreLabel setText:@"点击查看"];
    [self.storeBriefBGView addSubview:self.moreStoreLabel];
    
    xPos += 50;
    self.storeBriefMoreImageView = [[UIImageView alloc] initWithFrame:CGRectMake(xPos, 7.5, 15, 15)];
    [self.storeBriefMoreImageView setImage:[UIImage imageNamed:@"arrow_r"]];
    [self.storeBriefBGView addSubview:self.storeBriefMoreImageView];
    //title
    self.titleBGView = [[UIView alloc] init];
    [self.titleBGView setBackgroundColor:[UIColor clearColor]];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 30)];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.titleLabel setTextColor:[[KTCThemeManager manager] defaultTheme].globalThemeColor];
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
    
    self.descriptionLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH - 40, 20)];
    [self.descriptionLabel setBackgroundColor:[UIColor clearColor]];
    [self.descriptionLabel setTextColor:[UIColor lightGrayColor]];
    [self.descriptionLabel setFont:[UIFont systemFontOfSize:14]];
    [self.descriptionLabel setTextAlignment:NSTextAlignmentLeft];
    [self.descriptionLabel setLineBreakMode:NSLineBreakByCharWrapping];
    self.descriptionLabel.delegate = self;
    [self.descriptionLabel setLinkAttributes:nil];
    [self.descriptionBGView addSubview:self.descriptionLabel];
    [self.headerView addSubview:self.descriptionBGView];
    
    self.descriptionBottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 40, 2)];
    [self.descriptionBottomLineView setBackgroundColor:[UIColor lightGrayColor]];
    [self.descriptionBGView addSubview:self.descriptionBottomLineView];
    
    [self.headerView addSubview:self.descriptionBGView];
}


#pragma mark UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger number = [self.detailModel.cellModels count];
    if ([self.detailModel.relatedServices count] > 0) {
        number += 1;
    }
    return number;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger number = 0;
    if (section < [self.detailModel.cellModels count]) {
        number = 1;
    } else {
        NSUInteger serviceCount = [self.detailModel.relatedServices count];
        if (serviceCount > ServiceMaxDisplayCount) {
            //最多3个
            serviceCount = ServiceMaxDisplayCount;
            //include title
            serviceCount ++;
        }
        number = serviceCount;
    }
    return number;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < [self.detailModel.cellModels count]) {
        ParentingStrategyDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
        if (!cell) {
            cell =  [[[NSBundle mainBundle] loadNibNamed:@"ParentingStrategyDetailViewCell" owner:nil options:nil] objectAtIndex:0];
        }
        cell.indexPath = indexPath;
        cell.delegate = self;
        [cell configWithDetailCellModel:[self.detailModel.cellModels objectAtIndex:indexPath.section]];
        return cell;
    } else {
        if (indexPath.row < ServiceMaxDisplayCount) {
            StrategyDetailRelatedServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:kRelatedServiceCellIdentifier forIndexPath:indexPath];
            if (!cell) {
                cell =  [[[NSBundle mainBundle] loadNibNamed:@"StrategyDetailRelatedServiceCell" owner:nil options:nil] objectAtIndex:0];
            }
            [cell configWithModel:[self.detailModel.relatedServices objectAtIndex:indexPath.row]];
            return cell;
        } else {
            return self.moreServiceCell;
        }
    }
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    if (indexPath.section < [self.detailModel.cellModels count]) {
        ParentingStrategyDetailCellModel *model = [self.detailModel.cellModels objectAtIndex:indexPath.section];
        height = [model cellHeight];
    } else {
        if (indexPath.row < ServiceMaxDisplayCount) {
            height = [StrategyDetailRelatedServiceCell cellHeight];
        } else {
            height = 40;
        }
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = 0.01;
    if (section < [self.detailModel.cellModels count]) {
        ParentingStrategyDetailCellModel *model = [self.detailModel.cellModels objectAtIndex:section];
        if ([model.title length] > 0 || section == 0) {
            height = 50;
        } else {
            height = 20;
        }
    } else {
        height = 20;
    }
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section < [self.detailModel.cellModels count]) {
        CGFloat viewHeight = [self tableView:self.tableView heightForHeaderInSection:section];
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, viewHeight)];
        [bgView setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalBGColor];
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
        [bottomLineView setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalThemeColor];
        [signBGView addSubview:bottomLineView];
        //标题
        ParentingStrategyDetailCellModel *model = [self.detailModel.cellModels objectAtIndex:section];
        if ([model.title length] > 0 || section == 0) {
            //圆圈
            yPosition = (viewHeight - circleDiameter) / 2;
            UIView *circleView = [[UIView alloc] initWithFrame:CGRectMake(0, yPosition, circleDiameter, circleDiameter)];
            [circleView setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalBGColor];
            circleView.layer.borderColor = [[KTCThemeManager manager] defaultTheme].globalThemeColor.CGColor;
            circleView.layer.borderWidth = width;
            circleView.layer.cornerRadius = circleDiameter / 2;
            circleView.layer.masksToBounds = YES;
            [signBGView addSubview:circleView];
            
            //标题
            CGFloat xPosition = leftMargin + circleDiameter + 10;
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(xPosition, circleView.frame.origin.y, SCREEN_WIDTH - (10 + xPosition), circleDiameter)];
            CGPoint center =  CGPointMake(label.center.x, label.center.y);
            [label setTextColor:[[KTCThemeManager manager] defaultTheme].globalThemeColor];
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
            [topLineView setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalThemeColor];
            [signBGView addSubview:topLineView];
        }
        return bgView;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.delegate) {
        if (indexPath.section < [self.detailModel.cellModels count]) {
            if ([self.delegate respondsToSelector:@selector(parentingStrategyDetailView:didSelectedItemAtIndex:)]) {
                [self.delegate parentingStrategyDetailView:self didSelectedItemAtIndex:indexPath.section];
            }
        } else if (indexPath.row < ServiceMaxDisplayCount) {
            if ([self.delegate respondsToSelector:@selector(parentingStrategyDetailView:didClickedRelatedServiceAtIndex:)]) {
                [self.delegate parentingStrategyDetailView:self didClickedRelatedServiceAtIndex:indexPath.row];
            }
        } else {
            if ([self.delegate respondsToSelector:@selector(didClickedAllRelatedServiceOnParentingStrategyDetailView:)]) {
                [self.delegate didClickedAllRelatedServiceOnParentingStrategyDetailView:self];
            }
        }
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


- (void)parentingStrategyDetailViewCell:(ParentingStrategyDetailViewCell *)cell didSelectedLinkWithSegueModel:(HomeSegueModel *)model {
    if (self.delegate && [self.delegate respondsToSelector:@selector(parentingStrategyDetailView:didSelectedLinkWithSegueModel:)]) {
        [self.delegate parentingStrategyDetailView:self didSelectedLinkWithSegueModel:model];
    }
}

#pragma mark TTTAttributedLabelDelegate

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithAddress:(NSDictionary *)addressComponents {
    if (self.delegate && [self.delegate respondsToSelector:@selector(parentingStrategyDetailView:didSelectedLinkWithSegueModel:)]) {
        TextSegueModel *model = [addressComponents objectForKey:@"promotionSegueModel"];
        [self.delegate parentingStrategyDetailView:self didSelectedLinkWithSegueModel:model.segueModel];
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
    [self.mainImageView setImageWithURL:self.detailModel.mainImageUrl placeholderImage:PLACEHOLDERIMAGE_BIG];
    yPosition += mainImageViewHeight;
    //store
    NSUInteger storeCount = [self.detailModel.storeItems count];
    if (storeCount > 0) {
        CGFloat storeBGHeight = 30;
        CGFloat storeYPos = yPosition - storeBGHeight;
        [self.storeBriefAlphaView setFrame:CGRectMake(0, storeYPos, SCREEN_WIDTH, storeBGHeight)];
        [self.storeBriefBGView setFrame:self.storeBriefAlphaView.frame];
        if (storeCount == 1) {
            StrategyDetailRelatedStoreItemModel *model = [self.detailModel.storeItems firstObject];
            [self.storeBriefLabel setText:model.location.locationDescription];
        } else {
            NSString *text = [NSString stringWithFormat:@"全城%lu家门店", (unsigned long)storeCount];
            [self.storeBriefLabel setText:text];
        }
        
        [self.storeBriefAlphaView setHidden:NO];
        [self.storeBriefBGView setHidden:NO];
    } else {
        [self.storeBriefAlphaView setHidden:YES];
        [self.storeBriefBGView setHidden:YES];
    }
    
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
        NSString *wholeString = [NSString stringWithFormat:@"%@：%@", self.detailModel.strategyDescriptionTitle, self.detailModel.strategyDescription];
        NSMutableAttributedString *labelString = [[NSMutableAttributedString alloc] initWithString:wholeString];
        NSDictionary *fontAttribute = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14], NSFontAttributeName, [[KTCThemeManager manager] defaultTheme].lightTextColor, NSForegroundColorAttributeName, nil];
        [labelString setAttributes:fontAttribute range:NSMakeRange(0, [wholeString length])];
        NSDictionary *attribute = [NSDictionary dictionaryWithObjectsAndKeys:[[KTCThemeManager manager] defaultTheme].globalThemeColor, NSForegroundColorAttributeName, nil];
        [labelString addAttributes:attribute range:NSMakeRange(0, [self.detailModel.strategyDescriptionTitle length])];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:AttributeStringLineSpace];//调整行间距
        [labelString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelString length])];
        if (self.detailModel.briefSegueModels) {
            for (TextSegueModel *model in self.detailModel.briefSegueModels) {
                //[NSNumber numberWithBool:YES], NSUnderlineStyleAttributeName
                NSDictionary *linkAttribute = [NSDictionary dictionaryWithObjectsAndKeys:model.linkColor, NSForegroundColorAttributeName, nil];
                for (NSString *rangeString in model.linkRangeStrings) {
                    NSRange range = NSRangeFromString(rangeString);
                    [labelString addAttributes:linkAttribute range:range];
                    [self.descriptionLabel addLinkToAddress:[NSDictionary dictionaryWithObject:model forKey:@"promotionSegueModel"] withRange:range];
                }
            }
        }
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
//        [button setTitleColor:[[KTCThemeManager manager] defaultTheme].globalThemeColor forState:UIControlStateNormal];
        [button setTitleColor:[[KTCThemeManager manager] defaultTheme].highlightTextColor forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor clearColor]];
        [button sizeToFit];
        [self.tagBGView addSubview:button];
        
        //加点边距
        [button setFrame:CGRectMake(xPosition, yPosition, button.frame.size.width + 10, buttonHeight)];
        
        [button.layer setCornerRadius:10];
        [button.layer setBorderWidth:1];
//        [button.layer setBorderColor:[[KTCThemeManager manager] defaultTheme].globalThemeColor.CGColor];
        [button.layer setBorderColor:[[KTCThemeManager manager] defaultTheme].highlightTextColor.CGColor];
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


- (void)didClickedAtRelatedStores:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedStoreOnParentingStrategyDetailView:)]) {
        [self.delegate didClickedStoreOnParentingStrategyDetailView:self];
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

- (void)scrollToRelatedServices {
    if ([self.detailModel.relatedServices count] > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:[self.detailModel.cellModels count]] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    } else if ([self.detailModel.cellModels count] > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:[self.detailModel.cellModels count] - 1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
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
