//
//  HomeVC.m
//  App预览图
//
//  Created by 韩肖杰 on 2019/1/3.
//  Copyright © 2019 xuqigang. All rights reserved.
//

#import "HomeVC.h"
#import "ScreenshotEditVC.h"
#import "TemplateCell.h"
#import "TemplateGroupModel.h"
#import "TemplateGroupReusableView.h"
#import "ZYQAssetPickerController.h"
#import <objc/runtime.h>
@interface HomeVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UINavigationControllerDelegate,ZYQAssetPickerControllerDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstrint;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *templateGroupParameters;

@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
//    [self setupObject];
//    [self.collectionView reloadData];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)startButtonClicked:(UIButton *)sender {
    
    
    ScreenshotEditVC *vc = [ScreenshotEditVC instanceFromNib];
    TemplateParameter *temlate1 = [[TemplateParameter alloc] init];
    temlate1.shellTopScale = 0.75;
    temlate1.title = @"模板下";
    temlate1.previewIcon = @"tem_plus1";
    temlate1.screenshotType = ScreenshotType_Plus;
    temlate1.screenshotScale = 1242/2208.0;
    temlate1.shellImage = @"iphone6plus-gold";
    temlate1.backgroundColor = [UIColor clearColor];
    temlate1.backgroundImage = nil;
    vc.templateParameter = temlate1;
    PushViewController(vc);
}
//- (void)setupObject{
//    self.templateGroupParameters = [NSMutableArray arrayWithCapacity:1];
//    TemplateGroupModel *group1 = [[TemplateGroupModel alloc] init];
//
//    TemplateParameter *temlate1 = [[TemplateParameter alloc] init];
//    temlate1.shellTopScale = 0.75;
//    temlate1.title = @"模板下";
//    temlate1.previewIcon = @"tem_plus1";
//    temlate1.screenshotType = ScreenshotType_Plus;
//    temlate1.screenshotScale = 1242/2208.0;
//    temlate1.shellImage = @"iphone6plus-gold";
//    temlate1.backgroundColor = [UIColor clearColor];
//    temlate1.backgroundImage = nil;
//
//    TemplateParameter *temlate2 = [[TemplateParameter alloc] init];
//    temlate2.previewIcon = @"tem_plus2";
//    temlate2.title = @"模板上";
//    temlate2.shellTopScale = 0.25;
//    temlate2.screenshotScale = 1242/2208.0;
//    temlate2.shellImage = @"iphone6plus-gold";
//    temlate2.backgroundColor = [UIColor clearColor];
//    temlate2.backgroundImage = nil;
//    temlate2.screenshotType = ScreenshotType_Plus;
//
//    TemplateParameter *temlate3 = [[TemplateParameter alloc] init];
//    temlate3.previewIcon = @"tem_plus3";
//    temlate3.shellTopScale = 1.35;
//    temlate3.title = @"模板底";
//    temlate3.screenshotScale = 1242/2208.0;
//    temlate3.shellImage = @"iphone6plus-gold";
//    temlate3.backgroundColor = UIColorFromRGB(0xf2f2f2);
//    temlate3.backgroundImage = nil;
//    temlate3.screenshotType = ScreenshotType_Plus;
//    group1.list = @[temlate1,temlate2,temlate3];
//    group1.title = @"5.5英寸（1242*2208）";
//    TemplateGroupModel *group2 = [[TemplateGroupModel alloc] init];
//
//    TemplateParameter *temlateX1 = [[TemplateParameter alloc] init];
//    temlateX1.previewIcon = @"tem_x1";
//    temlateX1.title = @"模板X下";
//    temlateX1.shellTopScale = 0.25;
//    temlateX1.screenshotScale = 1242/2688.0;
//    temlateX1.shellImage = @"iPhoneX-spacegray";
//    temlateX1.backgroundColor = [UIColor clearColor];
//    temlateX1.backgroundImage = nil;
//    temlateX1.screenshotType = ScreenshotType_X;
//    TemplateParameter *temlateX2 = [[TemplateParameter alloc] init];
//    temlateX2.previewIcon = @"tem_x2";
//    temlateX2.shellTopScale = 0.75;
//    temlateX2.title = @"模板X上";
//    temlateX2.screenshotScale = 1242 / 2688.0;
//    temlateX2.shellImage = @"iPhoneX-spacegray";
//    temlateX2.backgroundColor = [UIColor clearColor];
//    temlateX2.backgroundImage = nil;
//    temlateX2.screenshotType = ScreenshotType_X;
//
//    TemplateParameter *temlateX3 = [[TemplateParameter alloc] init];
//    temlateX3.previewIcon = @"tem_x3";
//    temlateX3.shellTopScale = 1.25;
//    temlateX3.title = @"模板X底";
//    temlateX3.screenshotScale = 1242 / 2688.0;
//    temlateX3.shellImage = @"iPhoneX-spacegray";
//    temlateX3.backgroundColor = [UIColor clearColor];
//    temlateX3.backgroundImage = nil;
//    temlateX3.screenshotType = ScreenshotType_X;
//
//    group2.list = @[temlateX1,temlateX2,temlateX3];
//    group2.title = @"6.5英寸（1242 * 2688）";
//    [self.templateGroupParameters addObject:group1];
//    [self.templateGroupParameters addObject:group2];
//}
- (void)setupUI{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"图片美化";
    [self hiddenLeftButton];
//    UINib *emojiCellNib = [TemplateCell nib];
//    [self.collectionView registerNib:emojiCellNib forCellWithReuseIdentifier:@"TemplateCell"];
//    UINib *reusableView = [TemplateGroupReusableView nib];
//    [self.collectionView registerNib:reusableView forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"TemplateGroupReusableHeaderView"];
//    [self.collectionView registerNib:reusableView forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"TemplateGroupReusableFootView"];
//    self.collectionView.delegate = self;
//    self.collectionView.dataSource = self;
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.topConstrint.constant = StatusBarHeight + 44;
//    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
//    flowLayout.itemSize = CGSizeMake((self.collectionView.xm_width - 25)/5.0, (self.collectionView.xm_width - 25)/5.0 * (16/9.0));
//    flowLayout.minimumLineSpacing = 10;
//    flowLayout.minimumInteritemSpacing = 5;
//    flowLayout.headerReferenceSize = CGSizeMake(self.collectionView.xm_width, 44);
//    flowLayout.sectionInset = UIEdgeInsetsMake(10, 16, 10, 16);
}

#pragma mark UICollectionViewDataSource
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    TemplateGroupModel *groupInfo = [self.templateGroupParameters objectAtIndex:section];
//    return [groupInfo.list count];
//}
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
//    return [self.templateGroupParameters count];
//}
//// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
//- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
//    TemplateCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TemplateCell" forIndexPath:indexPath];
//    if (indexPath.section < [self.templateGroupParameters count] ) {
//        TemplateGroupModel *groupInfo = [self.templateGroupParameters objectAtIndex:indexPath.section];
//        NSArray<TemplateParameter*> *list = groupInfo.list;
//        if (indexPath.item < [list count]) {
//            [cell setupCellData:[list objectAtIndex:indexPath.item]];
//        } else {
//            [cell setupCellData:nil];
//        }
//    } else {
//        [cell setupCellData:nil];
//    }
//    return cell;
//}
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
//
//    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
//
//        TemplateGroupReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"TemplateGroupReusableHeaderView" forIndexPath:indexPath];
//        if (indexPath.section < [self.templateGroupParameters count]) {
//            [header setupReusableViewData:[self.templateGroupParameters objectAtIndex:indexPath.section]];
//        }
//        return header;
//    } else {
//        return [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"TemplateGroupReusableFootView" forIndexPath:indexPath];
//    }
//}
//#pragma mark - UICollectionViewDelegate
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section < [self.templateGroupParameters count] ) {
//        TemplateGroupModel *groupInfo = [self.templateGroupParameters objectAtIndex:indexPath.section];
//        if (indexPath.row < groupInfo.list.count) {
//            TemplateParameter *template = [groupInfo.list objectAtIndex:indexPath.row];
//            template.screenshotImage = [UIImage imageNamed:@"test.jpg"];
//            ScreenshotEditVC *vc = [ScreenshotEditVC instanceFromNib];
//            vc.templateParameter = template;
//            PushViewController(vc);
//            return;
//            ZYQAssetPickerController *pickerController = [[ZYQAssetPickerController alloc] init];
//            objc_setAssociatedObject(pickerController, "templateParameter", template, OBJC_ASSOCIATION_RETAIN);
//            pickerController.maximumNumberOfSelection = 1;
//            pickerController.assetsFilter = ZYQAssetsFilterAllAssets;
//            pickerController.showEmptyGroups=NO;
//            pickerController.delegate=self;
//            [self presentViewController:pickerController animated:YES completion:nil];
//        }
//
//    } else {
//        NSLog(@"元素索引有误");
//    }
//}
//#pragma mark - ZYQAssetPickerControllerDelegate
//-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
//    //设置图片背景
//    ZYQAsset *asset=[assets lastObject];
//    [asset setGetFullScreenImage:^(UIImage *result) {
//        TemplateParameter *template = objc_getAssociatedObject(picker, "templateParameter");
//        template.screenshotImage = result;
//        ScreenshotEditVC *vc = [ScreenshotEditVC instanceFromNib];
//        vc.templateParameter = template;
//        PushViewController(vc);
//    }];
//}

//
//- (IBAction)iPadButtonClicked:(UIButton *)sender {
//    ScreenshotEditVC *vc = [ScreenshotEditVC instanceFromNib];
//    PushViewController(vc);
//}
//- (IBAction)iPhoneButtonClicked:(UIButton *)sender {
//    ScreenshotEditVC *vc = [ScreenshotEditVC instanceFromNib];
//    PushViewController(vc);
//}
//- (IBAction)iPhoneXButtonClicked:(UIButton *)sender {
//    ScreenshotEditVC *vc = [ScreenshotEditVC instanceFromNib];
//    PushViewController(vc);
//}


@end
