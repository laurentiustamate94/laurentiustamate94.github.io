#!/bin/bash

# only proceed script when started not by pull request (PR)
if [ $TRAVIS_PULL_REQUEST == "true" ]; then
  echo "this is PR, exiting"
  exit 0
fi

# enable error reporting to the console
set -e

# build site with jekyll, by default to `_site' folder
jekyll build

# cleanup
rm -rf ../laurentiustamate94.github.io.master/*

#clone `master' branch of the repository using encrypted GH_TOKEN for authentification
git clone https://${GH_TOKEN}@github.com/laurentiustamate94/laurentiustamate94.github.io.git ../laurentiustamate94.github.io.master

# copy generated HTML site to `master' branch
cp -Rf _site/* ../laurentiustamate94.github.io.master

# commit and push generated content to `master' branch
# since repository was cloned in write mode with token auth - we can push there
cd ../laurentiustamate94.github.io.master
git config user.email "laurentiu.stamate@outlook.com"
git config user.name "Laurentiu Stamate"
rm -rf Gemfile Gemfile.lock build.sh
git add -A .
git commit -m "$TRAVIS_COMMIT_MESSAGE"
git push --quiet origin master > /dev/null 2>&1 