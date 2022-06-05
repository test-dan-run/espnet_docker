# ESPNet Dockerised

## Getting Started

### Choice 1: Pull the docker image from Docker Hub
I have already prebuilt the docker image and uploaded onto Docker Hub (omg it took 3 hours to upload), so it should work out of the box. 
```bash
docker pull dleongsh/espnet:202205-torch1.10-cu113-runtime
# if you wanna use tensorboard
docker pull dleongsh/tensorboard:latest
```

### Choice 2: Build the docker image
If for some reason the prebuilt image doesn't work (freakin espnet), build the image yourself here.
```
docker build -t dleongsh/espnet:202205-torch1.10-cu113-runtime .
```

## Running a Recipe

### Prep Work
Now the thing is that, while I would have liked to have the espnet repository locally so we can conveniently edit the scripts, it would have required a lot of dependencies pre-installed, and the symbolic links are everywhere and messy, I don't wanna risk a broken espnet installation. 

We're gonna hack our way thru. Look at the mount folder for an example, which will be mounting onto the espnet docker container.

Inside `run.sh`, you will see the following script.

```
cd /workspace/espnet/egs2/mini_an4/asr1

./asr.sh \
    --lang en \
    --train_set train_nodev \
    --valid_set train_dev \
    --test_sets "train_dev test test_seg" \
    --lm_train_text "data/train_nodev/text" "$@" \
    --lm_exp "/mount/exp/transformer/lm_exp" \
    --lm_stats_dir "/mount/exp/transformer/lm_stats" \
    --asr_exp "/mount/exp/transformer/asr_exp" \
    --asr_stats_dir "/mount/exp/transformer/asr_stats" \
    --asr_config "/mount/tuning/train_asr_transformer.yaml" \
    --inference_config "/mount/tuning/decode_transformer.yaml"
```
We will be using the `mini_an4` dataset, which is a small dataset, as a test. It worked for my machine, so I god hope it works for yours.
In the first line, we cd into the mini_an4/asr1 project, and run the ./asr.sh script from there. 

All the logs are stored in the `/workspace/espnet/egs2/mini_an4` folder by default. To conveniently look at the logs and have access to the weights, we will redirect them to our mount folder. The params you need to change are `--lm_exp`, `--lm_stats_dir`, `--asr_exp` and `--asr_stats_dir`.

Now assuming you wanna play around with different model architectures, you will need to *set up your own config files*, and let `./asr.sh` know where you find them. By default, the `mini_an4` experiment uses an RNN encoder and decoder. As a test, I swapped them out with transformers. The params for these are `--asr_config` (encoder) and `--inference_config` (decoder).

There are a bunch of other params that I haven't explored yet, like where to access your own data etc., so I will have to trouble you to explore this on your own. You can find the other `./asr.sh` parameters in the file [here](https://github.com/espnet/espnet/blob/master/egs2/TEMPLATE/asr1/asr.sh).

*NOTE:* Please remember to add '\' for each parameter you add, otherwise you will be running ./asr.sh with a few parameters missing.

### Running the docker-compose
Once all your prep work is done, hop over to the `docker-compose.yaml` file. 

1. You might need to change your input mounting directory. (might not be `/mnt/c/projects/espnet_docker/mount`, could be `/home/dan-is-cute/projects/pesnet_docker/mount` idk, don't judge) 

2. Next, once you're done, you can just run:

```bash
docker-compose up
```

3. To view the tensorboard, just go to [localhost:6006](localhost:6006) on your browser.

## That's It
Ye, that's it. If nothing works, let me know on telegram~

