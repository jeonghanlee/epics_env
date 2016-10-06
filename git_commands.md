
### How to build the BASE and its modules
* Start again from scratch

```
jhlee@kaffee:~/epics_env (master)$ git submodule deinit -f .
jhlee@kaffee:~/epics_env (master)$ git submodule init
jhlee@kaffee:~/epics_env (master)$ git submodule update
```

* Set the desired version of BASE and its modules
```
jhlee@kaffee:~/epics_env (master)$ bash epics_env_setup.bash 

>>>> You are entering in : git_selection
 0: git src                             master
 1: git src                          R3.16.0.1
 2: git src                        R3.15.4-rc1
 3: git src                       R3.15.4-pre1
 4: git src                            R3.15.4
 5: git src                        R3.15.3-rc1
 6: git src                       R3.15.3-pre1
 7: git src                            R3.15.3
 8: git src                        R3.15.2-rc1
 9: git src                       R3.15.2-pre1
10: git src                            R3.15.2
Select master or one of tags which can be built, followed by [ENTER]:4

[ENTER]
```

* make them.. all..

```
jhlee@kaffee:~/epics_env (master)$ make
```

