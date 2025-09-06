## To Use
- [ ] Cloud Run
- [ ] Cloud Run Function
- [ ] Network server and load balancer: practice follow the demos.

### Set up project at terminal
From local computer terminal:

```bash
# if not done so. Connect gcloud cli to google account. Follow the instructions
gcloud init

# list available project and ID
gcloud projects list

# set GCP project by ID
gcloud config set project file-backup-471312

# show current project 
gcloud config list
```

### Cloud storage
From GCP console
- create a project `file-backup` on Google Cloud console.
- create a bucket, for example, `gl-familiy` and select archive for lowest cost
    - can be created from terminal but better from consol for easy setting

From local computer terminal, copy a file to the bucket

```bash
# list storage buckets
gcloud storage buckets list

# copy a file to a bucket. The bucket name must be unique on GCP
gcloud storage cp xxx.zip gs://gl-familiy/

# copy a directory
gcloud storage cp -r dir_xxx gs:://bucket_name/
```


