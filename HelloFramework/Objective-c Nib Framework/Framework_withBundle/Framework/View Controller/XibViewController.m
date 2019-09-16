//
//  XibViewController.m
//  HelloXib
//
//  Created by Uran on 2018/2/12.
//  Copyright © 2018年 Uran. All rights reserved.
//

#import "XibViewController.h"
#import "HelloView.h"
#import "CusTableViewCell.h"
#import "TopViewControllerManager.h"

#import "define.h"

#define cellID @"Cell"
#define CusCellID @"CusTableViewCell"
@interface XibViewController()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic,strong) HelloView * helloView;
@property (nonatomic,strong) UIViewController * topVC;
@property (nonatomic,strong) TopViewControllerManager * topVCManager;
@property (nonatomic,strong) NSBundle * bundle;
@end

@implementation XibViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor greenColor];
    
    self.backView.backgroundColor = [UIColor blueColor];
    _helloView = [[HelloView alloc] initWithFrame:CGRectMake(0, 0, _backView.frame.size.width, _backView.frame.size.height)];
    [self.backView addSubview:_helloView];
    
    _topVCManager = [TopViewControllerManager sharedInstance];
    
    // 取得 Bundle
    self.bundle = BundleSelf;
    // 從 bundle 中找出 image
    UIImage *img = [UIImage imageNamed:@"jobs.png" inBundle:_bundle compatibleWithTraitCollection:nil];
    self.imageView.image = img;
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    UINib * nib = [UINib nibWithNibName:@"CusTableViewCell" bundle:_bundle];
    [_tableView registerNib:nib forCellReuseIdentifier:CusCellID];
}
-(void)viewWillLayoutSubviews{
    _helloView.frame = CGRectMake(0, 0, _backView.frame.size.width, _backView.frame.size.height);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Public Function
+(void)showXibViewController{
    // 使用 Bundle 管理 Xib，判斷 path 是 nil 還是 不是nil 決定要 mainBundle 還是 self bundle
    NSBundle * bundle = BundleSelf;
    XibViewController * xibVC = [[XibViewController alloc] initWithNibName:@"XibViewController" bundle:bundle];
    
    UIViewController * topVC = [TopViewControllerManager topViewController];
    if (topVC.navigationController != nil) {
        [topVC.navigationController pushViewController:xibVC animated:YES];
    }else{
        [topVC presentViewController:xibVC animated:YES completion:nil];
    }
}
#pragma mark - private Function

#pragma mark - Table View Delegate DataSource，現無法解決如何製成 Framework
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CusTableViewCell *cell = (CusTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CusCellID];
    if (cell) {
        cell.showLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
        return cell;
    }else{
        NSLog(@"cell is nil");
        UINib * cusCellNib = [UINib nibWithNibName:@"CusTableViewCell" bundle:[NSBundle mainBundle]];
        [self.tableView registerNib:cusCellNib forCellReuseIdentifier:CusCellID];
        NSArray *nibContents;
        CusTableViewCell * cusCell;
        nibContents = [[NSBundle mainBundle]
                       loadNibNamed:@"CusTableViewCell" owner:self options:nil];
        NSEnumerator *nibEnumerator = [nibContents objectEnumerator];
        NSObject *nibItem = nil;
        while ((nibItem = [nibEnumerator nextObject]) != nil) {
            if ([nibItem isKindOfClass:[CusTableViewCell class]]) {
                cusCell = (CusTableViewCell *)nibItem;
                cusCell.showLabel.text = [NSString stringWithFormat:@"Jobs : %ld",(long)indexPath.row];
                return cusCell;
            }
        }
    }
    
    return cell;
}

#pragma mark : Touch Delegate
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.topVC = [_topVCManager topViewController];
    if (self.topVC.navigationController != nil) {
        [self.topVC.navigationController popViewControllerAnimated:YES];
    }else{
        [self.topVC dismissViewControllerAnimated:YES completion:nil];
    }
}
@end
