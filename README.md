# bci-challange

## Reading data

In order to load the data such as `scratch.m` script does it, you need to have the following file structure:

```
sketch.R
utils/
   split_test_by_target.m
   ...
data/
   SBJ01/
      SBJ01/
        S01/
            Train/
              trainData.mat 
              trainEvents.txt
            Test/
                ...
        S02/
           ...
        S03/
           ...
   SBJ02/
    ...
```

Then (for given subject and session) you can simply call

```matlab
subj = '10';
session = '01';
data_load;
```

## Riemanian approach

Download and load `lib` folder from this package:
https://github.com/alexandrebarachant/covariancetoolbox

## Materials

http://www.medicon2019.org/scientific-challenge/

http://www.medicon2019.org/wp-content/uploads/ChallengeMediconDatasetDescription.pdf


