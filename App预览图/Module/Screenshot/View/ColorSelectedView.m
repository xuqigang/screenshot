//
//  ColorSelectedView.m
//  App预览图
//
//  Created by 韩肖杰 on 2019/1/4.
//  Copyright © 2019 xuqigang. All rights reserved.
//

#import "ColorSelectedView.h"
#import "UIColor+utils.h"
#import "QGDBManager.h"
@interface ColorSelectedView ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSInteger _maxColorNumber;
}
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic, strong) ColorSelectedViewResultCallBack resultCallBack;
@property (weak, nonatomic) IBOutlet UISlider *redslider;
@property (weak, nonatomic) IBOutlet UISlider *greenslider;
@property (weak, nonatomic) IBOutlet UISlider *blueslider;
@property (weak, nonatomic) IBOutlet UISlider *opacityslider;
@property (weak, nonatomic) IBOutlet UIView *colorPreview;
@property (weak, nonatomic) IBOutlet UITextField *redTextField;
@property (weak, nonatomic) IBOutlet UITextField *greenTextField;
@property (weak, nonatomic) IBOutlet UITextField *blueTextField;
@property (weak, nonatomic) IBOutlet UITextField *opacityTextField;
@property (weak, nonatomic) IBOutlet UITextField *hexTextField;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<ColorInfo*> *colorDataSource;

@end
@implementation ColorSelectedView
+ (instancetype)defaultView{
    static ColorSelectedView * colorSelectedView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        colorSelectedView = [ColorSelectedView instanceFromNib];
    });
    return colorSelectedView;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.frame = UIScreen.mainScreen.bounds;
    [self layoutIfNeeded];
    CGRect contentViewFrame = self.contentView.frame;
    contentViewFrame.origin.y = self.frame.size.height;
    self.contentView.frame = contentViewFrame;
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    effectView.tag = 1001;
    [self.contentView insertSubview:effectView atIndex:0];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    UIView *effectView = [self.contentView viewWithTag:1001];
    effectView.frame = self.contentView.bounds;
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    flowLayout.itemSize = CGSizeMake(self.collectionView.frame.size.height / 2.0 - 2, self.collectionView.frame.size.height / 2.0 - 2);
    flowLayout.minimumInteritemSpacing = 6;
    flowLayout.minimumLineSpacing = 4;
    
    _maxColorNumber = self.collectionView.frame.size.width / (self.collectionView.frame.size.height / 2.0 + 4) * 2;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.colorDataSource count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    cell.borderWidth = 1;
    cell.borderColor = [UIColor whiteColor];
    if (self.colorDataSource.count > indexPath.row) {
        ColorInfo *info = [self.colorDataSource objectAtIndex:indexPath.row];
        UIColor *color = [UIColor colorWithRed:info.red/255.0 green:info.green/255.0 blue:info.blue/255.0 alpha:info.opacity];
        cell.contentView.backgroundColor = color;
    } else{
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < [self.colorDataSource count]) {
        ColorInfo *info = [self.colorDataSource objectAtIndex:indexPath.row];
        if (_resultCallBack) {
            UIColor *color = [UIColor colorWithRed:info.red green:info.green blue:info.blue alpha:info.opacity];
            _resultCallBack(info,color,nil);
        }
    }
    [self hiddenView];
}

#pragma mark - 点击

- (IBAction)cancelButtonClicked:(UIButton *)sender {
    [self hiddenView];
    if (_resultCallBack) {
        _resultCallBack(nil,nil,[NSError new]);
    }
}
- (IBAction)enterButtonClicked:(UIButton *)sender {
    ColorInfo *colorInfo = [ColorInfo new];
    colorInfo.red = (NSInteger)self.redslider.value;
    colorInfo.green = (NSInteger)self.greenslider.value;
    colorInfo.blue = (NSInteger)self.blueslider.value;
    colorInfo.opacity = self.opacityslider.value;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self->_resultCallBack) {
            UIColor *color = [UIColor colorWithRed:colorInfo.red/255.0 green:colorInfo.green/255.0 blue:colorInfo.blue/255.0 alpha:colorInfo.opacity];
            self->_resultCallBack(colorInfo,color,nil);
        }
    });
    
    BOOL flag = [[QGDBManager defaultManager] existData:colorInfo];
    if (flag == NO) {
        if ([self.colorDataSource count] >= _maxColorNumber) {
            ColorInfo *firstColorInfo = [self.colorDataSource firstObject];
            [[QGDBManager defaultManager] deleteData:firstColorInfo result:^(BOOL flag) {
                [self.colorDataSource removeObjectAtIndex:0];
                [self.collectionView reloadData];
                [[QGDBManager defaultManager] insertData:colorInfo result:^(BOOL flag) {
                    
                }];
            }];
        } else {
            [[QGDBManager defaultManager] insertData:colorInfo result:^(BOOL flag) {
                
            }];
        }
        
        
    }
    [self hiddenView];
}
- (IBAction)rgbSliderChanged:(UISlider *)sender {
    [self updateColorPreview];
    self.redTextField.text = [NSString stringWithFormat:@"%.0f",self.redslider.value];
    self.greenTextField.text = [NSString stringWithFormat:@"%.0f",self.greenslider.value];
    self.blueTextField.text = [NSString stringWithFormat:@"%.0f",self.blueslider.value];
    self.hexTextField.text = [UIColor convertRGBToHexStringWithRed:self.redslider.value green:self.greenslider.value blue:self.blueslider.value];
}
- (IBAction)opacitySlider:(UISlider *)sender {
    self.opacityTextField.text = [NSString stringWithFormat:@"%2f",sender.value];
    [self updateColorPreview];
}

- (void)updateColorPreview{
    UIColor *color = [UIColor colorWithRed:self.redslider.value/255.0 green:self.greenslider.value/255.0 blue:self.blueslider.value/255.0 alpha:self.opacityslider.value];
    self.colorPreview.backgroundColor = color;
}
- (void)showInView:(UIView*)view result:(ColorSelectedViewResultCallBack) result{
    self.resultCallBack = result;
    if (view) {
         self.frame = view.bounds;
        [view addSubview:self];
    } else {
        self.frame = UIApplication.sharedApplication.delegate.window.bounds;
        [UIApplication.sharedApplication.delegate.window addSubview:self];
    }
    [self layoutIfNeeded];
    ColorInfo *colorInfo = [ColorInfo new];
    [[QGDBManager defaultManager] selectData:colorInfo result:^(NSMutableArray *resultSet) {
        self.colorDataSource = resultSet;
        [self.collectionView reloadData];
    }];
    [self updateColorPreview];
    
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
    
    if (point.y < self.frame.size.height - 340) {
        [self hiddenView];
        if (_resultCallBack) {
            _resultCallBack(nil,nil,[NSError new]);
        }
    }
}
@end
