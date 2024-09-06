#!/bin/bash

generate_man_page() {
    cat << EOF
# deploy(1) - Automated deployment script

## NAME
deploy - Manage deployments and rollbacks for web applications

## SYNOPSIS
\`deploy [-k keep_releases] [-r git_repo] [-b git_branch] [-f git_folder] [-m] {deploy|rollback|man}\`

## DESCRIPTION
The \`deploy\` script automates the deployment and rollback process for web applications. It follows a release-based deployment strategy, managing multiple releases and shared resources.

## OPTIONS
* \`-k keep_releases\`: Specify the number of releases to keep (default: 5)
* \`-r git_repo\`: Specify the Git repository URL
* \`-b git_branch\`: Specify the Git branch to deploy
* \`-f git_folder\`: Specify a subfolder within the Git repository to deploy
* \`-m\`: Display this manual page
* \`deploy\`: Execute the deployment process
* \`rollback\`: Revert to the previous release
* \`man\`: Display this manual page

## DEPLOYMENT PROCESS
1. Creates the project structure
2. Clones the specified Git repository
3. Creates a new release
4. Copies shared files
5. Updates the 'current' symlink
6. Cleans up old releases
7. Runs the Makefile if present

## ROLLBACK PROCESS
Reverts the 'current' symlink to the previous release

## ENVIRONMENT
* \`PROJECT_ROOT\`: Root directory for the project (default: ./project)
* \`RELEASES_DIR\`: Directory for storing releases
* \`SHARED_DIR\`: Directory for shared resources
* \`CURRENT_LINK\`: Symlink pointing to the current release
* \`DEFAULT_KEEP_RELEASES\`: Default number of releases to keep
* \`GIT_REPO\`: Git repository URL
* \`GIT_BRANCH\`: Git branch to deploy
* \`GIT_FOLDER\`: Subfolder within the Git repository to deploy

## FILES
* \`.env\`: Environment configuration file (optional)
* \`Makefile\`: Build script in the deployed codebase (optional)

## EXIT STATUS
* 0: Success
* 1: Failure

## EXAMPLES
Deploy the application:
\`\`\`
./deploy.sh -k 3 -r https://github.com/user/repo.git -b main deploy
\`\`\`

Rollback to the previous release:
\`\`\`
./deploy.sh rollback
\`\`\`

Display the manual page:
\`\`\`
./deploy.sh -m
\`\`\`
or
\`\`\`
./deploy.sh man
\`\`\`

## AUTHORS
This script was created by an unknown author.

## SEE ALSO
git(1), make(1)
EOF
}