//
//  ViewController.m
//  一次定位
//
//  Created by 纵昂 on 17/1/4.
//  Copyright © 2017年 纵昂. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
@interface ViewController ()<CLLocationManagerDelegate>

@property (nonatomic, strong)CLLocationManager * mgr;

@end
/**
 模拟器bug: 可以尝试切换同系统模拟器.
 或者直接使用真机
 */
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor=[UIColor redColor];
    
//1. 创建CLLocationManager对象
    self.mgr =[CLLocationManager new];
    
    //2. 请求用户授权 --> 从iOS8开始, 必须在程序中请求用户授权, 除了写代码, 还要配置plist列表的键值
    
    //如果要适配iOS7, 一定要加if判断, 因为低版本的SDK没有授权方法
    //    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) { }
    
    
    /**
     1. 如果要授权, 从iOS8开始, 必须在程序中请求用户授权, 除了写代码, 还要配置plist列表的键值
     2. 授权方式 -->requestWhenInUseAuthorization 当用户使用的使用授权
     -->requestAlwaysAuthorization 永久授权方法
     3. 一定要记得授权方法和plist列表匹配 (when / always)
     NSLocationWhenInUseUsageDescription
     NSLocationAlwaysUsageDescription
     
     4. 如果2个方法都写, 会出现2此授权的情况 (第一次会走第一个方法, 第二次会走第二个方法 --> 一般使用1个方法即可
     
     5. 大部分的程序之使用 "使用期间" 这个授权即可. 如果说列表出出现了3个, 说明两个授权方法写了
     6. plist的Value 可以不写, 写上是为了提示用户, 当前程序会在哪些地方使用定位. 建议写上, 提高用户打开的几率
     )
     */

//2. 请求用户授权 --> 从iOS8开始, 必须在程序中请求用户授权, 除了写代码, 还要配置plist列表的键值
    if ([self.mgr respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
//         当用户使用的实用授权 --> 能看见APP界面的时候就是使用期间
        [self.mgr requestWhenInUseAuthorization];
//      永久授权方法 --> 锁屏 / 退出后台
//        [self.mgr requestAlwaysAuthorization];

    }
    
    /**
     iOS9新特性 --> 临时获取后台定位权限
     */
    
    //allowsBackgroundLocationUpdates 如果实现了此方法, 还需要配置plist列表
    
    //一定注意适配版本, 要加iOS9判断
    if ([UIDevice currentDevice].systemVersion.floatValue>=9.0) {
        self.mgr.allowsBackgroundLocationUpdates=YES;
    }
    
//    设置代理－－》获取用户位置
    self.mgr.delegate=self;
//   4\ 调用开始定位方法
     [self.mgr startUpdatingLocation];
    
//    比较连个位置之间的距离
//    北京和西安的距离
//    创建一个位置对象，最少只需要两个值，经纬度
    CLLocation * location1 =[[CLLocation alloc] initWithLatitude:40 longitude:116];
    CLLocation * location2 =[[CLLocation alloc] initWithLatitude:34.27 longitude:108.93];
    
//    比较的事直线距离
    CLLocationDistance distance =[location1 distanceFromLocation:location2];
    NSLog(@"distance: %f",distance /1000);
    /**
     持续定位: 持续定位会消耗电量, 应该对电量做点优化
     
     */
    
    //5. 距离筛选器 --> 位置发生了一定的改变之后, 才去调用代理方法 降低方法的调用来达到省电的目的
    //distanceFilter 单位是米, 如果设置了10, 就代表发生10米以上的位置变化时才会调用代理方法
//    self.mgr.distanceFilter =10;
//    6,定位精准度
//    手机当中那些方式可以定位：移动网络数据(基站定位)，GPS，Wi-Fi
//    GPS：跟全球24颗卫星之间通讯，降低通讯计算的过程就可以省电
//    desired:期望
//    Accuracy:精准度／准确
//    self.mgr.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    /**
     kCLLocationAccuracyBestForNavigation
     kCLLocationAccuracyBest;
     kCLLocationAccuracyNearestTenMeters;
     kCLLocationAccuracyHundredMeters;
     kCLLocationAccuracyKilometer;
     kCLLocationAccuracyThreeKilometers;
     */
    
}

#pragma mark 代理方法
// 当完成位置更新的时候调用 －－》此方法会频繁调用
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
//    CLLocation *location = locations.lastObject;
//    NSLog(@"locations: %tu",location.horizontalAccuracy);
//   5. 停止定位 --> 7.1 开始 didUpdateLocations方法有可能不会持续调用
//    [self.mgr stopUpdatingLocation];
    //locations: <+40.05894607,+116.32944547> +/- 50.00m (speed 0.00 mps / course -1.00) @ 15/12/11 中国标准时间 09:45:28

    CLLocation * location = locations.lastObject;
    //NSLog(@"locations: %@",location);
    
    //5. 停止定位
    //[self.mgr stopUpdatingLocation];
    
    //locations: <+40.05894607,+116.32944547> +/- 50.00m (speed 0.00 mps / course -1.00) @ 15/12/11 中国标准时间 09:45:28
    
    
    NSLog(@"latitude: %f, longitude: %f",location.coordinate.latitude, location.coordinate.longitude);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
