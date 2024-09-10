---
draft: true 
date: 2023-01-31 
categories:
  - blog
tags:
  - HarmonyOS
  - Huawei
  - ArkTS
  - ArkUI
authors:
  squidfunk:
    name: Wbil
    description: SASTer
    avatar: https://avatars.githubusercontent.com/u/109361390
---
# HarmonyOS NEXT

> 本文档编写过程中 HarmonyOS NEXT Developer Beta2 升级为了 HarmonyOS NEXT Developer Beta3，Beta3 的API能力级别为API 12 Beta3，部分内容在不同版本中的使用和效果有所变化。

## 目录
- [HarmonyOS NEXT](#harmonyos-next)
  - [目录](#目录)
  - [应用程序包](#应用程序包)
    - [Module 类型](#module-类型)
      - [HAP](#hap)
        - [Lint](#lint)
        - [entry HAP](#entry-hap)
        - [feature HAP](#feature-hap)
      - [Library Module](#library-module)
        - [Static Library](#static-library)
        - [Shared Library](#shared-library)
        - [区别](#区别)
    - [应用程序包结构](#应用程序包结构)
      - [Stage 模型](#stage-模型)
        - [ArkTS 源码（.ets）](#arkts-源码ets)
        - [配置文件](#配置文件)
        - [资源文件](#资源文件)
        - [其他](#其他)
      - [FA 模型](#fa-模型)
        - [config.json](#configjson)
        - [assets](#assets)
          - [resources](#resources)
          - [resources.index](#resourcesindex)
        - [js](#js)
        - [pack.info](#packinfo)
  - [ArkTS](#arkts)
    - [简介](#简介)
    - [在UI框架上的拓展（详见 ArkUI ）](#在ui框架上的拓展详见-arkui-)
    - [与TS的主要区别与特点（非严格模式 TS ）](#与ts的主要区别与特点非严格模式-ts-)
      - [1. 禁止在代码中使用 @ts-ignore](#1-禁止在代码中使用-ts-ignore)
      - [2. 强制静态类型\&要求显式初始化](#2-强制静态类型要求显式初始化)
      - [3. 禁止在运行时变更对象布局](#3-禁止在运行时变更对象布局)
      - [4. 主要的常见 Lint](#4-主要的常见-lint)
        - [不支持 JSX （ ArkUI ）](#不支持-jsx--arkui-)
        - [+ - ～ 等一元运算符只可用于数值](#----等一元运算符只可用于数值)
        - [delete 没有意义 （ 见3 ）](#delete-没有意义--见3-)
        - [不支持 in（ 见3 ）](#不支持-in-见3-)
        - [不得使用 with](#不得使用-with)
        - [不得使用 eval](#不得使用-eval)
        - [仅允许在表达式中使用 typeof 运算符](#仅允许在表达式中使用-typeof-运算符)
        - [不支持结构赋值/函数声明与变量声明( 见2 )](#不支持结构赋值函数声明与变量声明-见2-)
        - [逗号运算符仅用在 for 循环语句中](#逗号运算符仅用在-for-循环语句中)
        - [接口不能继承具有相同方法的两个接口](#接口不能继承具有相同方法的两个接口)
        - [不支持 enum 类接口的声明合并](#不支持-enum-类接口的声明合并)
        - [接口不能继承类](#接口不能继承类)
        - [不支持 require  import 赋值表达式  export= ... UMD 或在模块名字中使用通配符](#不支持-require--import-赋值表达式--export--umd-或在模块名字中使用通配符)
        - [在 import 语句前不得有其他语句（动态 import除外）](#在-import-语句前不得有其他语句动态-import除外)
        - [允许 .ets 文件 import .ets/.ts/.js 文件源码, 不允许 .ts / .js 文件 import.ets 文件源码](#允许-ets-文件-import-etstsjs-文件源码-不允许-ts--js-文件-importets-文件源码)
        - [catch() 不能标注类型](#catch-不能标注类型)
        - [不支持 is 运算符](#不支持-is-运算符)
        - [不支持在函数内声明函数](#不支持在函数内声明函数)
        - [对象属性名字不能是数字或者字符串](#对象属性名字不能是数字或者字符串)
        - [类型、命名空间的命名必须唯一](#类型命名空间的命名必须唯一)
        - [不允许 index signature](#不允许-index-signature)
        - [不支持通过索引访问字段](#不支持通过索引访问字段)
        - [不支持 structural typing](#不支持-structural-typing)
        - [对象字面量不能用于类型声明](#对象字面量不能用于类型声明)
        - [箭头函数](#箭头函数)
        - [显式声明类型，不支持类型表达式](#显式声明类型不支持类型表达式)
      - [\*5. 不支持 Structural typing](#5-不支持-structural-typing)
    - [其他差异](#其他差异)
      - [\*与标准 TS / JS 的差异](#与标准-ts--js-的差异)
  - [ArkUI](#arkui)
    - [基本组成](#基本组成)
    - [声明式 UI](#声明式-ui)
      - [创建组件](#创建组件)
        - [无参数](#无参数)
        - [有参数](#有参数)
      - [配置属性](#配置属性)
      - [配置事件](#配置事件)
      - [配置子组件](#配置子组件)
    - [装饰器](#装饰器)
      - [@Entry](#entry)
      - [@state (状态管理）](#state-状态管理)
      - [@props (状态管理）](#props-状态管理)
      - [@Link (状态管理）](#link-状态管理)
      - [@Provide \& @Consume (状态管理）](#provide--consume-状态管理)
      - [*@Observed \& @ObjectLink (V1状态管理）*](#observed--objectlink-v1状态管理)
      - [@Observed \& @Trace (V2状态管理）（API version 12）](#observed--trace-v2状态管理api-version-12)
      - [@Component(V1 \& V2状态管理)（V2 ：API version 12）](#componentv1--v2状态管理v2-api-version-12)
        - [V1 \& V2 的区别和关系](#v1--v2-的区别和关系)
          - [自定义组件冻结](#自定义组件冻结)
      - [@Local (状态管理）（API version 12）](#local-状态管理api-version-12)
      - [@Parma (V2 状态管理）（API version 12）](#parma-v2-状态管理api-version-12)
      - [@Monitor (状态管理）（API version 12）](#monitor-状态管理api-version-12)
      - [@Computed (状态管理）（API version 12）](#computed-状态管理api-version-12)
      - [@Type (状态管理）（API version 12）](#type-状态管理api-version-12)
      - [@Once (状态管理）（API version 12）](#once-状态管理api-version-12)
      - [@builder](#builder)
        - [参数传递](#参数传递)
          - [按值传递](#按值传递)
          - [按引用传递（推荐）](#按引用传递推荐)
        - [@Localbuilder](#localbuilder)
          - [限制](#限制)
          - [区别](#区别-1)
        - [@BuilderParam](#builderparam)
          - [初始化](#初始化)
          - [常见用途：](#常见用途)
        - [wrapBuilder](#wrapbuilder)
      - [@styles](#styles)
        - [@Extend](#extend)
        - [stateStyles](#statestyles)
        - [@AnimatableExtend](#animatableextend)
      - [@Require](#require)
    - [自定义组件](#自定义组件)
      - [重渲染](#重渲染)
      - [删除](#删除)
        - [节点删除机制](#节点删除机制)
    - [生命周期](#生命周期)
      - [页面生命周期](#页面生命周期)
        - [onPageShow](#onpageshow)
        - [onPageHide](#onpagehide)
      - [组件生命周期](#组件生命周期)
        - [aboutToAppear](#abouttoappear)
        - [onDidBuild](#ondidbuild)
        - [aboutToDisappear](#abouttodisappear)
      - [生命周期流程示意图](#生命周期流程示意图)
    - [布局](#布局)
    - [状态管理（V2）](#状态管理v2)
      - [装饰器](#装饰器-1)
      - [AppStorage (V2) (API version 12)](#appstorage-v2-api-version-12)
        - [connect](#connect)
        - [remove](#remove)
        - [keys](#keys)
        - [限制](#限制-1)
      - [Persistence (V2)(API version 12)](#persistence-v2api-version-12)
        - [connect \& keys \& remove](#connect--keys--remove)
        - [save](#save)
        - [notifyOnError](#notifyonerror)
        - [提醒](#提醒)
      - [!!绑定 (API version 12)](#绑定-api-version-12)
      - [自定义组件冻结](#自定义组件冻结-1)
    - [渲染控制](#渲染控制)
      - [条件渲染（ if ）](#条件渲染-if-)
      - [循环渲染（ ForEach ）（API version 9）](#循环渲染-foreach-api-version-9)
        - [首次渲染](#首次渲染)
        - [非首次渲染](#非首次渲染)
        - [使用场景](#使用场景)
        - [可能出现的问题](#可能出现的问题)
      - [懒加载LazyForEach](#懒加载lazyforeach)
        - [限制](#限制-2)
        - [首次渲染](#首次渲染-1)
        - [非首次渲染](#非首次渲染-1)
      - [混合开发 ContentSlot](#混合开发-contentslot)
        - [接口](#接口)
        - [Native 接口](#native-接口)
        - [Native 侧逻辑](#native-侧逻辑)
  - [NDK 开发](#ndk-开发)
    - [NDK 的使用与结构](#ndk-的使用与结构)
      - [适用场景](#适用场景)
      - [不适用场景](#不适用场景)
      - [Node-API](#node-api)
      - [文件结构](#文件结构)
        - [build](#build)
        - [build-tools](#build-tools)
      - [llvm](#llvm)
    - [构建](#构建)
      - [ohos.toolchain.cmake](#ohostoolchaincmake)
      - [DevEco Studio 模版构建（默认 , 推荐）](#deveco-studio-模版构建默认--推荐)
        - [CMakeLists.txt](#cmakeliststxt)
        - [externalNativeOptions](#externalnativeoptions)
      - [CMAKE 构建](#cmake-构建)
        - [环境](#环境)
        - [编译（以 linux \& mac 为例）](#编译以-linux--mac-为例)
      - [毕昇编译器](#毕昇编译器)
        - [主要特点：](#主要特点)
          - [循环加速](#循环加速)
          - [矢量化优化](#矢量化优化)
  - [工具](#工具)
    - [CodeGenic](#codegenic)
      - [代码补全](#代码补全)
        - [快捷键](#快捷键)
      - [Chat](#chat)
        - [卡片生成（万能卡片）](#卡片生成万能卡片)
    - [HDC](#hdc)
      - [环境](#环境-1)
        - [环境变量 HDC\_SERVER\_PORT（MacOS \& Linux）](#环境变量-hdc_server_portmacos--linux)
        - [全局环境变量（Linux \& MacOS）](#全局环境变量linux--macos)
      - [HDC 基础功能](#hdc-基础功能)
        - [HDC 信息](#hdc-信息)
        - [设备列表](#设备列表)
        - [连接设备](#连接设备)
          - [有线连接](#有线连接)
          - [无线连接](#无线连接)
        - [日志等级](#日志等级)
          - [`[level]` 可选参数(直接使用对应数字，不要使用 string )](#level-可选参数直接使用对应数字不要使用-string-)
        - [终止 HDC 服务进程](#终止-hdc-服务进程)
        - [启动 HDC 服务进程](#启动-hdc-服务进程)
        - [切换连接方式（ USB / 无线）](#切换连接方式-usb--无线)
      - [HDC 网络命令](#hdc-网络命令)
        - [列出全部转发端口转发任务](#列出全部转发端口转发任务)
        - [设置正向端口转发任务](#设置正向端口转发任务)
        - [设置反向端口转发任务](#设置反向端口转发任务)
        - [删除端口转发任务](#删除端口转发任务)
      - [HDC 文件指令](#hdc-文件指令)
        - [从本地发送文件到远端设备](#从本地发送文件到远端设备)
        - [从远端设备发送文件至本地](#从远端设备发送文件至本地)
      - [HDC APP 指令](#hdc-app-指令)
        - [安装 APP](#安装-app)
        - [卸载 APP](#卸载-app)
      - [HDC 调试指令](#hdc-调试指令)
  - [附录](#附录)
    - [名词解释](#名词解释)
      - [A](#a)
        - [abc文件](#abc文件)
        - [ANS](#ans)
        - [Atomic Service，元服务](#atomic-service元服务)
        - [ArkUI](#arkui-1)
        - [ArkCompiler](#arkcompiler)
      - [C](#c)
        - [CES](#ces)
        - [Cross-device migration，跨端迁移](#cross-device-migration跨端迁移)
      - [D](#d)
        - [DV](#dv)
      - [E](#e)
        - [ExtensionAbility](#extensionability)
      - [F](#f)
        - [FA](#fa)
        - [FA模型](#fa模型)
      - [H](#h)
        - [HAP](#hap-1)
        - [HDF](#hdf)
        - [HML](#hml)
        - [Hop，流转](#hop流转)
      - [I](#i)
        - [IDN](#idn)
      - [M](#m)
        - [Manual hop，用户手动流转](#manual-hop用户手动流转)
        - [MSDP](#msdp)
        - [Multi-device collaboration，多端协同](#multi-device-collaboration多端协同)
      - [P](#p)
        - [PA](#pa)
      - [S](#s)
        - [Service widget，服务卡片](#service-widget服务卡片)
        - [Stage模型](#stage模型)
        - [Super virtual device，超级虚拟终端](#super-virtual-device超级虚拟终端)
        - [System suggested hop，系统推荐流转](#system-suggested-hop系统推荐流转)
      - [U](#u)
        - [UIAbility](#uiability)


## 应用程序包
### Module 类型
依据使用场景分为 HAP HSP 两种
#### HAP
Ability 类型的模块用于实现功能和特性编译后生成.hap的文件

HAP 包可以独立安装和运行，是应用安装的基本单位，一个应用中可以包含一个或多个 HAP 包，包含 entry 和 feature 两种类型。

##### Lint
* 不支持导出
* 同一应用的所有 HAP 的以下配置必须相同：
  > * bundleName、versionCode、versionName、minCompatibleVersionCode、debug、minAPIVersion、targetAPIVersion、apiReleaseType
* 同一设备类型所有 HAP 对应的 moduleName 标签必须唯一
* 多 HAP 场景下，同一应用的所有 HAP、HSP 的签名证书要保持一致。
  > * 开发时需要保证签名一致
  > * 上架时会对所有 HAP 进行重签名保证一致

##### entry HAP
主模块，包含应用的入口界面、入口图标和主功能特性，编译后生成 entry 类型的 HAP 。每一个应用分发到同一类型的设备上的应用程序包，__只能包含唯一一个 entry 类型的 HAP__ 。

##### feature HAP
用于代码复用与资源共享，一个应用中 feature HAP 的数量是没有限制的。

#### Library Module
用于代码复用和资源共享，分为 Static 和 Shared 两种

##### Static Library
静态共享库，HAR ，后缀为 .har

  * 可以作为第二方库发布到 OHPM 私有仓库供内部其他应用使用，也可作为第三方库发布到 OHPM 中心仓，供其他应用使用
  * 多包应用相同 HAR 会导致重复拷贝
  * 推荐混淆
  * 可以依赖其他 HAR ，但不支持循环依赖，也不支持依赖传递。
  * 不支持引用 AppScope 目录中的资源
  * 不支持在设备上单独安装/运行
  * 不支持在配置文件中声明 UIAbility 组件与 ExtensionAbility 组件和 pages 页面(可以包含 pages 页面，通过命名路由```router.pushNamedRoute()```进行跳转)
##### Shared Library
动态共享库，HSP ，后缀为 .hsp 

  * 仅支持应用内共享
  * 不支持在设备上单独安装/运行。 HSP 的版本号必须与 HAP 版本号一致。
  * 可以依赖其他 HAR 或 HSP ，但不支持循环依赖，也不支持依赖传递
  * 不支持在配置文件中声明 UIAbility 组件与 ExtensionAbility 组件
  * 集成态HSP只支持 Stage 模型,且需要 API12 及以上(HarmonyOS NEXT Developer Beta3 +)，使用标准化的 OHMUrl 格式
  * 针对 HAR 包重复拷贝，应该使用 HSP 替代 HAR 

##### 区别
HAR 与 HSP 引用的区别：
![DIff between HAR and HSP](https://alliance-communityfile-drcn.dbankcdn.com/FileServer/getFile/cmtyPub/011/111/111/0000000000011111111.20240813092647.54120059115137432680833343108943:50001231000000:2800:7B09A46717BB553CAC1655F40A3A443C74A690DA560A6CA5112F50C65A683398.png?needInitFileName=true?needInitFileName=true)

|  | HAP | HAR | HSP |
| --- | --- | --- | --- |
| 支持在配置文件中声明 UIAbility 组件与 ExtensionAbility 组件 | √ | × | × |
| 支持在配置文件中声明 pages 页面 | √ | × | √ |
| 支持包含资源文件与 .so 文件 | √ | √ | √ |
| 支持依赖其他 HAR 文件 | √ | √ | √ |
| 支持依赖其他 HSP 文件 | √ | √ | √ |
| 支持在设备上独立安装运行 | √ | × | × |


### 应用程序包结构
分为 Stage 模型和 FA 模型两种（仅介绍开发态，编译和发布态与开发态不同）

#### Stage 模型
文件夹结构：

``` typescript
MyApplication
├── .hvigor
├── .idea
├── AppScope
├── entry
│   └── src
│       ├── main
│       │   ├── ets
│       │   └── entryability
│       │       └── pages
│       ├── resources
│       └── mock
├── hvigor
└── oh_modules
```

##### ArkTS 源码（.ets）
路径：
``` bash
Module_name > src > main > ets
```

##### 配置文件
* AppScope > app.json5 
   > 声明应用的全局配置信息，比如应用Bundle名称、应用名称、应用图标、应用版本号等。
* Module_name > src > main > module.json5
    > 用于声明 Module 基本信息、支持的设备类型、所含的组件信息、运行所需申请的权限等

##### 资源文件
* AppScope > resources
  > 应用需要的资源
* Module_name > src > main > resources
  > 该Module需要的资源

##### 其他
* build-profile.json5 ：工程级或 Module 级的构建配置文件，包括应用签名、产品配置等。
* hvigorfile.ts ：应用级或Module级的编译构建任务脚本。
* obfuscation-rules.txt ：Release 模式编译的混淆规则。
* oh-package.json5 ：依赖

#### FA 模型
FA 模型将所有的资源文件、库文件和代码文件都放在 assets 文件夹中，在文件夹内部进一步区分。
![Fa Module](https://alliance-communityfile-drcn.dbankcdn.com/FileServer/getFile/cmtyPub/011/111/111/0000000000011111111.20240813092647.87271446841759453214630162849639:50001231000000:2800:2C2AFBFE360AF1C39AA52D8D61338A5FAFD5C5122E7D4BF8D43CF7B66A908D90.png?needInitFileName=true?needInitFileName=true)

##### config.json
应用配置文件，IDE 会自动生成一部分模块代码，按需修改。见[应用配置文件](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/app-structure-V5)。

##### assets
HAP 资源、库和代码的集合。
* 内部分为 entry 和 js 。
* entry 中存放的是 resources 目录和 resources.index 文件。

  ###### resources
  用于存放应用的资源文件（字符串、图片等），详见资源文件的使用。

  ###### resources.index
  资源索引表，由 IDE 调用 SDK 工具生成。

##### js
编译后的代码文件

##### pack.info
Bundle 中用于描述每个 HAP 属性的文件，例如 app 中的 bundleName 和 versionCode 信息、module 中的 name 、type 和 abilities 等信息，由 IDE 工具构建 Bundle 包时自动生成。

## ArkTS

### 简介

* HarmonyOS 的主力应用开发语言。

* 基于 TS 生态基础上进一步扩展。

* 保持了 TS 的基本风格

* 通过规范定义强化开发期静态检查和分析，提升程序执行稳定性和性能。

### 在UI框架上的拓展（详见 ArkUI ）

* 语法拓展：声明式 UI 描述、自定义组件和动态扩展 UI 元素的能力

* 状态管理：在 UI 开发框架中，与UI相关联的数据可以在组件内使用，也可以在不同组件层级间传递，比如父子组件之间、爷孙组件之间，还可以在应用全局范围内传递或跨设备传递。另外，从数据的传递形式来看，可分为只读的单向传递和可变更的双向传递。开发者可以灵活地利用这些能力来实现数据和 UI 的联动。

* 渲染：条件渲染可根据应用的不同状态，渲染对应状态下的 UI 内容。循环渲染可从数据源中迭代获取数据，并在每次迭代过程中创建相应的组件。数据懒加载从数据源中按需迭代数据，并在每次迭代过程中创建相应的组件。

### 与TS的主要区别与特点（非严格模式 TS ）

#### 1. 禁止在代码中使用 @ts-ignore
强制进行类型检查，同时限制某些 ts / js 标准库使用

#### 2. 强制静态类型&要求显式初始化

减少运行时候的类型检查，提升性能

***（ ArkTS 中禁止使用 any 类型）***
	
``` typescript
// 不支持：
let res: any = some_api_function('hello', 'world');
// 支持：
class CallResult {
  public succeeded(): boolean { ... }
  public errorMessage(): string { ... }
}
	
let res: CallResult = some_api_function('hello', 'world');
if (!res.succeeded()) {
  console.log('Call failed: ' + res.errorMessage());
}
	
```
TS :
	
``` typescript
class Person {
  name: string // undefined
  
  setName(n: string): void {
    this.name = n
  }
  
  getName(): string {
  // 开发者使用"string"作为返回类型，这隐藏了name可能为"undefined"的事实。
  // 更合适的做法是将返回类型标注为"string | undefined"，以告诉开发者这个API所有可能的返回值的类型。
    return this.name
  }
}
	
let buddy = new Person()
// 假设代码中没有对name的赋值，例如没有调用"buddy.setName('John')"
buddy.getName().length; // 运行时异常：name is undefined
```
ArkTS :
	
``` typescript
class Person {
  name: string = ''
  
  setName(n: string): void {
    this.name = n
  }
  
  // 类型为"string"，不可能为"null"或者"undefined"
  getName(): string {
    return this.name
  }
}
	
let buddy = new Person()
// 假设代码中没有对name的赋值，例如没有调用"buddy.setName('John')"
buddy.getName().length; // 0, 没有运行时异常
```
	
*\*如果变量可能为 undefined ，则应该被精确标注*
	
``` typescript
class Person {
    name?: string // 可能为undefined
	
    setName(n: string): void {
        this.name = n
    }
	
    // 编译时错误：name可能为"undefined"，所以不能将这个API的返回类型标注为"string"
    getNameWrong(): string {
        return this.name
    }
	
    getName(): string | undefined { // 返回类型匹配name的类型
        return this.name
    }
}
	
let buddy = new Person()
// 假设代码中没有对name的赋值，例如没有调用"buddy.setName('John')"
	
// 编译时错误：编译器认为下一行代码有可能访问"undefined"的属性，报错
buddy.getName().length;  // 编译失败
	
buddy.getName()?.length; // 编译成功，没有运行时错误
```

#### 3. 禁止在运行时变更对象布局
规则：arkts-no-method-reassignment

如果需要为某个特定的对象增加方法，可以封装函数或者使用继承的机制。

 具体表现为禁止以下行为：
> * 向对象中添加新的属性或方法。
> * 从对象中删除已有的属性或方法。
> * 将任意类型的值赋值给对象属性。

#### 4. 主要的常见 Lint
##### 不支持 JSX （ ArkUI ）
##### + - ～ 等一元运算符只可用于数值
##### delete 没有意义 （ 见3 ）
##### 不支持 in（ 见3 ）
##### 不得使用 with
##### 不得使用 eval
##### 仅允许在表达式中使用 typeof 运算符
> 不得使用 typeof 作为类型

##### 不支持结构赋值/函数声明与变量声明( 见2 )
限制展开运算符使用：
仅支持展开数组、Array 的子类和 TypedArray（例如 Int32Array ）。

仅支持使用在以下场景中：
传递给剩余参数时  / 
复制一个数组到数组字面量

##### 逗号运算符仅用在 for 循环语句中
##### 接口不能继承具有相同方法的两个接口
> 一个接口中不能包含两个无法区分的方法
> 
> 如果一个接口继承了具有相同方法的两个接口，则该接口必须使用联合类型来声明该方法的返回值类型

##### 不支持 enum 类接口的声明合并
##### 接口不能继承类
##### 不支持 require  import 赋值表达式  export= ... UMD 或在模块名字中使用通配符
> 导入是编译时而非运行时特性。

##### 在 import 语句前不得有其他语句（动态 import除外）

##### 允许 .ets 文件 import .ets/.ts/.js 文件源码, 不允许 .ts / .js 文件 import.ets 文件源码

##### catch() 不能标注类型
>  throw 只支持抛出 Error 类或其派生类的实例。禁止抛出其他类型

##### 不支持 is 运算符
> 使用 instanceof

##### 不支持在函数内声明函数
> 只能使用 Lambda 函数

##### 对象属性名字不能是数字或者字符串
反例：
	
``` typescript
	var x = { 'name': 'x', 2: '3' };
```	
##### 不支持以#开头的私有字段
使用 private 关键字
	
``` typescript
TypeScript
	
class C {
  #foo: number = 42
}
ArkTS
	
class C {
  private foo: number = 42
}
```
	
##### 类型、命名空间的命名必须唯一
反例：
	
``` typescript
let X: string
type X = number[] // 类型的别名与变量同名
```	
##### 使用 let 不支持 var
	
与现有 lint 保持一致
	
##### 使用具体的类型而非 any 或 unknown
	
不得使用 any 和 unknown
	
##### 不允许多个静态块
	
```typescript
class C {
  static s: string
	
  static {
    C.s = 'aa'
  }
  static {
    C.s = C.s + 'bb'
  }
}
	
// 应改为：
class C {
  static s: string
	
  static {
    C.s = 'aa'
    C.s = C.s + 'bb'
  }
}
	
```
##### 不允许 index signature
	
改用数组
	
``` typescript
interface ListItem {
  getHead(): this
}
	
class C {
  n: number = 0
	
  m(c: this) {
    // ...
  }
}
	
//ArkTS
interface ListItem {
  getHead(): ListItem
}
	
class C {
  n: number = 0
	
  m(c: C) {
    // ...
  }
}

```	
##### 不支持 intersection type
	
可以使用继承作为替代方案
	
##### 不支持在函数和类的静态方法中使用 this
	
需要显式使用具体类型
	
##### 不支持条件类型
	
应该选择引入带显式约束的新类型，或使用 Object 重写逻辑。

``` typescript
type X<T> = T extends number ? T: never
type Y<T> = T extends Array<infer Item> ? Item: never
```
应该写为

``` typescript
// 在类型别名中提供显式约束
type X1<T extends number> = T

// 用Object重写，类型控制较少，需要更多的类型检查以确保安全
type X2<T> = Object

// Item必须作为泛型参数使用，并能正确实例化
type YI<Item, T extends Array<Item>> = Item
```
##### 不支持通过索引访问字段
不支持动态访问字段。只能访问已在类中声明或者继承可见的字段，访问其他字段将会造成编译时错误。
使用点操作符访问字段，例如（ obj.field ），不支持索引访问（ obj[field] ）。

``` typescript
class Point {
  x: string = ''
  y: string = ''
}
let p: Point = {x: '1', y: '2'};
console.log(p['x']);// 错误
console.log(p.x);//正确

```
##### 不支持 structural typing
编译器无法直接比较两种类型的公共 API 并决定它们是否相同。

``` typescript
interface I1 {
  f(): string
}

interface I2 { // I2等价于I1但是无法直接比较
  f(): string
}


interface I1 {
  f(): string
}

type I2 = I1 // I2是I1的别名
```
##### 对象字面量不能用于类型声明
不支持使用对象字面量声明类型，可以使用类或者接口声明类型。

``` typescript
//TS
let o: {x: number, y: number} = {
  x: 2,
  y: 3
}

type S = Set<{x: number, y: number}>
```
``` typescript 
//ArkTS

class O {
  x: number = 0
  y: number = 0
}

let o: O = {x: 2, y: 3};

type S = Set<O>
```
##### 箭头函数
不支持函数表达式，只能使用箭头函数

##### 显式声明类型，不支持类型表达式
``` typescript
//error
const Rectangle = class {
  constructor(height: number, width: number) {
    this.height = height;
    this.width = width;
  }

  height
  width
}

const rectangle = new Rectangle(0.0, 0.0);

//ArkTS
class Rectangle {
  constructor(height: number, width: number) {
    this.height = height;
    this.width = width;
  }

  height: number
  width: number
}

const rectangle = new Rectangle(0.0, 0.0);
```
#### *5. 不支持 Structural typing

对 Structural typing 的支持需要在语言、编译器和运行时进行大量的考虑和仔细的实现。（后续可能会支持）

### 其他差异

* 应用环境限制

#### *与标准 TS / JS 的差异

标准 TS / JS 中，JSON 的数字格式，小数点后必须跟着数字，如 2.e3 这类科学计数法不被允许，报出 SyntaxError 。在方舟运行时中，允许使用这类科学计数法。

## ArkUI
![img](https://alliance-communityfile-drcn.dbankcdn.com/FileServer/getFile/cmtyPub/011/111/111/0000000000011111111.20240807211336.48670286055385560158826671135413:50001231000000:2800:AF0D7267233A7AFFE6AD3F52ACE2F8E0F4973DF9ED8A52DAAD932DA692D9CE4C.png?needInitFileName=true?needInitFileName=true)
### 基本组成
* 装饰器： 用于装饰类、结构、方法以及变量，并赋予其特殊的含义。如上述示例中 @Entry 、@Component 和 @State 都是装饰器，@Component 表示自定义组件，@Entry 表示该自定义组件为入口组件，@State 表示组件中的状态变量，状态变量变化会触发 UI 刷新。

* UI 描述：以声明式的方式来描述 UI 的结构，例如 build() 方法中的代码块。以方法的形式表示 UI 内容。

* 自定义组件：可复用的 UI 单元，可组合其他组件。

* 系统组件：ArkUI 框架中默认内置的基础和容器组件，可直接被开发者调用，比如示例中的 Column 、Text 、Divider 、Button 。

* 属性方法：组件可以通过链式调用配置多项属性，如 fontSize() 、width() 、height() 、backgroundColor() 等。（即 style ）

* 事件方法：组件可以通过链式调用设置多个事件的响应逻辑，如跟随在 Button 后面的 onClick() 。

### 声明式 UI
#### 创建组件
不需要使用 new
##### 无参数

``` typescript
Column() {
  Text('item 1')
  Divider()//eg
  Text('item 2')
}
```
##### 有参数

``` typescript
// string类型的参数
Text('test')
// $r形式引入应用资源，可应用于多语言场景
Text($r('app.string.title_value'))
// 无参数形式
Text()
```

#### 配置属性
属性方法以“.”链式使用

``` typescript
Image('test.jpg')
  .alt('error.jpg')    
  .width(100)    
  .height(100)
```

#### 配置事件
同样以“.”链式使用

``` typescript
Button('add counter')
  .onClick(() => {
    this.counter += 2;
  })


myClickHandler(): void {
  this.counter += 2;
}
...
Button('add counter')
  .onClick(this.myClickHandler.bind(this))
```

#### 配置子组件
如果组件支持子组件配置，则需在尾随闭包 `{...}` 中为组件添加子组件的UI描述

``` typescript
Column() {
  Text('Hello')
    .fontSize(100)
  Divider()
  Text(this.myText)
    .fontSize(100)
    .fontColor(Color.Red)
}
```


### 装饰器
每个装饰器在不同版本的支持有所不同，使用前请先确认当前 API Version 支持的功能
#### @Entry
作为 UI 页面的入口。在单个 UI 页面中，最多可以使用 @Entry 装饰一个自定义组件。@Entry 可以接受一个可选的 LocalStorage 的参数或者一个可选的 EntryOptions 参数( API 10+ )。

| 名称               | 类型            | 必填 | 说明                                                                 |
|--------------------|-----------------|------|----------------------------------------------------------------------|
| routeName          | string          | 否   | 表示作为命名路由页面的名字。                                        |
| storage            | LocalStorage    | 否   | 页面级的 UI 状态存储。                                                 |
| useSharedStorage12+| boolean         | 否   | 是否使用 LocalStorage.getShared() 接口返回的 LocalStorage 实例对象，默认值 false 。 |

#### @state (状态管理）
状态变量，会触发重渲染。

#### @props (状态管理） 
@Prop 装饰的变量可以和父组件建立单向的同步关系。即 @Prop 装饰的变量是可变的，但是变化不会同步回其父组件。

#### @Link (状态管理）
区别于 @props ，双向同步

#### @Provide & @Consume (状态管理）
用于与后代组件的双向数据同步，可以摆脱参数传递机制的束缚，实现跨层级传递

#### *@Observed & @ObjectLink (V1状态管理）*
多层嵌套的情况，比如二维数组，或者数组项 class ，或者 class 的属性是 class 等多层的情况使用 @Observed / @ObjectLink

#### @Observed & @Trace (V2状态管理）（API version 12）
替代 V1 中的 @Observed & @ObjectLink ， 解决了无法实现对嵌套类对象属性变化的直接观测问题

#### @Component(V1 & V2状态管理)（V2 ：API version 12）
用于装饰自定义组件
##### V1 & V2 的区别和关系
* V2 仅可以使用全新的状态变量装饰器，包括 @Local 、@Param 、@Once 、@Event 、@Provider 、@Consumer 等
*  V2 装饰的自定义组件暂不支持组件复用、LocalStorage 等现有自定义组件的能力
* 不得同时使用两代 @Component
* V2 支持可选 `Bool freezeWhenInactive` ，来实现组件冻结功能 

###### 自定义组件冻结
> 当 @Component V2 装饰的自定义组件处于非激活状态时，状态变量将不响应更新，即 @Monitor 不会调用，状态变量关联的节点不会刷新。

常见场景：

1. 页面路由

	> 页面A调用 `router.pushUrl` 接口跳转到页面B时，页面A为隐藏不可见状态，此时如果更新页面A中的状态变量，不会触发页面A刷新。

2. Navigation

#### @Local (状态管理）（API version 12）
对 @Component V2 装饰的自定义组件中变量变化的观测

#### @Parma (V2 状态管理）（API version 12）
表示组件从外部传入的状态，使得父子组件之间的数据能够进行同步

V1 中 @State 、@Prop 、@Link 、@ObjectLink 使用各有限制，不易区分，当使用不当时，还会导致性能问题。

#### @Monitor (状态管理）（API version 12）
监听状态变量修改，使得状态变量具有深度监听的能力。

#### @Computed (状态管理）（API version 12）
计算属性，在被计算的值变化的时候，只会计算一次。主要应用于解决 UI 多次重用该属性从而重复计算导致的性能问题。

#### @Type (状态管理）（API version 12）
标记类属性，使得类属性序列化时不丢失类型信息，便于类的反序列化。

#### @Once (状态管理）（API version 12）
仅从外部初始化一次、不接受后续同步变化


#### @builder 
用于自定义构建函数 

自定义组件内自定义构建函数:
>定义语法：
``` @builder MyBuilderFunction(){...}``` 

>使用方法：
``` this.MyBuilderFunction()```

全局自定义构建函数：

如果不涉及组件状态变化，建议使用全局的自定义构建方法。
> 定义语法：
> @Builder function MyGlobalBuilderFunction() { ... }
> 
> 使用方法：
> MyGlobalBuilderFunction()

##### 参数传递
* 参数类型与声明类型一致
* 不使用 undefined ，null 或者返回 undefined null 的表达式
* @Builder 内部不得改变参数值
* 遵循 UI 语法
* 只有传入一个参数，且参数需要直接传入对象字面量才会按引用传递该参数，其余传递方式均为按值传递。

###### 按值传递
默认传递方法

**注意：传递参数为状态变量时候，状态变量的改变不会引起@Builder的UI刷新（状态变量请按引用传递）**

###### 按引用传递（推荐）
按引用传递参数时，如果在 @Builder 方法内调用自定义组件或者其他 @Builder 方法，ArkUI 提供```$$```作为按引用传递参数的范式。

``` typescript
class Tmp {
  paramA1: string = ''
}

@Builder function overBuilder($$: Tmp) {
  Row() {
    Column() {
      Text(`overBuilder===${$$.paramA1}`)
      HelloComponent({message: $$.paramA1})
    }
  }
}
```

##### @Localbuilder
@LocalBuilder 拥有和局部 @Builder 相同的功能，且比局部 @Builder 能够更好的确定组件的父子关系和状态管理的父子关系。

###### 限制
* 只能在所属组件内声明，不允许全局声明。

* 不能被内置装饰器和自定义装饰器使用。

* 不能和自定义组件内的静态方法一起使用。

###### 区别
@Builder 方法引用传参时，为了改变 this 指向，使用 bind ( this ) 后，会导致组件的父子关系和状态管理的父子关系不一致。

@LocalBuilder 无论是否使用 bind ( this ) ，都不会改变组件的父子关系。

##### @BuilderParam
用来装饰指向 @Builder 方法的变量（ @BuilderParam 是用来承接 @Builder 函数的），在初始化自定义组件时对此属性进行赋值，为自定义组件增加特定的功能。该装饰器用于声明任意 UI 描述的一个元素，类似 slot 占位符。
###### 初始化
使用所属自定义组件的自定义构建函数或者全局的自定义构建函数在本地初始化：

``` typescript
@Builder function overBuilder() {}

@Component
struct Child {
  @Builder doNothingBuilder() {};

  // 使用自定义组件的自定义构建函数初始化@BuilderParam
  @BuilderParam customBuilderParam: () => void = this.doNothingBuilder;
  // 使用全局自定义构建函数初始化@BuilderParam
  @BuilderParam customOverBuilderParam: () => void = overBuilder;
  build(){}
}
```

用父组件自定义构建函数初始化子组件 @BuilderParam

``` typescript
@Component
struct Child {
  @Builder customBuilder() {}
  // 使用父组件@Builder装饰的方法初始化子组件@BuilderParam
  @BuilderParam customBuilderParam: () => void = this.customBuilder;

  build() {
    Column() {
      this.customBuilderParam()
    }
  }
}

@Entry
@Component
struct Parent {
  @Builder componentBuilder() {
    Text(`Parent builder `)
  }

  build() {
    Column() {
      Child({ customBuilderParam: this.componentBuilder })
    }
  }
}
```
###### 常见用途：

* 参数初始化组件
* 尾随闭包初始化组件
	* 此场景下自定义组件内有且仅有一个使用 @BuilderParam 装饰的属性。
	* 此场景下自定义组件不支持使用通用属性。

##### wrapBuilder
用于封装全局 @Builder ，用于实现全局 @Builder 可以进行赋值和传递。

用法：

``` typescript
@Builder
function MyBuilder(value: string, size: number) {
  Text(value)
    .fontSize(size)
}

let globalBuilder: WrappedBuilder<[string, number]> = wrapBuilder(MyBuilder);
```

#### @styles
* ***当前*** @Styles 仅支持通用属性和通用事件。
* @Styles 方法不支持参数

``` typescript
// 反例： @Styles不支持参数
@Styles function globalFancy (value: number) {
  .width(value)
}
```
* @Styles 可以定义在组件内或全局，在全局定义时需在方法名前面添加 function 关键字，组件内定义时则不需要添加 function 关键字。(只能在当前文件内使用，不支持 export ) (使用动态属性设置实现跨文件操作）
* 定义在组件内的 @Styles 可以通过 this 访问组件的常量和状态变量，可以在 @Styles 里通过事件来改变状态变量的值
* 组件内 @Styles 的优先级高于全局 @Styles

##### @Extend
基于 @styles ，用于扩展原生组件样式

``` typescript
@Extend(UIComponentName) function functionName { ... }
```
* @Extend 仅支持在全局定义，不支持在组件内部定义
* 只能在当前文件内使用，不支持 export
* 支持封装指定组件的私有属性、私有事件和自身定义的全局方法
* 支持参数，在调用时可以传递参数，调用遵循 TS 方法传值调用
 
``` typescript
@Extend(Text) function fancy (fontSize: number) {
  .fontColor(Color.Red)
  .fontSize(fontSize)
}

@Entry
@Component
struct FancyUse {
  build() {
    Row({ space: 10 }) {
      Text('Fancy')
        .fancy(16)
      Text('Fancy')
        .fancy(24)
    }
  }
}
```
* 参数可以为 function ，作为 Event 事件的句柄。
* 参数可以为状态变量，当状态变量改变时，UI 可以正常的被刷新渲染

##### stateStyles
依据组件的内部状态的不同，快速设置不同样式（多态样式）

ArkUI提供五种状态：

* focused：获焦态。

* normal：正常态。

* pressed：按压态。

* disabled：不可用态。

* selected：选中态。(API version 10+ 支持）

``` typescript
 Button('Button1')
        .stateStyles({
          focused: {
            .backgroundColor('#ffffeef0')
          },
          pressed: {
            .backgroundColor('#ff707070')
          },
          normal: {
            .backgroundColor('#ff2787d9')
          }
        })
```
##### @AnimatableExtend
用于自定义可动画的属性方法，通过逐帧回调函数修改不可动画属性值，实现动画效果。        
	
> 可动画属性：如果一个属性方法在 animation 属性前调用，改变这个属性的值可以生效animation属性的动画效果，这个属性称为可动画属性。比如 height 、width 、backgroundColor 、translate 属性，Text 组件的 fontSize 属性等。
> 
> 不可动画属性：如果一个属性方法在 animation 属性前调用，改变这个属性的值不能生效 animation 属性的动画效果，这个属性称为不可动画属性。比如 Polyline 组件的 points 属性等。

``` typescript
@AnimatableExtend(UIComponentName) function functionName(value: typeName) { 
  .propertyName(value)
}
```

* 仅支持定义在全局，不支持在组件内部定义
*  函数参数类型必须为 number 类型或者实现 AnimtableArithmetic<T> 接口的自定义类型。
*  义的函数参数类型必须为 number 类型或者实现 AnimtableArithmetic<T> 接口的自定义类型。

 AnimtableArithmetic<T> 接口说明:

| 名称                                 | 入参类型                     | 返回值类型                | 说明         |
|--------------------------------------|------------------------------|---------------------------|--------------|
| plus                                 | AnimtableArithmetic<T>       | AnimtableArithmetic<T>    | 加法函数     |
| subtract                             | AnimtableArithmetic<T>       | AnimtableArithmetic<T>    | 减法函数     |
| multiply                             | number                       | AnimtableArithmetic<T>    | 乘法函数     |
| equals                               | AnimtableArithmetic<T>       | boolean                   | 相等判断函数 |

一些AnimtableExtend动画效果展示：

![anime1](https://alliance-communityfile-drcn.dbankcdn.com/FileServer/getFile/cmtyPub/011/111/111/0000000000011111111.20240807211340.22256734201432374547211138224425:50001231000000:2800:C80D59AF2C495CDDEC1E9F774D2F75EE6073B7C492648C2F8023357BF44DD403.gif?needInitFileName=true?needInitFileName=true)![anime2](https://alliance-communityfile-drcn.dbankcdn.com/FileServer/getFile/cmtyPub/011/111/111/0000000000011111111.20240807211340.55857212477359263306689190947486:50001231000000:2800:3A150323253AA61267B668CCB11564D4474CA9CDCE780D6FF5BD7183AD7A5BC4.gif?needInitFileName=true?needInitFileName=true)

#### @Require
校验 @Prop 、@State 、@Provide 、@BuilderParam 和普通变量(无状态装饰器修饰的变量)是否需要构造传参的一个装饰器。

### 自定义组件
ArkUI 中：UI 显示的内容均为组件，由框架直接提供的称为系统组件，由开发者定义的称为自定义组件。

``` typescript
@Component
struct HelloComponent {
  @State message: string = 'Hello, World!';

  build() {
    // HelloComponent自定义组件组合系统组件Row和Text
    Row() {
      Text(this.message)
        .onClick(() => {
          // 状态变量message的改变驱动UI刷新，UI从'Hello, World!'刷新为'Hello, ArkUI!'
          this.message = 'Hello, ArkUI!';
        })
    }
  }
}
```
同 TS ，export 关键字导出，import 自定义组件

给自定义组件设置样式时，相当于套了一个不可见的容器组件，这些样式是设置在容器组件上的，而非直接设置给 Button 等组件。

#### 重渲染
以下两种情况会启动重渲染：
> * 框架观察到了变化，将启动重新渲染。
>
> * 根据框架持有的两个 map （首次渲染时候执行 build 方法渲染系统组件，如果子组件为自定义组件，则创建自定义组件的实例。在首次渲染的过程中，框架会记录状态变量和组件的映射关系，当状态变量改变时，驱动其相关的组件刷新），框架可以知道该状态变量管理了哪些 UI 组件，以及这些 UI 组件对应的更新函数。执行这些 UI 组件的更新函数，实现最小化更新。
 
#### 删除
删除自定义组件&变量，同步的变量将从同步源上取消注册
##### 节点删除机制
1. 后端节点直接从组件树上摘下
1. 后端节点被销毁
1. 对前端节点解引用
1. 前端节点已经没有引用时，将被JS虚拟机垃圾回收

### 生命周期
#### 页面生命周期
被 @Entry 装饰的组件生命周期

 ##### onPageShow
> 页面每次显示时触发一次，包括路由过程、应用进入前台等场景。
 
 ##### onPageHide
> 页面每次隐藏时触发一次，包括路由过程、应用进入后台等场景。
 
> ##### onBackPress
 用户点击返回按钮时触发。

#### 组件生命周期
@Component 装饰的自定义组件的生命周期
 ##### aboutToAppear
> 即将出现时回调该接口，具体时机为在创建自定义组件的新实例后，在执行其 build() 函数之前执行。
 
 ##### onDidBuild
> 组件 build() 函数执行完成之后回调该接口
 
##### aboutToDisappear
> 自定义组件析构销毁之前执行

#### 生命周期流程示意图
![live](https://alliance-communityfile-drcn.dbankcdn.com/FileServer/getFile/cmtyPub/011/111/111/0000000000011111111.20240813092657.17334026790310891329072807330769:50001231000000:2800:2FDD535808E0FC4AEB4ABD3A0A5A0C4BA13DDFD2264454FBDE4FACC27DD14912.png?needInitFileName=true?needInitFileName=true)

### 布局
接口：
> * onMeasureSize : 每次布局时触发，计算子组件的尺寸，其执行时间先于 onPlaceChildren
> * onPlaceChildren ：每次布局时触发，设置子组件的起始位置

### 状态管理（V2）
#### 装饰器
见上文装饰器

#### AppStorage (V2) (API version 12)
提供应用状态数据的中心存储，状态数据在应用级别都是可访问的。AppStorage V2 将在应用运行过程保留其数据。数据通过唯一的键字符串值访问。

##### connect
创建或获取储存的数据

``` typescript
static connect<T extends object>(
    type: TypeConstructorWithArgs<T>,
    keyOrDefaultCreator?: string | StorageDefaultCreator<T>,
    defaultCreator?: StorageDefaultCreator<T> 
): T | undefined;
```
| 参数                | 说明                                                                                      |
|---------------------|-------------------------------------------------------------------------------------------|
| type                | 指定的类型，若未指定 key ，则使用 type 的 name 作为 key                                          |
| keyOrDefaultCreater | 指定的 key ，或者是默认数据的构造器                                                        |
| defaultCreator      | 默认数据的构造器                                                                         |
| 返回值              | 创建或获取数据成功时，返回数据；否则返回   undefined                                        |

##### remove
删除指定 key 的储存数据

``` typescript
static remove<T>(keyOrType: string | TypeConstructorWithArgs<T>): void;
```

| 参数         | 说明                                                                                       |
|--------------|--------------------------------------------------------------------------------------------|
| keyOrType    | 需要删除的 key , 如果指定的是 type 类型，删除的 key 为 type 的 name                                |
| 返回值       | 无。                                                                                        |


##### keys
返回所有 AppStorage V2 中的 key

``` typescript
static keys(): Array<string>;
```
##### 限制
1. UI 使用（ UI 线程），不能在其他线程使用
2. 不支持 collections.Set 、collections.Map
3. 不支持非 buildin 类型，如 PixelMap 、NativePointer 、ArrayList 等 Native 类型

#### Persistence (V2)(API version 12)
持久化储存 UI 状态，会将最新数据储存在设备磁盘上（持久化）
##### connect & keys & remove
与 AppStorage V2 大致一致

##### save
手动持久化数据

``` typescript
static save<T>(keyOrType: string | TypeConstructorWithArgs<T>): void;
```
##### notifyOnError
响应序列化或反序列化失败的回调

``` typescript
static notifyOnError(callback: PersistenceErrorCallback | undefined): void;
```

##### 提醒
> 1. 不宜大量持久化数据，可能会导致页面卡顿
> 2. 单个 key 支持数据大小约 8k ，过大会导致持久化失败
> 3. 不支持循环引用的对象
> 4. 只有 @Trace 的数据改变会触发自动持久化
> 5. 持久化的数据必须是 class 对象

#### !!绑定 (API version 12)
替代 V1 中 `$$` 语法，提供双向绑定。不使用则父组件的变化是单向的。

用于初始化 @Param & @Event

* @Event 需要声明为 \$+@Param 属性名

* `!!` 双向绑定语法不支持多层父子组件传递

#### 自定义组件冻结 
> 见 @Component V2 介绍

### 渲染控制
#### 条件渲染（ if ）
支持 if 、else 和 else if

#### 循环渲染（ ForEach ）（API version 9）
##### 首次渲染
在 ForEach 首次渲染时，会根据前述键值生成规则为数据源的每个数组项生成唯一键值，并创建相应的组件。

##### 非首次渲染
在 ForEach 组件进行非首次渲染时，它会检查新生成的键值是否在上次渲染中已经存在。如果键值不存在，则会创建一个新的组件；如果键值存在，则不会创建新的组件，而是直接渲染该键值所对应的组件。

##### 使用场景
1. 数据源不变
2. 数据源数组项发生变化（如插入、删除操作）
3. 数据源数组项子属性变化

##### 可能出现的问题
1. 对键值生成规则理解问题容易导致渲染结果非预期
2. 创建组件导致的渲染性能降低

#### 懒加载LazyForEach
根据滚动容器可视区域按需创建组件，当组件滑出可视区域外时，框架会进行组件销毁回收以降低内存占用
##### 限制
* LazyForEach 必须在容器组件内使用，仅有 List、Grid、Swiper、WaterFlow 支持懒加载（可配置 cachedCount 属性，即只加载可视部分以及其前后少量数据用于缓冲），其他组件一次性加载所有数据。
* 每次迭代中，会且只会创建一个子组件
* 可以和条件渲染混合使用
* 必须使用 DataChangeListener 对象来进行更新，第一个参数 dataSource 使用状态变量时，状态变量改变不会触发 LazyForEach 的 UI 刷新
* 键值生成器必须针对每个数据生成唯一的值，如值相同会导致渲染问题
* 必须和 @Reusable 装饰器（自定义组件具备可复用的能力，它可以被添加到任意的自定义组件上）一起使用才能触发节点复用

##### 首次渲染
根据键值生成规则为数据源的每个数组项生成唯一键值
>  默认生成规则：  `viewId + '-' + index.toString()` 

##### 非首次渲染
根据数据源的变化情况调用 listener 对应的接口，通知 LazyForEach 做相应的更新

#### 混合开发 ContentSlot
渲染并管理 Native 层使用 C-API 创建的组件。

##### 接口
组件接口：

``` typescript
ContentSlot(content: Content);
```

> Content 作为 ContentSlot 的管理器，通过 Native 侧提供的接口，可以注册并触发 ContentSlot 的上下树事件回调以及管理 ContentSlot 的子组件。

例：
	
``` typescript
import { nativeNode } from 'libNativeNode.so' // 开发者自己实现的so
import { NodeContent } from '@kit.ArkUI'

@Component
struct Parent {
    private nodeContent: Content = new NodeContent();

    aboutToAppear() {
        // 通过C-API创建节点，并添加到管理器nodeContent上
        nativeNode.createNativeNode(this.nodeContent);
    }

    build() {
        Column() {
            // 显示nodeContent管理器里存放的Native侧的组件
            ContentSlot(this.nodeContent)
        }
    }
}
```

##### Native 接口
| 接口名 | 描述 |
| --- | --- |
| OH\_ArkUI\_NodeContent\_RegisterCallback(ArkUI\_NodeContentHandle content, ArkUI\_NodeContentCallback callback) | 向管理器 Content 上注册事件。 |
| OH\_ArkUI\_NodeContentEvent\_GetEventType(ArkUI\_NodeContentEvent\* event) | 获取 Content 上触发的事件类型。 |
| OH\_ArkUI\_NodeContent\_AddNode(ArkUI\_NodeContentHandle content, ArkUI\_NodeHandle node) | 在 Content 上添加子组件。 |
| OH\_ArkUI\_NodeContent\_InsertNode(ArkUI\_NodeContentHandle content, ArkUI\_NodeHandle node, int32\_t position) | 在 Content 上插入子组件。 |
| OH\_ArkUI\_NodeContent\_RemoveNode(ArkUI\_NodeContentHandle content, ArkUI\_NodeHandle node) | 在 Content 上移除子组件。 |
| OH\_ArkUI\_GetNodeContentFromNapiValue(napi\_env env, napi\_value value, ArkUI\_NodeContentHandle\* content) | 在 Native 侧获取 ArkTS 侧 Content 指针。 |
| OH\_ArkUI\_NodeContentEvent\_GetNodeContentHandle(ArkUI\_NodeContentEvent\* event) | 获取触发上下树事件的 Content 对象。 |
| OH\_ArkUI\_NodeContent\_SetUserData(ArkUI\_NodeContentHandle content, void\* userData) | 在 Content 上设置用户自定义属性。 |
| OH\_ArkUI\_NodeContent\_GetUserData(ArkUI\_NodeContentHandle content) | 在 Content 上获取用户自定义属性。 |

##### Native 侧逻辑
流程：
> 1. 声明变量
> 2. 创建原生节点
> 3. 注册上下树事件，通过事件获取对应 Content 对象
> 4. 添加子组件
> 5. 插入子组件
> 6. 删除子组件
> 7. 设置自定义属性
> 8. 获取自定义属性

例：

``` typescript
ArkUI_NodeContentHandle nodeContentHandle_ = nullptr;
ArkUI_NativeNode_API_1 *nodeAPI;

napi_value Manager::CreateNativeNode(napi_env, napi_callback_info info) {
    // napi相关处理空指针&数据越界等问题
    if ((env == nullptr) || (info == nullptr)) {
        return nullptr;
    }
    
    size_t argc = 1;
    napi_value args[1] = { nullptr };
    if (napi_get_cb_info(env, info, &argc, args, nullptr, nullptr) != napi_ok) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager", "CreateNativeNode napi_get_cb_info failed");
    }
    
    if (argc != 1) {
        return nullptr;
    }
    
    // 将nodeContentHandle_指向ArkTS侧传入的nodeContent
    OH_ARKUI_GetNodeContentFromNapiValue(env, args[0], &nodeContentHandle_);
    
    nodeAPI = reinterpret_cast<ArkUI_NativeNodeAPI_1 *>(OH_ArkUI_QueryModuleInterfaceByName(ARKUI_NATIVE_NODE, "ArkUI_NativeNode_API_1"));
    
    if (nodeAPI != nullptr) {
        if (nodeAPI->createNode != nullptr && nodeAPI->addChild != nullptr) {
            ArkUINodeHandle component;
            // 创建C侧组件，具体请查看ArkUI api文档的Capi章节
            component = CreateNodeHandle();
            // 将组件添加到nodeContent管理器中
            OH_ArkUI_NodeContent_AddNode(nodeContentHandle_, component);
        }
    }
}
auto nodeContentEvent = [](ArkUI_NodeContentEvent *event) {
    ArkUI_NodeContentHandle content = OH_ArkUI_NodeContentEvent_GetNodeContentHandle(event);
    // 针对不同content需要额外做的逻辑
    if (OH_ArkUINodeContentEvent_GetEventType(event) = NODE_CONTENT_EVENT_ON_ATTACH_TO_WINDOW) {
        // ContentSlot上树时需要触发的逻辑
    } else if (OH_ArkUINodeContentEvent_GetEventType(event) = NODE_CONTENT_EVENT_ON_DETACH_FROM_WINDOW) {
        // ContentSlot下树时需要触发的逻辑
    };
};
// 将该事件注册到nodeContent上
OH_ArkUI_NodeContent_RegisterCallback(nodeContentHandle_, nodeContentEvent);
ArkUINodeHandle component;
component = CreateNodeHandle();
// 将组件添加到nodeContent管理器中
OH_ArkUI_NodeContent_AddNode(nodeContentHandle_, component);
ArkUINodeHandle component;
component = CreateNodeHandle();
// 将组件插入nodeContent管理器对应位置
OH_ArkUI_NodeContent_InsertNode(nodeContentHandle_, component, position);
// 在nodeContent中移除对应组件
OH_ArkUI_NodeContent_RemoveNode(nodeContentHandle_, component);
// 创建需要定义的自定义数据
void *userData = CreateUserData();
OH_ArkUI_NodeContent_SetUserData(nodeContentHandle_, userData);
void *userData = OH_ArkUI_NodeContent_GetUserData(nodeContentHandle_);
```

## NDK 开发
### NDK 的使用与结构
#### 适用场景
1. 性能敏感
2. 复用已有 C/C++ 库
3. 针对 CPU 特性专项定制库的情况
  
#### 不适用场景
1. 纯 C/C++ 应用
2. 希望尽可能多兼容不同（ HarmonyOS ）设备的应用

#### Node-API
即 NAPI ，ArkTS / JS 于 C / C++ 跨语言调用使用的接口，基于 Node.js 的 Node-API ，但是与 Node-API 不（完全）兼容

> *\* C-API 为 HarmonyOS NDK 曾用名，已弃用*

#### 文件结构

```
NDK/
├── build/
│   └── cmake/
│       └── ohos.toolchain.cmake
├── build-tools/
└── llvm/
```

##### build

包含预定义的 toolchain 脚本``` ohos.toolchain.cmake ```，编译时会通过 CMAKE_TOOLCHAIN_FILE 指出该文件的路径。

##### build-tools
NDK 提供的编译工具

#### llvm
NDK 提供的编译器

### 构建

#### ohos.toolchain.cmake
用于 CMAKE 的 toolchain 脚本，参数如下：
| 参数 | 类型 | 说明 |
| --- | --- | --- |
| OHOS\_STL | c++\_shared/c++\_static | libc++ 的链接方式。默认为 c++\_shared 。c++\_shared 表示采用动态链接 libc++\_shared.so ; c++\_static 表示采用静态链接 libc++\_static.a 。由于 C++ 运行时中存在一些全局变量，因此同一应用中的全部 Native 库需要采用相同的链接方式。 |
| OHOS\_ARCH | armeabi-v7a/arm64-v8a/x86\_64 | 设置当前 Native 交叉编译的目标架构，当前支持的架构为 armeabi-v7a/arm64-v8a/x86\_64 。 |
| OHOS\_PLATFORM | OHOS | 选择平台。当前只支持 HarmonyOS 平台。 |

#### DevEco Studio 模版构建（默认 , 推荐）
##### CMakeLists.txt
包含源代码、头文件以及三方库，编译参数

##### externalNativeOptions
参数列表：
| 配置项 | 类型 | 说明 |
| --- | --- | --- |
| path | string | CMake 构建脚本地址，即 CMakeLists.txt 文件地址。 |
| abiFilters | array | 本机的ABI编译环境，包括：<ul><li>arm64-v8a</li><li>x86_64</li></ul> 如不配置该参数，编译时默认编译出 arm64-v8a 架构相关so。 |
| arguments | string | CMake 编译参数。 |
| cppFlags | string | C++ 编译器参数。 |

#### CMAKE 构建
##### 环境

``` bash
export PATH=~/Ndk/mac-sdk-full/sdk/packages/ohos-sdk/darwin/native/build-tools/cmake/bin:$PATH
```

##### 编译（以 linux & mac 为例）
采用 O`HOS_STL=c++_shared` 动态链接 c++ 库方式构建工程，如不指定，默认采用 c++_shared ；DOHOS_ARCH 参数可根据系统架构来决定具体值。

``` bash
mkdir build && cd build
cmake -DOHOS_STL=c++_shared -DOHOS_ARCH=armeabi-v7a -DOHOS_PLATFORM=OHOS -DCMAKE_TOOLCHAIN_FILE={ohos-sdk}/linux/native/build/cmake/ohos.toolchain.cmake ..
cmake --build .
```

采用 `OHOS_STL=c++_static` 静态链接 c++ 库方式构建工程。

``` bash
 >mkdir build && cd build
 >cmake -DOHOS_STL=c++_static -DOHOS_ARCH=armeabi-v7a -DOHOS_PLATFORM=OHOS -DCMAKE_TOOLCHAIN_FILE={ohos-sdk}/linux/native/build/cmake/ohos.toolchain.cmake ..
 >cmake --build .
 ```

命令中，`OHOS_ARCH` 与 `OHOS_PLATFORM` 两个变量最终会生成 clang++ 的 --target 命令参数，

在此例子中就是 `--target=arm-linux-ohos --march=armv7a` 两个参数；

`CMAKE_TOOLCHAIN_FILE` 指定了toolchain文件，

在此文件中默认给 clang++ 设置了 `--sysroot={ndk_sysroot目录}` ，告诉编译器查找系统头文件的根目录。

> **注意:** ohos-sdk 是下载下来的 SDK 的根目录，开发者需要自行替换成实际的下载目录。

#### 毕昇编译器
基于 LLVM 开源软件开发的一款用于 C / C++ 等语言的 native 编译器
* 运行时间更短
* 指令数更少

##### 主要特点：

###### 循环加速
额外识别出循环内不同代码块间数据依赖关系、以及不同代码块运行的迭代次数差别，对更多的循环进行 loop distribution 优化。

###### 矢量化优化
* 更多的矢量化转换
* 更高效的指令选择

## 工具

### CodeGenic
> * 处于测试阶段，需通过[华为社区](https://developer.huawei.com/consumer/cn/personalcenter/overview)申请权限。
> 
> * 申请通过后前往[个人下载中心](https://developer.huawei.com/consumer/cn/download/)下载插件，通过本地磁盘安装至 DevEco Studio。
> * Github Copilot 1.4.6 可以正常安装和使用（通过 Jetbrains 官网下载），但是 chat 功能无法补全华为生态的语法，文中 Tab 自动补全也仅基于上下文(并混杂 TS 语法)。

#### 代码补全
暂不支持自动补全，`ALT+R` 触发补全
> 请保证代码上下10行内有效行>5行

##### 快捷键
> * Alt + \（macOS : opt + \）：触发代码补全，显示灰度代码
> * Tab：应用灰度的生成代码
> * Esc：取消灰度的生成代码
> * Ctrl + 1（macOS : cmd + 1）：**token 级**应用灰度代码
> * Ctrl + 2（macOS : cmd + 2）：**token 级**回退灰度代码

#### Chat
大体使用与 Copilot Chat 类似

##### 卡片生成（万能卡片）
可以给大模型提供所需卡片的用途、功能、尺寸以生成对于的卡片预览图和代码。生成后可以直接下载或者插入卡片的逻辑代码、UI代码、配置信息和静态资源文件
> * 用途：如直播类、美食推荐类、热映电影等。
> * 功能：指组件，如图标、标题、按钮以及组件的状态信息等，如图标主题、标题内容、按钮显示的文字等
> * 尺寸：可选项，现在仅支持1\*2（微卡片）、2\*2（小卡片）、2\*4（中卡片）、4\*4（大卡片）四种尺寸

\* 当前不支持在生成预览图后，继续按照要求修改卡片

### HDC
类似安卓的 ADB

#### 环境
##### 环境变量 HDC_SERVER_PORT（MacOS & Linux）

.zshrc
``` bash
HDC_SERVER_PORT=7035
launchctl setenv HDC_SERVER_PORT $HDC_SERVER_PORT
export HDC_SERVER_PORT
```

##### 全局环境变量（Linux & MacOS）
.zshrc
``` bash
HDC_SDK_PATH=/User/username/sdk/HarmonyOS/10/toolchains
launchctl setenv HDC_SDK_PATH $HDC_SDK_PATH # 仅MacOS需要在此执行，Linux无须执行
export PATH=$PATH:$HDC_SDK_PATH
```
* 具体路径信息以 SDK 实际配置路径为准


#### HDC 基础功能
##### HDC 信息
``` bash
hdc -v 显示版本
hdc -h 帮助
```
##### 设备列表

``` bash
hdc list target [-v]
```
显示连接的设备列表及其标识符

可选项 `-v` 可用于显示设备的详细信息

##### 连接设备

###### 有线连接
``` bash
hdc -t [connect-key] [command]
```
用于连接设备，`connect-key` 通过 `hdc list targets` 查询
* 如果通过 usb 连接，标识符为序列号；如果通过网络连接设备，标识符为 `IP地址:端口号`
  
连接单台设备时，执行命令无需指定设备标识符；连接了多台设备时，每次执行命令时需要指定目标设备的标识符。

###### 无线连接

``` bash
hdc tconn [IP]:[port] [-remove]
```
`-remove` 可选性为断开指定网络设备连接

##### 日志等级

``` bash
hdc -l [level] [command]
```
###### `[level]` 可选参数(直接使用对应数字，不要使用 string )
0. LOG_OFF

1. LOG_FATAL

2. LOG_WARN

3. LOG_INFO

4. LOG_DEBUG

5. LOG_ALL

##### 终止 HDC 服务进程

``` bash
hdc kill [-r]
```
可选项 `-r` 为重启并终止服务进程

##### 启动 HDC 服务进程

``` bash
hdc start [-r]
```
可选项 `-r` 为服务进程启动状态下，触发服务进程重新启动

##### 切换连接方式（ USB / 无线）

``` bash
hdc tmode usb
hdc tmode port [port-number]
```

#### HDC 网络命令

##### 列出全部转发端口转发任务

``` bash
hdc fport ls
```
返回值中 `Forward` 代表正向端口转发任务，`Reverse` 表示反向端口转发任务，`empty` 表示无端口转发任务

##### 设置正向端口转发任务

``` bash
hdc fport localnode remotenode
```
监听“主机端口”，接收请求并进行转发，转发到“设备端口”

##### 设置反向端口转发任务

``` bash
hdc rport remotenode localnode
```
将指定的“设备端口”转发数据到“主机端口”转发任务

##### 删除端口转发任务
 删除指定的转发任务

 ``` bash
 hdc fport rm taskstr
 ```
 `taskstr` 形如 `tcp:XXXX tcp:XXXX`


#### HDC 文件指令
##### 从本地发送文件到远端设备
``` bash
hdc file send localpath remotepath
```

##### 从远端设备发送文件至本地
``` bash
hdc file recv remotepath localpath
```

#### HDC APP 指令
##### 安装 APP
``` bash
hdc install [-r|-s] src
```
| 参数 | 说明 |
| --- | --- |
| -r | 替换已存在应用（.hap） |
| -s | 安装一个共享包（.hsp） |

##### 卸载 APP
``` bash
hdc uninstall [-k|-s] packageName
```
| 参数 | 说明 |
| --- | --- |
| -k | 保留/data和/cache目录 |
| -s | 卸载共享包 |

#### HDC 调试指令
| 命令 | 说明 |
| --- | --- |
| `hdc jpid` | 显示可调试应用列表 |
| `hdc hilog [options]` | 打印设备端的日志信息，options 表示 hilog 支持的参数，可通过`hdc hilog -h`查阅支持的参数列表 |
| `hdc shell [command]` | 交互命令，`[command]` 表示需要执行的单次命令，不同类型或版本的系统支持的 command 命令有所差异，可以通过 `hdc shell ls /system/bin` 查阅支持的命令列表 |


## 附录

### 名词解释

*华为文档中常使用的缩写和“黑话”*

#### A
##### abc文件
方舟字节码（ArkCompiler Bytecode）文件，是ArkCompiler的编译工具链以源代码作为输入编译生成的产物，其文件后缀名为.abc。在发布态，abc文件会被打包到HAP中。

##### ANS
Advanced Notification Service，通知增强服务，是HarmonyOS中负责处理通知的订阅、发布和更新等操作的系统服务。

##### Atomic Service，元服务
原名原子化服务，是HarmonyOS提供的一种面向未来的服务提供方式，是有独立入口的（用户可通过点击服务卡片打开元服务）、免安装的（无需显式安装，由系统程序框架后台安装后即可使用）用户应用程序形态。

##### ArkUI
方舟开发框架，是为HarmonyOS平台开发极简、高性能、跨设备应用设计研发的UI开发框架，支撑开发者高效地构建跨设备应用UI界面。

##### ArkCompiler
方舟编译器，是华为自研的统一编程平台，包含编译器、工具链、运行时等关键部件，支持高级语言在多种芯片平台的编译与运行，可支撑传统应用、元服务运行在手机、个人电脑、平板、电视、汽车和智能穿戴等多种设备上的需求。

#### C
##### CES
Common Event Service，是HarmonyOS中负责处理公共事件的订阅、发布和退订的系统服务。

##### Cross-device migration，跨端迁移
是一种实现用户应用程序流转的技术方案。指在A端运行的用户应用程序，迁移到B端上并从迁移时刻A端状态继续运行，然后A端用户应用程序退出。

#### D
##### DV
Device Virtualization，设备虚拟化，通过虚拟化技术可以实现不同设备的能力和资源融合。

#### E
##### ExtensionAbility
Stage模型中的组件类型名，即ExtensionAbility组件，提供特定场景（如卡片、输入法）的扩展能力，满足更多的使用场景。

#### F
##### FA
Feature Ability，在FA模型中代表有界面的Ability，用于与用户进行交互。

##### FA模型
HarmonyOS早期版本开始支持的应用模型，已经不再主推。建议使用新的Stage模型进行开发。

#### H
##### HAP
Harmony Ability Package，一个HAP文件包含应用的所有内容，由代码、资源、三方库及应用配置文件组成，其文件后缀名为.hap。

##### HDF
Hardware Driver Foundation，硬件驱动框架，用于提供统一外设访问能力和驱动开发、管理框架。

##### HML
HarmonyOS Markup Language，是一套类HTML的标记语言。通过组件、事件构建出页面的内容。页面具备数据绑定、事件绑定、列表渲染、条件渲染等高级能力。

##### Hop，流转
在HarmonyOS中泛指涉及多端的分布式操作。流转能力打破设备界限，多设备联动，使用户应用程序可分可合、可流转，实现如邮件跨设备编辑、多设备协同健身、多屏游戏等分布式业务。

流转为开发者提供更广的使用场景和更新的产品视角，强化产品优势，实现体验升级。

#### I
##### IDN
Intelligent Distributed Networking，是HarmonyOS特有的分布式组网能力单元。开发者可以通过IDN获取分布式网络内的设备列表和设备状态信息，以及注册分布式网络内设备的在网状态变化信息。

#### M
##### Manual hop，用户手动流转
是指开发者在用户应用程序中内嵌规范的流转图标，使用户可以手动选择合适的可选设备进行流转。用户点击图标后，会调起系统提供的流转面板。面板中会展示出用户应用程序的信息及可流转的设备，引导用户进行后续的流转操作。

##### MSDP
Mobile Sensing Development Platform，移动感知平台。MSDP子系统提供分布式融合感知能力，借助HarmonyOS分布式能力，汇总融合来自多个设备的多种感知源，从而精确感知用户的空间状态、移动状态、手势、运动健康等多种状态，构建全场景泛在基础感知能力，支撑智慧生活新体验。

##### Multi-device collaboration，多端协同
是一种实现用户应用程序流转的技术方案。指多端上的不同FA/PA同时运行、或者接替运行实现完整的业务；或者，多端上的相同FA/PA同时运行实现完整的业务。

#### P
##### PA
Particle Ability，在FA模型中代表无界面的Ability，主要为Feature Ability提供支持，例如作为后台服务提供计算能力，或作为数据仓库提供数据访问能力。

#### S
##### Service widget，服务卡片
将用户应用程序的重要信息以服务卡片的形式展示在桌面，用户可通过快捷手势使用卡片，以达到服务直达、减少层级跳转的目的。

##### Stage模型
HarmonyOS 3.1 Develper Preview版本开始新增的应用模型，提供UIAbility、ExtensionAbility两大类应用组件。由于该模型还提供了AbilityStage、WindowStage等类作为应用组件和Window窗口的“舞台”，因此称之为Stage模型。

##### Super virtual device，超级虚拟终端
亦称超级终端，通过分布式技术将多个终端的能力进行整合，存放在一个虚拟的硬件资源池里，根据业务需要统一管理和调度终端能力，来对外提供服务。

##### System suggested hop，系统推荐流转
是指当用户使用用户应用程序时，所处环境中存在使用体验更优的可选设备，则系统自动为用户推荐该设备，用户可确认是否启动流转。

#### U
##### UIAbility
Stage模型中的组件类型名，即UIAbility组件，包含UI，提供展示UI的能力，主要用于和用户交互。