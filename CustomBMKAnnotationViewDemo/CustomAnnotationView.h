//
//  CustomAnnotationView.h
//  CustomBMKAnnotationViewDemo
//
//  Created by wordtech on 17/3/16.
//  Copyright © 2017年 bwayCW. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKMapComponent.h>

@interface CustomAnnotationView : BMKAnnotationView
- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier customView:(UIView *)detailView;
@end
