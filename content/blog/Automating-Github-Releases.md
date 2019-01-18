---
title: "Automating Github Releases"
hero_image: "hero.jpg"
date: 2019-01-12T14:27:39-05:00
description: "Automating Github Releases with scripts"
draft: false
---

Github releases are a good way to distribute milestone releases of
your repository and in particular, releasing binary files such that
others do not necessarily need to recompile from source.

Note: If you want to simply just mark milestones of your repository,
you can use the `git tag` feature. Tags pushed to Github will be
in the releases area of your repository and offer users the option to
download a `zip` or `tar.gz` of the repository at the commit specified
by the tag.

I decided to start looking into Github releases to share the compiled
pdfs of my .tex notes/reviews. Previously, I have been adding the pdf
files to my public repository, which of course is a bad idea as it
increases the size of the repository linearly with each commit, which
is very bad when one commits often. So in this post I will describe
the steps I have gone through to automate my Github releases.

## OAuth
To commence, you need to generate a OAuth token to use for sending web
requests to the Github API. Full details on doing so are
[here](https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/),
but essentially all you must do is go to the developer settings and
[generate a personal access
token](https://github.com/settings/tokens/new). You will need
`public_repo` in order to create releases for a public repository, or
the entire `repo` scope to be able to create releases for a private
repository.

## Using curl to manage releases
(Full documentation on using the REST API to manage releases
[here](https://developer.github.com/v3/repos/releases/), I will touch
on the basic versions of what I have used)

*Note*: Variables to replace with your values in curl URLs here are
denoted by $(var_name)

To create a release, you'll want to send a POST request to the
releases URL through the Github API, with the pertinent information,
like so: 
``` 
curl --data '{"tag_name": "tag name (equivalent to git
tag names)", "name": "name of the release, often a version number",
"body": "Description"}'
https://api.github.com/repos/$(github_username)/$(github_repository)/releases\?access_token\=$(your_oauth_token)
``` 
There are other parameters (`target_commitish`, `draft`,
`prerelease`) as well (more details [here](https://developer.github.com/v3/repos/releases/)). The only
required one is `tag_name`. 

Now to edit the release, you will need the URL returned by the
POST request that created the release, or you can GET that information
again with the following:
```
curl https://api.github.com/repos/$(github_username)/$(github_repository)/releases/tags/$(tag_name)\?access_token\=$(your_oauth_token)
```

In particular, we are interested in uploading assets, the required URL
is given by the "upload_url" returned by either the POST or GET
request as above.

### Uploading a release asset

Here's how you upload a pdf using curl:
```
curl -H "Content-Type: application/pdf" -T file.pdf https://uploads.github.com/repos/$(github_username)/$(github_repository)/releases/$(release_id)/assets\?name\=$(asset_name)\&access_token\=$(your_oauth_token)
```

To upload different types of assets, you may consult the [IANA's media
types](https://www.iana.org/assignments/media-types/media-types.xhtml)
or you can query a file's type with `file -b --mime-type $(FILENAME)`.

### Deleting releases

```
curl -X DELETE https://api.github.com/repos/$(github_username)/$(github_repository)/releases/$(release_id)\?access_token\=$(your_oauth_token)
```

More information on the Github REST API [here](https://developer.github.com/v3/).
