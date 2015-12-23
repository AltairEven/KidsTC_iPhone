//
//  KTCSearchFilterView.m
//  KidsTC
//
//  Created by 钱烨 on 7/31/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "KTCSearchFilterView.h"
#import "KTCSearchResultFilterLevel1Cell.h"
#import "KTCSearchResultFilterLevel2Cell.h"


inline KTCSearchResultFilterCoordinate FilterCoordinateMake(NSInteger level1Index, NSInteger level2Index) {
    KTCSearchResultFilterCoordinate coordinate;
    coordinate.level1Index = level1Index;
    coordinate.level2Index = level2Index;
    return coordinate;
}

static NSString *const kLevel1CellIdentifier = @"kLevel1CellIdentifier";
static NSString *const kLevel2CellIdentifier = @"kLevel2CellIdentifier";

@interface KTCSearchFilterView () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *filterBGView;
@property (weak, nonatomic) IBOutlet UIView *lvl1BGView;
@property (weak, nonatomic) IBOutlet UIView *lvl2BGView;
@property (weak, nonatomic) IBOutlet UIView *peopleBGView;

@property (weak, nonatomic) IBOutlet UIView *peopleDot;
@property (weak, nonatomic) IBOutlet UIButton *peopleButton;
@property (weak, nonatomic) IBOutlet UIView *peopleTag;


@property (weak, nonatomic) IBOutlet UITableView *level1Table;
@property (weak, nonatomic) IBOutlet UITableView *level2Table;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;

@property (nonatomic, strong) UINib *level1CellNib;
@property (nonatomic, strong) UINib *level2CellNib;

@property (nonatomic, assign) BOOL peopleButtonSelected;
@property (nonatomic, assign) NSInteger currentLevel1Index;
@property (nonatomic, assign) NSInteger currentLevel2Index;

- (IBAction)didClickedPeopleButton:(id)sender;
- (IBAction)didClickedConfirmButton:(id)sender;
- (IBAction)didClickedClearButton:(id)sender;

@end

@implementation KTCSearchFilterView

#pragma mark Initialization

- (instancetype)init {
    self = [[[NSBundle mainBundle] loadNibNamed:@"KTCSearchFilterView" owner:self options:nil] objectAtIndex:0];
    if (self) {
        [self buildSubviews];
    }
    return self;
}


- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    static BOOL bLoad;
    if (!bLoad)
    {
        bLoad = YES;
        KTCSearchFilterView *view = [GConfig getObjectFromNibWithView:self];
        return view;
    }
    bLoad = NO;
    return self;
}

- (void)buildSubviews {
    [self.filterBGView setBackgroundColor:[AUITheme theme].globalBGColor];
    [self.lvl1BGView setBackgroundColor:[AUITheme theme].globalBGColor];
    [self.lvl2BGView setBackgroundColor:[AUITheme theme].globalBGColor];
    [self.peopleBGView setBackgroundColor:[AUITheme theme].globalCellBGColor];
    [self.peopleTag setBackgroundColor:[AUITheme theme].globalThemeColor];
    [self.peopleDot setBackgroundColor:[AUITheme theme].globalThemeColor];
    
    self.peopleDot.layer.cornerRadius = 2.5;
    self.peopleDot.layer.masksToBounds = YES;
    [self.peopleDot setHidden:YES];
    [self.peopleTag setHidden:YES];
    
    self.level1Table.delegate = self;
    self.level1Table.dataSource = self;
    self.level1Table.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
    if (!self.level1CellNib) {
        self.level1CellNib = [UINib nibWithNibName:NSStringFromClass([KTCSearchResultFilterLevel1Cell class]) bundle:nil];
        [self.level1Table registerNib:self.level1CellNib forCellReuseIdentifier:kLevel1CellIdentifier];
    }
    
    self.level2Table.delegate = self;
    self.level2Table.dataSource = self;
    self.level2Table.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
    if (!self.level2CellNib) {
        self.level2CellNib = [UINib nibWithNibName:NSStringFromClass([KTCSearchResultFilterLevel2Cell class]) bundle:nil];
        [self.level2Table registerNib:self.level2CellNib forCellReuseIdentifier:kLevel2CellIdentifier];
    }
    
    self.currentLevel1Index = -1;
    self.currentLevel2Index = -1;
    
    [self.confirmButton setBackgroundColor:[AUITheme theme].buttonBGColor_Normal forState:UIControlStateNormal];
    [self.confirmButton setBackgroundColor:[AUITheme theme].buttonBGColor_Highlight forState:UIControlStateHighlighted];
}

- (void)setPeopleButtonSelected:(BOOL)peopleButtonSelected {
    _peopleButtonSelected = peopleButtonSelected;
    [self.peopleTag setHidden:!peopleButtonSelected];
}


#pragma mark UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger number = 0;
    if (tableView == self.level1Table) {
        number = [self.categoriesFilterModelArray count];
    } else {
        if (self.peopleButtonSelected) {
            number = [self.peopleFilterModel.subArray count];
        } else {
            KTCSearchResultFilterModel *model = [self.categoriesFilterModelArray objectAtIndex:self.currentLevel1Index];
            number = [model.subArray count];
        }
    }
    return number;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.level1Table) {
        KTCSearchResultFilterLevel1Cell *cell = [tableView dequeueReusableCellWithIdentifier:kLevel1CellIdentifier forIndexPath:indexPath];
        if (!cell) {
            cell =  [[[NSBundle mainBundle] loadNibNamed:@"KTCSearchResultFilterLevel1Cell" owner:nil options:nil] objectAtIndex:0];
        }
        KTCSearchResultFilterModel *model = [self.categoriesFilterModelArray objectAtIndex:indexPath.row];
        [cell.titleLabel setText:model.name];
        if (self.categoryFilterCoordinate.level1Index == indexPath.row && self.categoryFilterCoordinate.level2Index >= 0) {
            [cell hideDot:NO];
        } else {
            [cell hideDot:YES];
        }
        return cell;
    }
    if (tableView == self.level2Table) {
        KTCSearchResultFilterLevel2Cell *cell = [tableView dequeueReusableCellWithIdentifier:kLevel2CellIdentifier forIndexPath:indexPath];
        if (!cell) {
            cell =  [[[NSBundle mainBundle] loadNibNamed:@"KTCSearchResultFilterLevel2Cell" owner:nil options:nil] objectAtIndex:0];
        }
        KTCSearchResultFilterModel *model = nil;
        if (self.peopleButtonSelected) {
            model = [self.peopleFilterModel.subArray objectAtIndex:indexPath.row];
        } else {
            KTCSearchResultFilterModel *level1 = [self.categoriesFilterModelArray objectAtIndex:self.currentLevel1Index];
            model = [level1.subArray objectAtIndex:indexPath.row];
        }
        [cell.titleLabel setText:model.name];
        return cell;
    }
    
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    if (tableView == self.level1Table) {
        height = 44;
    } else {
        height = 44;
    }
    return height;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.level1Table) {
        self.peopleButtonSelected = NO;
        self.currentLevel1Index = indexPath.row;
        [self.level2Table reloadData];
        self.currentLevel2Index = -1;
        if (indexPath.row == self.categoryFilterCoordinate.level1Index && self.categoryFilterCoordinate.level2Index >= 0) {
            [self.level2Table selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.categoryFilterCoordinate.level2Index inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
            self.currentLevel2Index = self.categoryFilterCoordinate.level2Index;
        }
    }
    if (tableView == self.level2Table) {
        if (self.peopleButtonSelected) {
            if (self.currentLevel2Index != indexPath.row) {
                [self.peopleDot setHidden:NO];
                _peopleFilterCoordinate = FilterCoordinateMake(0, indexPath.row);
                self.currentLevel2Index = indexPath.row;
            } else {
                [self.peopleDot setHidden:YES];
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
                self.currentLevel2Index = -1;
                _peopleFilterCoordinate = FilterCoordinateMake(0, -1);
            }
        } else {
            if (self.currentLevel2Index != indexPath.row) {
                _categoryFilterCoordinate = FilterCoordinateMake(self.currentLevel1Index, indexPath.row);
                self.currentLevel2Index = indexPath.row;
            } else {
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
                _categoryFilterCoordinate = FilterCoordinateMake(self.currentLevel1Index, -1);
                self.currentLevel2Index = -1;
            }
            [self.level1Table reloadData];
            [self.level1Table selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentLevel1Index inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
#pragma mark Private methods

- (IBAction)didClickedPeopleButton:(id)sender {
    if (!self.peopleButtonSelected) {
        self.peopleButtonSelected = YES;
        [self.level1Table deselectRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentLevel1Index inSection:0] animated:YES];
        [self.level2Table reloadData];
        if (self.peopleFilterCoordinate.level2Index >= 0) {
            [self.level2Table selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.peopleFilterCoordinate.level2Index inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
            self.currentLevel2Index = self.peopleFilterCoordinate.level2Index;
        }
    }
}

- (IBAction)didClickedConfirmButton:(id)sender {
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(didClickedConfirmButtonOnSearchFilterView:)]) {
            [self.delegate didClickedConfirmButtonOnSearchFilterView:self];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(filterViewNeedDismiss:)]) {
            [self.delegate filterViewNeedDismiss:self];
        }
    }
}

- (IBAction)didClickedClearButton:(id)sender {
    _peopleFilterCoordinate = FilterCoordinateMake(-1, -1);
    [self.peopleDot setHidden:YES];
    
    if (self.currentLevel2Index >= 0) {
        [self.level2Table deselectRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentLevel2Index inSection:0] animated:YES];
    }
    _categoryFilterCoordinate = FilterCoordinateMake(-1, -1);
    [self.level1Table reloadData];
    if (!self.peopleButtonSelected) {
        [self.level1Table selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentLevel1Index inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}


#pragma mark Public methods

- (void)showWithPeopleFilterCoordinate:(KTCSearchResultFilterCoordinate)peopleFilterCoordinate categoryFilterCoordinate:(KTCSearchResultFilterCoordinate)categoryFilterCoordinate {
    [self.superview bringSubviewToFront:self];
    [self setHidden:NO];
    _peopleFilterCoordinate = peopleFilterCoordinate;
    _categoryFilterCoordinate = categoryFilterCoordinate;
    self.peopleButtonSelected = NO;
    
    self.currentLevel1Index = -1;
    [self.level1Table reloadData];
    [self didClickedPeopleButton:nil];
}


@end
