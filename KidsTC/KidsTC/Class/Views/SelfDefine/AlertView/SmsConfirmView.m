/*
 * Copyright (c) 2011,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：SmsConfirmView.m
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：qitao
 * 完成日期：2011年10月09日
 */


#import "SmsConfirmView.h"


#define PHONE_CELL_HEIGHT         44


@interface SmsConfirmView()

@end

@implementation SmsConfirmView

#pragma mark -
#pragma mark BaseAlertView

- (void)loadContentView{
    [[NSBundle mainBundle] loadNibNamed:@"SmsConfirmView" 
                                  owner:self
                                options:nil];
    _replaceView = NO;
}

- (void)willDismissAlertView{
    [super willDismissAlertView];
    if (_replaceView) {
        SmsConfirmView *view = [[SmsConfirmView alloc] init];
        [view show];
    }
}

- (void)willPresentAlertView{
    [super willPresentAlertView];
}
- (void)didDismissAlertView{
    [super didDismissAlertView];
}


#pragma mark -
#pragma mark Public

- (void)showSmsConfirmViewWithHint:(NSString*)hint
{
    UIView * lastView = [_contentView.subviews lastObject];
    [lastView removeFromSuperview];
    
    if (hint) {
        _verifyLabel.text = hint;
    }
    [_contentView addSubview:_confirmInputView];
    _confirmInputView.center = CGPointMake(_contentView.center.x, _contentView.center.y*2.0/3.0);
    [_verifyText becomeFirstResponder];
    
    [super show];
}

- (void)showPhoneNoViewWithTitle:(NSString*)title andHint:(NSString*)hint
{
    UIView * lastView = [_contentView.subviews lastObject];
    [lastView removeFromSuperview];
    
    if (title) {
        _phoneNoTitle.text = title;
    }
    if (hint) {
        _phoneNoLabel.text = hint;
    }
    [_contentView addSubview:_phoneNoView];
    _phoneNoView.center = CGPointMake(_contentView.center.x, _contentView.center.y*2.0/3.0);
    [_phoneText becomeFirstResponder];
    
    [super show];
}


- (void)showCallSupportView
{
    UIView * lastView = [_contentView.subviews lastObject];
    [lastView removeFromSuperview];
    
    [_contentView addSubview:_CallSupportView];
    _CallSupportView.center = _contentView.center;
    
    [super show];
}

- (void)showSimplePhoneView:(NSArray*)phoneArr
{
    _phoneList = phoneArr;

    UIView * lastView = [_contentView.subviews lastObject];
    [lastView removeFromSuperview];
    
    NSInteger limitCnt = phoneArr.count;
    if (limitCnt == 0) limitCnt = 1;
    if (limitCnt > 4) limitCnt = 4;
    
    CGRect oldRc = _simplePhontView.frame;
    CGFloat df = _phoneTable.frame.size.height - limitCnt*44;
    oldRc.size.height -= df;
    _simplePhontView.frame = oldRc;
    
    [_contentView addSubview:_simplePhontView];
    _simplePhontView.center = _contentView.center;
    
    [super show];
}

- (IBAction)callHelp
{
    if (_confirmBlock) {
        _confirmBlock(nil);
    }
}

- (IBAction)fetchVerifyCode
{
    if (_phoneText.text.length > 0) {
        if (_confirmBlock) {
            _confirmBlock(_phoneText.text);
        }
    }
}

- (IBAction)verifyConform
{
    if (_verifyText.text.length > 0) {
        if (_confirmBlock) {
            _confirmBlock(_verifyText.text);
        }
    }
}

- (IBAction)cancel {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    [self dismissAnimated:YES];
}



#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return PHONE_CELL_HEIGHT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return _phoneList.count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *phoneIdentifierCell = @"phoneIdentifierCell";
    
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:phoneIdentifierCell];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:phoneIdentifierCell];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.highlightedTextColor = cell.textLabel.textColor = [UIColor colorWithWhite:45.0/255 alpha:1];
        
        UIImageView * sepLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"point_line.png"]];
        sepLine.frame = CGRectMake(20, PHONE_CELL_HEIGHT-1, 232, 1);
        [cell.contentView addSubview:sepLine];
        
        UIView * selBgView = [[UIView alloc] initWithFrame:cell.bounds];
        selBgView.backgroundColor = COLOR_BLUE;
        UIImageView * selArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"point_choose.png"]];
        selArrow.frame = CGRectMake(55, 17, 11, 10);
        [selBgView addSubview:selArrow];
        cell.selectedBackgroundView = selBgView;
	}
    
	cell.textLabel.text = [_phoneList objectAtIndex:indexPath.row];
    
	return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_confirmBlock) {
        _confirmBlock([_phoneList objectAtIndex:indexPath.row]);
    }
}

@end
