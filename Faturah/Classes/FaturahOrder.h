//
//  FaturahOrder.h
//  Pods
//
//  Created by Mohamed Adly on 6/14/16.
//
//

#import <Foundation/Foundation.h>
#import "FaturahOrderItem.h"

@interface FaturahOrder : NSObject

//order properties
@property (nonatomic, strong) NSNumber* orderDeliveryCharge;
@property (nonatomic, strong) NSNumber* orderTotalPrice;
@property (nonatomic, strong) NSString* orderCustomerName;
@property (nonatomic, strong) NSString* orderDate;
@property (nonatomic, strong) NSString* orderCustomerEmail;
@property (nonatomic, strong) NSString* orderCustomerPhone;
@property (nonatomic, strong) NSString* orderLanguage;

//items
@property (nonatomic, strong) NSMutableArray* orderItems;
@property (nonatomic, strong) NSMutableArray* orderItemsIDs;
@property (nonatomic, strong) NSMutableArray* orderItemsNames;
@property (nonatomic, strong) NSMutableArray* orderItemsDescriptions;
@property (nonatomic, strong) NSMutableArray* orderItemsQuantities;
@property (nonatomic, strong) NSMutableArray* orderItemsPrices;

//add item
- (void) addItem:(FaturahOrderItem *) aItem;

@end
