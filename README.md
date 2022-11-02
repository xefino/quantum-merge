# quantum-merge
This GitHub action pushes code in a given directory to a given remote repository based on a filter. This action is especially useful for repositories that generate code which should be pushed to other repositories (e.g. protobuf). This action will preserve commit authors and messages.

## Configuration

This action requires a number of arguments to work and some optional arguments to offer additional functionality.

### deploy-key

This action relies on the [webfactory/ssh-agent](https://github.com/webfactory/ssh-agent) action to authenticate with GitHub. In order for this to work, a deploy key has to be generated and stored in the destination repository, with the ID for this key stored in the source repository as a secret, which should be used for this argument. For more information, please see their documentation. This parameter is required.

### username

The username or organization name associated with the destination repository. This parameter is required.

### repository

The name of the desintation repository. This parameter is required.

### branch

The branch to which the code should be pushed. This parameter is not required, and if omitted, will assume a value of "main".

### directory

The source directory that should be merged with the destination repository. This parameter is required.

### filter

A filter to apply to files cloned from the destination repository before copying files from the source directory. This filter is intended to allow for file deletions to be propogated to the destination directory. This paramter will be injected into a find operation of the form `find {directory} -type f \( $filter \) -delete` so this parameter allows for fairly flexible file filtering. For more information on find, see this [blog post](https://math2001.github.io/article/bashs-find-command/).