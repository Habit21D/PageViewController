//
//  SHViewController.m
//  SegmentTableView
//
//  Created by apple on 2017/9/7.
//  Copyright © 2017年 jyn. All rights reserved.
//  SegmentHeaderViewController，继承自它就可以直接创建带有头视图的segment了

#import "SHViewController.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define WEAKSELF __weak typeof(self) weakSelf = self;
@interface SHViewController ()
<
UIScrollViewDelegate
>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray <UIViewController *> *vcArray;
@property (nonatomic, strong) UIView *headerView;//头视图
@property (nonatomic, assign) CGFloat headerHeight;//头视图的高度
@property (nonatomic, assign) CGFloat segmentHeight;//segment的高度
@property (nonatomic, assign) CGFloat headerMaxScrollHeight;//headerView最大的上移距离
@property (nonatomic, assign) CGFloat viewHeight;//self.view的高度

@end

@implementation SHViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = NO;
    [self.view addSubview:self.scrollView];
    
}

- (CGFloat)viewHeight {
    if (_viewHeight > 0) {
        return _viewHeight;
    }
    
    CGFloat height = SCREEN_HEIGHT;
    if (self.navigationController && self.navigationController.isNavigationBarHidden == NO) {
        height -= 64;
    }
    
    if (self.tabBarController.tabBar.isHidden == YES) {
        height -= 49;
    }
    
    _viewHeight = height;
    return _viewHeight;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.viewHeight)];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (void)addChildVCWithArray:(NSArray <UIViewController *> *)childVCArray
                 headerView:(UIView *)headerView
                segmentHeight:(CGFloat)segmentHeight {
    //滚动的头视图
    if (headerView) {
        [self.view addSubview:headerView];
        self.headerView = headerView;
        self.headerHeight = CGRectGetHeight(headerView.frame);
        self.segmentHeight =  segmentHeight;
        self.headerMaxScrollHeight = self.headerHeight - self.segmentHeight;
    }
    
    if (!childVCArray || childVCArray.count <= 0) {
        return;
    }
    //scrollview的contentSize
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * childVCArray.count, self.viewHeight);
    //需要左右滚动的segmentVC
    self.vcArray = childVCArray;
    WEAKSELF
    [childVCArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIViewController* childVC = (UIViewController *)obj;
        childVC.view.frame = CGRectMake(SCREEN_WIDTH * idx, CGRectGetMinY(childVC.view.frame), SCREEN_WIDTH, CGRectGetHeight(childVC.view.frame));
        [weakSelf.scrollView addSubview:childVC.view];
        [weakSelf addChildViewController:childVC];
        UIScrollView *scrollView = [weakSelf getScrollViewWithVC:childVC];
        
        [scrollView addObserver:weakSelf forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionInitial context:nil];
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    UIScrollView *scrollView = object;
    CGFloat offsetY = scrollView.contentOffset.y;
    if ([keyPath isEqualToString:@"contentOffset"]) {
        //headerview的frame变化
        if (offsetY >= self.headerMaxScrollHeight) {
            if (CGRectGetMinY(self.headerView.frame) != -self.headerMaxScrollHeight) {
                self.headerView.frame = CGRectMake(0, - self.headerMaxScrollHeight, SCREEN_WIDTH, self.headerHeight);
                
            }}else if (offsetY >= 0 && offsetY < self.headerMaxScrollHeight) {
                
                self.headerView.frame = CGRectMake(0, - offsetY, SCREEN_WIDTH, self.headerHeight);
            }else if (offsetY < 0) {
//                self.headerView.frame = CGRectMake(SCREEN_WIDTH * offsetY / self.headerHeight /2.0,0, SCREEN_WIDTH * (self.headerHeight - offsetY)/self.headerHeight, self.headerHeight - offsetY);//头视图随着拉伸变大
                self.headerView.frame = CGRectMake(0, -offsetY, SCREEN_WIDTH, self.headerHeight);
            }
    
        //各个vc中scrollView的frame变化
        WEAKSELF
        [self.vcArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIViewController* childVC = (UIViewController *)obj;
            UIScrollView *scrollView = [weakSelf getScrollViewWithVC:childVC];
            if (offsetY >= weakSelf.headerMaxScrollHeight) {
                if (scrollView.contentOffset.y < weakSelf.headerMaxScrollHeight)
                    scrollView.contentOffset = CGPointMake(0, weakSelf.headerMaxScrollHeight);
            }else if (offsetY >= 0 && offsetY < weakSelf.headerMaxScrollHeight) {
                if(scrollView.contentOffset.y != offsetY)
                    scrollView.contentOffset = CGPointMake(0, offsetY);
            }else if (offsetY < 0) {
                if (scrollView.contentOffset.y > 0)
                    scrollView.contentOffset = CGPointMake(0, 0);
            }
        }];

    }

}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.viewControllerScrollToIndex) {
        NSInteger index = scrollView.contentOffset.x / SCREEN_WIDTH;
        self.viewControllerScrollToIndex(index);
    }
}

- (UIScrollView *)getScrollViewWithVC:(UIViewController *)vc {
    for (UIView *tempView in vc.view.subviews) {
        if ([tempView isKindOfClass:[UIScrollView class]]) {
            return (UIScrollView *)tempView;
        }
    }
    
    return nil;
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
