//
//  FLGLibraryTableViewController.m
//  HackerBooksAdvanced
//
//  Created by Javi Alzueta on 15/4/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#import "FLGLibraryTableViewController.h"
#import "FLGBook.h"
#import "FLGAuthor.h"

@interface FLGLibraryTableViewController ()

@end

@implementation FLGLibraryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table DataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // Averiguar cual es la libreta
    FLGBook *b = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    // Crear una celda
    static NSString *cellId = @"bookCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    
    // Configurarla: sincronizar libreta->celda
    cell.textLabel.text = b.title;
    NSString *authorsString = @"";
    for (FLGAuthor *author in b.authors) {
        authorsString = [NSString stringWithFormat:@"%@%@, ", authorsString, author.name];
    }
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", authorsString];
    
    //Devolverla
    return cell;
}

@end
