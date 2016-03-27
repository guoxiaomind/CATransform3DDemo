//
//  MainViewController.m
//  CATransform3DDemo
//
//  Created by David Guo on 16/3/27.
//  Copyright © 2016年 David. All rights reserved.
//

#import "MainViewController.h"
#define screenWidth [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height
#define animateShowTime 0.3f

@interface MainViewController (){
    UIView *maskView;
    UIButton * showButton;
    UIView *currentView;
    UIView *bottomView;
}

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (void)initUI{
    
    self.view.backgroundColor = [UIColor redColor];
    
    maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [maskView setBackgroundColor:[UIColor blackColor]];
    [maskView setAlpha:0];
    UITapGestureRecognizer *hideGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAnimate)];
    [maskView addGestureRecognizer:hideGesture];
    
    currentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    currentView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:currentView];
    
    showButton = [[UIButton alloc]initWithFrame:CGRectMake((self.view.frame.size.width-100)/2, 250, 100, 60)];
    showButton.backgroundColor = [UIColor yellowColor];
    [showButton addTarget:self action:@selector(showAnimate) forControlEvents:UIControlEventTouchUpInside];
    [currentView addSubview:showButton];
    
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, screenHeight, screenWidth, 340)];
    [bottomView setBackgroundColor:[UIColor greenColor]];
    [self.view addSubview:bottomView];

}

- (void)showAnimate{
    [self showViewAnimate:currentView];
}
- (void)hideAnimate{
    [self hideViewAnimate:currentView];
}
//显示动画
- (void)showViewAnimate:(UIView *)view
{
    [self.view addSubview:maskView];
    CGRect frame = [bottomView frame];
    frame.origin.y = screenHeight - bottomView.frame.size.height;
    [UIView animateWithDuration:animateShowTime animations:^{
        [view.layer setTransform:[self firstStep]];
    } completion:^(BOOL finished){
        [UIView animateWithDuration:animateShowTime animations:^{
             [view.layer setTransform:[self secondStep:view]];
        } completion:^(BOOL finished){
            [UIView animateWithDuration:animateShowTime animations:^{
                [maskView setAlpha:0.5f];
                [bottomView setFrame:frame];
            }];
        }];
    }];
    [self.view bringSubviewToFront:bottomView];
}
//隐藏动画
- (void)hideViewAnimate:(UIView *)view
{
    CGRect frame = [bottomView frame];
    frame.origin.y += bottomView.frame.size.height;
    [UIView animateWithDuration:animateShowTime animations:^{
        [maskView setAlpha:0.f];
        [bottomView setFrame:frame];
    } completion:^(BOOL finished){
        [UIView animateWithDuration:animateShowTime animations:^{
            [maskView removeFromSuperview];
            [view.layer setTransform:[self firstStep]];
        } completion:^(BOOL finished){
            [UIView animateWithDuration:animateShowTime animations:^{
                [view.layer setTransform:CATransform3DIdentity];
            }];
        }];
    }];
}
//动画效果的第一步
-(CATransform3D)firstStep{
    
    //让transform1为单位矩阵
    CATransform3D transform1 = CATransform3DIdentity;
    //z轴纵深的3D效果和CATransform3DRotate配合使用才能看出效果
    transform1.m34 = 1.0/-900;
    //x和y都缩小为原来的0.9，z不变
    transform1 = CATransform3DScale(transform1, 0.9, 0.9, 1);
    //绕x轴向内旋转30度
    transform1 = CATransform3DRotate(transform1,15.0f * M_PI/180.0f, 1, 0, 0);
    return transform1;
}
//动画效果的第二步
-(CATransform3D)secondStep:(UIView*)view{
    //让transform2为单位矩阵
    CATransform3D transform2 = CATransform3DIdentity;
    //变成transform1旋转前的状态
    transform2 = CATransform3DScale(transform2, 0.9, 0.9, 1);
    return transform2;
}

@end
