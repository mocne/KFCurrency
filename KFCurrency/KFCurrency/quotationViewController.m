//
//  quotationViewController.m
//  KFCurrency
//
//  Created by 彭凯锋 on 2017/1/20.
//  Copyright © 2017年 pengkaifeng. All rights reserved.
//

#import "quotationViewController.h"
#import "AFNetworking.h"
#import "currencyViewController.h"
#import "bankViewController.h"

@interface quotationViewController ()

@property (strong, nonatomic) IBOutlet UIButton *countryName;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (strong, nonatomic) IBOutlet UIButton *pBuy;
@property (strong, nonatomic) IBOutlet UIButton *mBuy;
@property (strong, nonatomic) IBOutlet UIButton *pSell;
@property (strong, nonatomic) IBOutlet UIButton *mSell;
@property (strong, nonatomic) IBOutlet UIButton *midPrice;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UIButton *bankBtn;
@property (nonatomic, strong) NSArray *bankArr;
@property (nonatomic) NSInteger bankNum;
@property (nonatomic, strong) NSString *bankName;

@end

@implementation quotationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.translucent = NO;
    // Do any additional setup after loading the view.
    _dataArray = [NSMutableArray array];
    _bankArr = @[@"工商银行",@"招商银行",@"建设银行",@"中国银行",@"交通银行",@"农业银行"];

    [_countryName setTitle:@"美元" forState:UIControlStateNormal];
    [self getData];
    [_countryName addTarget:self action:@selector(chooseCountryName) forControlEvents:UIControlEventTouchDown];

    [_bankBtn addTarget:self action:@selector(chooseBank) forControlEvents:UIControlEventTouchDown];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCountryName:) name:@"changeCountryName" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBankName:) name:@"changeBankName" object:nil];
}

- (void)chooseBank{
    bankViewController *bankVC = [bankViewController new];
    [self.navigationController pushViewController:bankVC animated:YES];
}

- (void)changeBankName:(NSNotification *)notification{

    NSString *temp = (notification.userInfo[@"value"]);
    _bankName = temp;
    _bankBtn.titleLabel.text = [NSString stringWithFormat:@"来自：%@",_bankName];

    [self getData];

}

- (void)chooseCountryName{
    currencyViewController *newVC = [currencyViewController new];
    [self.navigationController pushViewController:newVC animated:YES];
}

- (void)changeCountryName:(NSNotification *)notification{

    NSString *cName = notification.userInfo[@"value"];
    _countryName.titleLabel.text = cName;
    [_countryName setTitle:cName forState:UIControlStateNormal];

    [self getData];

}


- (void)getData{

    //请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"key"] = @"f459c362e40de4b76f08ccd1989e2a99";
    params[@"bank"] = @(_bankNum);
    params[@"type"] = @0;


    NSString *urlStr = @"http://web.juhe.cn:8080/finance/exchange/rmbquot";

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];

    [manager GET:urlStr parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {

        //提示：如果开发网络应用，可以将反序列化出来的对象，保存至沙箱，以便后续开发使用。

        NSDictionary *temp = responseObject;

        _dataArray = temp[@"result"];
        NSDictionary *dict = _dataArray[0];

        for (int i = 0; i < _bankArr.count; i++) {
            NSString *keyName = [NSString stringWithFormat:@"data%d",i+1];

            



//
//                [_pBuy setTitle:dic[@"fBuyPri"] forState:UIControlStateNormal];
//                [_mBuy setTitle:dic[@"mBuyPri"] forState:UIControlStateNormal];
//                [_pSell setTitle:dic[@"fSellPri"] forState:UIControlStateNormal];
//                [_mSell setTitle:dic[@"mSellPri"] forState:UIControlStateNormal];
//                [_midPrice setTitle:dic[@"bankConversionPri"] forState:UIControlStateNormal] ;
//                _dateLabel.text = [NSString stringWithFormat:@"更新时间 %@ %@",dic[@"date"],dic[@"time"]];

            
        }


    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        NSLog(@"errror:%@",error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  刷新数据
 */
- (IBAction)reloadData:(UIBarButtonItem *)sender {
    [self getData];
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
