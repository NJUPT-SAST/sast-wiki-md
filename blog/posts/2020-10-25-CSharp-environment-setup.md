---

title: C# 与 .NET 环境配置（2021 年修订）
date: 2020-10-25
authors:
    - EnderHorror
    - Jisu-Woniu
categories:
    - blog
tags: C# .NET Tutorial
---

本文将介绍基于 Windows 平台和 .NET 5.0 的 C# 开发环境配置与简易使用方法  

<!--more-->

## 直接安装 .NET CLI（控制台程序）

1. 访问 .NET 官网[下载页](https://dotnet.microsoft.com/download)，选择需要的版本（如 .NET 5.0），选择“Download .NET SDK x64”

2. 运行安装向导，完成后在终端中输入 `dotnet`，将看到以下信息：

```dotnetcli
    > dotnet
    
    Usage: dotnet [options]
    Usage: dotnet [path-to-application]
    
    Options:
    -h|--help         Display help.
    --info            Display .NET information.
    --list-sdks       Display the installed SDKs.
    --list-runtimes   Display the installed runtimes.
    
    path-to-application:
    The path to an application .dll file to execute.
```

3. 在想创建项目的文件夹运行终端，输入

```dotnetcli
    dotnet new console -o HelloWorldApp
```

等待命令执行完成，这将创建一个 HelloWorldApp 文件夹

1. 用代码编辑器（建议使用 [Visual Studio Code](https://code.visualstudio.com/)）打开 HelloWorldApp 文件夹，其中的 Program.cs 文件应如下所示：

```csharp
    using System;

    namespace HelloWorldApp
    {
        class Program
        {
            static void Main(string[] args)
            {
                Console.WriteLine("Hello World!");
            }
        }
    }
```

2. 在 HelloWorldApp 文件夹中，执行

```dotnetcli
    dotnet run
```

    程序将运行并输出 `Hello World!`

## 通过 Visual Studio 安装（以 Visual Studio 2019 为例）

1. 下载 Visual Studio 2019

    确保电脑符合 Visual Studio 2019 安装[系统要求](https://docs.microsoft.com/zh-cn/visualstudio/releases/2019/system-requirements)

    打开 [Visual Studio 官网](https://visualstudio.microsoft.com/)选择“下载 Visual Studio Community 2019”

2. 安装 Visual Studio 2019

    运行 Visual Studio 2019 安装程序，待其加载数据完成，在“选择工作负荷”界面勾选“.NET 桌面开发”，选择安装位置并点击安装

3. 启动 Visual Studio 2019 并登录 Microsoft 账号

    如果没有账号需在线免费注册。可点击 Visual Studio 官网右上角的头像图标注册。登录过程如遇白屏/加载失败可采用特殊手段联网

4. 创建新项目
    - 在启动窗口中选择“创建新项目”，选择“C# 控制台应用程序”，点击“下一步”

    - 输入项目名称如“HelloWorldApp”，选择创建位置，点击“下一步”

    - 目标框架选择“.NET 5.0”，点击“创建”

5. 将自动打开 Program.cs 文件，代码如下：

```csharp
    using System;
    
    namespace HelloWorldApp
    {
        class Program
        {
            static void Main(string[] args)
            {
                Console.WriteLine("Hello World!");
            }
        }
    }
```

6. 按 F5 启动程序，程序将输出 `Hello World!` 与进程退出提示

## 学习资料推荐

1. 书籍推荐：

    - 《Visual C# 从入门到精通》
    - 《C# 入门经典》

2. 网站推荐

    - 微软官方 C# 文档：<https://docs.microsoft.com/zh-cn/dotnet/csharp/>
    - .NET API 浏览器：<https://docs.microsoft.com/dotnet/api/>
    - 菜鸟教程：<https://www.runoob.com/csharp/csharp-tutorial.html>
