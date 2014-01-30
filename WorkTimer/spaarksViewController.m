//
//  spaarksViewController.m
//  WorkTimer
//
//  Created by martin steel on 13/01/2014.
//  Copyright (c) 2014 martin steel. All rights reserved.
//

#import "spaarksViewController.h"

@interface spaarksViewController ()

@end

@implementation spaarksViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
}




-(NSInteger)numberOfSectionsInTableView: (UITableView *)tableview
{
    return 1;
}


-(NSInteger)tableview:(UITableView *)tableview numberOfRowsInSection:(NSInteger)section
{
    return 30;
}


-(UITableViewCell *)tableview:(UITableView *)tableview cellforRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:@"MainCell"];
    
    if(cell == nil)
    {
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: @"MainCell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"Index row of this cell: %d", indexPath.row];
    return cell;
    
}
 

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
