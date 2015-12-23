//
//  MC_PhotoAlbumViewController.m
//  Coordinate
//
//  Created by Qian Ye on 13-11-19.
//  Copyright (c) 2013年 MapABC. All rights reserved.
//

#import "MC_PhotoAlbumViewController.h"
//#include "GlobalDefine.h"
#import "MC_PhotoAlbumCell.h"
#import "MC_ImagePickerViewController.h"

static MC_PhotoAlbumViewController *controller;

@interface MC_PhotoAlbumViewController ()

@property (strong, nonatomic) ALAssetsLibrary *assetsLibrary;

@property (strong, nonatomic) UIView *topView;

@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) UIButton *btnCancel;

@property (strong, nonatomic) UITableView *table;

@property (strong, nonatomic) NSMutableArray *dataArray;

- (NSArray *)getAllGroupsData;

- (void)allGroupsGotWithData:(NSArray *)array;

@end

@implementation MC_PhotoAlbumViewController

@synthesize topView, titleLabel, btnCancel, table;
@synthesize dataArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (id)init
{
    self = [super init];
    if (self) {
        self.assetsLibrary = [[ALAssetsLibrary alloc] init];
        self.dataArray = [[NSMutableArray alloc] init];
    }
    
    return self;
}

+ (MC_PhotoAlbumViewController *)sharedInstance
{
    if (controller == nil) {
        controller = [[MC_PhotoAlbumViewController alloc] init];
    }
    
    return controller;
}


- (void)initView
{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    CGFloat fLeft = 0.0;
    CGFloat fTop = 0.0;
    CGFloat fWidth = self.view.frame.size.width;
    CGFloat fHeight = 40.0;
//    if (CurrentVersion >= 7.0) {
//        fHeight = 60.0;
//    }
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(fLeft, fTop, fWidth, fHeight)];
    [self.topView setBackgroundColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0]];
    [self.view addSubview:self.topView];
    
    fLeft = 5.0;
//    if (CurrentVersion >= 7.0) {
        fTop = 25.0;
//    } else {
//        fTop = 5.0;
//    }
    fWidth = 60.0;
    fHeight = 30.0;
    self.btnCancel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.btnCancel setFrame:CGRectMake(fLeft, fTop, fWidth, fHeight)];
    [self.btnCancel setTitle:@"取消" forState:UIControlStateNormal];
    [self.btnCancel setBackgroundColor:[UIColor clearColor]];
    [self.btnCancel addTarget:self action:@selector(onClickCancelButton) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:self.btnCancel];
    
    fLeft = 100.0;
    fWidth = 120.0;
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(fLeft, fTop, fWidth, fHeight)];
    [self.titleLabel setText:@"相册"];
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.topView addSubview:self.titleLabel];
    
//    if (CurrentVersion >= 7.0) {
        fHeight = 60.0;
//    } else {
//        fHeight = 40.0;
//    }
    fLeft = 0.0;
    fTop = fHeight;
    fWidth = self.view.frame.size.width;
    fHeight = self.view.frame.size.height - fTop;
    self.table = [[UITableView alloc] initWithFrame:CGRectMake(fLeft, fTop, fWidth, fHeight)];
    [self.table setDelegate:self];
    [self.table setDataSource:self];
    [self.view addSubview:self.table];
}


- (void)onClickCancelButton
{
    [self dismissViewControllerAnimated:YES completion:^(void){;}];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    MC_PhotoAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSString *name = [[self.dataArray objectAtIndex:indexPath.row] objectForKey:PhotoAlbumName];
        NSString *assetCount = [[self.dataArray objectAtIndex:indexPath.row] objectForKey:PhotoAlbumAssetsCount];
        NSString *description = [NSString stringWithFormat:@"%@(%@个资源)", name, assetCount];
        UIImage *posterImage = [[self.dataArray objectAtIndex:indexPath.row] objectForKey:PhotoAlbumPosterImage];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:description, MCPhotoAlbumDataTypeDescription, posterImage, MCPhotoAlbumDataTypePosterImage, nil];
        cell = [[MC_PhotoAlbumCell alloc] initWithStyle:UITableViewCellStyleDefault dataDic:dic andReuseIdentifier:CellIdentifier];
    }
    //config the cell
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return MC_PHOTOALBUMCELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate MC_PhotoAlbumViewController:self didChooseAlbumGroup:[[self.dataArray objectAtIndex:indexPath.row] objectForKey:PhotoAlbumAssetsGroup]];
    [self dismissViewControllerAnimated:YES completion:^(void){;}];
}


- (NSArray *)getAllGroupsData
{
    NSMutableArray *groupsArray = [[NSMutableArray alloc] init];
    //get photo groups
    void (^assetsGroupsEnumerator)(ALAssetsGroup *, BOOL *) = ^ (ALAssetsGroup *group, BOOL *stop)
    {
        if (group == nil) {
            
            if (*stop == NO) {
                [self allGroupsGotWithData:groupsArray];
            }
            
            return;
        }
        
        NSString *assetsGroup = [NSString stringWithFormat:@"%@",group];//获取相簿的组
        NSString *groupInfo = [assetsGroup substringFromIndex:16 ] ;
        NSArray *arr = [[NSArray alloc] init];
        arr = [groupInfo componentsSeparatedByString:@","];
        NSString *groupName = [[arr objectAtIndex:0] substringFromIndex:5];
        NSString *assetsCount = [[arr objectAtIndex:2] substringFromIndex:14];
        
        CGImageRef posterImageRef = [group posterImage];
        UIImage *posterImage = [UIImage imageWithCGImage:posterImageRef];
        
        NSDictionary *dataDic = [NSDictionary dictionaryWithObjectsAndKeys:groupName, PhotoAlbumName, assetsCount, PhotoAlbumAssetsCount, posterImage, PhotoAlbumPosterImage, group, PhotoAlbumAssetsGroup, nil];
        [groupsArray addObject:dataDic];
    };
    
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:assetsGroupsEnumerator failureBlock:^(NSError *){NSLog(@"Get saved photos failed.");}];
    
    return groupsArray;
}


- (void)allGroupsGotWithData:(NSArray *)array
{
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:array];
    [self.table reloadData];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self initView];
    [self getAllGroupsData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
