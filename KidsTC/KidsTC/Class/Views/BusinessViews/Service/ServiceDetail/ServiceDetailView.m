//
//  ServiceDetailView.m
//  KidsTC
//
//  Created by 钱烨 on 7/13/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "ServiceDetailView.h"
#import "RichPriceView.h"
#import "InsuranceView.h"
#import "AUIBannerScrollView.h"
#import "AUISegmentView.h"
#import "ServiceDetailSegmentCell.h"

#define BannerRatio (1)
#define SectionGap (10)
#define SegmentViewHeight (40)

static NSString *const kSegmentCellIdentifier = @"kSegmentCellIdentifier";

@interface ServiceDetailView () <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, AUIBannerScrollViewDataSource, AUISegmentViewDataSource, AUISegmentViewDelegate, ServiceDetailMoreInfoViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) AUISegmentView *segmentView;
@property (nonatomic, strong) ServiceDetailMoreInfoView *moreInfoView;

@property (strong, nonatomic) IBOutlet UITableViewCell *topCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *priceCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *InsuranceCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *couponCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *noticeTitleCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *noticeCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *recommendCell;
//top
@property (weak, nonatomic) IBOutlet AUIBannerScrollView *bannerScrollView;
@property (weak, nonatomic) IBOutlet UILabel *serviceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceDescriptionLabel;
//price
@property (weak, nonatomic) IBOutlet RichPriceView *priceView;
@property (weak, nonatomic) IBOutlet UILabel *priceDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentNSaleLabel;
//insurance
@property (weak, nonatomic) IBOutlet InsuranceView *InsuranceView;
//coupon
@property (weak, nonatomic) IBOutlet UILabel *couponTitleLabel;
//notice
@property (weak, nonatomic) IBOutlet UIView *noticeTitleCellTagView;
@property (weak, nonatomic) IBOutlet UILabel *noticeTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *noticeBGView;

//recommend
@property (weak, nonatomic) IBOutlet UIImageView *recommendFaceImageView;
@property (weak, nonatomic) IBOutlet UILabel *recommendLabel;


@property (nonatomic, strong) UINib *segmentCellNib;

@property (nonatomic, strong) ServiceDetailModel *detailModel;
@property (nonatomic, strong) NSMutableArray *cellArray;
@property (nonatomic, assign) CGFloat tableViewHeight;
@property (nonatomic, assign) CGFloat viewHeight;

- (void)initTableView;

- (void)initSegmentView;

- (void)initMoreInfoView;

- (void)configTopCell;

- (void)configPriceCell;

- (void)configInsuranceCell;

- (void)configCouponCell;

- (void)configNoticeTitleCell;

- (void)configNoticeCell;

- (void)configRecommendCell;

@end

@implementation ServiceDetailView


#pragma mark Initialization


- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    static BOOL bLoad;
    if (!bLoad)
    {
        bLoad = YES;
        ServiceDetailView *view = [GConfig getObjectFromNibWithView:self];
        [view buildSubviews];
        return view;
    }
    bLoad = NO;
    return self;
}

- (void)buildSubviews {
    [self.scrollView setBackgroundColor:[AUITheme theme].globalBGColor];
    self.scrollView.delegate = self;
    
    self.bannerScrollView.dataSource = self;
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
    //price view
    [self.priceView setContentColor:[AUITheme theme].globalThemeColor];
    [self.priceView.unitLabel setFont:[UIFont systemFontOfSize:15]];
    [self.priceView.priceLabel setFont:[UIFont systemFontOfSize:25]];
    
    self.priceDescriptionLabel.layer.borderWidth = BORDER_WIDTH;
    self.priceDescriptionLabel.layer.borderColor = [AUITheme theme].globalThemeColor.CGColor;
    self.priceDescriptionLabel.layer.cornerRadius = 2;
    self.priceDescriptionLabel.layer.masksToBounds = YES;
    [self.priceDescriptionLabel setTextColor:[AUITheme theme].globalThemeColor];
    //segment view
    //moreinfo view
    //cells
    [self.topCell.contentView setBackgroundColor:[AUITheme theme].globalCellBGColor];
    
    [self.priceCell.contentView setBackgroundColor:[AUITheme theme].globalCellBGColor];
    
    [self.InsuranceView setFontSize:13];
    [self.InsuranceCell.contentView setBackgroundColor:[AUITheme theme].globalCellBGColor];
    
    [self.couponCell.contentView setBackgroundColor:[AUITheme theme].globalCellBGColor];
    
    [self.noticeTitleCell.contentView setBackgroundColor:[AUITheme theme].globalCellBGColor];
    [self.noticeTitleLabel setText:@"购买须知"];
    [self.noticeTitleCellTagView setBackgroundColor:[AUITheme theme].globalThemeColor];
    
    [self.noticeCell.contentView setBackgroundColor:[AUITheme theme].globalCellBGColor];
    
    [self.recommendCell.contentView setBackgroundColor:[AUITheme theme].globalCellBGColor];
    self.recommendFaceImageView.layer.cornerRadius = 30;
    self.recommendFaceImageView.layer.masksToBounds = YES;
    
    self.cellArray = [[NSMutableArray alloc] init];
}


#pragma mark UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.cellArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *rowArray = [self.cellArray objectAtIndex:section];
    return [rowArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *rowArray = [self.cellArray objectAtIndex:indexPath.section];
    UITableViewCell *cell = [rowArray objectAtIndex:indexPath.row];
    switch (cell.tag) {
        case 0:
        {
            [self configTopCell];
        }
            break;
        case 1:
        {
            [self configPriceCell];
        }
            break;
        case 2:
        {
            [self configInsuranceCell];
        }
            break;
        case 3:
        {
            [self configCouponCell];
        }
            break;
        case 4:
        {
            [self configNoticeTitleCell];
        }
            break;
        case 5:
        {
            [self configNoticeCell];
        }
            break;
        case 6:
        {
            [self configRecommendCell];
        }
            break;
        default:
            break;
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *rowArray = [self.cellArray objectAtIndex:indexPath.section];
    UITableViewCell *cell = [rowArray objectAtIndex:indexPath.row];
    
    CGFloat height = 0;
    switch (cell.tag) {
        case 0:
        {
            height = [self.detailModel topCellHeight];
        }
            break;
        case 1:
        {
            height = [self.detailModel priceCellHeight];
        }
            break;
        case 2:
        {
            height = [self.detailModel insuranceCellHeight];
        }
            break;
        case 3:
        {
            height = [self.detailModel couponCellHeight];
        }
            break;
        case 4:
        {
            height = [self.detailModel noticeTitleCellHeight];
        }
            break;
        case 5:
        {
            height = [self.detailModel noticeCellHeight];
        }
            break;
        case 6:
        {
            height = [self.detailModel recommendCellHeight];
        }
            break;
        default:
            break;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = 0.01;
    if (section > 0) {
        height = SectionGap / 2;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    CGFloat height = SectionGap / 2;
    if (section == [self.cellArray count] - 1) {
        height = SectionGap;
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [[self.cellArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if (cell == self.couponCell) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedCouponOnServiceDetailView:)]) {
            [self.delegate didClickedCouponOnServiceDetailView:self];
        }
    }
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        CGFloat offset = self.scrollView.contentOffset.y;
        if (offset >= self.tableViewHeight) {
            //segment view置顶
            [self.segmentView setFrame:CGRectMake(0, offset, self.segmentView.frame.size.width, self.segmentView.frame.size.height)];
            [self.moreInfoView setScrollEnabled:YES];
        } else {
            //segment view移动
            [self.segmentView setFrame:CGRectMake(0, self.tableViewHeight, self.segmentView.frame.size.width, self.segmentView.frame.size.height)];
            [self.moreInfoView setScrollEnabled:NO];
        }
    }
}


#pragma mark AUIBannerScrollViewDataSource

- (NSUInteger)numberOfBannersOnScrollView:(AUIBannerScrollView *)scrollView {
    return [self.detailModel.imageUrls count];
}

- (UIImageView *)bannerImageViewOnScrollView:(AUIBannerScrollView *)scrollView withViewFrame:(CGRect)frame atIndex:(NSUInteger)index {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    NSURL *imageUrl = [self.detailModel.imageUrls objectAtIndex:index];
    if (index == 1) {
        [imageView setImageWithURL:imageUrl];
    } else {
        [imageView setImageWithURL:imageUrl];
    }
    return imageView;
}


- (CGFloat)heightForBannerScrollView:(AUIBannerScrollView *)scrollView {
    return SCREEN_WIDTH * BannerRatio;
}

#pragma mark AUISegmentViewDataSource & AUISegmentViewDelegate

- (NSUInteger)numberOfCellsForSegmentView:(AUISegmentView *)segmentView {
    return 3;
}

- (UITableViewCell *)segmentView:(AUISegmentView *)segmentView cellAtIndex:(NSUInteger)index {
    
    ServiceDetailSegmentCell *cell = [segmentView dequeueReusableCellWithIdentifier:kSegmentCellIdentifier forIndex:index];
    if (!cell) {
        cell =  [[[NSBundle mainBundle] loadNibNamed:@"ServiceDetailSegmentCell" owner:nil options:nil] objectAtIndex:0];
    }
    switch (index) {
        case 0:
        {
            [cell.titleLabel setText:@"商品详情"];
        }
            break;
        case 1:
        {
            [cell.titleLabel setText:@"商户"];
        }
            break;
        case 2:
        {
            [cell.titleLabel setText:@"评价"];
        }
            break;
        default:
            break;
    }
    return cell;
}

- (void)segmentView:(AUISegmentView *)segmentView didSelectedAtIndex:(NSUInteger)index {
    ServiceDetailMoreInfoViewTag viewTag = (ServiceDetailMoreInfoViewTag)index;
    [self.moreInfoView setViewTag:viewTag];
    if (self.delegate && [self.delegate respondsToSelector:@selector(serviceDetailView:didChangedMoreInfoViewTag:)]) {
        [self.delegate serviceDetailView:self didChangedMoreInfoViewTag:viewTag];
    }
}

#pragma mark ServiceDetailMoreInfoViewDelegate

- (void)serviceDetailMoreInfoView:(ServiceDetailMoreInfoView *)infoView didChangedViewContentSize:(CGSize)size {
    CGFloat moreInfoHeight = size.height;
    CGFloat standardHeight = infoView.standardViewSize.height;
    if (moreInfoHeight <= standardHeight) {
        moreInfoHeight = standardHeight;
    }
    self.viewHeight = self.tableViewHeight + SegmentViewHeight + moreInfoHeight;
    [self.scrollView setContentSize:CGSizeMake(0, self.viewHeight)];
}

- (void)serviceDetailMoreInfoView:(ServiceDetailMoreInfoView *)infoView didClickedStoreAtIndex:(NSUInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(serviceDetailView:didClickedStoreCellAtIndex:)]) {
        [self.delegate serviceDetailView:self didClickedStoreCellAtIndex:index];
    }
}

- (void)serviceDetailMoreInfoView:(ServiceDetailMoreInfoView *)infoView didClickedCommentAtIndex:(NSUInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(serviceDetailView:didClickedCommentCellAtIndex:)]) {
        [self.delegate serviceDetailView:self didClickedCommentCellAtIndex:index];
    }
}


- (void)didClickedMoreCommentButtonOnServiceDetailMoreInfoView:(ServiceDetailMoreInfoView *)infoView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedMoreCommentOnServiceDetailView:)]) {
        [self.delegate didClickedMoreCommentOnServiceDetailView:self];
    }
}

#pragma mark Private methods

- (void)initTableView {
    if (!self.tableView) {
        //table view initialization, init after scroll view built
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.tableViewHeight) style:UITableViewStyleGrouped];
        self.tableView.backgroundView = nil;
        [self.tableView setBackgroundColor:[AUITheme theme].globalBGColor];
        [self.tableView setScrollEnabled:NO];
        [self.tableView setShowsHorizontalScrollIndicator:NO];
        [self.tableView setShowsVerticalScrollIndicator:NO];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.scrollView addSubview:self.tableView];
    }
    [self.tableView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.tableViewHeight)];
}

- (void)initSegmentView {
    if (!self.segmentView) {
        self.segmentView = [[AUISegmentView alloc] initWithFrame:CGRectMake(0, self.tableViewHeight, SCREEN_WIDTH, SegmentViewHeight)];
        [self.segmentView setScrollEnable:NO];
        [self.segmentView setShowSeparator:NO];
        self.segmentView.dataSource = self;
        self.segmentView.delegate = self;
        if (!self.segmentCellNib) {
            self.segmentCellNib = [UINib nibWithNibName:NSStringFromClass([ServiceDetailSegmentCell class]) bundle:nil];
            [self.segmentView registerNib:self.segmentCellNib forCellReuseIdentifier:kSegmentCellIdentifier];
        }
        [self.segmentView reloadData];
        [self.scrollView addSubview:self.segmentView];
        [self.segmentView setSelectedIndex:0];
        [self segmentView:self.segmentView didSelectedAtIndex:0];
    }
    [self.segmentView setFrame:CGRectMake(0, self.tableViewHeight, SCREEN_WIDTH, SegmentViewHeight)];
}

- (void)initMoreInfoView {
    if (!self.moreInfoView) {
        self.moreInfoView = [[ServiceDetailMoreInfoView alloc] init];
        self.moreInfoView.delegate = self;
        [self.scrollView addSubview:self.moreInfoView];
        
        [self.scrollView bringSubviewToFront:self.segmentView];
    }
    CGRect standardFrame = CGRectMake(0, self.tableViewHeight + SegmentViewHeight, SCREEN_WIDTH, self.frame.size.height - SegmentViewHeight);
    [self.moreInfoView setFrame:standardFrame];
    [self.moreInfoView setStandardViewSize:standardFrame.size];
    [self.moreInfoView setViewTag:(ServiceDetailMoreInfoViewTag)self.segmentView.selectedIndex];
    [self.moreInfoView setIntroductionUrlString:self.detailModel.introductionUrlString];
    [self.moreInfoView setStoreListModels:self.detailModel.storeItemsArray];
    [self.moreInfoView setCommentListModels:self.detailModel.commentItemsArray];
}

- (void)configTopCell {
    //banner
    [self.bannerScrollView reloadData];
    //others
    [self.serviceNameLabel setText:self.detailModel.serviceName];
    [self.serviceDescriptionLabel setText:self.detailModel.serviceDescription];
}

- (void)configPriceCell {
    //price
    [self.priceView setPrice:self.detailModel.price];
    if ([self.detailModel.priceDescription length] > 0) {
        [self.priceDescriptionLabel setHidden:NO];
        [self.priceDescriptionLabel setText:self.detailModel.priceDescription];
    } else {
        [self.priceDescriptionLabel setHidden:YES];
    }
    //count
    NSString *commentCount = [NSString stringWithFormat:@"%lu", (unsigned long)self.detailModel.commentsNumber];
    NSString *saleCount = [NSString stringWithFormat:@"%lu", (unsigned long)self.detailModel.saleCount];
    
    NSString *wholeString = [NSString stringWithFormat:@"%@评价|已售%@", commentCount, saleCount];
    NSMutableAttributedString *labelString = [[NSMutableAttributedString alloc] initWithString:wholeString];
    NSDictionary *attribute = [NSDictionary dictionaryWithObject:[AUITheme theme].highlightTextColor forKey:NSForegroundColorAttributeName];
    [labelString setAttributes:attribute range:NSMakeRange(0, [commentCount length])];
    [labelString addAttributes:attribute range:NSMakeRange([labelString length] - [saleCount length], [saleCount length])];
    [self.commentNSaleLabel setAttributedText:labelString];
}

- (void)configInsuranceCell {
    [self.InsuranceView setSupportedInsurance:self.detailModel.supportedInsurances];
}

- (void)configCouponCell {
    [self.couponTitleLabel setText:self.detailModel.couponName];
}

- (void)configNoticeTitleCell {
}

- (void)configNoticeCell {
    CGFloat margin = 10;
    CGFloat xPosition = margin;
    CGFloat yPosition = margin;
    UIFont *font = [UIFont systemFontOfSize:13];
    
    for (ServiceDetailNoticeItem *item in self.detailModel.noticeArray) {
        CGFloat labelWidth = SCREEN_WIDTH - margin * 2;
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPosition, yPosition, labelWidth, 20)];
        [titleLabel setTextColor:[UIColor lightGrayColor]];
        [titleLabel setFont:font];
        [titleLabel setLineBreakMode:NSLineBreakByCharWrapping];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setText:item.title];
        [titleLabel sizeToFitWithMaximumNumberOfLines:0];
        [self.noticeBGView addSubview:titleLabel];
        
        labelWidth = SCREEN_WIDTH - margin * 2 - titleLabel.frame.size.width;
        if (labelWidth < 100) {
            labelWidth = SCREEN_WIDTH - margin * 2;
            xPosition = margin;
            yPosition += titleLabel.frame.size.height + margin;
        } else {
            xPosition += titleLabel.frame.size.width;
        }
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPosition, yPosition, labelWidth, 20)];
        [contentLabel setTextColor:[UIColor lightGrayColor]];
        [contentLabel setFont:font];
        [contentLabel setLineBreakMode:NSLineBreakByCharWrapping];
        [contentLabel setBackgroundColor:[UIColor clearColor]];
        [contentLabel setText:item.content];
        [contentLabel sizeToFitWithMaximumNumberOfLines:0];
        [self.noticeBGView addSubview:contentLabel];
        
        xPosition = margin;
        yPosition += contentLabel.frame.size.height + margin * 2;
    }
}

- (void)configRecommendCell {
    [self.recommendFaceImageView setImageWithURL:self.detailModel.recommenderFaceImageUrl];
    
    NSString *recommderName = self.detailModel.recommenderName;
    if ([recommderName length] == 0) {
        recommderName = @"童童推荐";
    }
    NSString *wholeString = [NSString stringWithFormat:@"%@：%@", recommderName, self.detailModel.recommendString];
    NSMutableAttributedString *labelString = [[NSMutableAttributedString alloc] initWithString:wholeString];
    NSDictionary *attribute = [NSDictionary dictionaryWithObject:[UIFont boldSystemFontOfSize:15] forKey:NSFontAttributeName];
    [labelString setAttributes:attribute range:NSMakeRange(0, [recommderName length] + 1)];
    [self.recommendLabel setAttributedText:labelString];
    
}

#pragma mark Public methods

- (void)setIntroductionUrlString:(NSString *)urlString {
    self.detailModel.introductionUrlString = urlString;
    [self.moreInfoView setIntroductionUrlString:urlString];
}

- (void)reloadData {
    [self.cellArray removeAllObjects];
    self.tableViewHeight = 0;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(detailModelForServiceDetailView:)]) {
        self.detailModel = [self.dataSource detailModelForServiceDetailView:self];
        if (self.detailModel) {
            NSMutableArray *section1 = [NSMutableArray arrayWithObjects:self.topCell, self.priceCell, nil];
            self.tableViewHeight = [self.detailModel topCellHeight] + [self.detailModel priceCellHeight];
            if ([self.detailModel.supportedInsurances count] > 0) {
                [section1 addObject:self.InsuranceCell];
                self.tableViewHeight += [self.detailModel insuranceCellHeight];
            }
            [self.cellArray addObject:[NSArray arrayWithArray:section1]];
            
            if (self.detailModel.hasCoupon) {
                NSArray *section2 = [NSArray arrayWithObject:self.couponCell];
                [self.cellArray addObject:section2];
                self.tableViewHeight += SectionGap;
                self.tableViewHeight += [self.detailModel couponCellHeight];
            }
            if ([self.detailModel.noticeArray count] > 0) {
                NSArray *section3 = [NSArray arrayWithObjects:self.noticeTitleCell, self.noticeCell, nil];
                [self.cellArray addObject:section3];
                self.tableViewHeight += SectionGap;
                self.tableViewHeight += [self.detailModel noticeTitleCellHeight] + [self.detailModel noticeCellHeight];
            }
            if ([self.detailModel.recommendString length] > 0) {
                NSArray *section4 = [NSArray arrayWithObject:self.recommendCell];
                [self.cellArray addObject:section4];
                self.tableViewHeight += SectionGap;
                self.tableViewHeight += [self.detailModel recommendCellHeight];
            }
            self.tableViewHeight += SectionGap;
        }
    }
    [self initTableView];
    [self initSegmentView];
    [self initMoreInfoView];
    self.viewHeight = self.tableViewHeight + self.segmentView.frame.size.height + self.moreInfoView.frame.size.height;
    [self.scrollView setContentSize:CGSizeMake(0, self.viewHeight)];
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
