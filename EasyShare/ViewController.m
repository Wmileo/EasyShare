//
//  ViewController.m
//  EasyShare
//
//  Created by ileo on 16/2/2.
//  Copyright © 2016年 ileo. All rights reserved.
//

#import "ViewController.h"
#import "ShareCenter.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *but = [[UIButton alloc] initWithFrame:CGRectMake(50, 50, 100, 100)];
    but.backgroundColor = [UIColor orangeColor];
    [but addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:but];
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)share{
    ShareURLModel *model = [[ShareURLModel alloc] init];
    model.title = @"title";
    model.detail = @"detail";
    model.shareURL = @"http://www.baidu.com";
    model.imageURL = @"https://dn-mdpic.qbox.me/GroupAvatar/GroupAvatarImage_faKUryFMXLoZjqP_1859438527.jpg?imageView2/1/w/48/h/48/q/100";
    
    [[ShareCenter sharedInstance] shareURL:model withPlatform:Share_WX_Session];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
