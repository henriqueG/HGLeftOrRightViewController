# HGLeftOrRightViewController

# How to use?
Just drop the HGLeftOrRightViewController.h and .m into your project.

1. It supports xib and storyboards. (so you can connect delegate and data source directly)

2. Cell changes are simple. Just change the layout in HGViewCell.xib. HGLeftOrRightViewController.m contains the HGViewCell class, so you can customize the entire cell class. 

3. HGLeftOrRightViewController uses AutoLayout to put the cells in the middle.

4. Use all Data Source methods to populate the HGLoRViewController. (It is easier and works almost like the UITableView)

  1. `-(NSInteger)numberOfItemsInLeftOrRightView:(HGLeftOrRightViewController*)lorView;`

  2. `-(HGViewCell*)leftOrRightView:(HGLeftOrRightViewController*)lorView cellForItemAtIndexPath:(NSIndexPath*)indexPath;`

  3. `-(CGSize)cellSizeOfleftOrRightView:(HGLeftOrRightViewController*)lorView;`

  4. `-(NSInteger)numberOfItemsToPreLoadInLeftOrRightView:(HGLeftOrRightViewController*)lorView;`


![alt tag](https://github.com/henriqueG/HGLeftOrRightViewController/blob/master/SS2.png)
 

# License
HGLeftOrRightViewController is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.
