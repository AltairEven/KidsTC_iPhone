#import <UIKit/UIKit.h>

@class AUISegmentView;

@protocol AUISegmentViewDataSource <NSObject>

- (NSUInteger)numberOfCellsForSegmentView:(AUISegmentView *)segmentView;

- (UITableViewCell *)segmentView:(AUISegmentView *)segmentView cellAtIndex:(NSUInteger)index;

@optional

- (CGFloat)segmentView:(AUISegmentView *)segmentView cellWidthAtIndex:(NSUInteger)index;

@end

@protocol AUISegmentViewDelegate <NSObject>

- (void)segmentView:(AUISegmentView *)segmentView didSelectedAtIndex:(NSUInteger)index;

@end

@interface AUISegmentView : UIView

@property (nonatomic, assign) id<AUISegmentViewDataSource> dataSource;

@property (nonatomic, assign) id<AUISegmentViewDelegate> delegate;

@property (nonatomic, assign) NSUInteger selectedIndex;

@property (nonatomic, readonly) NSUInteger segmentCellCount;

@property (nonatomic, assign) BOOL scrollEnable;

@property (nonatomic, assign) BOOL showSeparator; //default NO

- (void)registerNib:(UINib *)nib forCellReuseIdentifier:(NSString *)identifier;

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier forIndex:(NSUInteger)index;

- (void)reloadData;

- (void)deselectAll;

- (void)deselectIndex:(NSUInteger)index;

- (void)scrollToIndex:(NSUInteger)index position:(UITableViewScrollPosition)position animated:(BOOL)animated;

@end
