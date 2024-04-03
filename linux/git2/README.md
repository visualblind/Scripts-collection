# git2

Ever wanted to handle multiple git repositories in one single directory? For example, if you deploy a software with git, you may not want to add the configuration into that repository.

Our idea: Just initialise a second git repository in the same directory and call it `.git2`.

## Usage

Use `git2` just like `git`.

For example, init a new repository:

```sh
git2 init .
```

Use `git2 add`, `git2 commit` and all other commands you known.

The ``.gitignore`` and ``.gitattribute`` files for the second git repository are named ``.gitignore_git2`` and ``.gitiattributes_git2``. When the git2 command is running, these files are renamed to their original names (without ``_git2``). So to add ``.gitignore_git2`` just run ``git add .gitignore``.

You can clone an repository as git2-repository in an existing (and non empty) directory:
```sh
git2 clone REPO .
```


### Addional commands

<table>
  <thead>
  <tr>
    <th>Option</th>
    <th>Description</th>
  </tr>
  </thead>
  <tbody>
  <tr>
    <td><code>git2</code></td>
    <td>Get current git2 base dir information.</td>
  </tr>
  <tr>
    <td><code>git2 setup-exclude</code></td>
    <td>Add an exclude file in the first git repository (<code>.git/info/exclude</code>) with the files of the second git repository.</td>
  </tr>
  <tr>
    <td><code>git2 swap-git2</code></td>
    <td>Swap .git and .git2 repositories.</td>
  </tr>
  <tr>
    <td><code>git2 help</code></td>
    <td>Help dialog with git2 commands.</td>
  </tr>
  </tbody>
</table>

These sub commands are individuell script files named `git2-SUBCOMMAND`.

## Options

* Environment variable `GITTWO_DIRNAME`:  
  Directory name and acronym for the current (second) git repository. Default: `.git2`.  
  See file `git3` for an example.

## How it works

First, git2 tries to locate the git2 `.git2` repository.
Following the script exchanges the .gitignore and .gitattribute files.
After that it executes the real git command (with a custom GIT_DIR and GIT_WORK_TREE environment configuration).
Finally, it reexchanges the dot git files.

To ignore files from the first git repository, all it's files are added to the `.git2/info/exclude` file.

