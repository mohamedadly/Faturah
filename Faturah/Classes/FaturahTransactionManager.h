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

typedef NS_ENUM(NSInteger, FaturahPaymentStatus)
{
    FaturahPaymentStatusCompleted,
    FaturahPaymentStatusPending,
    FaturahPaymentStatusFailed,
    FaturahPaymentStatusCanceled
};


@protocol FaturahTransactionManagerDelegate <NSObject>

@required
- (void) transactionManagerDidFinishTransactionPreparation:(FaturahTransaction*) transaction withError:(NSError*) error;
- (void) transactionManagerDidFinishPaymentWithStatus:(FaturahPaymentStatus) status andError:(NSError*)error;

@end

@interface FaturahTransactionManager : NSObject

//shared instance
+ (instancetype)sharedManager;


//transaction
- (void) prepareTranscation:(FaturahTransaction*) aTransaction withDelegate:(id<FaturahTransactionManagerDelegate>) aDelegate;
- (void) startPayementForTransaction:(FaturahTransaction*) aTransaction fromViewController:(UIViewController*) aviewController withDelegate:(id<FaturahTransactionManagerDelegate>) aDelegate;

//response handler
- (BOOL) openURL:(NSURL*)url;

@end

#endif