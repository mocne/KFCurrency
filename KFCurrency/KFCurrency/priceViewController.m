//
//  priceViewController.m
//  KFCurrency
//
//  Created by 彭凯锋 on 2017/1/20.
//  Copyright © 2017年 pengkaifeng. All rights reserved.
//

#import "priceViewController.h"

@interface priceViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arr;

@end

@implementation priceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.translucent = NO;
    // Do any additional setup after loading the view.
    _arr = [NSMutableArray  array];
    [self getNetState];

    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _tableView .delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = YES;
    [self.view addSubview:_tableView];

    [NSTimer timerWithTimeInterval:1 target:self selector:@selector(reloadTableView) userInfo:nil repeats:YES];

}

- (void)reloadTableView{
    [_tableView reloadData];
}

- (void)getNetState{

    NSString *asd = [self networkingStatesFromStatebar];
    NSLog(@"当前是 %@ 网络",asd);
    if (![asd isEqualToString:@"wifi"]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"网络提示" message:@"为节省流量，建议选择Wi-Fi网络环境下使用" preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *quitAC = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"选取非Wi-Fi网络");
        }];

        UIAlertAction *wifiAC = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"选取Wi-Fi网络环境");

            NSURL*url=[NSURL URLWithString:@"Prefs:root=WIFI"];
            NSString * defaultWork = [self getDefaultWork];
            NSString * bluetoothMethod = [self getBluetoothMethod];
            Class LSApplicationWorkspace = NSClassFromString(@"LSApplicationWorkspace");
            [[LSApplicationWorkspace  performSelector:NSSelectorFromString(defaultWork)] performSelector:NSSelectorFromString(bluetoothMethod) withObject:url withObject:nil];

        }];

        [alert addAction:quitAC];
        [alert addAction:wifiAC];

        [self presentViewController:alert animated:YES completion:^{
            NSLog(@"跳转至设置页面");
        }];
    }
}

-(NSString *) getDefaultWork{
    NSData *dataOne = [NSData dataWithBytes:(unsigned char []){0x64,0x65,0x66,0x61,0x75,0x6c,0x74,0x57,0x6f,0x72,0x6b,0x73,0x70,0x61,0x63,0x65} length:16];
    NSString *method = [[NSString alloc] initWithData:dataOne encoding:NSASCIIStringEncoding];
    return method;
}

-(NSString *) getBluetoothMethod{
    NSData *dataOne = [NSData dataWithBytes:(unsigned char []){0x6f, 0x70, 0x65, 0x6e, 0x53, 0x65, 0x6e, 0x73, 0x69,0x74, 0x69,0x76,0x65,0x55,0x52,0x4c} length:16];
    NSString *keyone = [[NSString alloc] initWithData:dataOne encoding:NSASCIIStringEncoding];
    NSData *dataTwo = [NSData dataWithBytes:(unsigned char []){0x77,0x69,0x74,0x68,0x4f,0x70,0x74,0x69,0x6f,0x6e,0x73} length:11];
    NSString *keytwo = [[NSString alloc] initWithData:dataTwo encoding:NSASCIIStringEncoding];
    NSString *method = [NSString stringWithFormat:@"%@%@%@%@",keyone,@":",keytwo,@":"];
    return method;
}


#pragma mark - table view dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 21;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"MTCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    cell.textLabel.text = [NSString stringWithFormat:@"Cell %ld", (long)indexPath.section + 1];

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}


#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

/**
 *  获取stateBar网络状态
 */
- (NSString *)networkingStatesFromStatebar {
    
    // 状态栏是由当前app控制的，首先获取当前app
    UIApplication *app = [UIApplication sharedApplication];

    NSArray *children = [[[app valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];

    int type = 0;
    for (id child in children) {
        if ([child isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            type = [[child valueForKeyPath:@"dataNetworkType"] intValue];
        }
    }

    NSString *stateString = @"wifi";

    switch (type) {
        case 0:
            stateString = @"notReachable";
            break;

        case 1:
            stateString = @"2G";
            break;

        case 2:
            stateString = @"3G";
            break;

        case 3:
            stateString = @"4G";
            break;

        case 4:
            stateString = @"LTE";
            break;

        case 5:
            stateString = @"wifi";
            break;

        default:
            break;
    }

    return stateString;
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
