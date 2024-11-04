# ServerDeployUtility

### Setup:

1. Clone this repo:
```shell
git clone https://github.com/ej-you/ServerDeployUtility.git
```

2. Move into utility's directory:
```shell
cd ./ServerDeployUtility
```

3. Run installer:
```shell
bash ./manager.sh install
```

4. Check correct installation:
```shell
bash ./manager.sh status
# correct output:
# ServerDeployUtility status: installed
```

### Usage:
> **deploy** **[ run** _[custom_script]_ _[-v | --verbose]_ **]** | **[status]** | **[set-config]** | **[add]** | **[logs]** | **[-h | --help]**


### Description:

> _**!!! Pay attention, please**_ <br>
> To use `deploy utility` you need to configured project dir. Use `deploy set-config`.
Project dir is directory from which `deploy utility` will start all deploy scripts

> If you want to add new custom script use `deploy add`.

> _**!!! Pay attention, please**_ <br>
> If actions from custom script must execute in the directory other than project dir, use `cd` instruction in your custom script

> All important paths and variables you can see using `deploy status`


### Options and Arguments:

| option/argument     | description                                                                   |
|---------------------|-------------------------------------------------------------------------------|
| run _custom_script_ | Run your custom script from `custom_scripts` subdir                           |
| run                 | Run default script using your configurated project dir                        |
| -v, --verbose       | Show detailed output for command `run`                                        |
| status              | Show detailed status of `deploy utility`                                      |
| add                 | Add custom script using utility's interactive mode                            |
| set-config          | Configure project dir for run default script using utility's interactive mode |
| logs                | Show all "deploy utility" logs                                                |
| -h, --help          | Show help message                                                             |

### Examples:

#### Run `default script` using detailed output:
```shell
deploy run -v
```
#### Run script `project.sh` from `custom_scripts` subdir:
```shell
deploy run project
```
#### Show detailed status of `deploy utility`:
```shell
deploy status
```
#### Start interactive mode for configure `project dir`:
```shell
deploy set-config
```
#### Start interactive mode for adding `custom script`:
```shell
deploy add
```
