//
//  XHBaseNC.m
//   
//
//  Created by Hanxiaojie on 2018/5/29.
//  Copyright © 2018年 凤凰新媒体. All rights reserved.
//

#import "XHBaseNC.h"

@interface XHBaseNC ()
{
    NSString *_title;
    NSString *_image;
}
@end

@implementation XHBaseNC

- (void)viewDidLoad {
    [super viewDidLoad];
 
    
    [self.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:UIColorForRGB(85, 85, 85, 1), NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
//    self.navigationBar.barTintColor = [UIColor whiteColor];
    [self.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    // Do any additional setup after loading the view.
}
- (void)updateThemeColor{
    self.navigationBar.barTintColor = [UIColor whiteColor];
    [self.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    [self setTitle:_title andImage:_image andSelectedImage:_image];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) setTitle:(NSString*) title andImage:(NSString * ) img andSelectedImage:(NSString*) selectedImg
{
    _title = title;
    _image = img;
    self.tabBarItem.title = title;
    self.tabBarItem.image = [[UIImage imageWithIdentifier:img iconColor:UIColorForRGB(85, 85, 85, 1) size:30] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.tabBarItem.selectedImage = [[UIImage imageWithIcon:img backgroundColor:[UIColor clearColor] iconColor:[UIColor whiteColor] fontSize:32] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
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
