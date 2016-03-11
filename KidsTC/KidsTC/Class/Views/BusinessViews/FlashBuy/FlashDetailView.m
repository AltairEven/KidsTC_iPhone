//
//  FlashDetailView.m
//  KidsTC
//
//  Created by Altair on 2/29/16.
//  Copyright © 2016 KidsTC. All rights reserved.
//

#import "FlashDetailView.h"
#import "RichPriceView.h"
#import "InsuranceView.h"
#import "AUIBannerScrollView.h"
#import "AUISegmentView.h"
#import "ServiceDetailSegmentCell.h"
#import "ServiceDetailActivityCell.h"
#import "TTTAttributedLabel.h"
#import "ServiceDetailRelatedServiceCell.h"

typedef enum {
    ServiceDetailTableCellTagTop = 0,
    ServiceDetailTableCellTagPrice = 1,
    ServiceDetailTableCellTagInsurance = 2,
    ServiceDetailTableCellTagCoupon = 3,
    ServiceDetailTableCellTagContent = 4,
    ServiceDetailTableCellTagNoticeTitle = 5,
    ServiceDetailTableCellTagNotice = 6,
    ServiceDetailTableCellTagRecommend = 7,
    ServiceDetailTableCellTagActivity = 8,
    ServiceDetailTableCellTagMoreServiceTitle = 9,
    ServiceDetailTableCellTagMoreService = 10
}ServiceDetailTableCellTag;

#define SectionGap (10)
#define SegmentViewHeight (40)
#define MoreServiceMaxCount (3)

static NSString *const kSegmentCellIdentifier = @"kSegmentCellIdentifier";
static NSString *const kActivityCellIdentifier = @"kActivityCellIdentifier";
static NSString *const kMoreServiceCellIdentifier = @"kMoreServiceCellIdentifier";

@interface FlashDetailView () <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, AUIBannerScrollViewDataSource, AUISegmentViewDataSource, AUISegmentViewDelegate, ServiceDetailMoreInfoViewDelegate, TTTAttributedLabelDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) AUISegmentView *segmentView;
@property (nonatomic, strong) ServiceDetailMoreInfoView *moreInfoView;

@property (strong, nonatomic) IBOutlet UITableViewCell *topCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *priceCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *contentCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *noticeTitleCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *noticeCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *recommendCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *moreServiceTitleCell;
//top
@property (weak, nonatomic) IBOutlet AUIBannerScrollView *bannerScrollView;
@property (weak, nonatomic) IBOutlet UIView *storeBriefAlphaView;
@property (weak, nonatomic) IBOutlet UIView *storeBriefBGView;
@property (weak, nonatomic) IBOutlet UILabel *storeBriefLabel;
@property (weak, nonatomic) IBOutlet UIButton *storeBriefButton;
@property (weak, nonatomic) IBOutlet UILabel *serviceNameLabel;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *serviceDescriptionLabel;
//price
@property (weak, nonatomic) IBOutlet RichPriceView *priceView;
@property (weak, nonatomic) IBOutlet RichPriceView *originalPriceView;
@property (weak, nonatomic) IBOutlet UILabel *priceDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentNSaleLabel;
//content
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
//notice
@property (weak, nonatomic) IBOutlet UIView *noticeTitleCellTagView;
@property (weak, nonatomic) IBOutlet UILabel *noticeTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *noticeBGView;

//recommend
@property (weak, nonatomic) IBOutlet UIImageView *recommendFaceImageView;
@property (weak, nonatomic) IBOutlet UILabel *recommendLabel;

//more service
@property (weak, nonatomic) IBOutlet UIView *moreServiceTitleCellTagView;
@property (weak, nonatomic) IBOutlet UILabel *moreServiceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *moreServiceTagImage;



@property (nonatomic, strong) UINib *segmentCellNib;
@property (nonatomic, strong) UINib *activityCellNib;
@property (nonatomic, strong) UINib *moreServiceCellNib;

@property (nonatomic, strong) ServiceDetailModel *detailModel;
@property (nonatomic, strong) NSMutableArray *cellArray;
@property (nonatomic, assign) CGFloat tableViewHeight;
@property (nonatomic, assign) CGFloat viewHeight;

- (void)initTableView;

- (void)initSegmentView;

- (void)initMoreInfoView;

- (void)configTopCell;

- (void)configPriceCell;

- (void)configContentCell;

- (void)configNoticeTitleCell;

- (void)configNoticeCell;

- (void)configRecommendCell;

- (void)didTappedOnStoreBrief;

@end

@implementation FlashDetailView


#pragma mark Initialization


- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    static BOOL bLoad;
    if (!bLoad)
    {
        bLoad = YES;
        FlashDetailView *view = [GConfig getObjectFromNibWithView:self];
        [view buildSubviews];
        return view;
    }
    bLoad = NO;
    return self;
}

- (void)buildSubviews {
    
    [self.scrollView setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalBGColor];
    self.scrollView.delegate = self;
    
    self.bannerScrollView.dataSource = self;
    [self.bannerScrollView setRecyclable:YES];
    [self.bannerScrollView setShowPageIndex:NO];
    
    [self.storeBriefAlphaView setBackgroundColor:[UIColor clearColor]];
    [GToolUtil renderGradientForView:self.storeBriefAlphaView displayFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.storeBriefAlphaView.frame.size.height) startPoint:CGPointMake(0.5, 0) endPoint:CGPointMake(0.5, 1) colors:[NSArray arrayWithObjects:RGBA(0, 0, 0, 0), RGBA(0, 0, 0, 1), nil] locations:nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTappedOnStoreBrief)];
    [self.storeBriefBGView addGestureRecognizer:tap];
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
    //description
    self.serviceDescriptionLabel.delegate = self;
    [self.serviceDescriptionLabel setLinkAttributes:nil];
    //price view
    [self.priceView setContentColor:[[KTCThemeManager manager] defaultTheme].globalThemeColor];
    [self.priceView setUnitFont:[UIFont systemFontOfSize:15]];
    [self.priceView setPriceFont:[UIFont systemFontOfSize:25]];
    
    [self.originalPriceView setContentColor:[UIColor lightGrayColor]];
    [self.originalPriceView setUnitFont:[UIFont systemFontOfSize:12]];
    [self.originalPriceView setPriceFont:[UIFont systemFontOfSize:12]];
    [self.originalPriceView setSlashed:YES];
    
    [self.priceDescriptionLabel setTextColor:[[KTCThemeManager manager] defaultTheme].globalThemeColor];
    //segment view
    //moreinfo view
    //cells
    [self.topCell.contentView setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalCellBGColor];
    
    [self.priceCell.contentView setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalCellBGColor];
    
    [self.contentCell.contentView setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalCellBGColor];
    
    [self.noticeTitleCell.contentView setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalCellBGColor];
    [self.noticeTitleLabel setText:@"购买须知"];
    [self.noticeTitleCellTagView setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalThemeColor];
    
    [self.noticeCell.contentView setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalCellBGColor];
    
    
    [self.moreServiceTitleCellTagView setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalThemeColor];
    
    if (!self.activityCellNib) {
        self.activityCellNib = [UINib nibWithNibName:NSStringFromClass([ServiceDetailActivityCell class]) bundle:nil];
        [self.tableView registerNib:self.activityCellNib forCellReuseIdentifier:kActivityCellIdentifier];
    }
    if (!self.moreServiceCellNib) {
        self.moreServiceCellNib = [UINib nibWithNibName:NSStringFromClass([ServiceDetailRelatedServiceCell class]) bundle:nil];
        [self.tableView registerNib:self.moreServiceCellNib forCellReuseIdentifier:kMoreServiceCellIdentifier];
    }
    
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
        case ServiceDetailTableCellTagTop:
        {
            [self configTopCell];
        }
            break;
        case ServiceDetailTableCellTagPrice:
        {
            [self configPriceCell];
        }
            break;
        case ServiceDetailTableCellTagContent:
        {
            [self configContentCell];
        }
            break;
        case ServiceDetailTableCellTagNoticeTitle:
        {
            [self configNoticeTitleCell];
        }
            break;
        case ServiceDetailTableCellTagNotice:
        {
            [self configNoticeCell];
        }
            break;
        case ServiceDetailTableCellTagRecommend:
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
        case ServiceDetailTableCellTagTop:
        {
            height = [self.detailModel topCellHeight];
        }
            break;
        case ServiceDetailTableCellTagPrice:
        {
            height = [self.detailModel priceCellHeight];
        }
            break;
        case ServiceDetailTableCellTagContent:
        {
            height = [self.detailModel contentCellHeight];
        }
            break;
        case ServiceDetailTableCellTagNoticeTitle:
        {
            height = [self.detailModel noticeTitleCellHeight];
        }
            break;
        case ServiceDetailTableCellTagNotice:
        {
            height = [self.detailModel noticeCellHeight];
        }
            break;
        case ServiceDetailTableCellTagRecommend:
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
    if (self.delegate) {
//        UITableViewCell *cell = [[self.cellArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
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
        if (self.delegate && [self.delegate respondsToSelector:@selector(FlashDetailView:didScrolledAtOffset:)]) {
            [self.delegate FlashDetailView:self didScrolledAtOffset:self.scrollView.contentOffset];
        }
    }
}


#pragma mark AUIBannerScrollViewDataSource

- (NSUInteger)numberOfBannersOnScrollView:(AUIBannerScrollView *)scrollView {
    return [self.detailModel.narrowImageUrls count];
}

- (UIImageView *)bannerImageViewOnScrollView:(AUIBannerScrollView *)scrollView withViewFrame:(CGRect)frame atIndex:(NSUInteger)index {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    NSURL *imageUrl = [self.detailModel.narrowImageUrls objectAtIndex:index];
    [imageView setImageWithURL:imageUrl placeholderImage:PLACEHOLDERIMAGE_BIG];
    return imageView;
}

- (NSURL *)bannerImageUrlForScrollView:(AUIBannerScrollView *)scrollView atIndex:(NSUInteger)index {
    NSURL *imageUrl = [self.detailModel.narrowImageUrls objectAtIndex:index];
    return imageUrl;
}


- (CGFloat)heightForBannerScrollView:(AUIBannerScrollView *)scrollView {
    return SCREEN_WIDTH * self.detailModel.imageRatio;
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
            [cell.titleLabel setText:@"门店"];
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
    if (self.delegate && [self.delegate respondsToSelector:@selector(FlashDetailView:didChangedMoreInfoViewTag:)]) {
        [self.delegate FlashDetailView:self didChangedMoreInfoViewTag:viewTag];
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
    if (self.delegate && [self.delegate respondsToSelector:@selector(FlashDetailView:didClickedStoreCellAtIndex:)]) {
        [self.delegate FlashDetailView:self didClickedStoreCellAtIndex:index];
    }
}

- (void)serviceDetailMoreInfoView:(ServiceDetailMoreInfoView *)infoView didClickedCommentAtIndex:(NSUInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(FlashDetailView:didClickedCommentCellAtIndex:)]) {
        [self.delegate FlashDetailView:self didClickedCommentCellAtIndex:index];
    }
}


- (void)didClickedMoreCommentButtonOnServiceDetailMoreInfoView:(ServiceDetailMoreInfoView *)infoView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedMoreCommentOnFlashDetailView:)]) {
        [self.delegate didClickedMoreCommentOnFlashDetailView:self];
    }
}

#pragma mark TTTAttributedLabelDelegate

- (void)attributedLabel:(TTTAttributedLabel *)label
didSelectLinkWithAddress:(NSDictionary *)addressComponents {
    if (self.delegate && [self.delegate respondsToSelector:@selector(FlashDetailView:didSelectedLinkWithSegueModel:)]) {
        TextSegueModel *model = [addressComponents objectForKey:@"promotionSegueModel"];
        [self.delegate FlashDetailView:self didSelectedLinkWithSegueModel:model.segueModel];
    }
}

#pragma mark Private methods

- (void)initTableView {
    if (!self.tableView) {
        //table view initialization, init after scroll view built
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.tableViewHeight) style:UITableViewStyleGrouped];
        self.tableView.backgroundView = nil;
        [self.tableView setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalBGColor];
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
    [GConfig resetLineView:self.bannerScrollView withLayoutAttribute:NSLayoutAttributeHeight constant:self.detailModel.imageRatio * SCREEN_WIDTH];
    //store brief
    NSUInteger storeCount = [self.detailModel.storeItemsArray count];
    if (storeCount > 1) {
        [self.storeBriefAlphaView setHidden:NO];
        [self.storeBriefBGView setHidden:NO];
        NSString *title = [NSString stringWithFormat:@"全城%lu家门店通用", (unsigned long)storeCount];
        [self.storeBriefLabel setText:title];
    } else {
        StoreListItemModel *itemModel = [self.detailModel.storeItemsArray firstObject];
        if (itemModel.location) {
            [self.storeBriefAlphaView setHidden:NO];
            [self.storeBriefBGView setHidden:NO];
            [self.storeBriefLabel setText:itemModel.storeName];
        } else {
            [self.storeBriefAlphaView setHidden:YES];
            [self.storeBriefBGView setHidden:YES];
        }
    }
    //others
    [self.serviceNameLabel setText:self.detailModel.serviceName];
    
    NSMutableAttributedString *labelString = [[NSMutableAttributedString alloc] initWithString:self.detailModel.serviceDescription];
    NSDictionary *fontAttribute = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13], NSFontAttributeName, [[KTCThemeManager manager] defaultTheme].globalThemeColor, NSForegroundColorAttributeName, nil];
    [labelString setAttributes:fontAttribute range:NSMakeRange(0, [labelString length])];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:AttributeStringLineSpace];//调整行间距
    [labelString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelString length])];
    if (self.detailModel.promotionSegueModels) {
        for (TextSegueModel *model in self.detailModel.promotionSegueModels) {
            //[NSNumber numberWithBool:YES], NSUnderlineStyleAttributeName
            NSDictionary *linkAttribute = [NSDictionary dictionaryWithObjectsAndKeys:model.linkColor, NSForegroundColorAttributeName, [NSNumber numberWithBool:YES], NSUnderlineStyleAttributeName, nil];
            for (NSString *rangeString in model.linkRangeStrings) {
                NSRange range = NSRangeFromString(rangeString);
                [labelString addAttributes:linkAttribute range:range];
                [self.serviceDescriptionLabel addLinkToAddress:[NSDictionary dictionaryWithObject:model forKey:@"promotionSegueModel"] withRange:range];
            }
        }
    }
    [self.serviceDescriptionLabel setAttributedText:labelString];
}

- (void)configPriceCell {
    //price
    [self.priceView setPrice:self.detailModel.currentPrice];
    if (self.detailModel.originalPrice <= self.detailModel.currentPrice) {
        [self.originalPriceView setHidden:YES];
    } else {
        [self.originalPriceView setPrice:self.detailModel.originalPrice];
    }
    if ([self.detailModel.priceDescription length] > 0) {
        [self.priceDescriptionLabel setHidden:NO];
        [self.priceDescriptionLabel setText:self.detailModel.priceDescription];
    } else {
        [self.priceDescriptionLabel setText:@""];
        [self.priceDescriptionLabel setHidden:YES];
    }
    //count
    NSString *commentCount = [NSString stringWithFormat:@"%lu", (unsigned long)self.detailModel.commentsNumber];
    NSString *saleCount = [NSString stringWithFormat:@"%lu", (unsigned long)self.detailModel.saleCount];
    
    NSString *wholeString = [NSString stringWithFormat:@"%@评价|已售%@", commentCount, saleCount];
    NSMutableAttributedString *labelString = [[NSMutableAttributedString alloc] initWithString:wholeString];
    NSDictionary *attribute = [NSDictionary dictionaryWithObject:[[KTCThemeManager manager] defaultTheme].highlightTextColor forKey:NSForegroundColorAttributeName];
    [labelString setAttributes:attribute range:NSMakeRange(0, [commentCount length])];
    [labelString addAttributes:attribute range:NSMakeRange([labelString length] - [saleCount length], [saleCount length])];
    [self.commentNSaleLabel setAttributedText:labelString];
}

- (void)configContentCell {
    [self.contentLabel setText:self.detailModel.serviceContent];
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
        [titleLabel setTextColor:RGBA(120, 120, 120, 1)];
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
        [contentLabel setTextColor:RGBA(120, 120, 120, 1)];
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

- (void)didTappedOnStoreBrief {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedStoreBriefOnFlashDetailView:)]) {
        [self.delegate didClickedStoreBriefOnFlashDetailView:self];
    }
}

#pragma mark Public methods

- (void)setIntroductionUrlString:(NSString *)urlString {
    self.detailModel.introductionUrlString = urlString;
    [self.moreInfoView setIntroductionUrlString:urlString];
}

- (void)reloadData {
    [self.cellArray removeAllObjects];
    self.tableViewHeight = 0;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(detailModelForFlashDetailView:)]) {
        self.detailModel = [self.dataSource detailModelForFlashDetailView:self];
        if (self.detailModel) {
            NSMutableArray *section1 = [NSMutableArray arrayWithObjects:self.topCell, self.priceCell, nil];
            self.tableViewHeight = [self.detailModel topCellHeight] + [self.detailModel priceCellHeight];
            [self.cellArray addObject:[NSArray arrayWithArray:section1]];
            
            if ([self.detailModel.serviceContent length] > 0) {
                NSArray *section2 = [NSArray arrayWithObject:self.contentCell];
                [self.cellArray addObject:section2];
                self.tableViewHeight += SectionGap;
                self.tableViewHeight += [self.detailModel contentCellHeight];
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
        self.tableView.backgroundView = [[KTCEmptyDataView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.tableView.frame.size.height) image:[UIImage imageNamed:@""] description:@"啥都木有啊···" needGoHome:YES];
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
