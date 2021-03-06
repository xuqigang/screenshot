//
//  XHScreenshotEditVC.m
//  ScreenShot
//
//  Created by 韩肖杰 on 2019/1/4.
//  Copyright © 2019 xuqigang. All rights reserved.
//

#import "XHScreenshotEditVC.h"
#import "ScreenshotPreview.h"
#import "XHScreenshotTextFiled.h"
#import "XHScreenshotPasterView.h"
#import "XHScreenshotMenuView.h"
#import "XHColorSelectedView.h"
#import "XHPasterSelectView.h"
#import "XHTextStyleEditView.h"
#import "ZYQAssetPickerController.h"
#import "XHScreenshotPreviewVC.h"
#import "BackgroundFuctionPanelView.h"
#import <ZipArchive.h>
@interface XHScreenshotEditVC ()<XHScreenshotMenuViewDelegate,ScreenshotTextFieldDelegate,ScreenshotPreviewDelegate,XHScreenshotPasterViewDelegate, ZYQAssetPickerControllerDelegate,UINavigationControllerDelegate,BackgroundFuctionPanelViewDelegate,XHScreenshotMenuViewDelegate>
@property (nonatomic, strong) NSMutableArray *materialArray;
@property (nonatomic, strong) ScreenshotPreview *screenshotPreview;
@property (nonatomic, strong) XHScreenshotMenuView *screenshotMenuView;
@property (nonatomic, strong) BackgroundFuctionPanelView *backgroundFuctionPanelView;
@end

@implementation XHScreenshotEditVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.materialArray = [NSMutableArray arrayWithCapacity:1];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupScreenshotParameter];
    // Do any additional setup after loading the view from its nib.
}
- (void)setupUI{
    self.navigationItem.title = @"Snapshot Wrapper";
    [self setRightButtonText:@"Save"];
    [self setRightSecondButtonText:@"预览"];
    [self.view addSubview:self.screenshotPreview];
    [self.view addSubview:self.screenshotMenuView];
}
- (void)setupScreenshotParameter{
    self.screenshotPreview.backgroundColor = self.XHTemplateParameter.backgroundColor;
    self.screenshotPreview.shellImage = [UIImage imageNamed:self.XHTemplateParameter.shellImage];
    self.screenshotPreview.screenshotImage = self.XHTemplateParameter.screenshotImage;
    self.screenshotPreview.shellTopScale = self.XHTemplateParameter.shellTopScale;
    self.screenshotPreview.screenshotType = self.XHTemplateParameter.screenshotType;
//    [self.XHTemplateParameter.XHTextPatameters enumerateObjectsUsingBlock:^(XHTextPatameter * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        CGFloat y = arc4random() % 100 + 60;
//        CGFloat x = arc4random() % 100 + 20;
//        XHScreenshotTextFiled *textField = [[XHScreenshotTextFiled alloc] initWithFrame:CGRectMake(x, y, 0, 0)];
//        textField.delegate = self;
//        textField.textLabel.text = obj.text;
//        textField.textLabel.font = obj.font;
//        textField.textLabel.textColor = obj.textColor;
//        textField.textLabel.backgroundColor = obj.backgroundColor;
//        [self.screenshotPreview addSubview:textField];
//        [textField updatePosition];
//        [textField setIsEditing:NO];
//        [self.materialArray addObject:textField];
//    }];
//
    
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    CGFloat bottomHeight = 49;
    CGFloat topHeight = StatusBarHeight + 44;
    if (@available(iOS 11.0, *)) {
        UIEdgeInsets safeAreaInsets = [UIApplication sharedApplication].keyWindow.safeAreaInsets;
        bottomHeight = bottomHeight + safeAreaInsets.bottom;
    }
    
    CGFloat screenshotPreviewHeight = self.view.xm_height - topHeight - bottomHeight - 80;
    CGFloat screenshotPreviewWidth = screenshotPreviewHeight * self.XHTemplateParameter.screenshotScale;
    self.screenshotPreview.frame = CGRectMake((self.view.xm_width - screenshotPreviewWidth)/2.0, topHeight + 40,screenshotPreviewWidth , screenshotPreviewHeight);
    self.screenshotMenuView.frame = CGRectMake(0, self.view.xm_height - bottomHeight, self.view.xm_width, bottomHeight);
}
#pragma mark -init
- (ScreenshotPreview*)screenshotPreview{
    if (!_screenshotPreview) {
        _screenshotPreview = [ScreenshotPreview instanceFromNib];
        _screenshotPreview.delegate = self;
    }
    return _screenshotPreview;
}
- (XHScreenshotMenuView*)screenshotMenuView{
    if (!_screenshotMenuView) {
        _screenshotMenuView = [XHScreenshotMenuView instanceFromNib];
        _screenshotMenuView.delegate = self;
    }
    return _screenshotMenuView;
}
- (BackgroundFuctionPanelView*)backgroundFuctionPanelView{
    if (!_backgroundFuctionPanelView) {
        _backgroundFuctionPanelView = [BackgroundFuctionPanelView defaultView];
        _backgroundFuctionPanelView.delegate = self;
    }
    return _backgroundFuctionPanelView;
}

- (XHTemplateParameter*)XHTemplateParameter{
    if (!_XHTemplateParameter) {
        _XHTemplateParameter = [[XHTemplateParameter alloc] init];
        _XHTemplateParameter.shellTopScale = 0.75;
        _XHTemplateParameter.shellImage = @"shell_iPhonePlus";
    }
    return _XHTemplateParameter;
}
    
#pragma mark - 父类
- (void)rightButtonClicked:(UIButton *)button //需要时，在子类重写
{
    [self.screenshotPreview generateScreenshotImageCallback:^(UIImage * _Nonnull image) {
        UIImageWriteToSavedPhotosAlbum(image, self,@selector(image:didFinishSavingWithError:contextInfo:),nil);
    }];
}
- (void)rightSecondButtonClicked:(UIButton *)button //需要时，在子类重写
{
    [self.screenshotPreview generateScreenshotImageCallback:^(UIImage * _Nonnull image) {
        XHScreenshotPreviewVC *vc = [XHScreenshotPreviewVC instanceFromNib];
        vc.preImage = image;
        PushViewController(vc);
    }];
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    [SVProgressHUD showSuccessWithStatus:@"快照保存成功"];
}

#pragma mark - XHScreenshotMenuViewDelegate
- (void)screenshotMenuViewDidSelectedBackground:(XHScreenshotMenuView*)screenshotMenuView{
    [self.backgroundFuctionPanelView showInView:self.view];
}
- (void)screenshotMenuViewDidSelectedTextMaterial:(XHScreenshotMenuView*)screenshotMenuView{
    
    CGFloat y = arc4random() % 100 + 60;
    CGFloat x = arc4random() % 100 + 20;
    XHScreenshotTextFiled *textField = [[XHScreenshotTextFiled alloc] initWithFrame:CGRectMake(x, y, 150, 50)];
    textField.delegate = self;
    [self.screenshotPreview addSubview:textField];
    [self.materialArray addObject:textField];
    [self.materialArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj isEqual:textField]) {
            [obj setIsEditing:NO];
            if ([obj isKindOfClass:[XHScreenshotTextFiled class]]) {
                [obj resignFirstResponser];
            }
        }
    }];
}
- (void)screenshotMenuViewDidSelectedPasterMaterial:(XHScreenshotMenuView*)screenshotMenuView{
    [[XHPasterSelectView defaultView] showInView:self.view result:^(PasterInfo * _Nullable pasterInfo, NSError * _Nullable error) {
        
        UIImage *image = [UIImage imageNamed:pasterInfo.icon];
        CGFloat scale = image.size.width / image.size.height;
        XHScreenshotPasterView *pasterView = [[XHScreenshotPasterView alloc] initWithFrame:CGRectMake(40, 60, image.size.width * 0.7, image.size.width / scale * 0.7)];
        [pasterView setImageList:@[image] imageDuration:0];
        [self.screenshotPreview addSubview:pasterView];
        [self.materialArray addObject:pasterView];
        [self.materialArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if([obj isEqual:pasterView] == NO){
                [obj setIsEditing:NO];
            }
            
        }];
    }];
}
- (void)screenshotMenuViewShare:(XHScreenshotMenuView*)screenshotMenuView{
    [self.screenshotPreview generateScreenshotImageCallback:^(UIImage * _Nonnull image) {
        
        NSData *imageData = UIImagePNGRepresentation(image);
        //在这里呢 如果想分享图片 就把图片添加进去  文字什么的通上
        NSArray *activityItems = @[imageData];
        UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
        //不出现在活动项目
        activityVC.excludedActivityTypes = @[UIActivityTypePrint,UIActivityTypeMessage,UIActivityTypeMail,UIActivityTypeAddToReadingList,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll];
        [self presentViewController:activityVC animated:YES completion:nil];
        // 分享之后的回调
        activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
            if (completed) {
                [SVProgressHUD showSuccessWithStatus:@"分享成功"];
                //分享 成功
            } else  {
                [SVProgressHUD showErrorWithStatus:@"分享失败"];
                //分享 取消
            }
        };
        
    }];
}
- (void)screenshotMenuViewRevoke:(XHScreenshotMenuView*)screenshotMenuView{
    if ([self.materialArray count] > 0) {
        id view = [self.materialArray lastObject];
        [view removeFromSuperview];
        [self.materialArray removeLastObject];
    }
}
#pragma mark - BackgroundFuctionPanelViewDelegate <NSObject>

- (void)backgroundFuctionPanelViewDidColorClicked:(BackgroundFuctionPanelView*)functionPanelView{
    [[XHColorSelectedView defaultView] showInView:self.view result:^(ColorInfo * _Nullable colorInfo, UIColor * _Nullable color, NSError * _Nullable error) {
        if (error == nil) {
            [self.screenshotPreview setBackgroundColor:color];
        }
    }];
}

- (void)backgroundFuctionPanelViewDidImageClicked:(BackgroundFuctionPanelView*)functionPanelView{
    
    ZYQAssetPickerController *pickerController = [[ZYQAssetPickerController alloc] init];
    pickerController.view.tag = 100;
    pickerController.maximumNumberOfSelection = 1;
    pickerController.assetsFilter = ZYQAssetsFilterAllAssets;
    pickerController.showEmptyGroups=NO;
    pickerController.delegate=self;
    [self presentViewController:pickerController animated:YES completion:nil];
    
}
#pragma mark - XHScreenshotPasterViewDelegate <NSObject>
- (void)onPasterViewTap{
    
}
- (void)onRemovePasterView:(XHScreenshotPasterView*)pasterView{
    [self.materialArray removeObject:pasterView];
}

#pragma mark - ScreenshotTextFieldDelegate
- (void)onEditing:(XHScreenshotTextFiled*)screenshotTextFiled{
    [self.materialArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj isEqual:screenshotTextFiled]) {
            [obj setIsEditing:NO];
            if ([obj isKindOfClass:[XHScreenshotTextFiled class]]) {
                [obj resignFirstResponser];
            }
        }
    }];
}
- (void)onBubbleTap:(XHScreenshotTextFiled*)screenshotTextFiled{
    [[XHTextStyleEditView defaultView] showInView:self.view result:^(TextStyleParameter * _Nullable textStyleParameter, NSError * _Nullable error) {
        [self modifyTextStyleInXHScreenshotTextFiled:screenshotTextFiled withTextStyleParameter:textStyleParameter];
    }];
}
- (void)onTextInputBegin{
    
}
- (void)onTextInputDone:(NSString*)text{
    
}
- (void)onRemoveTextField:(XHScreenshotTextFiled*)textField{
    [self.materialArray removeObject:textField];
}

#pragma mark - ZYQAssetPickerControllerDelegate
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    
    if (picker.view.tag == 100) {
        //设置图片背景
        ZYQAsset *asset=[assets lastObject];
        [asset setGetFullScreenImage:^(UIImage *result) {
            [self.screenshotPreview setBackgroundImage:result];
        }];
        
    } else {
        ZYQAsset *asset=[assets lastObject];
        [asset setGetFullScreenImage:^(UIImage *result) {
            [self.screenshotPreview setScreenshotImage:result];
        }];
    }
    
}

#pragma mark - ScreenshotPreviewDelegate
- (void)screenshotPreviewEndEdited:(ScreenshotPreview*)screenshotPreview{
    [self.materialArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setIsEditing:NO];
    }];
}
- (void)screenshotImagePreviewDidTap:(ScreenshotPreview*)screenshotPreview{
    ZYQAssetPickerController *pickerController = [[ZYQAssetPickerController alloc] init];
    pickerController.view.tag = 101;
    pickerController.maximumNumberOfSelection = 1;
    pickerController.assetsFilter = ZYQAssetsFilterAllAssets;
    pickerController.showEmptyGroups=NO;
    pickerController.delegate=self;
    [self presentViewController:pickerController animated:YES completion:nil];
}
#pragma mark - 其它
- (void)modifyTextStyleInXHScreenshotTextFiled:(XHScreenshotTextFiled*)textFiled withTextStyleParameter:(TextStyleParameter*)parameter{
    if (parameter) {
        if (parameter.overstriking) {
            textFiled.textLabel.font = [UIFont boldSystemFontOfSize:parameter.fontSize];
        } else {
            textFiled.textLabel.font = [UIFont systemFontOfSize:parameter.fontSize];
        }
        if (parameter.textColorInfo) {
            textFiled.textLabel.textColor = [UIColor colorWithRed:parameter.textColorInfo.red/255.0 green:parameter.textColorInfo.green/255.0 blue:parameter.textColorInfo.blue/255.0 alpha:parameter.textColorInfo.opacity];
        } else {
            textFiled.textLabel.textColor = [UIColor clearColor];
        }
        switch (parameter.alignment) {
            case 10:
                textFiled.textLabel.textAlignment = NSTextAlignmentLeft;
                break;
            case 11:
                textFiled.textLabel.textAlignment = NSTextAlignmentCenter;
                break;
            case 12:
                textFiled.textLabel.textAlignment = NSTextAlignmentRight;
                break;
            default:
                textFiled.textLabel.textAlignment = NSTextAlignmentLeft;
                break;
        }
        if (parameter.backgroundColorInfo) {
            textFiled.textLabel.backgroundColor = [UIColor colorWithRed:parameter.backgroundColorInfo.red/255.0 green:parameter.backgroundColorInfo.green/255.0 blue:parameter.backgroundColorInfo.blue/255.0 alpha:parameter.backgroundColorInfo.opacity];
        } else {
            textFiled.textLabel.backgroundColor = [UIColor clearColor];
        }
        
//        textFiled.textLabel.shadowColor = parameter.shaowColorInfo == nil ? [UIColor clearColor] : [UIColor colorWithRed:parameter.shaowColorInfo.red/255.0 green:parameter.shaowColorInfo.green/255.0 blue:parameter.shaowColorInfo.blue/255.0 alpha:parameter.shaowColorInfo.opacity];
        textFiled.textLabel.alpha = parameter.opacity;
        [textFiled updatePosition];
    }
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
