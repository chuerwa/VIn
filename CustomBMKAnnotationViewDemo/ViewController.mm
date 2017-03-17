//
//  ViewController.m
//  CustomBMKAnnotationViewDemo
//
//  Created by wordtech on 17/3/16.
//  Copyright © 2017年 bwayCW. All rights reserved.
//

#import "ViewController.h"
#import "CustomAnnotationView.h"
#import "ImageAnnoTationView.h"
#define ZOOMLEVEL 14
@interface ViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>{  //地图、定位、检索代理
    BMKPointAnnotation* imagePointAnnotation;//系统标注
    BMKPointAnnotation* customPointAnnotation;//自定义标注
    NSMutableArray *imagePointArr;//默认view
    NSMutableArray *customPointArr;//自定义
    BOOL isSuccessLocation;//用来标识时候定位成功
    BMKAnnotationView *seleView;
}
//地理编码主类，用来查询、返回结果信息
@property (nonatomic, strong) BMKGeoCodeSearch *geocodesearch;
//地图反编码
@property (nonatomic, strong) BMKReverseGeoCodeOption *reverseGeocodeSearchOption;
//地图
@property (strong, nonatomic) BMKMapView *mapView;
//定位
@property (nonatomic, strong) BMKLocationService *locService;
@property (strong, nonatomic) IBOutlet UIView *customView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
}

/**
 初始化需要用到的功能
 */
- (void)setUp {
    self.mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [self.view addSubview:self.mapView];
    _mapView.delegate = self;// 此处记得不用的时候需要置nil，否则影响内存的释放
    _mapView.showsUserLocation = YES;//显示定位图层
    [_mapView setMapType:BMKMapTypeSatellite];/// 当前地图类型，可设定为标准地图、卫星地图
    //编码
    _locService = [[BMKLocationService alloc]init];
    _geocodesearch = [[BMKGeoCodeSearch alloc] init];
    _reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc] init];
    _locService.delegate = self;
    _geocodesearch.delegate = self;
    
   // 定位图层自定义样式参数
    BMKLocationViewDisplayParam *displayParam = [[BMKLocationViewDisplayParam alloc]init];
    displayParam.isRotateAngleValid = true;//跟随态旋转角度是否生效
    displayParam.isAccuracyCircleShow = false;//精度圈是否显示
    displayParam.locationViewOffsetX = 0;//定位偏移量(经度)
    displayParam.locationViewOffsetY = 0;//定位偏移量（纬度）
    [_mapView updateLocationViewWithParam:displayParam];
    [self startLocation];
}

/**
 随机模拟数据
 */
- (void)getShowData:(CLLocationCoordinate2D)coor {
    imagePointArr = [NSMutableArray array];
    customPointArr = [NSMutableArray array];
    NSMutableArray *dataArr = [NSMutableArray array];
    for (int i = 0; i < 20; i++) {
        double lat =  (arc4random() % 100) * 0.001f;
        double lon =  (arc4random() % 100) * 0.001f;
        //为了保证数据一样，所以用数组将随机产生的将纬度存起来
        CLLocationCoordinate2D coorrr = CLLocationCoordinate2DMake(coor.latitude + lat, coor.longitude + lon);
        NSDictionary *latLonDic = @{@"lat":[NSString stringWithFormat:@"%f",coorrr.latitude],@"lon":[NSString stringWithFormat:@"%f",coorrr.longitude]};
        [dataArr addObject:latLonDic];
        customPointAnnotation = [[BMKPointAnnotation alloc] init];
        customPointAnnotation.coordinate = coorrr;
        customPointAnnotation.title = [NSString stringWithFormat:@"%d",i];
        [customPointArr addObject:customPointAnnotation];
        [_mapView addAnnotation:customPointAnnotation];
        BMKAnnotationView *detailView = [_mapView viewForAnnotation:customPointAnnotation];
        detailView.tag = 20000 + i;
        
    }
    //用两个for循环是为了保证自定义的annotion点在最下面，(先添加的点在地图最下方，安卓有一个属性可以设置覆盖物层级关系，但是ios目前还没有这个属性)
    for (int i = 0; i < 20; i++) {
        CLLocationCoordinate2D coorrr = CLLocationCoordinate2DMake([dataArr[i][@"lat"]doubleValue], [dataArr[i][@"lon"]doubleValue]);
        imagePointAnnotation = [[BMKPointAnnotation alloc] init];
        imagePointAnnotation.coordinate = coorrr;
        imagePointAnnotation.title = [NSString stringWithFormat:@"%d",i];
        [imagePointArr addObject:imagePointAnnotation];
        [_mapView addAnnotation:imagePointAnnotation];
         BMKAnnotationView* aview = [_mapView viewForAnnotation:imagePointAnnotation];
        aview.tag = 10000+i;
    }
    
    
}


/**
 自定义view点击事件

 */
- (IBAction)customViewClick:(UIButton *)sender {
    NSLog(@"我被点击了");
    [self popVC];
}

- (void)popVC {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"我被点击了" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVC addAction:action];
    [self presentViewController:alertVC animated:YES completion:nil];
}


#pragma mark - mapView,location,delegate

/**
 开始定位
 */
- (void)startLocation {
    NSLog(@"进入普通定位态");
    [_locService startUserLocationService];
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
}
/**
 *在地图View将要启动定位时，会调用此函数
 */
- (void)willStartLocatingUser
{
    NSLog(@"start locate");
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
    
    NSLog(@"heading is %@",userLocation.heading);
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [_mapView updateLocationData:userLocation];
    _reverseGeocodeSearchOption.reverseGeoPoint = userLocation.location.coordinate;
    BOOL flag = [_geocodesearch reverseGeoCode:_reverseGeocodeSearchOption];
    if(flag){
        NSLog(@"反geo检索发送成功");
        CLLocationCoordinate2D coord;
        coord.latitude=userLocation.location.coordinate.latitude;
        coord.longitude=userLocation.location.coordinate.longitude;
        [self getShowData:coord];
        
        BMKCoordinateRegion region ;//表示范围的结构体
        region.center = coord;//指定地图中心点
        region.span.latitudeDelta = 0.1;//经度范围（设置为0.1表示显示范围为0.2的纬度范围）
        region.span.longitudeDelta = 0.1;//纬度范围
        [_mapView setRegion:region animated:YES];
        [_locService stopUserLocationService];
    }else{
        NSLog(@"反geo检索发送失败");
//        [self startLocation];
    }
}
/**
 *在地图View停止定位后，会调用此函数
 
 */
- (void)didStopLocatingUser
{
    NSLog(@"stop locate");
}
/**
 *定位失败后，会调用此函数
 
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
}

#pragma mark -------------地理反编码的delegate---------------

-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    NSLog(@"address:%@----%@",result.addressDetail,result.address);
    //  addressDetail:     层次化地址信息
    //  address:    地址名称
    //  businessCircle:  商圈名称
    //  location:  地址坐标
    //  poiList:   地址周边POI信息，成员类型为BMKPoiInfo
    NSLog(@"地址名称：%@, 商圈名称:%@",result.address,result.businessCircle);
    if (error == 0) {//检索结果正常返回
        //code
        isSuccessLocation = YES;
    }
}



#pragma mark 点击 地图 锚点
-(void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view {
    if (view.tag >= 10000 && view.tag < 20000) {
        seleView = view;
        [[NSBundle mainBundle] loadNibNamed:@"PredictView" owner:self options:nil];
        UIView *areaPaoView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 242, 125)];
        self.customView.frame = CGRectMake(90, 0, 142, 120);
        [areaPaoView addSubview:self.customView];
        BMKActionPaopaoView *paopao=[[BMKActionPaopaoView alloc]initWithCustomView:areaPaoView];
        view.paopaoView.hidden = YES;
        if (mapView.zoomLevel > ZOOMLEVEL) {
            
            return;
        }else {
            view.paopaoView = paopao;
        }
        
        
    
    }else if (view.tag >= 20000 && view.tag < 30000) {
        if (mapView.zoomLevel < ZOOMLEVEL) {//此时自定义标注为隐藏状态,但是仍然可以相应点击事件,所以将其屏蔽
            return;
        }
        [self popVC];
    }
}
/**
 重写BMKAnnotationView
 
 @param mapView 当前map
 @param annotation 自定义的view
 @return 自定义的view
 */
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation {
    if (annotation == imagePointAnnotation) {
        NSString *AnnotationViewID = @"imageMark";
        
          ImageAnnoTationView *annotationView = [[ImageAnnoTationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
            // 设置颜色
//            annotationView.pinColor = BMKPinAnnotationColorPurple;
            // 从天上掉下效果
            annotationView.annimage = [UIImage imageNamed:@"地灾点.png"];
//            annotationView.animatesDrop = YES;
        
        return annotationView;
    }else if (annotation == customPointAnnotation) {
        [[NSBundle mainBundle] loadNibNamed:@"PredictView" owner:self options:nil];
        self.customView.frame = CGRectMake(0, 0, 142, 120);
        self.customView.tag = 111222333;//设置一个tag值方便后面显示隐藏调用
        CustomAnnotationView *customAnnotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomID" customView:self.customView];//将你需要自定义的view传给他自己的初始化方法
        return customAnnotationView;
    }
    return nil;
}
/**
 *地图渲染每一帧画面过程中，以及每次需要重绘地图时（例如添加覆盖物）都会调用此接口
 *@param mapView 地图View
 *@param status 此时地图的状态
 */
- (void)mapView:(BMKMapView *)mapView onDrawMapFrame:(BMKMapStatus *)status {
   
    NSLog(@"%f",mapView.zoomLevel);
    if (mapView.zoomLevel > ZOOMLEVEL) {
        if (!isSuccessLocation) {//地图在定位过程中zoomlevel波动较大，所以在定位成功后用isSuccessLocation来标记
            for (BMKPointAnnotation *ann in customPointArr) {
                BMKAnnotationView* annView = [_mapView viewForAnnotation:ann];
                UIView *view = [annView viewWithTag:111222333];
                [view setHidden:NO];
                
            }
            //防止在地图放大之前用户已经选中某个点了
            [mapView deselectAnnotation:seleView.annotation animated:YES];
            isSuccessLocation = YES;//避免地图放大过程中频繁调用此方法，所以在zoomlevel大于ZOOMLEVEL后就一直显示自定义view
        }
    }else {
        if (isSuccessLocation) {
            for (BMKPointAnnotation *ann in customPointArr) {
                BMKAnnotationView* annView = [_mapView viewForAnnotation:ann];
                UIView *view = [annView viewWithTag:111222333];
                [view setHidden:YES];
                
            }
            isSuccessLocation = NO;
            
        }

    }
    
}

- (void)dealloc {
    if (_mapView) {
        _mapView = nil;
    }
}









@end































