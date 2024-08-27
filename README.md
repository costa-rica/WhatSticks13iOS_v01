
# What Sticks 13 iOS

![What Sticks Logo](https://what-sticks.com/website_images/wsLogo180.png)

## Description
What Sticks 13 iOS uses data collected by Apple Health to provide users with insights on their sleep and exercise tendencies. This is done by calculating correlation statistics between sleep, exercise and weather metrics collected by the user’s iPhone.


## Features
- uses GPS location collection to determine the user’s weather.
- retrieves data from the user’s Apple Health Data.
- displays a table of the user’s correlations. 

## Details
This application connects with the [WhatSticks13Api](https://github.com/costa-rica/WhatSticks13Api).

The testing environment is on the web now [dev13.what-sticks.com](https://dev13.what-sticks.com).

## Issues:
1. 2024-08-26: we do not delete UserLocations from the device. The API removes dates already collected so it is not an a calculation issue, it is simply a carrying more data than we need. After we know location collection is being done properly we can start looking into deleting the UserDefault for arryUserLocation once the data is sent. Also the LocationFetcher.arryUserLocation property will need to deleted to a clean slate.



## Contributing
The What Sticks project is open source and we welcome contributors.

For any queries or suggestions, please contact us at nrodrig1@gmail.com.
