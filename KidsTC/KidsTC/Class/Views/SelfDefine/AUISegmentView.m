#import "AUISegmentView.h"


@interface AUISegmentView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) CGFloat cellWidth;

@property (nonatomic, assign) BOOL hasRotated;

- (void)buildSubviews;

@end

@implementation AUISegmentView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self buildSubviews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self buildSubviews];
    }
    return self;
}

- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    [self buildSubviews];
    return self;
}

- (void)buildSubviews {
    CGRect tableViewRect = CGRectMake(0.0, 0.0, self.frame.size.height, SCREEN_WIDTH);
    self.tableView = [[UITableView alloc] initWithFrame:tableViewRect style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // scrollbar 不显示
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    
    [self.tableView setScrollEnabled:NO];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0, 10, 0, 10)];
    }
    
    [self addSubview:self.tableView];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    if (selectedIndex < self.segmentCellCount) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
        [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

- (void)setScrollEnable:(BOOL)scrollEnable {
    _scrollEnable = scrollEnable;
    [self.tableView setScrollEnabled:scrollEnable];
}

- (void)setShowSeparator:(BOOL)showSeparator {
    if (showSeparator) {
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    } else {
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
}


#pragma mark UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.segmentCellCount;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 10, 0, 10)];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(segmentView:cellAtIndex:)]) {
        cell = [self.dataSource segmentView:self cellAtIndex:indexPath.row];
        cell.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    if (self.scrollEnable) {
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(segmentView:cellWidthAtIndex:)]) {
            height = [self.dataSource segmentView:self cellWidthAtIndex:indexPath.row];
        } else {
            height = self.frame.size.height;
        }
    } else {
        height = self.frame.size.width / self.segmentCellCount;
    }
    return height;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _selectedIndex = indexPath.row;
    if (self.delegate && [self.delegate respondsToSelector:@selector(segmentView:didSelectedAtIndex:)]) {
        [self.delegate segmentView:self didSelectedAtIndex:indexPath.row];
    }
}

#pragma mark Public method

- (void)reloadData {
    if (!self.hasRotated) {
        [self.tableView setFrame:CGRectMake(0.0, 0.0, self.frame.size.height, SCREEN_WIDTH)];
        //tableview逆时针旋转90度。
        self.tableView.center = CGPointMake(SCREEN_WIDTH / 2, self.frame.size.height / 2);
        self.tableView.transform = CGAffineTransformMakeRotation(-M_PI / 2);
        self.hasRotated = YES;
    }
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfCellsForSegmentView:)]) {
        _segmentCellCount = [self.dataSource numberOfCellsForSegmentView:self];
        [self.tableView reloadData];
    }
}

- (void)registerNib:(UINib *)nib forCellReuseIdentifier:(NSString *)identifier {
    if (!nib) {
        return;
    }
    [self.tableView registerNib:nib forCellReuseIdentifier:identifier];
}

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier forIndex:(NSUInteger)index {
    return [self.tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
}

- (void)deselectAll {
    [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex inSection:0] animated:YES];
}

- (void)deselectIndex:(NSUInteger)index {
    [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
