//
//  ScreenshotEditVC.m
//  App预览图
//
//  Created by 韩肖杰 on 2019/1/4.
//  Copyright © 2019 xuqigang. All rights reserved.
//

#import "ScreenshotEditVC.h"
#import "ScreenshotPreview.h"
#import "ScreenshotTextFiled.h"
#import "ScreenshotPasterView.h"
#import "ScreenshotMenuView.h"
#import "ColorSelectedView.h"
#import "PasterSelectView.h"
#import "TextStyleEditView.h"
#import "ZYQAssetPickerController.h"
#import "ScreenshotPreviewVC.h"
#import "BackgroundFuctionPanelView.h"
@interface ScreenshotEditVC ()<ScreenshotMenuViewDelegate,ScreenshotTextFieldDelegate,ScreenshotPreviewDelegate,ScreenshotPasterViewDelegate, ZYQAssetPickerControllerDelegate,UINavigationControllerDelegate,BackgroundFuctionPanelViewDelegate>
@property (nonatomic, strong) NSMutableArray *materialArray;
@property (nonatomic, strong) ScreenshotPreview *screenshotPreview;
@property (nonatomic, strong) ScreenshotMenuView *screenshotMenuView;
@property (nonatomic, strong) BackgroundFuctionPanelView *backgroundFuctionPanelView;
@end

@implementation ScreenshotEditVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.materialArray = [NSMutableArray arrayWithCapacity:1];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    // Do any additional setup after loading the view from its nib.
}
- (void)setupUI{
    self.navigationItem.title = @"设计快照";
    [self setRightButtonText:@"保存"];
    [self setRightSecondButtonText:@"预览"];
    [self.view addSubview:self.screenshotPreview];
    [self.view addSubview:self.screenshotMenuView];
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
    CGFloat screenshotPreviewWidth = screenshotPreviewHeight * (9/16.0);
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
- (ScreenshotMenuView*)screenshotMenuView{
    if (!_screenshotMenuView) {
        _screenshotMenuView = [ScreenshotMenuView instanceFromNib];
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
        ScreenshotPreviewVC *vc = [ScreenshotPreviewVC instanceFromNib];
        vc.preImage = image;
        PushViewController(vc);
    }];
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    [SVProgressHUD showSuccessWithStatus:@"快照保存成功"];
}

#pragma mark - ScreenshotMenuViewDelegate
- (void)screenshotMenuViewDidSelectedBackground:(ScreenshotMenuView*)screenshotMenuView{
    [self.backgroundFuctionPanelView showInView:self.view];
}
- (void)screenshotMenuViewDidDeleteBackgroundImage:(ScreenshotMenuView*)screenshotMenuView{
    [self.screenshotPreview setBackgroundImage:nil];
}
- (void)screenshotMenuViewDidSelectedTextMaterial:(ScreenshotMenuView*)screenshotMenuView{
    
    CGFloat y = arc4random() % 100 + 60;
    CGFloat x = arc4random() % 100 + 20;
    ScreenshotTextFiled *textField = [[ScreenshotTextFiled alloc] initWithFrame:CGRectMake(x, y, 150, 50)];
    textField.delegate = self;
    [self.screenshotPreview addSubview:textField];
    [self.materialArray addObject:textField];
    [self.materialArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj isEqual:textField]) {
            [obj setIsEditing:NO];
            if ([obj isKindOfClass:[ScreenshotTextFiled class]]) {
                [obj resignFirstResponser];
            }
        }
    }];
}
- (void)screenshotMenuViewDidSelectedPasterMaterial:(ScreenshotMenuView*)screenshotMenuView{
    [[PasterSelectView defaultView] showInView:self.view result:^(PasterInfo * _Nullable pasterInfo, NSError * _Nullable error) {
        
        UIImage *image = [UIImage imageNamed:pasterInfo.icon];
        CGFloat scale = image.size.width / image.size.height;
        ScreenshotPasterView *pasterView = [[ScreenshotPasterView alloc] initWithFrame:CGRectMake(40, 60, image.size.width * 0.7, image.size.width / scale * 0.7)];
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
- (void)screenshotMenuViewShare:(ScreenshotMenuView*)screenshotMenuView{
    
}
- (void)screenshotMenuViewRevoke:(ScreenshotMenuView*)screenshotMenuView{
    if ([self.materialArray count] > 0) {
        id view = [self.materialArray objectAtIndex:0];
        [view removeFromSuperview];
        [self.materialArray removeObjectAtIndex:0];
    }
}
#pragma mark - BackgroundFuctionPanelViewDelegate <NSObject>

- (void)backgroundFuctionPanelViewDidColorClicked:(BackgroundFuctionPanelView*)functionPanelView{
    [[ColorSelectedView defaultView] showInView:self.view result:^(ColorInfo * _Nullable colorInfo, UIColor * _Nullable color, NSError * _Nullable error) {
        if (error == nil) {
            [self.screenshotPreview setBackgroundColor:color];
        }
    }];
}

- (void)backgroundFuctionPanelViewDidImageClicked:(BackgroundFuctionPanelView*)functionPanelView{
    
    ZYQAssetPickerController *pickerController = [[ZYQAssetPickerController alloc] init];
    pickerController.maximumNumberOfSelection = 1;
    pickerController.assetsFilter = ZYQAssetsFilterAllAssets;
    pickerController.showEmptyGroups=NO;
    pickerController.delegate=self;
    [self presentViewController:pickerController animated:YES completion:nil];
    
}
#pragma mark - ScreenshotPasterViewDelegate <NSObject>
- (void)onPasterViewTap{
    
}
- (void)onRemovePasterView:(ScreenshotPasterView*)pasterView{
    [self.materialArray removeObject:pasterView];
}

#pragma mark - ScreenshotTextFieldDelegate
- (void)onEditing:(ScreenshotTextFiled*)screenshotTextFiled{
    [self.materialArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj isEqual:screenshotTextFiled]) {
            [obj setIsEditing:NO];
            if ([obj isKindOfClass:[ScreenshotTextFiled class]]) {
                [obj resignFirstResponser];
            }
        }
    }];
}
- (void)onBubbleTap:(ScreenshotTextFiled*)screenshotTextFiled{
    [[TextStyleEditView defaultView] showInView:self.view result:^(TextStyleParameter * _Nullable textStyleParameter, NSError * _Nullable error) {
        [self modifyTextStyleInScreenshotTextFiled:screenshotTextFiled withTextStyleParameter:textStyleParameter];
    }];
}
- (void)onTextInputBegin{
    
}
- (void)onTextInputDone:(NSString*)text{
    
}
- (void)onRemoveTextField:(ScreenshotTextFiled*)textField{
    [self.materialArray removeObject:textField];
}

#pragma mark - ZYQAssetPickerControllerDelegate
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    //设置图片背景
    ZYQAsset *asset=[assets lastObject];
    [asset setGetFullScreenImage:^(UIImage *result) {
        [self.screenshotPreview setBackgroundImage:result];
    }];
}

#pragma mark - ScreenshotPreviewDelegate
- (void)screenshotPreviewEndEdited:(ScreenshotPreview*)screenshotPreview{
    [self.materialArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setIsEditing:NO];
    }];
}
#pragma mark - 其它
- (void)modifyTextStyleInScreenshotTextFiled:(ScreenshotTextFiled*)textFiled withTextStyleParameter:(TextStyleParameter*)parameter{
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
