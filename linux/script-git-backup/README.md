# git-backup

Various scripts to backup git repositories

Create an own script using these backup scripts.
Run this script manually or use cron:

```sh
crontab -e
```
add for once a day:
```cron
0 5 * * * /home/user/bin/mybackup_script
```

## Example script


```sh
#!/bin/sh
# backup my git repositories

# backup gitolite
echo "#### HOST: gitolite.example.com"
backup-gitolite "git@gitolite.example.com" "backup_gitolite_example_com/"

# backup gitlab
echo "#### HOST: gitolab.example.com"
backup-gitlab "gitlab.example.com" "1234TOKENABC" "backup_gitlab_example_com/"

# backup github
echo "#### HOST: github.example.com"
backup-github simonwalz "backup_github_com/"
```

## Usage: backup-git-repo

Backup a git repository by its repository url:

```sh
backup-git-repo REPO_URL LOCAL_PATH
```

##### Options
<table>
  <thead>
  <tr>
    <th>Option</th>
    <th>Description</th>
  </tr>
  </thead>
  <tbody>
  <tr>
    <td><code>REPO_URL</code></td>
    <td>Full repository URL</td>
  </tr>
  <tr>
    <td><code>LOCAL_PATH</code></td>
    <td>Local directory to save the git repository in. Can be a bare or a non-bare repository. Creates a bare repository if directory does not exist.</td>
  </tr>
  </tbody>
</table>


## Usage: backup-github

Backup all public git repositories of a [GitHub](https://github.com) user:

```sh
backup-github GITHUB_USER LOCAL_PATH_PREFIX [EXCLUDE_REPOS]
```

##### Options

<table>
  <thead>
  <tr>
    <th>Option</th>
    <th>Description</th>
  </tr>
  </thead>
  <tbody>
  <tr>
    <td><code>GITHUB_USER</code></td>
    <td>Your GitHub username</td>
  </tr>
  <tr>
    <td><code>LOCAL_PATH_PREFIX</code></td>
    <td>Local directory prefix to save the git repositories in. If prefix ends on a `/` a separate directory is created.</td>
  </tr>
  <tr>
    <td><code>EXCLUDE_REPOS</code></td>
    <td>(optional) Repositories to ignore. Use an <a href="https://en.wikibooks.org/wiki/Regular_Expressions/POSIX-Extended_Regular_Expressions">extended regular expression</a> to match repositories. E.g. <code>'^Repo A$|^Repo B$'</td>
  </tr>
  </tbody>
</table>


## Usage: backup-gitlab

Backup all git repositories of a [GitLab](https://gitlab.com) user:

```sh
backup-gitlab GITLAB_HOST GITLAB_TOKEN LOCAL_PATH_PREFIX [EXCLUDE_REPOS] [GITLAB_HTTP_PROTO] [FETCH_PROTO] [GITLAB_USER] [CURL_OPTS]
```

##### Options

<table>
  <thead>
  <tr>
    <th>Option</th>
    <th>Description</th>
  </tr>
  </thead>
  <tbody>
  <tr>
    <td><code>GITLAB_HOST</code></td>
    <td>Pure hostname of the gitlab server. E.g. <code>gitlab.example.com</code></td>
  </tr>
  <tr>
    <td><code>GITLAB_TOKEN</code></td>
    <td>A GitLab API token. See <a href="https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html">GitLab Dokumentation</a></td>
  </tr>
  <tr>
    <td><code>LOCAL_PATH_PREFIX</code></td>
    <td>Local directory prefix to save the git repositories in. If prefix ends on a `/` a separate directory is created.</td>
  </tr>
  <tr>
    <td><code>EXCLUDE_REPOS</code></td>
    <td>(optional) Repositories to ignore. Use an <a href="https://en.wikibooks.org/wiki/Regular_Expressions/POSIX-Extended_Regular_Expressions">extended regular expression</a> to match repositories. E.g. <code>'^Repo A$|^Repo B$'</td>
  </tr>
  <tr>
    <td><code>GITLAB_HTTP_PROTO</code></td>
    <td>(optional) HTTP proto to use: <code>https</code> (default) or <code>http</code></td>
  </tr>
  <tr>
    <td><code>FETCH_PROTO</code></td>
    <td>(optional) Protocol to use for fetching the repositories: <code>ssh</code> (default), <code>https</code> or <code>http</code></td>
  </tr>
  <tr>
    <td><code>FETCH_USER</code></td>
    <td>(optional) Username to use for fetching the repositories.<br>Default for SSH: <code>git</code><br>Default for HTTP: <code>user</code></td>
  </tr>
  <tr>
    <td><code>CURL_OPTS</code></td>
    <td>(optional) Additional curl command line options. E.g. <code>'-u user:pass'</code> for an additional HTTP BASIC authentication</td>
  </tr>
  </tbody>
</table>


## Usage: backup-gitolite


Backup all git repositories of a [Gitolite](http://gitolite.com):

```sh
backup-gitolite GITOLITE_HOST LOCAL_PATH_PREFIX [EXCLUDE_REPOS]
```

##### Options

<table>
  <thead>
  <tr>
    <th>Option</th>
    <th>Description</th>
  </tr>
  </thead>
  <tbody>
  <tr>
    <td><code>GITOLITE_HOST</code></td>
    <td>Username and hostname of the gitolite server. E.g. <code>git@gitolite.example.com</code></td>
  </tr>
  <tr>
    <td><code>LOCAL_PATH_PREFIX</code></td>
    <td>Local directory prefix to save the git repositories in. If prefix ends on a `/` a separate directory is created.</td>
  </tr>
  <tr>
    <td><code>EXCLUDE_REPOS</code></td>
    <td>(optional) Repositories to ignore. Use an <a href="https://en.wikibooks.org/wiki/Regular_Expressions/POSIX-Extended_Regular_Expressions">extended regular expression</a> to match repositories. E.g. <code>'^Repo A$|^Repo B$'</td>
  </tr>
  </tbody>
</table>

