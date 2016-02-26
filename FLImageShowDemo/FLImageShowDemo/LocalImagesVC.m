//
//  LocalImagesVC.m
//  FLImageShowDemo
//
//  Created by fuliang on 16/2/25.
//  Copyright © 2016年 fuliang. All rights reserved.
//

#import "LocalImagesVC.h"
#import "FLImageShowVC.h"

@interface LocalImagesVC ()

@property (nonatomic,strong)NSArray *imageNames;
@end

@implementation LocalImagesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    _imageNames = @[@"1.jpg", @"2.png", @"3.jpg", @"4.jpg", @"5.jpg", @"6.jpg", @"7.jpg", @"8.jpg"];
    
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI
{
    CGFloat width = 80;
    CGFloat fxWidth = ([UIScreen mainScreen].bounds.size.width - 3 * width) / 4;
    [_imageNames enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger hang = idx / 3;
        NSInteger lie = idx % 3;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((lie + 1) * fxWidth + lie * width, (hang + 1) * fxWidth + hang * width + 64, width, width)];
        imageView.image = [UIImage imageNamed:obj];
        imageView.tag = idx;
        [self.view addSubview:imageView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewAction:)];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:tap];
    }];
}

#pragma mark--点击
- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imageViewAction:(UITapGestureRecognizer *)tap
{
    UIImageView *imageView = (UIImageView *)tap.view;
    NSInteger tag = imageView.tag;
    NSString *imageName = _imageNames[tag];
    NSLog(@"点击%@",imageName);
    
    FLImageShowVC *fvc = [[FLImageShowVC alloc] init];
    fvc.localImageNamesArray = _imageNames;
    fvc.currentIndex = tag;
    [self.navigationController pushViewController:fvc animated:YES];
}

@end
