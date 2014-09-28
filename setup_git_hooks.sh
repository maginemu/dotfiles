mkdir -p ~/.git_template/hooks
cp /Library/Developer/CommandLineTools/usr/share/git-core/templates/hooks/* ~/.git_template/hooks

cat  <<EOF > ~/.git_template/hooks/pre-commit
#!/bin/sh
if [ "`git config user.name`" == SET_ME_LOCALLY ]; then
    echo "fatal: user.name is not set locally"
    exit 1
fi
if [ "`git config user.email`" == SET_ME_LOCALLY ]; then
    echo "fatal: user.email is not set locally"
    exit 1
fi
EOF
chmod 755 ~/.git_template/hooks/pre-commit

git config --global init.templatedir '~/.git_template'
