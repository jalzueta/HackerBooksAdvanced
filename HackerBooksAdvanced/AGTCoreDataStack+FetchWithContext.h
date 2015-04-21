//
//  AGTCoreDataStack+FetchWithContext.h
//  HackerBooksAdvanced
//
//  Created by Javi Alzueta on 20/4/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#import "AGTCoreDataStack.h"

@interface AGTCoreDataStack (FetchWithContext)

+(NSArray *) executeFetchRequest:(NSFetchRequest *)req
                         context:(NSManagedObjectContext *) context
                      errorBlock:(void(^)(NSError *error)) errorBlock;

@end
