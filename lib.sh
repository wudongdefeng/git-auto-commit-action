#!/bin/bash

_switch_to_repository() {
    echo "INPUT_REPOSITORY value: $INPUT_REPOSITORY";
    cd $INPUT_REPOSITORY
}

_git_is_dirty() {
    echo "GIT IS DIRTY"
    [[ -n "$(git status -s)" ]]
}

# Set up .netrc file with GitHub credentials
_setup_git ( ) {
    echo "SETUP GIT"
  cat <<- EOF > $HOME/.netrc
        machine github.com
        login $GITHUB_ACTOR
        password $GITHUB_TOKEN

        machine api.github.com
        login $GITHUB_ACTOR
        password $GITHUB_TOKEN
EOF
    chmod 600 $HOME/.netrc

    git config --global user.email "actions@github.com"
    git config --global user.name "GitHub Actions"
}

_switch_to_branch() {
    echo "INPUT_BRANCH value: $INPUT_BRANCH";

    # Switch to branch from current Workflow run
    git switch -c $INPUT_BRANCH
    # git checkout $INPUT_BRANCH
}

_add_files() {
    echo "INPUT_FILE_PATTERN: ${INPUT_FILE_PATTERN}"
    git add "${INPUT_FILE_PATTERN}"
}

_local_commit() {
    echo "INPUT_COMMIT_OPTIONS: ${INPUT_COMMIT_OPTIONS}"
    git commit -m "$INPUT_COMMIT_MESSAGE" --author="$GITHUB_ACTOR <$GITHUB_ACTOR@users.noreply.github.com>" ${INPUT_COMMIT_OPTIONS:+"$INPUT_COMMIT_OPTIONS"}
}

_push_to_github() {
    echo "GITHUB_REPOSITORY: ${GITHUB_REPOSITORY}"
    git push --set-upstream https://github.com/${GITHUB_REPOSITORY} "HEAD:$INPUT_BRANCH"
}
