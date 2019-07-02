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


## Dependencies

You need to add to your paths the following packages.

### Riemanian approach

Download and load `lib` folder from this package:
https://github.com/alexandrebarachant/covariancetoolbox

### Classification
Classification was done using ensemble implementation from the following package:
https://github.com/treder/MVPA-Light

## The best model

Our best models consists on combined ensemble approach with Riemanian features. Simplified steps are described below. For details, look at the code.

1. Make ensemble of features: different time windows size, different low-pass filters, subset of electrodes.
2. Create prototype (template) of the ERP response, as the trimmed mean over trials from single session of a participant.
3. Concatenate prototype with single trial signal.
4. Compute covariances (with shrinkage) and transform them to Riemanian space.
5. Calculate FGDA filters and perform geodesic filtering.
6. Take upper diagonal of resulting 2D features and train ensemble of LDA classifiers.
7. Perform cumulative probability vote per particular class (ERP or not).

To run the prediction of the best model, call simply: `createOutput.m`.

## Materials

http://www.medicon2019.org/scientific-challenge/

http://www.medicon2019.org/wp-content/uploads/ChallengeMediconDatasetDescription.pdf


