//
//  FaturahTransactionManager.h
//  Pods
//
//  Created by Mohamed Adly on 6/14/16.
//
//

#ifndef FaturahTransactionManager_h
#define FaturahTransactionManager_h

#import <Foundation/Foundation.h>
#import "FaturahTransaction.h"

@protocol FaturahTransactionManagerDelegate <NSObject>

@required
- (void) transactionManagerDidFinishTransactionPreparation:(FaturahTransaction*) transaction withError:(NSError*) error;

@end

@interface FaturahTransactionManager : NSObject

//shared instance
+ (instancetype)sharedManager;


//transaction
- (void) prepareTranscation:(FaturahTransaction*) aTransaction withDelegate:(id<FaturahTransactionManagerDelegate>) aDelegate;

@end

#endif