# Quick start

To clone all the sub-projects:

```
$ install `mr` (`apt-get install mr`)
$ echo $(pwd)/.mrconfig >> ~/.mrtrust
$ mr checkout
```

To build packages:

```
$ make
```

To add a new subproject:

- edit `.mrconfig` and add a new section for the project (base it on the
  existing sections for the existing subprojects)
- add a new .spec.in file for the project in rpm/$PROJECT.spec.in
- edit `Makefile` and add the subproject name to the COMPONENTS variable right
  at the beginning of the file.
- that's all
