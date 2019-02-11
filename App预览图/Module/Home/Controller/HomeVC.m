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
@interface HomeVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstrint;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *templateGroupParameters;

@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupObject];
    [self.collectionView reloadData];
    // Do any additional setup after loading the view from its nib.
}
- (void)setupObject{
    self.templateGroupParameters = [NSMutableArray arrayWithCapacity:1];
    TemplateGroupModel *group1 = [[TemplateGroupModel alloc] init];
    
    TemplateParameter *temlate1 = [[TemplateParameter alloc] init];
    
    group1.list = @[temlate1,temlate1,temlate1];
    group1.title = @"iPhone plus 设备";
    TemplateGroupModel *group2 = [[TemplateGroupModel alloc] init];
    group2.list = @[temlate1,temlate1,temlate1,temlate1,temlate1,temlate1];
    group2.title = @"iPhone x 设备";
    [self.templateGroupParameters addObject:group1];
    [self.templateGroupParameters addObject:group2];
}
- (void)setupUI{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"App Store屏幕快照设计";
    [self hiddenLeftButton];
    UINib *emojiCellNib = [TemplateCell nib];
    [self.collectionView registerNib:emojiCellNib forCellWithReuseIdentifier:@"TemplateCell"];
    UINib *reusableView = [TemplateGroupReusableView nib];
    [self.collectionView registerNib:reusableView forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"TemplateGroupReusableHeaderView"];
    [self.collectionView registerNib:reusableView forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"TemplateGroupReusableFootView"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.topConstrint.constant = StatusBarHeight + 44;
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    flowLayout.itemSize = CGSizeMake((self.collectionView.xm_width - 25)/5.0, (self.collectionView.xm_width - 25)/5.0 * (16/9.0));
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 5;
    flowLayout.headerReferenceSize = CGSizeMake(self.collectionView.xm_width, 44);
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 16, 10, 16);
}

#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    TemplateGroupModel *groupInfo = [self.templateGroupParameters objectAtIndex:section];
    return [groupInfo.list count];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return [self.templateGroupParameters count];
}
// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TemplateCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TemplateCell" forIndexPath:indexPath];
    if (indexPath.section < [self.templateGroupParameters count] ) {
        TemplateGroupModel *groupInfo = [self.templateGroupParameters objectAtIndex:indexPath.section];
        NSArray<TemplateParameter*> *list = groupInfo.list;
        if (indexPath.item < [list count]) {
            [cell setupCellData:[list objectAtIndex:indexPath.item]];
        } else {
            [cell setupCellData:nil];
        }
    } else {
        [cell setupCellData:nil];
    }
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        TemplateGroupReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"TemplateGroupReusableHeaderView" forIndexPath:indexPath];
        if (indexPath.section < [self.templateGroupParameters count]) {
            [header setupReusableViewData:[self.templateGroupParameters objectAtIndex:indexPath.section]];
        }
        return header;
    } else {
        return [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"TemplateGroupReusableFootView" forIndexPath:indexPath];
    }
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section < [self.templateGroupParameters count] ) {
        TemplateGroupModel *groupInfo = [self.templateGroupParameters objectAtIndex:indexPath.section];
        if (indexPath.row < groupInfo.list.count) {
            TemplateParameter *template = [groupInfo.list objectAtIndex:indexPath.row];
            ScreenshotEditVC *vc = [ScreenshotEditVC instanceFromNib];
            vc.templateParameter = template;
            PushViewController(vc);
        }
        
    } else {
        NSLog(@"元素索引有误");
    }
}


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
