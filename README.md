## Prerequisites

You will need `docker` and `wget`. If you are using Linux, we recommend that you add your user to the `docker` group so that using `docker` doesn’t require sudo access. You can find the instructions [here](https://docs.docker.com/engine/install/linux-postinstall/).

Clone the repo at https://github.com/KenSukiVN/KenZNode-Guides: 

```bash
git clone [https://github.com/KenSukiVN/KenZNode-Guides](https://github.com/KenSukiVN/KenZNode-Guides)
cd KenZNode-Guides/tangle
```


## Setup and running

Once inside the `tangle` folder, run:

```bash
bash run.sh
```

It might take quite some time before you actually get the node running: the script will first download required files. The script will then run the node for you and you should start seeing some block-related output.