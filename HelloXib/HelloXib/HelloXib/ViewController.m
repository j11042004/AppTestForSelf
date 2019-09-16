//
//  ViewController.m
//  HelloXib
//
//  Created by Uran on 2018/2/12.
//  Copyright © 2018年 Uran. All rights reserved.
//

#import "ViewController.h"
#import "XibViewController.h"
#import "CusTableViewCell.h"
#define CellID @"Cell"
#define CusCellID @"CusTableViewCell"
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
//    [self.tableview registerNib:[UINib nibWithNibName:@"CusTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:CusCellID];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    UINib * cusCellNib = [UINib nibWithNibName:@"CusTableViewCell" bundle:[NSBundle mainBundle]];
    [self.tableview registerNib:cusCellNib forCellReuseIdentifier:CusCellID];
}
- (IBAction)show:(id)sender {
    [XibViewController showXibViewController];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CusTableViewCell *cell =  (CusTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CusCellID];
    if(cell == nil) {
        NSLog(@"Cell is nil");
        UINib * cusCellNib = [UINib nibWithNibName:@"CusTableViewCell" bundle:[NSBundle mainBundle]];
        [self.tableview registerNib:cusCellNib forCellReuseIdentifier:CusCellID];
        NSLog(@"registerNib");
        NSArray *nibContents;
        CusTableViewCell * cusCell;
        
        nibContents = [[NSBundle mainBundle]
                       loadNibNamed:@"CusTableViewCell" owner:self options:nil];
        NSEnumerator *nibEnumerator = [nibContents objectEnumerator];
        NSObject *nibItem = nil;
        while ((nibItem = [nibEnumerator nextObject]) != nil) {
            if ([nibItem isKindOfClass:[CusTableViewCell class]]) {
                cusCell = (CusTableViewCell *)nibItem;
                cusCell.showLabel.text = [NSString stringWithFormat:@"hello : %ld",(long)indexPath.row];
                return cusCell;
            }
        }
    }else{
        cell.showLabel.text = [NSString stringWithFormat:@"hello : %ld",(long)indexPath.row];
    }

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
