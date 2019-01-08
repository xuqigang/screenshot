//
//  PasterSelectView.m
//  App预览图
//
//  Created by 韩肖杰 on 2019/1/8.
//  Copyright © 2019 xuqigang. All rights reserved.
//

#import "PasterSelectView.h"
#import "PasterViewCell.h"
#import "ILGCollectionViewFlowLayout.h"
@interface PasterSelectView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) PasterSelectViewResultCallBack resultCallBack;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end
@implementation PasterSelectView

+ (instancetype)defaultView{
    static PasterSelectView * pasterSelectView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pasterSelectView = [PasterSelectView instanceFromNib];
    });
    return pasterSelectView;
}
- (void)awakeFromNib{
    [super awakeFromNib];
    self.frame = UIScreen.mainScreen.bounds;
    [self layoutIfNeeded];
    UINib *nibCell = [PasterViewCell nib];
    [self.collectionView registerNib:nibCell forCellWithReuseIdentifier:@"PasterViewCell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    ILGCollectionViewFlowLayout *layout = [[ILGCollectionViewFlowLayout alloc] initWithRowCount:2 itemCountPerRow:5];
    //        layout.itemSize = CGSizeMake(self.giftItemWidth, self.giftItemHeight);//设置cell的size
    layout.estimatedItemSize = CGSizeMake(100, 100);
    [layout setColumnSpacing:0.0 rowSpacing:0.0 edgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;//设置滚动方向
    self.collectionView.collectionViewLayout = layout;
    
    CGRect contentViewFrame = self.contentView.frame;
    contentViewFrame.origin.y = self.frame.size.height;
    self.contentView.frame = contentViewFrame;
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    effectView.tag = 1001;
    [self.contentView insertSubview:effectView atIndex:0];
    [self.collectionView reloadData];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    UIView *effectView = [self.contentView viewWithTag:1001];
    effectView.frame = self.contentView.bounds;
}

#pragma mark -
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 30;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    PasterViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PasterViewCell" forIndexPath:indexPath];
    return cell;
    
}


- (void)showInView:(UIView * _Nullable )view result:(PasterSelectViewResultCallBack) result{
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
