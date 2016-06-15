//
//  FaturahTransactionManager.h
//  Pods
//
//  Created by Mohamed Adly on 6/14/16.
//
//

#import <Foundation/Foundation.h>

@interface FaturahTransactionManager : NSObject

//shared instance
+ (instancetype)sharedManager;


- (void)generateToken;

@end
