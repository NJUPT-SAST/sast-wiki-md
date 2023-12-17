# 贡献指南
如果您有想要发表在本站的文章，可以通过以下两种方式来投稿。请注意，本站的所有内容将遵循 署名-非商业性使用-相同方式共享 4.0 国际 (CC BY-NC-SA 4.0) 协议公开，这意味着您的作品也会被采用该协议进行分享。

## 使用 Git
您可以将您的文章以 Markdown 的格式提交到我们的 Git 仓库，遵循以下的步骤：

打开我们的仓库并 Fork 我们的项目到您的 Github 账号。
```bash
git clone https://github.com/NJUPT-SAST/sast-wiki-md
cd ./info
git remote add <YOUR-GITHUB-USERNAME> <YOUR FORKED URL>
git checkout -b <BRANCH-NAME>
```
注意！不要将您的改动直接放置在 main 分支。

将您的 Markdown 文稿放置在内容相关的目录内，并使之符合写作格式一节的要求。 如果您有需要插入的图片，我们建议您将其放置在 `assets/img/<YOUR-TITLE>` 内一并提交。
目录索引

```
git add --all
git commit --message "YOUR COMMIT MESSAGE"
git push --set-upstream <YOUR-GITHUB-USERNAME> <BRANCHNAME>
```

提交信息格式可以为 add post: `<TITLE>`

然后前往我们的仓库，提交 Pull Request

我们会尽快处理您的请求，如果有什么不合理之处，也会在 Pull Request 的讨论区回复。

## 发送邮件
如果您不熟悉 Git 操作，也可以通过将您的文章发送到 SAST 邮箱 ([opensource@sast.fun](mailto:opensource@sast.fun)) 来投稿。但是，我们建议您使用 Git 提交，以便更好地追踪和记录您的贡献。

# 其他贡献
如果您发现了本站的一些 Bug 和使用体验问题，也可以在 Github 仓库的 issue 区反馈，当然，您也可以直接提交一个 Pull Request，流程与投稿文章大致类似，只不过，您可能需要在本地设置 MkDocs 环境并充分测试您的改动。

如果您希望举办活动，参加科协以进一步贡献，也可以发送邮件深入咨询。

# 写作格式
我们推荐您下载合适的 Markdown 编辑器，如 Obsidian 或者 VSCode 并花些时间来学习一下 Markdown 的基本语法。

本站使用 MkDocs 进行驱动，因此，您需要将您的 Markdown 文件改动来符合解析要求。

将您的文章文件名改为 YYYY-MM-DD-TITLE 的格式
在您的文档开头添加元信息，具体格式为
```yaml
---
draft: true 
date: 2023-01-31 
categories:
  - Hello
  - World
tags:
  - Foo
  - Bar
authors:
  squidfunk:
    name: Max
    description: SASTer
    avatar: https://avatars.githubusercontent.com/u/60775796
---
```
其中 layout、 author 和 permalink 为必填项。如果您希望以您的文章开头作为摘要，请在合适的地方添加 `<!--more-->` 标签。

插入图片的格式为： `![DESCRIPTION](/assets/img/<TITLE>/<FILE-NAME>.png)`，并将相应图片移至该目录下。
其余与一般 Markdown 语法相同，本站支持插入行内和块级公式。

