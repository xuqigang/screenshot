//
//  ILGCollectionViewFlowLayout.m
//  Test-inke
//
//  Created by 唐嗣成 on 2017/12/11.
//  Copyright © 2017年 shawnTang. All rights reserved.
//

#import "ILGCollectionViewFlowLayout.h"
@interface ILGCollectionViewFlowLayout ()
@property (nonatomic, strong) NSMutableArray *sectionWidthArray;
@end

@implementation ILGCollectionViewFlowLayout

#pragma mark - lazy
-(NSMutableArray *)attributesArrayM{
    if(!_attributesArrayM){
        _attributesArrayM = [NSMutableArray array];
    }
    return _attributesArrayM;
}
-(NSMutableArray *)sectionWidthArray{
    if(!_sectionWidthArray){
        _sectionWidthArray = [NSMutableArray array];
    }
    return _sectionWidthArray;
}
#pragma mark -Public
-(void)setColumnSpacing:(CGFloat)columnSpacing rowSpacing:(CGFloat)rowSpacing edgeInsets:(UIEdgeInsets)edgeInsets{
    self.columnSpacing = columnSpacing;
    self.rowSpacing = rowSpacing;
    self.edgeInsets = edgeInsets;
}

-(void)setRowCount:(NSInteger)rowCount itemCountPerRow:(NSInteger)itemCountPerRow{
    self.rowCount = rowCount;
    self.itemCountPerRow = itemCountPerRow;
}

#pragma mark - 构造方法
+ (instancetype) horizontalPageFlowlayoutWithRowCount:(NSInteger)rowCount itemCountPerRow:(NSInteger)itemCountPerRow{
    return [[self alloc] initWithRowCount:rowCount itemCountPerRow:itemCountPerRow];
}
-(instancetype)initWithRowCount:(NSInteger)rowCount itemCountPerRow:(NSInteger)itemCountPerRow{
    self = [super init];
    if (self){
        self.rowCount = rowCount;
        self.itemCountPerRow = itemCountPerRow;
    }
    return self;
}

#pragma mark -重写父类方法
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setColumnSpacing:0 rowSpacing:0 edgeInsets:UIEdgeInsetsZero];
    }
    return self;
}

/** 布局前的准备工作 */
-(void)prepareLayout{
    [super prepareLayout];
    [self calculateCollectionViewContentSize];
    // 从collectionView 中获取到有多少个item
    [self.attributesArrayM removeAllObjects];
    NSInteger sectionNumber = [self.collectionView numberOfSections];
    CGFloat offsetX = 0;
    for (NSInteger section = 0; section < sectionNumber; section ++) {
        if (section > 0) {
            offsetX = offsetX + [self.sectionWidthArray[section - 1] floatValue];
        }
        NSInteger itemTotalCount = [self.collectionView numberOfItemsInSection:section];
        // 遍历出item的attributes,把它添加到管理它的属性数组中去
        for (int item = 0 ; item < itemTotalCount; item++) {
            NSIndexPath *indexpath = [NSIndexPath indexPathForItem:item inSection:section];
            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexpath offsetX:offsetX];
            [self.attributesArrayM addObject:attributes];
        }
    }
}
- (void)calculateCollectionViewContentSize{
    //计算出item的宽度
    CGFloat itemWidth = (self.collectionView.frame.size.width - self.edgeInsets.left - self.itemCountPerRow * self.columnSpacing) / self.itemCountPerRow;
    // 从collectionView中获取到有多少个item
    [self.sectionWidthArray removeAllObjects];
    NSInteger sectionNumber = [self.collectionView numberOfSections];
    for (NSInteger i = 0; i < sectionNumber; i ++) {
        NSInteger itemTotalCount = [self.collectionView numberOfItemsInSection:i];
        //理论上每页展示的item数目
        NSInteger itemCount = self.rowCount * self.itemCountPerRow;
        //余数（用于确定最后一页展示的item个数）
        NSInteger remainder = itemTotalCount % itemCount;
        //除数（用于判断页数）
        NSInteger pageNumber = itemTotalCount / itemCount;
        // 总个数小于self.rowCount * self.itemCountPerRow
        
        if (itemTotalCount == 0) {
            pageNumber = 0;
        } else if (itemTotalCount <= itemCount){
            pageNumber = 1;
        } else {
            if (remainder == 0){
                pageNumber = pageNumber;
            } else {
                // 余数不为0,除数加1
                pageNumber += 1;
            }
        }
        CGFloat sectionWidth = pageNumber * self.collectionView.frame.size.width;
        //考虑特殊情况（当item的总个数不是self.rowCount * self.itemCountPerRow的整数倍，并且余数小于没行展示的个数的时候）
//        if(pageNumber > 1 && remainder != 0 && remainder < self.itemCountPerRow) {
//            sectionWidth = self.edgeInsets.left + (pageNumber - 1) * self.itemCountPerRow * (itemWidth + self.columnSpacing) + remainder * itemWidth + (remainder - 1) * self.columnSpacing +self.edgeInsets.right;
//        } else {
//            sectionWidth = self.edgeInsets.left + pageNumber * self.itemCountPerRow * (itemWidth + self.columnSpacing) - self.columnSpacing + self.edgeInsets.right;
//        }
        
        [self.sectionWidthArray addObject:@(sectionWidth)];
    }
}

//父类方法
-(CGSize)collectionViewContentSize{
    __block CGFloat width = 0;
    [self.sectionWidthArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        width = width + [obj floatValue];
    }];
    // 只支持水平方向上的滚动
    return CGSizeMake(width, self.collectionView.frame.size.height);
}

/** 设置每个item的属性（主要是frame） */
-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath offsetX:(CGFloat)offsetX{
    // item的宽高由行间距和collectionView的内边距决定
    CGFloat itemWidth = (self.collectionView.frame.size.width - self.edgeInsets.left - self.itemCountPerRow * self.columnSpacing) / self.itemCountPerRow;
    CGFloat itemHeight = (self.collectionView.frame.size.height - self.edgeInsets.top - self.edgeInsets.bottom - (self.rowCount - 1) *self.rowSpacing) / self.rowCount;
    NSInteger item = indexPath.item;
    //当前item所在的页
    NSInteger pageNumber = item / (self.rowCount * self.itemCountPerRow);
    NSInteger x = item % self.itemCountPerRow + pageNumber * self.itemCountPerRow;
    NSInteger y = item / self.itemCountPerRow - pageNumber * self.rowCount;
    
    //计算出item的坐标
    CGFloat itemX = self.edgeInsets.left + (itemWidth + self.columnSpacing) * x + offsetX;
    CGFloat itemY = self.edgeInsets.top + (itemHeight + self.rowSpacing) * y;
    
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    attributes.frame = CGRectMake(itemX, itemY, itemWidth, itemHeight);
    return attributes;
}

/** 返回collectionView视图中所有视图的属性数组 */
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    return self.attributesArrayM;
}

@end
