# SleepDetection


## Notebooks

- Merge_PA_SleepScores.ipynb: merges raw accelerometer data with sleep scores.
- featureGeneration.ipynb: based on merged_data generated features for 30 second epochs and stores features, targets and timestamps in separate h5 files.
- Merge_ArousalScores.ipynb: updates the target data (obtained through featureGeneration.ipynb) to also include arousal labels. Saves the new target values as a h5 file.
- supervisedLearningMethods.ipynb: trains and tests binary sleep/wake decision tree, random forest and XGBoost classifiers using data from featureGeneration.ipynb.
- arousalClassification.ipynb: trains and tests multiclass sleep/wake/arousal decision tree, random forest and XGBoost classifiers using data from featureGeneration.ipynb.
- coMultiview.ipynb: trains and tests a co-training with multi-view method for binary sleep/wake classification.
- coSingleview.ipynb: trains and tests a co-training with single-view method for binary sleep/wake classification.
- supervisedMultiview.ipynb: trains and tests a supervised multi-view method for binary sleep/wake classification.
- supervisedMultiviewClustering.ipynb: trains and tests a supervised multi-view with clustering method for binary sleep/wake classification.



## Data Fromat 

- Raw accelerometer data: should include x-, y-, and z-values with timestamps from two tri-axial accelerometer sensors. Should be stored as a h5 file in a sequence based on timestamps.

## Scripts 

The `scripts` folder contains a couple of utility scripts.
For default behavior, it should be sufficient to execute them as-is, with no special environment variables or arguments.

### docker-build.sh

The `docker-build.sh` scripts is a convenience script for building the docker image. 
By default, the docker image will be built with a tag prefixed by the current user's username (e.g. `john/sleep`)

Arguments:
 - `-u | --user`: Alternatively specify a different username 
 
### docker-entrypoint.sh 

This script is called whenever a docker container is created from the docker image.
Consequently, **the user should never call the script manually**.
It checks for a special environment variable called "USER_ID", and if it is set, it will:

1. Create a new user inside the freshly spawned container with user id equal to the provided value 
1. Set ownership of the `/hunt4_sleep/user`, `/hunt4_sleep/notebooks`, and `/usr/local` folders to the new user 
1. Change user to the newly created user and execute the container startup command as normal

This script allows the container to be executed with a custom user that is specified at runtime. 
Its purpose is to allow the container to be run as a user on the host system (as opposed to the default root user), which makes it so that files written will be owned by the user executing the container and not the root.
The only alternative solution currently known to the author is to either create the user at image build time or to chown files (by userid) before killing the container.

**This is a hack**. Any suggestions to how it could be done in a cleaner way is welcome.

### docker-run.sh

Convenience shell script for running the container.
By default, it will execute a container based on an imagename prefixed by the current user's username (e.g. `john/sleep`).
It will also mount the hunt4 data sources used (in read-only mode) to `hunt4_sleep/data/labelled` and `hunt4_sleep/data/semi_supervised`, and mount the `./user` folder to `/hunt4_sleep/user`.
Finally, it will pass the current users userid (as given by `id -u`) to the container through the `USER_ID` environment variable, which in turn should make the container run as if it was executed by the current user (see `docker-entrypoint.sh`)

Arguments:
- `-i | --image [image]` specify a different image name than the default `<username>/sleep`
- `-d | --dir-user [path]` specify a different mount point for persistent user data than the default `./user`
- `--mount-notebooks` mount the `./notebooks` folder so that any changes will be saved after the container has finished
- `--as-root` run the container as the root user (by not setting the `USER_ID` env variable)

### ssh-connect.sh

Convenience script for running the notebook server remotely.

By default it will:

1. Query for your `<username>` at idi's Samuel01 machine 
1. Establish an ssh connection with port-forwarding 8888:localhost:????
1. Spawn a container from image with name `<username>/sleep`
1. Mount the folder `lhome/<username>/hun4_sleep_user` into `/hunt4_sleep_user`
1. Launch a jupyter notebook (default command) in the container 

If everything works out, you should now be able to access the notebook from your local machine's web-browser on `localhost:8888`.
Foreseeable errors that could occurr with this script includes:

- You do not have a user on idi's Samuel01, in which case the ssh connection will fail 
- You are not part of the docker-group on Samuel01, in which case the container will refuse to start
- The image `<username>/sleep` has not been built yet, in which case the container cannot start
- The port 8888 is already taken by another application on you machine 

Arguments:
- `-u | --user [username]` specify username so the script don't have to query you for it
- `-d | --dir-user [path]` mount a different user dir than `/lhome/<username>/hunt4_sleep_user
- `-p | --port [port]` use a different local port for the ssh forwarding than the default 8888
- `-r | --remote-port [port]` use a specific port on the remote machine (default is random number > 20k)
- `-i | --image [image]` use a different docker image than the default `<username>/sleep`


### fix_notebook_paths.py

Utility script that changes hardcoded windows paths in notebooks into relative paths.
The only reason it exists is because the notebooks in the repository this repository is forked from contained several hardcoded, absolute windows paths such as `D:/path`.
The notebooks included in this repository has already been preprocessed by this script, so you probably don't have to ever call it.
