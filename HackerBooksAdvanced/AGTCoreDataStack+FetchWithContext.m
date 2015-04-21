//
//  AGTCoreDataStack+FetchWithContext.m
//  HackerBooksAdvanced
//
//  Created by Javi Alzueta on 20/4/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#import "AGTCoreDataStack+FetchWithContext.h"

@implementation AGTCoreDataStack (FetchWithContext)

+(NSArray *) executeFetchRequest:(NSFetchRequest *)req
                         context:(NSManagedObjectContext *) context
                      errorBlock:(void(^)(NSError *error)) errorBlock{
    
    NSError *err;
    NSArray *res = [context executeFetchRequest:req
                                          error:&err];
    
    if (res == nil) {
        // la cagamos
        if (errorBlock != nil) {
            errorBlock(err);
        }
        
    }
    return res;
}

@end
