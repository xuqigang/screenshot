//
//  XMBaseVC.m
//   
//
//  Created by Hanxiaojie on 2018/5/29.
//  Copyright © 2018年 凤凰新媒体. All rights reserved.
//

#import "XMBaseVC.h"

@interface XMBaseVC ()

@property (nonatomic, strong) UIButton *rightBtn;

@end

@implementation XMBaseVC
+ (instancetype)instanceFromNib{
    XMBaseVC *vc = [[self alloc] initWithNibName:NSStringFromClass([self class]) bundle:[NSBundle mainBundle]];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    [self.navigationController.navigationBar setTitleTextAttributes:
//     
//     @{NSFontAttributeName:[UIFont systemFontOfSize:17],
//       
//       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    
    
    //设置返回按钮
    [self setLeftButtonText:@"返回"];
}

- (void) setNavigationBarColor:(UIColor *) color
{
    
    self.navigationController.navigationBar.barTintColor = color;
}

//设置左按钮
- (void) setLeftButtonText:(NSString * ) text
{
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 20, 44, 44);
    button.titleLabel.font = QGFont(16);
    [button setTitleColor:UIColorFromRGB(0x1F2124) forState:UIControlStateNormal];
    [button setTitle:text forState:UIControlStateNormal];
    [button addTarget:self action:@selector(leftButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = buttonItem;
    
}
- (void)setLeftButtonImage:(UIImage * ) image
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 20, 44, 44);
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(leftButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = buttonItem;
    
}
- (void)setLeftButtonWithImageName:(NSString * )imageName{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 20, 44, 44);
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(leftButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = buttonItem;
}
- (void)hiddenLeftButton
{
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = nil;
}
- (void) leftButtonClicked:(UIButton *) button
{
    NSLog(@"返回到上一界面");
    PopViewController;

}
//设置右按钮
- (void) setRightButtonText:(NSString * ) text
{
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBtn.frame = CGRectMake(0, 20, 44, 44);
    _rightBtn.titleLabel.font = QGFont(14);
    [_rightBtn setTitleColor:UIColorFromRGB(0x1F2124) forState:UIControlStateNormal];
    [_rightBtn setTitle:text forState:UIControlStateNormal];
    [_rightBtn addTarget:self action:@selector(rightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * buttonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBtn];
    self.navigationItem.rightBarButtonItem = buttonItem;
}

- (void)setRightButtonText:(NSString *)text selectedText:(NSString*)seletedText{
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBtn.frame = CGRectMake(0, 20, 44, 44);
    _rightBtn.titleLabel.font = QGFont(14);
    [_rightBtn setTitle:text forState:UIControlStateNormal];
    [_rightBtn setTitle:seletedText forState:UIControlStateSelected];
    
    [_rightBtn addTarget:self action:@selector(rightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * buttonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBtn];
    self.navigationItem.rightBarButtonItem = buttonItem;
}
- (void) setRightButtonWithImagename:(NSString * ) image
{
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBtn.frame = CGRectMake(0, 20, 44, 44);
    [_rightBtn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [_rightBtn addTarget:self action:@selector(rightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * buttonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBtn];
    self.navigationItem.rightBarButtonItem = buttonItem;
}

- (void) setRightButtonImage:(UIImage * ) image
{
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBtn.frame = CGRectMake(0, 0, 44, 44);
    [_rightBtn setImage:image forState:UIControlStateNormal];
    [_rightBtn addTarget:self action:@selector(rightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * buttonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBtn];
    self.navigationItem.rightBarButtonItem = buttonItem;
}
//设置右边第二个按钮
- (void)setRightSecondButtonText:(NSString *)text{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 44, 44);
    rightBtn.titleLabel.font = QGFont(14);
    [rightBtn setTitleColor:UIColorFromRGB(0x1F2124) forState:UIControlStateNormal];
    [rightBtn setTitle:text forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightSecondButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(47, 0, 1, 15)];
    lineView.xm_centerY = rightBtn.xm_centerY;
    lineView.backgroundColor = UIColorFromRGB(0x1F2124);
    [rightBtn addSubview:lineView];
    
    UIBarButtonItem * buttonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItems = @[self.navigationItem.rightBarButtonItem,buttonItem];
}
- (void)setRightSecondButtonText:(NSString *)text selectedText:(NSString*)seletedText{
    
}
- (void)setRightSecondButtonImage:(UIImage *)image{
    
}
- (void)setRightSecondButtonWithImagename:(NSString * )image{
    
}
- (void)rightSecondButtonClicked:(UIButton *)button //需要时，在子类重写
{
    
}
- (void) hiddenRightButton
{
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.rightBarButtonItems = nil;
}
- (void) rightButtonClicked:(UIButton *) button
{
    NSLog(@"右按钮点击");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    NSLog(@"%@控制器已经被释放",NSStringFromClass([self class]));
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
