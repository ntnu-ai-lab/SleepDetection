# SleepDetection


File descriptions (ipynb):

- Merge_PA_SleepScores.ipynb: merges raw accelerometer data with sleep scores (labels). The raw data must be loaded from a h5 file where each data point should be stored in sequence based on timestamp. 
- featureGeneration.ipynb: based on merged_data generated features for 30 second epochs and stores features, targets and timestamps in separate h5 files.
- Merge_ArousalScores.ipynb: updates the target data (obtained through featureGeneration.ipynb) to also include arousal labels. Saves the new target values as a h5 file.
- supervisedLearningMethods.ipynb: trains and tests binary sleep/wake decision tree, random forest and XGBoost classifiers using data from featureGeneration.ipynb.
- arousalClassification.ipynb: trains and tests multiclass sleep/wake/arousal decision tree, random forest and XGBoost classifiers using data from featureGeneration.ipynb.
- coMultiview.ipynb: trains and tests a co-training with multi-view method for binary sleep/wake classification.
- coSingleview.ipynb: trains and tests a co-training with single-view method for binary sleep/wake classification.
- supervisedMultiview.ipynb: trains and tests a supervised multi-view method for binary sleep/wake classification.
- supervisedMultiviewClustering.ipynb: trains and tests a supervised multi-view with clustering method for binary sleep/wake classification.
