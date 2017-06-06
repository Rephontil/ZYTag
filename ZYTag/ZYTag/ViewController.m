//
//  ViewController.m
//  ZYTag
//
//  Created by ZhouYong on 2017/4/28.
//  Copyright © 2017年 Rephontil/Yong Zhou. All rights reserved.
//  联系方式：17621066708 周勇

#import "ViewController.h"
#import "UIView+ZYCustomDimension.h"
#import "ZYTagVC.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 150)];
    label.text = @"历史标签区域,第一次是看不到的.当我们第一次添加标签以后,点击右上角的完成按钮,再次进入控制器就有了.历史标签可以直接添加到上面,非常强大的功能,自己去效果!";
    label.numberOfLines = 0;
    label.center = self.view.center;
    label.centerY = self.view.centerY - 140;
    [self.view addSubview:label];
    
    UIButton *tagVCBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tagVCBtn.frame = CGRectMake(0, 0, 300, 50);
    tagVCBtn.center = self.view.center;
    tagVCBtn.backgroundColor = [UIColor grayColor];
    [tagVCBtn setTitle:@"进入标签页" forState:UIControlStateNormal];
    tagVCBtn.titleLabel.font = [UIFont systemFontOfSize:30 weight:3];
    [tagVCBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [tagVCBtn addTarget:self action:@selector(pushToTagVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tagVCBtn];
    
}

- (void)pushToTagVC{
    [self.navigationController pushViewController:[[ZYTagVC alloc] init] animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
