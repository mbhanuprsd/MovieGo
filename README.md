# MovieGo

Instruction to add secret keys in Travis CI:
$ tar cvf secrets.tar foo.file bar.file
$ travis encrypt-file secrets.tar --add
$ vi .travis.yml
$ git add secrets.tar.enc .travis.yml
$ git commit -m 'use secret archive'
$ git push

Link check for Travis file:
http://www.yamllint.com/