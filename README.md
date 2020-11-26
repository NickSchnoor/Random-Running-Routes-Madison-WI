# Random-Running-Routes-Madison-WI
MatLab script that creates a random running route of a chosen distance in Madison, WI using roads I like to run on.

## Required Files
Run Nodes.kmz--Latitude and Longitude of intersections on my favorite running routes
Random Run Distances.xlsx--Distances between connected intersections in Madison
RandomRunGenerator.m--MatLab script that creates the random route

## Instructions:
1. Save Required files into a folder
2. Make sure MatLab is version 2020b or later and that the Mapping Toolbox and Statistics Toolbox are installed
3. Open RandomRunGenerator.m
4. Create a distance range you want to make a route in. Maximum distance in Line 3, Minimum distance in Line 4
5. Get longitude and latitude of your starting/stopping point. Put in Lines 6 and 7.
6. Hit Run

## Output:
A map of the randomly generated route should pop up as a figure with all imported intersections marked as well.  The route should be color-directioned: red->orange->yellow->green->blue->purple->red. The marked route connects the randomly selected intersections with straight lines. Sometimes these lines aren't on actual roads/trails. In these cases, soute interpolation is required.  The distance for these (and all) connections was calculated using the most direct road/trail route and it is advised to stick to this most direct option to avoid incorrect distances or getting lost.

## Customization
Feel free to add intersections and roads to this project, or to adapt the method for a different city. To do so, important intersections can be located with Google Earth's Pin tool and included in the Run Distances.kmz file.  Connections to these additional intersections should be measured with Google Earth path drawing tool and recorded in miles in the next column on the Random Run Distances.xlsx spreadsheet. The row that this measurement is recorded in should correlate with the name of the old intersection that is being connected with the new one. There will be a lot of empty cells in this column.  From here, any specific intersections referred to in the MatLab script can be edited to include the new intersections as well. ie new intersections that has only one connection to the rest of the map should be included on Line 55 (ie Picnic Point (already mapped)).
