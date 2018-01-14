//
//  ViewController.m
//  导航栏全透明下拉放大图片
//
//  Created by 杨英俊 on 18-1-10.
//  Copyright © 2018年 杨英俊. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) UIImageView *image;
@property (nonatomic,assign) CGFloat offset;

@end

@implementation ViewController

static NSString *const reuseId = @"cell";
#pragma mark ~~~~~~~~~~ 页面加载 ~~~~~~~~~~
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height / 3)];
    self.image.image = [UIImage imageNamed:@"image.jpeg"];
    [self.view addSubview:self.image];
    
    
    self.table = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
    self.table.dataSource = self;
    self.table.delegate = self;
    self.table.backgroundColor = [UIColor clearColor];
    self.table.contentInset = UIEdgeInsetsMake(self.view.frame.size.height/3 - 64, 0, 0, 0);
    [self.view addSubview: self.table];
    self.offset = self.table.contentOffset.y;
    
    
    [self.table registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseId];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
}

#pragma mark ~~~~~~~~~~ TableViewDataSource ~~~~~~~~~~
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    cell.textLabel.text = [NSString stringWithFormat:@"第%zdrow",indexPath.row];
    return cell;
}

#pragma mark ~~~~~~~~~~ ScrollViewDelegate ~~~~~~~~~~
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat y = scrollView.contentOffset.y;
    NSLog(@"%f---%f",y,self.offset);
    CGRect frame = self.image.frame;
    if (y > self.offset) {
        NSLog(@"向上");
        self.title = @"";
        frame.origin.y = self.offset-y;
        if (y>=0) {
            frame.origin.y = self.offset;
            self.title = @"标题";
        }
        self.image.frame = frame;
    }
    // tableView设置偏移时不能立马获取他的偏移量，所以一开始获取的offset值为0
    else if (self.offset == 0) return;
    else {
        NSLog(@"向下");
        CGFloat x = self.offset - y;
        frame = CGRectMake(-x/2, -x/2, self.view.frame.size.width + x, self.view.frame.size.height/3+x);
        self.image.frame = frame;
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
