//
//  XHPasterSelectView.m
//  ScreenShot
//
//  Created by 韩肖杰 on 2019/1/8.
//  Copyright © 2019 xuqigang. All rights reserved.
//

#import "XHPasterSelectView.h"
#import "PasterViewCell.h"
#import "ILGCollectionViewFlowLayout.h"
#import "SBJson.h"
@interface XHPasterSelectView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) XHPasterSelectViewResultCallBack resultCallBack;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray<PasterInfo*> *pastersDataSource;
@end
@implementation XHPasterSelectView

+ (instancetype)defaultView{
    static XHPasterSelectView * pasterSelectView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pasterSelectView = [XHPasterSelectView instanceFromNib];
    });
    return pasterSelectView;
}
- (void)awakeFromNib{
    [super awakeFromNib];
    self.frame = UIScreen.mainScreen.bounds;
    [self layoutIfNeeded];
    [self initDataSource];
    UINib *nibCell = [PasterViewCell nib];
    [self.collectionView registerNib:nibCell forCellWithReuseIdentifier:@"PasterViewCell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
   
    //        layout.itemSize = CGSizeMake(self.giftItemWidth, self.giftItemHeight);//设置cell的size
    
    CGRect contentViewFrame = self.contentView.frame;
    contentViewFrame.origin.y = self.frame.size.height;
    self.contentView.frame = contentViewFrame;
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    effectView.tag = 1001;
    [self.contentView insertSubview:effectView atIndex:0];
    [self.collectionView reloadData];
}
- (void)initDataSource{
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"pasters" ofType:@"json"];
    NSString *json = [[NSString alloc] initWithContentsOfFile:jsonPath encoding:NSUTF8StringEncoding error:nil];
    NSArray *list = [json JSONValue];
    self.pastersDataSource = [AssignToObject QGCustomModel:@"PasterInfo" ToArray:list];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    UIView *effectView = [self.contentView viewWithTag:1001];
    effectView.frame = CGRectMake(0, 40, self.collectionView.frame.size.width, self.collectionView.frame.size.height);
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    flowLayout.itemSize = CGSizeMake(60, 60);
    flowLayout.minimumInteritemSpacing = (self.collectionView.frame.size.width - 60 * 5 - 16 * 2)/4 - 1;
    flowLayout.minimumLineSpacing = 5;
    flowLayout.sectionInset = UIEdgeInsetsMake(5, 16, 5, 16);
}
#pragma mark - 点击

- (IBAction)cancelButtonClicked:(UIButton *)sender {
    [self hiddenView];
}
#pragma mark -
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.pastersDataSource.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    PasterViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PasterViewCell" forIndexPath:indexPath];
    if (indexPath.row < self.pastersDataSource.count) {
        [cell setupCellData:self.pastersDataSource[indexPath.row]];
    } else {
        [cell setupCellData:nil];
    }
    return cell;
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.resultCallBack && indexPath.row < self.pastersDataSource.count) {
        self.resultCallBack(self.pastersDataSource[indexPath.row], nil);
    }
    [self hiddenView];
}

- (void)showInView:(UIView * _Nullable )view result:(XHPasterSelectViewResultCallBack) result{
    self.resultCallBack = result;
    self.frame = view.bounds;
    if (view) {
        [view addSubview:self];
    } else {
        [UIApplication.sharedApplication.delegate.window addSubview:self];
    }
    [self layoutIfNeeded];
    CGRect frame = self.contentView.frame;
    frame.origin.y = self.frame.size.height - self.contentView.frame.size.height;
    [UIView animateWithDuration:0.25 animations:^{
        self.contentView.frame = frame;
    }];
}
- (void)hiddenView{
    CGRect frame = self.contentView.frame;
    frame.origin.y = self.frame.size.height;
    [UIView animateWithDuration:0.25 animations:^{
        self.contentView.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
    UITouch *touch = [allTouches anyObject];   //视图中的所有对象
    CGPoint point = [touch locationInView:self]; //
    
    if (point.y < self.frame.size.height - self.contentView.frame.size.height) {
        [self hiddenView];
    }
}

@end
