# Overview
This showcases a bug affecting NSFileManager over NFS and potentially other mount point sources.
We are using only **NSFileManager** with its **copyPath** method.
It showcases **data-loss**, which may affect other types of file operations, such as moving files.

By default, it will copy the directory (and its contents) from `./testitems` to a user-specified output directory.
Specify the output directory with `-o`, a success should look something like this:
```
eukara@m75q:~/Desktop/gnustep/testcase$ ./NSFileManagerBug -o "$HOME/Desktop/gnustep/testcase/woop/"
2024-11-02 12:30:57.475 NSFileManagerBug[7521:7521] fileManager copyPath from ./testitems to /Users/eukara/Desktop/gnustep/testcase/woop/ status: 1
```
Note the **status 1** on success.

When a failure to move occurs, it will report **status 0**:
```
eukara@m75q:~/Desktop/gnustep/testcase$ ./NSFileManagerBug -o "/Net/Gateway/Users/Marco/woo/"
2024-11-02 12:30:38.169 NSFileManagerBug[7517:7517] fileManager copyPath from ./testitems to /Net/Gateway/Users/Marco/woo/ status: 0
```
In the above example, we attempted to copy `./testitems` to a remote location, mounted via NFS.
Despite success status being `0`, it will still create the `woo` directory as specified in the parameter. **(!!!)**
However, you will find no items will have been transfered from within `./testitems` to the output directory. **(!!!)**

# Test Conditions

In the second (failure) example, we copied to an NFS export with the options `(rw,async,no_subtree_check,all_squash,anonuid=1003,anongid=100)` located under `/Net/Gateway/`

## Speculative Territory:

Due to the `all_squash` option, and emulation of user id `1003` (owner of the directory on the server side) some lower level permissions check within NSFileManager may fail.
If that is the case, NSFileManager is making assumptions about the success based on whether or not permissions match.
NSFileManager will first create the output directory, and then most likely change attributes of it. It may not comprehend that despite differing user IDs, it would still succeed in doing so because the server guarantees it (user id emulation, all_squash).
Instead the operation errors out, despite leaving us with an (empty) directory being successfully created.

# Affected Applications
https://github.com/gnustep/apps-gworkspace GWorkspace makes use of NSFileManager, and moving folders will result in data loss when doing so over our setup above.
https://github.com/gnustep/gap StepSync makes use of NSFileManager, it's a graphical, rsync type application and it will also fail to recursively copy directories over NFS setups like above.

# See also
https://github.com/gnustep/libs-base/issues/452
