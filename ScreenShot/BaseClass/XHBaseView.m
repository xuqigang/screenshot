//
//  XHBaseView.m
//  水晶日记
//
//  Created by Hanxiaojie on 2018/6/20.
//  Copyright © 2018年 徐其岗. All rights reserved.
//

#import "XHBaseView.h"

@implementation XHBaseView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] lastObject];
        if (self) {
            self.frame = frame;
        }
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] lastObject];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
