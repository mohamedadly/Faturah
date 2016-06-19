//
//  FaturahTransaction.h
//  Pods
//
//  Created by Mohamed Adly on 6/14/16.
//
//

#ifndef FaturahTransaction_h
#define FaturahTransaction_h

#import <Foundation/Foundation.h>
#import "FaturahOrder.h"

@interface FaturahTransaction : NSObject

//transaction properties
@property (nonatomic, strong) NSString* merchantCode;
@property (nonatomic, strong) NSString* secureKey;
@property (nonatomic, strong) NSString* token;
@property (nonatomic, strong) FaturahOrder* order;
@property (nonatomic, strong) NSString* message;
@property (nonatomic, strong) NSString* secureHash;
@property (nonatomic) BOOL isSecureMerchant;
@property (nonatomic, strong) NSString* urlScheme;

@end

#endif