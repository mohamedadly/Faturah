//
//  FaturahTransaction.h
//  Pods
//
//  Created by Mohamed Adly on 6/14/16.
//
//

#import <Foundation/Foundation.h>
#import "FaturahOrder.h"

@interface FaturahTransaction : NSObject

//transaction properties
@property (nonatomic, strong) NSString* merchantCode;
@property (nonatomic, strong) NSString* secureKey;
@property (nonatomic, strong) FaturahOrder* order;
@property (nonatomic, strong) NSString* token;
@property (nonatomic, strong) NSString* message;
@property (nonatomic, strong) NSString* hash;

@end