ImportURL.lua
=

Requires Codea 1.5 (beta) or greater. Downloads a file at the specified URL using http.request() and creates a tab with it's contents in the current project. Create a project including this file, and use Codea's project dependency feature to enable importURL in any project. Also, see https://github.com/fredbogg/getGit for a project based on importURL() that downloads an entire Codea project from a Github repo.

Usage:

* <code>importURL(url)</code>
* <code>importURL(tabname, url)</code>