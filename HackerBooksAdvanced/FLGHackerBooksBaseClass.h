//
//  FLGHackerBooksBaseClass.h
//  HackerBooksAdvanced
//
//  Created by Javi Alzueta on q7/4/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

@import CoreData;

@interface FLGHackerBooksBaseClass : NSManagedObject

// Para hacerla la clase base para Mogeneratorejecutar en linea de comandos:
// mogenerator -v2 -m Model.xcdatamodeld/Model.xcdatamodel/ --base-class AGTEverpobreBaseClass

+ (NSArray *) observableKeys;

@end
