//
//  AccountSettingViewController.m
//  KidsTC
//
//  Created by 钱烨 on 7/29/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "AccountSettingViewController.h"
#import "AccountSettingViewModel.h"
#import "UserRoleSelectViewController.h"
#import "ChangeNickNameViewController.h"
#import "ChangePasswordViewController.h"
#import "ImageTrimViewController.h"

@interface AccountSettingViewController () <AccountSettingViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, ImageTrimViewControllerDelegate>

@property (weak, nonatomic) IBOutlet AccountSettingView *settingView;

@property (nonatomic, strong) AccountSettingViewModel *viewModel;

@property (nonatomic, strong) AccountSettingModel *settingModel;

-(void)getMediaFromSource:(UIImagePickerControllerSourceType)sourceType;

@end

@implementation AccountSettingViewController

- (instancetype)initWithAccountSettingModel:(AccountSettingModel *)model {
    self = [super initWithNibName:@"AccountSettingViewController" bundle:nil];
    if (self) {
        self.settingModel = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _navigationTitle = @"账户设置";
    // Do any additional setup after loading the view from its nib.
    self.settingView.delegate = self;
    self.viewModel = [[AccountSettingViewModel alloc] initWithView:self.settingView];
    self.viewModel.settingModel = self.settingModel;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.viewModel startUpdateDataWithSucceed:nil failure:nil];
}

#pragma mark AccountSettingViewDelegate

- (void)accountSettingView:(AccountSettingView *)settingView didClickedWithViewTag:(AccountSettingViewTag)tag {
    switch (tag) {
        case AccountSettingViewTagFaceImage:
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"更改头像" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
            
            UIAlertAction *actionTake = [UIAlertAction actionWithTitle:@"拍照上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self getMediaFromSource:UIImagePickerControllerSourceTypeCamera];
            }];
            UIAlertAction *actionChoose = [UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self getMediaFromSource:UIImagePickerControllerSourceTypePhotoLibrary];
            }];
            UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [alertController dismissViewControllerAnimated:YES completion:nil];
            }];
            [alertController addAction:actionTake];
            [alertController addAction:actionChoose];
            [alertController addAction:actionCancel];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
            break;
        case AccountSettingViewTagRole:
        {
            UserRoleSelectViewController *controller = [[UserRoleSelectViewController alloc] initWithNibName:@"UserRoleSelectViewController" bundle:nil];
            
            __weak UserRoleSelectViewController *weakController = controller;
            [controller setCompleteBlock:^(UserRole selectedRole, KTCSex selectedSex){
                KTCUserRole *role = [KTCUserRole instanceWithRole:selectedRole sex:selectedSex];
                [[KTCUser currentUser] setUserRole:role];
                [weakController.navigationController popViewControllerAnimated:YES];
                self.viewModel.settingModel.userRole = role;
                [self.viewModel startUpdateDataWithSucceed:nil failure:nil];
            }];
            [controller setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case AccountSettingViewTagNickName:
        {
            ChangeNickNameViewController *controller = [[ChangeNickNameViewController alloc] initWithNibName:@"ChangeNickNameViewController" bundle:nil];
            [controller setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case AccountSettingViewTagMobilePhone:
        {
            
        }
            break;
        case AccountSettingViewTagPassword:
        {
            ChangePasswordViewController *controller = [[ChangePasswordViewController alloc] initWithNibName:@"ChangePasswordViewController" bundle:nil];
            [controller setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)didClickedLogoutButtonOnAccountSettingView:(AccountSettingView *)settingView {
    [[KTCUser currentUser] logoutManually:YES withSuccess:nil failure:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info {
    NSString *lastChosenMediaType=[info objectForKey:UIImagePickerControllerMediaType];
    if([lastChosenMediaType isEqual:(NSString *) kUTTypeImage]) {
        UIImage *chosenImage=[info objectForKey:UIImagePickerControllerOriginalImage];
        ImageTrimViewController *trimVC = [[ImageTrimViewController alloc] initWithImage:chosenImage targetSize:CGSizeMake(200, 200)];
        trimVC.delegate = self;
        [picker pushViewController:trimVC animated:YES];
    } else {
        [picker dismissViewControllerAnimated:YES completion:nil];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"错误信息" message:@"头像不支持非图片格式" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark ImageTrimViewControllerDelegate

- (void)imageTrimViewController:(ImageTrimViewController *)controller didFinishedTrimmingWithNewImage:(UIImage *)image {
    if (image) {
        UIImage *trimmedImage = [image imageByScalingToSize:CGSizeMake(100, 100)];
        [self.viewModel resetFaceImage:trimmedImage];
    } else {
        [[iToast makeText:@"获取图片失败"] show];
    }
}

#pragma mark Private methods

-(void)getMediaFromSource:(UIImagePickerControllerSourceType)sourceType
{
    if([UIImagePickerController isSourceTypeAvailable:sourceType]){
        NSArray *mediatypes=[UIImagePickerController availableMediaTypesForSourceType:sourceType];
        UIImagePickerController *picker=[[UIImagePickerController alloc] init];
        picker.mediaTypes=mediatypes;
        picker.delegate = self;
        picker.allowsEditing=NO;
        picker.sourceType=sourceType;
        NSString *requiredmediatype=(NSString *)kUTTypeImage;
        NSArray *arrmediatypes=[NSArray arrayWithObject:requiredmediatype];
        [picker setMediaTypes:arrmediatypes];
        [self presentViewController:picker animated:YES completion:nil];
    }
    else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"错误信息" message:@"当前设备不支持拍摄功能" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}

#pragma mark Super methods

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
