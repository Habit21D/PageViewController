//
//  ViewController.m
//  SegmentTableView
//
//  Created by apple on 2017/9/7.
//  Copyright © 2017年 jyn. All rights reserved.
//

#import "ViewController.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define HEAD_HEIGHT 240
@interface ViewController ()
<
UITableViewDataSource,
UITableViewDelegate,
UIScrollViewDelegate
>
@property (nonatomic , strong) UIScrollView *hScrollView;
@property (nonatomic , strong) UITableView *tableView1;
@property (nonatomic , strong) UITableView *tableView2;
@property (nonatomic , strong) UIImageView *headView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.hScrollView];
    [self.hScrollView addSubview:self.tableView1];
    [self.hScrollView addSubview:self.tableView2];
    [self.view addSubview:self.headView];

}

- (UIImageView *)headView {
    if (!_headView) {
        _headView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEAD_HEIGHT)];
        
        _headView.image = [UIImage imageNamed:@"headimage.jpg"];
        _headView.contentMode = UIViewContentModeScaleToFill;
        _headView.layer.masksToBounds = YES;
   
    }
    return _headView;
}

- (UIScrollView *)hScrollView {
    if (!_hScrollView) {
        _hScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _hScrollView.backgroundColor = [UIColor whiteColor];
        _hScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 2, SCREEN_HEIGHT);
        _hScrollView.showsHorizontalScrollIndicator = NO;
        _hScrollView.pagingEnabled = YES;
        _hScrollView.delegate = self;
    }
    return _hScrollView;
}

-(UITableView *)tableView1 {
    if (!_tableView1) {
        _tableView1 = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView1.backgroundColor = [UIColor whiteColor];
        _tableView1.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEAD_HEIGHT)];
        _tableView1.delegate = self;
        _tableView1.dataSource = self;
        _tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView1 registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
        
    }
    return _tableView1;
}

-(UITableView *)tableView2 {
    if (!_tableView2) {
        _tableView2 = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _tableView2.backgroundColor = [UIColor whiteColor];
        _tableView2.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEAD_HEIGHT)];

        _tableView2.delegate = self;
        _tableView2.dataSource = self;
        _tableView2.separatorStyle = UITableViewCellSeparatorStyleNone;

        [_tableView2 registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
        
    }
    return _tableView2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.textLabel.text = [NSString stringWithFormat:@"这里显示的是第%ld行",(long)indexPath.row];
    
    return cell;
}


/*
 scrollView滑动时调用
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.hScrollView) {
        //如果是底层scrollView的滑动则不用更改headerView跟随滑动
        return;
    }
    
    //如果是其他scrollView的滑动则需要更改headerView跟随滑动
    CGFloat contentY = scrollView.contentOffset.y;
    
    
    // 偏移量contentY有三种情况:
    // 1. 头视图完全显示，视图下拉，即：contentY < 0，此时可做处理：headerView跟随下移或者headerView放放大
    // 2. 头视图部分显示，即contentY >= 0 && contentY < HEAD_HEIGHT，此时headerView跟随contentY移动
    // 3. 头视图隐藏（或者只显示segment），即contentY >= HEAD_HEIGHT，此时headerView固定frame
    if (contentY < 0) {
        self.headView.frame = CGRectMake(SCREEN_WIDTH * contentY / HEAD_HEIGHT /2, 0, SCREEN_WIDTH * (HEAD_HEIGHT - contentY)/HEAD_HEIGHT, HEAD_HEIGHT - contentY);//头视图放大
//        self.headView.frame = CGRectMake(0, -contentY, SCREEN_WIDTH, HEAD_HEIGHT);//头视图跟随下移
    }else if (contentY >= 0 && contentY < HEAD_HEIGHT) {
        self.headView.frame = CGRectMake(0, - contentY, SCREEN_WIDTH, HEAD_HEIGHT);
    }else if (contentY >= HEAD_HEIGHT) {
        if (CGRectGetMinY(self.headView.frame) != -HEAD_HEIGHT) {
            self.headView.frame = CGRectMake(0, - HEAD_HEIGHT, SCREEN_WIDTH, HEAD_HEIGHT);

        }}
    
}

//放开手指时调用
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView == self.hScrollView) {
        
        return;
    }
    CGFloat contentY = scrollView.contentOffset.y;
    [self updateTableViewFrame:contentY];

}

//放开手指后，若tableView仍然自己滚动，自己滚动结束时会调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.hScrollView) {
        
        return;
    }
    CGFloat contentY = scrollView.contentOffset.y;
    [self updateTableViewFrame:contentY];
}

- (void)updateTableViewFrame:(CGFloat)offsetY {
    if (offsetY >= HEAD_HEIGHT) {
        if ( self.tableView1.contentOffset.y <= HEAD_HEIGHT) {
            self.tableView1.contentOffset = CGPointMake(0, HEAD_HEIGHT);
        }
        
        if ( self.tableView2.contentOffset.y <= HEAD_HEIGHT) {
            self.tableView2.contentOffset = CGPointMake(0, HEAD_HEIGHT);
        }
    }else if (offsetY >= 0 && offsetY < HEAD_HEIGHT) {
        self.tableView1.contentOffset = CGPointMake(0, offsetY);
        self.tableView2.contentOffset = CGPointMake(0, offsetY);
        
    }else if (offsetY < 0) {
        if ( self.tableView1.contentOffset.y > 0) {
            self.tableView1.contentOffset = CGPointMake(0, 0);
        }
        
        if ( self.tableView2.contentOffset.y > 0) {
            self.tableView2.contentOffset = CGPointMake(0, 0);
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
