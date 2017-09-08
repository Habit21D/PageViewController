//
//  DMViewController.m
//  SegmentTableView
//
//  Created by apple on 2017/9/8.
//  Copyright © 2017年 jyn. All rights reserved.
//

#import "DMViewController.h"
#import "DMTableViewController.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface DMViewController ()
@property (nonatomic , strong) UIImageView *headView;
@property (nonatomic , strong) DMTableViewController *vc1;
@property (nonatomic , strong) DMTableViewController *vc2;
@property (nonatomic , strong) DMTableViewController *vc3;
@property (nonatomic , strong) UIView *segment;
@end

@implementation DMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"左右滑动";
    
    [self addChildVCWithArray:@[self.vc1,self.vc2,self.vc3] headerView:self.headView segmentHeight:40];
    
    self.viewControllerScrollToIndex = ^(NSInteger index) {
        NSLog(@"%ld",(long)index);
    };
  }

- (UIImageView *)headView {
    if (!_headView) {
        _headView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180)];
        
        _headView.image = [UIImage imageNamed:@"headimage.jpg"];
        _headView.contentMode = UIViewContentModeScaleToFill;
        _headView.layer.masksToBounds = YES;
        
        
        [_headView addSubview:self.segment];

    }
    return _headView;
}

- (UIView *)segment {
    if (!_segment) {
        _segment = [[UIView alloc] initWithFrame:CGRectMake(0, 140, SCREEN_WIDTH, 40)];
        _segment.backgroundColor = [UIColor orangeColor];

    }
    return _segment;
}

- (DMTableViewController *)vc1 {
    if (!_vc1) {
        _vc1 = [[DMTableViewController alloc] init];
    }
    return _vc1;
}

- (DMTableViewController *)vc2 {
    if (!_vc2) {
        _vc2 = [[DMTableViewController alloc] init];
    }
    return _vc2;
}

- (DMTableViewController *)vc3 {
    if (!_vc3) {
        _vc3 = [[DMTableViewController alloc] init];
    }
    return _vc3;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
