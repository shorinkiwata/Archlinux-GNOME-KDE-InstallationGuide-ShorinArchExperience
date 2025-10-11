# 目录

1. [安装任意linux系统的前期准备工作](#安装任意linux系统的前期准备工作)
2. [archlinux安装教程](#archlinux安装教程)
3. [安装桌面环境前的准备](#安装桌面环境前的准备)
4. [显卡驱动和硬件编解码](#显卡驱动和硬件编解码)
5. [安装桌面环境](#安装桌面环境)
6. [快照](#快照)
7. [yay-AUR助手](#yay-AUR助手)
8. [中文输入法](#中文输入法)
9. [软件安装相关及我使用的软件](#软件安装相关)
10. [我的GNOME自定义设置](#我的GNOME自定义设置)
11. [我的KDE自定义设置](#我的KDE自定义设置)
12. [终端美化](#终端美化)
13. [Grub美化](#Grub美化)
14. [显卡切换](#显卡切换)
15. [虚拟机](#虚拟机)
16. [KVM虚拟机](KVM虚拟机)
17. [远程桌面](#远程桌面)
18. [显卡直通](#显卡直通)
    - [LookingGlass](#LookingGlass)
19. [KVM虚拟机性能优化和伪装](#KVM虚拟机性能优化和伪装)
20. [Linux玩游戏](#Linux玩游戏)
21. [Linux性能优化](#Linux性能优化)
22. [小技巧](#小技巧)
23. [干净删除Linux](#干净删除Linux)
24. [issues](#issues)
25. [附录](#附录)

# 安装任意linux系统的前期准备工作

## 解决安装Linux后Windows时间错乱的问题

[双系统时间同步-CSDN博客](https://blog.csdn.net/zhouchen1998/article/details/108893660)

Linux会把硬件时间改成标准UTC时间，然后根据系统设置的时区对UTC时间进行加减后显示出来。Windows默认读取主板硬件时间作为本地时间，所以此时你Windows显示的时间就变成了标准UTC时间而不是中国 UTC+8。表面上看就像是windows时间错乱。

Windows下管理员身份打开powershell 运行

```powershell
Reg add HKLM\SYSTEM\CurrentControlSet\Control\TimeZoneInformation /v RealTimeIsUniversal /t REG_DWORD /d 1
```

`Reg add` 添加一个注册表项目

`HKLM\SYSTEM\CurrentControlSet\Control\TimeZoneInformation`是路径

`/v RealTimeIsUniversal` /v指定项目名称

`/t REG_DWORD` /t指定数据类型为REG_DWORD（32位无符号整数）

`/d 1` /d指定具体的值，1代表启用

上面这条命令修改注册表，让Windows采用和Linux相同的策略，默认硬件时间为UTC，根据系统设置的时区进行相应的加减后再显示。

另一种方法是让Linux使用本地时间`timedatectl set-local-rtc 1`，我没试过，说不定会在日志、定时任务之类的地方出问题。由于我主要使用Linux，所以使用上面的方法。

## 下载ISO文件

去想要安装的Linux系统的官网下载ISO文件。官网下载慢的话可以找一找镜像站，主流Linux发行版通常会在下载页面提供镜像站链接。

- [Archlinux](https://archlinux.org/download/)
- [LinuxMint](https://linuxmint.com/download.php)

## 制作系统盘

### ⚠️警告：注意备份重要数据⚠️

### 方法一 ：压缩卷（没有u盘使用这个方法）

1. windows系统内win+x键，选择磁盘管理。找到想安装archlinux的位置，右键选择压缩卷，空出磁盘空间。
2. 右击空出的空间选择新增简单卷，大小设置为4096MB（足够装下iso里面的文件就行），盘符随意，格式化选择FAT32。
3. 双击打开iso，把里面的内容粘贴进刚刚新建的盘符里。

### 方法二：ventoy

[ventoy/Ventoy: A new bootable USB solution.](https://github.com/ventoy/Ventoy)

ventoy制作的系统盘可以存放多个系统镜像，推荐。

不知道怎么下载的话下载[图吧工具箱](https://www.tbtool.cn/)，在“其他工具”页面里有ventoy

## 进BIOS关闭安全启动

进入BIOS关闭安全启动（security boot）。不同的机器进bios方法不同，现代电脑通常是esc、f2、delete，如果不行的查找一下自己主板进bios的方法。

## 选择启动项

启动项选择刚刚制作的系统盘。引导界面会显示你是bios还是uefi，然后系统载入内存。这个环境被称作live环境。

### BIOS和UEFI

本文[安装Archlinux](安装ArchLinux)一节只包含UEFI+GPT环境下的安装，不涉及BIOS+MBR下安装。如果你的设备不支持UEFI，在安装引导程序的部分会有不同。

# archlinux安装教程

1. [手动安装](#手动安装)
2. [脚本安装](#脚本安装)

两种安装方式，按需选择。值得一提的是脚本安装可能会出现意想不到的报错。本文的手动安装部分的讲解要比脚本安装详细，建议阅读。

我假设你会最基本的电脑操作。如果你不懂的话我简单说一下：方向键可以移动光标进行选择，enter键确认选择、换行、执行命令，esc键退出，backspace删除文本。记住这些就足够了。

## 重要概念讲解

### Linux目录结构

Linux的目录是由 / 左斜杠开头的树状结构，/是一切的开始，所以被称为根目录（root目录）。例如/home就是根目录下的home目录，/home/shorin就是根目录下的home目录里面的shorin目录。

### 挂载

意思是把分区对应到某个目录。

#### 挂载点（mount point）

假设把/dev/nvme0n1这个设备挂载到/home目录，那就称/dev/nvme0n1的挂载点为/home。

### 文件系统

[archwiki file system](https://wiki.archlinux.org/title/File_systems)

文件系统决定了文件的存放和检索方式，根分区文件系统常用的有btrfs、ext4、xfs，不同的文件系统有不同的功能和特性。本文使用btrfs文件系统，最大的特点是快照（相当于存档和回档）

### Bootloader引导程序

[archwiki_arch_boot_process](https://wiki.archlinux.org/title/Arch_boot_process#Boot_loader)

引导程序，用来引导系统启动。grub最为常用。arch用户也有很多使用systemd-boot，这个引导程序非常精简。其他也有很多，有兴趣的可以看archwiki的介绍。

### EFI系统分区（ESP） 

[efi system partition](https://wiki.archlinux.org/title/EFI_system_partition)

用于存放.efi文件，这是启动系统的“第一把钥匙”。esp的文件系统必须是FAT。

### ESP挂载点

 常用挂载点为/boot、/boot/efi和/efi。

/boot是最典型的挂载点，很多bootloader程序只有esp挂载点为/boot时才能正常工作。由于/boot还存放着内核文件，所以/boot做挂载点需要分配较大空间。

使用Grub和rEFind时，esp挂载点可以是任意位置，但通常是/boot/efi或者/efi。因为/boot/efi会复杂化挂载过程，所以此时的推荐挂载点为/efi。

影响esp挂载点选择的另一大因素是btrfs的快照功能。esp必须使用FAT文件系统，挂载点为/boot，则无法使用btrfs快照记录和恢复/boot。假设创建快照时的内核版本是6.16，然后更新到了6.17，然后用快照进行回档。此时你的系统文件会被恢复到6.16，但是/boot里的内核文件仍然是6.17，版本不一致导致系统无法正常启动。所以如果要使用btrfs快照，/boot必须是btrfs文件系统。虽然也有完全备份/boot的用法，但是都很繁琐，不如直接把/boot包含进btrfs。

另外，这种情况下无法使用systemd-boot，使用grub也会产生问题。grub无法在btrfs写入grubenv（记忆启动项等功能相关）。解决办法是把grub装进esp。此时要注意，grub在esp内意味着无法被快照，假设你创建快照时的内核只有linux，然后你安装了linux-zen并更新了grub的配置文件使grub多出了linux-zen的启动项。快照回滚后不会修改grub配置文件，grub中的linux-zen因此成为了“幽灵启动项”。手动更新一次grub的配置文件即可解决这个问题。如果不在意记忆启动项之类的功能，可以保持默认安装位置（`/boot/grub`）享受快照的便利。本文采用grub装进esp的方案。

顺便一提，esp挂载点为/efi，grub装进esp，这个方案的esp内只存放.efi文件和grub的文件，文件大小加起来只有17MB左右，所以分配给esp的空间可以非常小，但是我依旧选择给esp分512MB，奢侈！



## 手动安装

参考链接：

[archlinux 简明指南](https://arch.icekylin.online/)

[安装指南 - Arch Linux 中文维基](https://wiki.archlinuxcn.org/wiki/%E5%AE%89%E8%A3%85%E6%8C%87%E5%8D%97)

### 连接网络

有线网自动连接，wifi要自己用命令行工具连接。使用如下命令确认网络连接：

```
ip a #查看网络连接信息
ping bilibili.com #确认网络正常
```

Ctrl+C可以中止正在运行的命令。

- 使用iwctl命令行工具连接wifi（此工具由`iwd`提供）

  1. 启动

     ```
     iwctl
     ```

     此时会进入iwctl，提示符会产生变化。

  2. 连接

     ```
     station wlan0 connect 【此处是你的wifi名字（不能是中文）】
     ```

  3. 退出iwctl

     ```
     exit
     ```

  4. 其他命令

     ```
     device list #列出设备
     station wlan0 scan #扫描网络
     station wlan0 get-networks #列出所有扫描的的wifi
     station wlan0 show #查看连接状态
     station wlan0 disconnect #断开连接
     ```

### 同步时间

```shell
timedatectl set-ntp true 
```

这条命令让arch连接到互联网上的公共时间服务器

### reflector自动设置镜像源

用reflector配置最快最新的国内镜像源，大幅提高下载速度。

```
reflector -a 24 -c cn -f 10 --sort score --save /etc/pacman.d/mirrorlist --v

-a（age） 24 指定最近24小时更新过的源
-c（country） cn 指定国家为中国（可以增加邻国）
-f（fastest） 10 筛选出下载速度最快的10个
--sort score 按照下载速度和同步时间综合评分并排序，比单纯按照下载速度排序更可靠
--save /etc/pacman.d/mirrorlist 将结果保存到/etc/pacman.d/mirrorlist
--v（verbose） 过程可视化
```

### 更新密钥

```
pacman -Sy archlinux-keyring

pacman是包管理器，管理软件的安装、卸载之类的
-S代表安装
-Sy代表同步数据库然后安装
```

### 可选：探索Linux文件

如果你有兴趣，可以安装一个终端管理器查看当前Live环境的目录。

```
pacman -S yazi
```

[yazi](https://yazi-rs.github.io/)是好用的终端文档管理器，功能方便的同时内存占用也很低，另外比较常用的还有[ranger](https://github.com/ranger/ranger)。

用`yazi`命令开启鸭子

```
yazi
```

此时应该会处在一个空的/root目录，按左方向键切换到上级目录。

左中右三块区域，左边是上级目录，中间是当前目录，右边是下级目录。上下左右键切换（或者使用vim key，jkhl对应上下左右）。想看什么自己决定吧。

q键退出yazi。ctrl+L清屏。

### 硬盘分区

```shell
lsblk -pf  #查看当前分区情况
fdisk -l /dev/想要查询详细情况的硬盘  #小写字母l，查看详细分区信息
```

```shell
cfdisk /dev/nvme0n1 #选择自己要使用的硬盘进行分区
```

1. 如果是新硬盘的话会弹出选项，选GPT。

2. efi分区

   创建512MB的分区，类型（type）选择efi system。

   PS：也可以直接使用windows的efi，如果使用win的efi分区的话跳过下面格式化efi分区的步骤（windows更新会搞坏linux的引导，建议给linux单独创建efi分区）。

3. 根分区

   其余空间全部分到一个分区里，类型linux filesystem。

#### 格式化分区

1. 再次查看分区情况

   ```shell
   lsblk -pf #查看分区情况
   fdisk -l /dev/想要查询详细情况的硬盘  #小写字母l，查看详细分区信息
   ```

2. 格式化efi分区

   ```shell
   mkfs.fat -F 32 /dev/nvme0n1p1（EFI分区名）
   ```

3. 格式化btrfs根分区

   ```shell
   mkfs.btrfs /dev/nvme0n1p2（根分区名）
   
   #加上-f参数可以强制格式化
   ```

#### 创建btrfs子卷

子卷是btrfs的一个特性，跟快照（相当于存档和回档）有关。通常至少要创建root子卷（存放系统文件）和home子卷（存放用户文件），也就是@和@home。由于这两者是平级关系，所以创建@快照时不会包含@home。这样就可以只恢复系统文件，不影响用户数据。

- 挂载

  ```shell
  mount -t btrfs -o compress=zstd /dev/nvme0n1p2（根分区名） /mnt
  ```

  ```
  mount 挂载命令
  -t 指定文件系统
  -o 指定额外的挂载参数
  conpress=zstd 指定透明压缩，zstd是压缩算法
  ```

  /mnt是根目录下的子目录，用于手动临时挂载外部设备。我们之前从u盘加载的其实也是一个的archlinux系统，称为live环境。这里的/mnt就是u盘系统（live环境）的/mnt目录。这条命令把/dev/nvme0n1p2分区挂载到了/mnt目录，而/dev/nvme0n1p2是我们将要安装的系统的根分区，这意味着/mnt成为了我们将要安装的系统的根目录。

  compress是btrfs的另一个特性，透明压缩。可以通过算法在数据写入磁盘前先对数据进行压缩，用以节省磁盘空间，延长磁盘寿命，代价是一点点cpu占用，但极小，对现代硬件来说几乎可以忽略不计。zstd是最平衡的压缩算法，可以像这样zstd:3指定压缩等级，最高15，通常3就可以了。

- 创建子卷

  ```shell
  btrfs subvolume create /mnt/@
  btrfs subvolume create /mnt/@home
  btrfs subvolume create /mnt/@swap #不需要睡眠到硬盘功能的话跳过这个
  ```

- 可选：确认

  ```shell
  btrfs subvolume list -p /mnt
  ```

- 取消挂载

  ```shell
  umount /mnt
  ```

### 正式挂载

1. 挂载root子卷

   ```
   mount -t btrfs -o subvol=/@,compress=zstd /dev/nvme0n1p2 /mnt
   ```

   和刚刚的挂载是一样的操作，不过这次是把/dev/nvme0n1p2上的@子卷挂载到了/mnt，而不是把/dev/nvme0n1p2挂载到/mnt。

2. 挂载home子卷

   ```
   mount --mkdir -t btrfs -o subvol=/@home,compress=zstd /dev/nvme0n1p2 /mnt/home
   ```

   由于/mnt下没有/mnt/home这个目录，所以要加上`--mkdir`命令创建/mnt/home用来挂载。把@home子卷挂载到了/mnt/home。

3. 可选：挂载swap子卷（不需要睡眠功能的话跳过这一步）

   ```
   mount --mkdir -t btrfs -o subvol=/@swap,compress=zstd /dev/nvme0n1p2 /mnt/swap
   ```

4. 挂载efi分区（esp）

   ```
   mount --mkdir /dev/nvme0n1p1 /mnt/efi
   ```

   记得把/dev/nvme0n1p1替换为自己对应的efi分区设备名。

5. 复查挂载情况

   ```
   df -h
   ```

### 安装系统

```
pacstrap -K /mnt base base-devel linux linux-firmware btrfs-progs

-K 复制密钥
base-devel是编译其他软件的时候用的
linux是内核，可以更换
linux-firmware是固件
btrfs-progs是btrfs文件系统的管理工具
```

pacstrap命令是把软件安装到指定的根目录下。

注意：如果你使用的是marvell的无线网卡，这里要额外安装linux-firmware-marvell，否则进系统找不到网卡。

### 安装必要的功能性软件

```
pacstrap /mnt networkmanager vim sudo amd-ucode

networkmanager 是联网用的，和kde和gnome深度集成，有特殊需求的话可以换成别的
vim 是文本编辑器，也可以换成别的，比如nano、neovim。
sudo 和权限管理有关
amd-ucode 是微码，用来修复和优化cpu，intel用户安装intel-ucode
```

可以再次运行yazi看到刚才在/mnt下安装的东西。

#### vim文本编辑器基础操作

vim是以键盘操作为核心理念的文本编辑器

`/`左斜杠进如搜索模式，回车跳转到搜索到的第一个，`n`n键跳转到搜索到的下一个，`Shift+n`跳转到搜索到的上一个；

`i `键进入编辑模式；

`esc` 退出编辑模式；

`:w` 冒号小写w写入；

`:q` 冒号小写q退出；

`:wq `冒号小写wq保存并退出；

`! `命令后加上感叹号代表强制执行。

知道这些就可以开始使用了。不习惯的话可以安装nano。nano的基础操作只需要记住Ctrl+F搜索、Ctrl+S保存和Ctrl+X退出即可。你也可以选择安装neovim，vim的加强版，更现代更好用。如果安装neovim的话后面所有`vim`命令都改成`nvim`

#### ⚠️没有联网软件的话一会安装完系统连不了网⚠️

### 可选：swap交换空间

参考链接：

[Swap - ArchWiki](https://wiki.archlinux.org/title/Swap)

[Swap - Manjaro](https://wiki.manjaro.org/index.php/Swap)

swap与虚拟内存有关。如果设置了硬盘swap的话还可以使用睡眠功能能。睡眠指的是把系统当前状态写入硬盘，然后电脑完全断电，下一次开机恢复到睡眠前的状态。硬盘swap有swap分区或者swap文件两种方式，前者配置更简单，后者配置稍复杂，但是更加灵活。这里采用交换文件的方式。

如果你不需要睡眠功能的话别设置硬盘swap，后续会有将内存用作swap的设置。

swap大小参考：

| 内存(GB) | 不需要睡眠(GB) | 需要睡眠（GB） | 不建议超过（GB） |
| -------- | -------------- | -------------- | ---------------- |
| 1        | 1              | 2              | 2                |
| 2        | 2              | 3              | 4                |
| 3        | 3              | 5              | 6                |
| 4        | 4              | 6              | 8                |
| 5        | 2              | 7              | 10               |
| 6        | 2              | 8              | 12               |
| 8        | 3              | 11             | 16               |
| 12       | 3              | 15             | 24               |
| 16       | 4              | 20             | 32               |
| 24       | 5              | 29             | 48               |
| 32       | 6              | 38             | 64               |
| 64       | 8              | 72             | 128              |
| 128      | 11             | 139            | 256              |
| 256      | 16             | 272            | 512              |

1. 创建swap文件

   ```
   btrfs filesystem mkswapfile --size 64g --uuid clear /mnt/swap/swapfile
   ```

2. 启动swap

   ```
   swapon /mnt/swap/swapfile
   ```

### 生成fstab文件

系统会根据fstab中的内容自动进行挂载。

```shell
genfstab -U /mnt > /mnt/etc/fstab
```

```
genfstab（生成文件系统表）
-U 用uuid指定分区
 > 大于号代表输出结果覆盖写入到有右边的文件里
 如果是>>两个大于号则代表追加写入
```

### 为双系统做准备

win和linux分别处在不同的efi分区里，所以为了检测到windows，需要挂载windows的efi分区。在genfstab之后才进行是因为没有必要自动挂载win的efi分区。

```shell
lsblk -pf 
```

找到有ntfs字样的那块盘，win的efi分区通常是那块盘的p1。如果想谨慎一点可以用`fdisk -l`查看详细信息。

```shell
fdisk -l /dev/nvme1n1
```

找到后挂载到/mnt下的任意目录即可，为了可读性我挂载到/mn/winboot

```shell
mount --mkdir /dev/nvme1n1p1 /mnt/winboot 
```

记得/dev/nvme1n1p1替换为自己windows efi分区对应的设备名。

### 更换根目录（change root）

进入刚刚安装的系统

```shell
arch-chroot /mnt
```

此时根目录从live环境变成了/mnt，可以注意到提示符的变化。

### 设置时间和时区

```shell
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
```

ln 是link的缩写，-s代表跨文件系统的软链接，-f代表强制执行，所以这条命令的意思是在/etc/目录下创建/usr/.../Shanghai这个文件的链接，取名为localtime。zoneinfo里面包含了所有可用时区的文件，localtime是系统确认时间的依据。

```
hwclock --systohc #系统时钟写入主板硬件时钟
```

### 本地化设置

1. 编辑配置文件

   ```
   vim /etc/locale.gen
   ```

   左斜杠键进行搜索；`i`键进入编辑模式；取消en_US.UTF-8 UTF-8和zh_CN.UTF-8的注释；`esc`退出编辑模式；`:wq`保存并退出。

2. 生成本地化配置

   ```
   locale-gen
   ```

3. 设置系统语言

   ```
   vim /etc/locale.conf
   ```

   `i`键进入编辑模式；写入`LANG=en_US.UTF-8`设置系统语言为英文；

   ```
   LANG=en_US.UTF-8
   ```

   `esc`退出编辑模式；`:wq`保存并退出。

   `/etc/locale.conf`这个文件是系统级的语言设置，`zh_CN.UTF-8`是中文，但是会导致tty的文件变成豆腐块，所以不建议这么做。后续安装完桌面环境后通过桌面环境提供的选项在用户空格修改系统语言即可。例如通过AccountService的偏好储存功能，你上次登录的会话、系统语言等内容都会存在`/var/lib/AccountService/users/你的用户名`这个文件里面。没有显示管理器的话可以在`~/.config/locale.conf`写入中文设置，覆盖掉`/etc/locale.conf`的设置。

### 设置主机名

```
vim /etc/hostname
```

`i`键进入编辑模式；取一个自己喜欢的主机名；`esc`退出编辑模式；`:wq`保存并退出。

PS：此时你应该已经相当熟悉vim编辑器最基本的操作了，所以后面我会省略vim的操作讲解。

### 设置root密码

```
passwd 
```

输入过程不显示，直接输入回车即可。

### 安装引导程序

就像前面[重要概念讲解](#重要概念讲解)部分说的那样，根据esp挂载点和个人需求的不同，bootloader的选择也会不同。这里安装最常用的grub，采用的是esp挂载点为`/efi`，grub装进esp的方案。

1. 安装必要的软件包

   ```shell
   pacman -S grub efibootmgr os-prober
   ```

   `efibootmgr` 管理uefi启动项；`os-prober` 用来搜索win11。

2. 安装grub

   ```
   grub-install --target=x86_64-efi --efi-directory=/efi --boot-directory=/efi --bootloader-id=ARCH 
   ```

   `grub-install`安装grub；

   `--target` 指定架构；

   `--efi-directory` 指定efi文件的目录（esp）；

   `--boot-directory` 指定grub文件的目录；

   `--bootloader-id` 任意取一个启动项名字；

   另外如果你有兴趣看看这是个啥的话可以安装yazi查看。刚刚是在live环境装的，`chroot`之后是另外的系统，所以要重新装。

   ```
   pacman -S yazi
   ```

   输入`yazi`命令打开终端文档管理器。`.efi`文件就存放在`/efi/EFI/你取的启动项名字/`这个目录里面，grub也在`/efi`里，`/boot`里有内核文件和initramfs。其他的东西你感兴趣的话也可以自己看一看。

   按q键退出yazi；clear命令或者按ctrl+L可以清屏。

3. 编辑grub的源文件

   ```
   vim /etc/default/grub
   ```

   这是生成grub的配置文件时需要用到的东西。

   - 启动项记忆功能

     `GRUB_DEFAULT=0`改成`=saved`，再取消`GRUB_SAVEDEFAULT=true`的注释。

   - 显示开机日志

     `GRUB_CMDLINE_LINUX_DEFAULT`里面去掉`quiet`以显示开机日志。有些发行版还会出现`slash`之类的字样，代表的是开机动画。再设置`loglevel=5`把日志等级为5。`loglevel`共7级，5级是一个信息量的平衡点。

   - 禁用watchdog

     `GRUB_CMDLINE_LINUX_DEFAULT`里添加`nowatchdog `以及`modprobe.blacklist=sp5100_tco`。intelcpu用户把`sp5100_tco`换成`iTCO_wdt`

     watchdog的目的简单来说是在系统死机的时候自动重启系统。对个人用户来说没有意义，禁用以节省系统资源、提高开机和关机速度。

   - 允许使用os-prober搜索其他系统

     取消最后一行`GRUB_DISABLE_OS_PROBER=false`的注释。

4. 生成grub的配置文件

   ```
   grub-mkconfig -o /efi/grub/grub.cfg
   ```

5. 在grub的默认安装位置创建链接

   ```
   ln -sf /efi/grub /boot/grub
   ```

   大多数程序会默认检测`/boot/grub`作为grub的安装位置，所以创建一个链接方便使用。

### 退出chroot

```
exit
```

此时就回到了live环境，可以注意到提示符的变化。

### 重启电脑

```
reboot
```

此时会自动取消所有的挂载。

### 拔掉系统u盘

如果u盘没拔掉的话记得拔掉

### 选择BIOS启动项

通常默认就是刚刚安装的arch，如果不是的话选择一下启动项。

### 登录root账户

用户名为root，密码刚刚设置过了。

### 连接网络

1. 开启networkmanager服务，注意大小写

   ```
   systemctl enable --now NetworkManager 
   ```

   `systemctl`调用systemd进行操作

   `enbale`代表开机自启
   `--now`代表现在启动

2. 连接wifi

   ```
   nmtui
   ```

   nmtui是networkmanager提供的TUI（终端用户交互程序）

   - 选择activate a connection
   - 选择自己的wifi进行连接
   - esc退出
   - Ctrl+L或者`clear`清屏

3. 验证是否有网

   ```
   ip a
   ping bilibili.com
   ```

### 放松一下吧

恭喜你成功手动安装了archlinux，现在小小地奖励一下自己吧。

```
pacman -S fastfetch lolcat cmatrix
```

不做讲解，自己运行命令试试吧。

```
fastfetch
```

```
fastfetch | lolcat 
```

```
cmatrix
```

```
cmatrix | lolcat
```

`|`竖线叫作pipeline管道符，作用是把左边程序的输出结果输入到右边的程序里。

下一节：[安装桌面环境前的准备](安装桌面环境前的准备)

---



## 脚本安装

 这部分是arch自带的archinstall脚本使用教程。

### 连接网络

有线网自动连接，wifi要自己用命令行工具连接。使用如下命令确认网络连接：

```
ip a #查看网络连接信息
ping bilibili.com #确认网络正常
```

Ctrl+C可以中止正在运行的命令。

- 使用iwctl命令行工具连接wifi（此工具由`iwd`提供）

  1. 启动

     ```
     iwctl
     ```

     此时会进入iwctl，提示符会产生变化。

  2. 连接

     ```
     station wlan0 connect 【此处是你的wifi名字（不能是中文）】
     ```

  3. 退出iwctl

     ```
     exit
     ```

  4. 其他命令

     ```
     device list #列出设备
     station wlan0 scan #扫描网络
     station wlan0 get-networks #列出所有扫描的的wifi
     station wlan0 show #查看连接状态
     station wlan0 disconnect #断开连接
     ```

### 可选：更新archinstall

1. 更新数据库

   ```
   pacman -Sy
   
   #pacman是包管理器，管理软件的安装、卸载之类的
   #-S代表安装
   #-Sy代表同步数据库
   ```

2. 更新密钥

   ```
   pacman -S archlinux-keyring
   ```

3. 更新archinstall脚本

   ```
   pacman -S archinstall
   ```

### 开启archinstall

```
archinstall
```

第一项是脚本语言，第二项是系统本地化，保持英文就行，改了会乱码，直接看第三项。

### Mirrors and repositories 设置镜像源

1. 选择第一项Select regions设置自己的所在地。加载会比较慢，耐心等一等。
2. 选择第三项optional repositories回车激活multilib。这是32位程序的源。

### Disk configuration 磁盘分区 

选择partitioning进入磁盘分区

第一项是自动分区，默认格式化整块硬盘，esp挂载到/boot。我要把esp挂载到/efi，所以只使用手动分区，具体原因[重要概念讲解](#重要概念讲解)部分已经说过了。

选择第二项手动分区 > 要使用的硬盘 

1. 创建启动分区

   选中要使用的空闲空间 > Size（分区大小）512MB > Filesystem（文件系统）FAT32 > Mountpoint（挂载点）/efi

   选中刚刚创建的分区，回车设置bootable和esp。

2. 创建swap分区

   **如果你不需要睡眠功能的话跳过这一步**。睡眠指的是把系统当前状态写入硬盘，然后电脑完全断电，下一次开机恢复到睡眠前的状态。

   swap交换空间与虚拟内存和睡眠有关。有swap分区或者swap文件两种方式，前者配置更简单，后者配置稍复杂，但是更加灵活。这里采用交换分区的方式。

   | 内存(GB) | 不需要睡眠(GB) | 需要睡眠（GB） | 不建议超过（GB） |
   | -------- | -------------- | -------------- | ---------------- |
   | 1        | 1              | 2              | 2                |
   | 2        | 2              | 3              | 4                |
   | 3        | 3              | 5              | 6                |
   | 4        | 4              | 6              | 8                |
   | 5        | 2              | 7              | 10               |
   | 6        | 2              | 8              | 12               |
   | 8        | 3              | 11             | 16               |
   | 12       | 3              | 15             | 24               |
   | 16       | 4              | 20             | 32               |
   | 24       | 5              | 29             | 48               |
   | 32       | 6              | 38             | 64               |
   | 64       | 8              | 72             | 128              |
   | 128      | 11             | 139            | 256              |
   | 256      | 16             | 272            | 512              |

   Size参考上面的表 > linux-swap

3. 创建root分区

   Size部分直接回车分配全部空间 > btrfs 

   选中刚刚创建的btrfs，回车。选择Mark/Unmark as compressed设置透明压缩；再选择Set subvolumes（创建子卷）> Add subvolume 

   至少需要创建root子卷和home子卷。Subvolume name设置成 @，对应Subvolume mountpoint是 / ； @home 对应 /home

   confirm and exit > confirm and exit > back 退出硬盘分区

   关于子卷是什么，可以看[创建btrfs子卷](#创建btrfs子卷)

### Swap（zram交换空间）

这一步是自动帮你配置zram交换空间，yes开启即可。

### Bootloader引导系统

最常用的是Grub，选Grub就行。有其他需求可以看[archwiki_boot_process](https://wiki.archlinux.org/title/Arch_boot_process)。

### Hostname主机名

 设置一个自己想要的主机名

### Authentication身份认证

- Root password设置管理员密码

- User account > Add a user 创建普通用户

  Should "" be a superuser(sudo)是问你要不要给这个用户管理员权限，选yes就行。

- U2F login setup这个是物理密钥，有需要的自行设置

### Profile

这里可以选择自动安装桌面、最小化安装等等。都选择用archinstall自动安装系统了，那就顺便自动安装一下桌面吧。如果不知道自己想安装哪个就从Gnome和KDE Plasma里随便选一个。KDE默认设置更符合windows用户的直觉，自带功能好用，个性化起来更方便，多显示器支持更，但是初见会觉得杂乱。Gnome的中文输入法体验更好，默认设置更符合mac用户的直觉，外观更好看，更简洁，但是简洁过头有些简陋了。

- Type > Desktop > 想安装的桌面环境或者窗口管理器

- Graphics driver（自动安装显卡驱动）

  amd选AMD/ATi (opensource)

  nvidia去[CodeNames · freedesktop.org](https://nouveau.freedesktop.org/CodeNames.html)这个页面搜索你的显卡型号，确认对应的NV family；NV160以后的显卡选Nvidia (open kernel module ...)；NV110~NV160的选Nvidia (proprietary)，再往前的选Nvidia (open-source nouveau ...)

### Applications（蓝牙和音视频）

- Bluetooth > Yes 自动安装蓝牙

- Audio > pipewire 自动安装音视频服务

  pipewire是新技术，兼容旧的pulseautio等服务，选pipewire就行了。

### Kernel（系统内核）

tab键选择。要续航选linux，要性能选linux-zen，其他选项有兴趣可以自己查询。

### Network configuration （网络配置）

选第三项 NetworkManager，因为跟Gnome和KDE Plasma深度集成。有别的需求自行查找。

### Additional packages（自定义安装其他软件包）

/左斜杠键进行搜索，tab键选择。

必须安装：vim（任意文本编辑器）、os-prober（双系统需要）

可选安装字体：wqy-zenhei（文泉驿正黑）、noto-fonts（谷歌开源字体）、noto-fonts-emoji（表情）

如果你使用的是marvell的无线网卡，这里要额外安装linux-firmware-marvell，否则进系统找不到网卡。

### Timezone（时区）

左斜杠键搜索Shanghai

### Automatic time sync (NTP) （自动启用网络时间同步）

默认开启，不用修改

### Install

选择install安装

### 双系统

安装完成后配置windows和linux的双系统。

1. 选择exit archinstall，退出archinstall

2. 挂载windwos的启动分区

   ```
   lsblk -pf 列出当前分区情况
   ```

   找到有ntfs字样的那块盘，win的efi分区通常是那块盘的p1。如果想谨慎一点可以用`fdisk -l`查看详细信息。

   ```shell
   fdisk -l 
   ```

   找到后挂载到/mnt下的任意目录即可，为了可读性我挂载到/mn/winboot

   ```shell
   mount --mkdir /dev/nvme1n1p1 /mnt/winboot 
   ```

3. arch-chroot 

   ```
   arch-chroot /mnt 进入刚刚安装的系统
   ```

4. 编辑grub的源文件

   ```
   vim /etc/default/grub
   ```

   方向键移动光标；`i`键进入编辑模式；取消最后一行`GRUB_DISABLE_OS_PROBER=false`的注释；`esc`退出编辑模式；`:wq`保存并退出。

   还有一些其他的设置：

   - 启动项记忆功能

     `GRUB_DEFAULT=0`改成`=saved`，再取消`GRUB_SAVEDEFAULT=true`的注释。

   - 显示开机日志

     `GRUB_CMDLINE_LINUX_DEFAULT`里面去掉`quiet`以显示开机日志。有些发行版还会出现`slash`之类的字样，代表的是开机动画。再设置`loglevel=5`把日志等级为5。`loglevel`共7级，5级是一个信息量的平衡点。

   - 禁用watchdog

     `GRUB_CMDLINE_LINUX_DEFAULT`里添加`nowatchdog `以及`modprobe.blacklist=sp5100_tco`。intelcpu用户把`sp5100_tco`换成`iTCO_wdt`

     watchdog的目的简单来说是在系统死机的时候自动重启系统。对个人用户来说没有意义，禁用以节省系统资源、提高开机和关机速度。

5. 生成grub的配置文件

   ```
   grub-mkconfig -o /efi/grub/grub.cfg
   ```

6. 在grub的默认安装位置创建链接

   ```
   ln -sf /efi/grub /boot/grub
   ```

   我们的grub在`/efi/grub`，大多数程序会默认检测`/boot/grub`作为grub的安装位置，所以创建一个链接方便使用。

7. 退出

   ```
   exit
   ```

8. 重启

   ```
   reboot
   ```

9. 选择bios启动项

# 安装桌面环境前的准备

## 设置全局默认文本编辑器

如果不设置默认编辑器的话有些程序会默认使用vi编辑器。vi是vim的前身，arch默认是没有安装vi的，所以不设置系统默认编辑器的话的话那些默认调用vi的软件会报错。

```
sudo vim /etc/environment
```

```
EDITOR=vim

#如果你使用的neovim的话填入nvim，nano填入nano
```

由于是全局变量，需要重启才能生效。

## 创建普通用户

有些软件会拒绝在root权限下运行，所以普通用户是必须的。

```
useradd -m -g wheel <username> 
```

username替换为自己的用户名（不需要输入<>符号）

-m代表创建用户的时候创建home目录，-g代表设置组

* 设置密码

```
passwd <username>
```

* 编辑权限

```
EDITOR=vim visudo
```

* 搜索 wheel，取消注释

```
%wheel ALL=（ALL：ALL） ALL
```

## 开启32位源

32位源建议开启，steam需要，wine运行exe也需要

编辑pacman配置文件

   ```
vim /etc/pacman.conf
   ```

去掉[multilib]两行的注释

可选：把ParallelDownloads的数值调大，这是多线程下载，默认是5 

然后同步数据库

```
pacman -Sy
```

## 字体

```
pacman -S wqy-zenhei noto-fonts noto-fonts-emoji
```

```
wqy-zenhei是文泉驿正黑
noto-fonts是谷歌字体，包含多个国家的语言
noto-fonts-emoji是emoji
```

# 显卡驱动和硬件编解码

## 显卡驱动和硬件编解码

以N卡RTX4060和AMD780m核显为例。顺便一提，由于我没有intel的硬件，所以本文所有CPU/GPU相关内容可能不适用于intel，尤其是后面虚拟机xml的部分。

参考链接：[NVIDIA - ArchWiki](https://wiki.archlinux.org/title/NVIDIA)、[AMDGPU](https://wiki.archlinux.org/title/AMDGPU)

### 检查头文件

```
pacman -S linux-headers
```

linux替换为自己的内核，比如zen内核是linux-zen-headers

### 安装显卡驱动 

- Nvidia

  ```
  pacman -S nvidia-open nvidia-utils lib32-nvidia-utils
  ```

  显卡驱动的选择在[CodeNames · freedesktop.org](https://nouveau.freedesktop.org/CodeNames.html)这个页面搜索自己的显卡，看看对应的family是什么。然后在[NVIDIA - ArchWiki](https://wiki.archlinux.org/title/NVIDIA)这个页面查找对应的显卡驱动。nv160family往后的显卡用nvidia-open，nv110到190如果nvidia-open表现不佳的话可以使用nvidia。nvidia-open是内核模块开源的驱动，不是完全的开源驱动。非标准内核要安装的驱动不一样，具体看wiki，例如zen内核装nvidia-open-dkms。

- AMD

  A卡不需要自己安装驱动，已经由`linux-firmware`和`mesa`提供了，检查一下vulkan驱动就行

  ```
  pacman -S --needed vulkan-radeon vulkan-mesa-layers
  ```

  vulkan-mesa-layers是为了解决混合模式下gnome-shell仍运行在独立显卡上导致显卡占用异常这个问题。

### 硬件编解码

[archwiki_硬件视频加速](https://wiki.archlinux.org/title/Hardware_video_acceleration)

 - nvidia

   ```
   pacman -S nvidia-vaapi-driver-git
   ```

   如果无效的话试试：   

   ```
   pacman -S libva-nvidia-driver
   ```

* amd

  自带

* intel

  Broadwell往后的intel显卡装`intel-media-driver`，旧的装`libva-intel-driver`。具体看archwiki

* 重启激活显卡驱动和字体

  ```
  reboot 
  ```

- 可选：验证硬件编解码

  ```
  pacman -S libva-utils
  ```

  使用libva-utils提供的vainfo进行验证。

  ```
  vainfo
  ```

  多显卡用户可以使用LIBVA_DRIVER_NAME环境变量指定要使用的显卡

  ```
  LIBVA_DRIVER_NAME=nvidia vainfo
  ```

# 安装桌面环境

## 选择桌面环境

想要图形化地使用Linux，需要安装Window Manager窗口管理器（wayland下是compositor合成器，为了方便下文统称为WM），或者安装Desktop Environment桌面环境，简称DE。

桌面环境不用多说，很熟悉了。WM顾名思义，作用是管理窗口的绘制等工作，资源占用极低，wayland下常用的有sway、hyprland和niri。用WM可以自己搭建桌面环境。现有的桌面环境通常都有自己的wm，比如gnome的wm是mutter，kde plasma的是kwin。新手建议从桌面环境入门，对WM有兴趣可以同时安装桌面环境和WM。桌面环境是一系列软件包的集合，同时安装多个桌面环境会显得混乱，但是wm只是一个占用极低的用来管理窗口的程序，所以在已经有桌面环境的情况下安装wm不会搞乱已有的桌面环境。如果你想，可以同时安装sway、hyprland、niri、mangowc……

主流的桌面环境是[GNOME](https://www.gnome.org/)和[KDE Plasma](https://kde.org/zh-cn/)（为了方便，下文称KDE Plasma为KDE）。轻量化的桌面环境主要使用xfce4和lxqt，（这两个桌面环境的大小不超过100MB，恐怖如斯），在使用wm的时候运行`xfce4-session`或者`plasmashell`可以获得一个更换了wm的桌面环境（缝合怪）。其他桌面环境有兴趣可以自己了解。


萌新阶段还是以GNOME和KDE为主。两句总结它们的优缺点：KDE功能众多且实用，但是初见会觉得杂乱无章。GNOME流畅且精简，但是精简过头变得太过简陋。

1. 自定义

   通常认为GNOME的默认设置更符合MAC的直觉，KDE的默认设置更符合Win的直觉，但是GNOME和KDE都高度可自定义，因此无论KDE还是GNOME都可以通过一些额外的设置做到win或者mac的操作逻辑。区别在于KDE的设置里已经集成了大量自定义选项，而GNOME需要额外安装扩展。

2. 外观

   KDE使用Qt，而GNOME使用GTK，所以外观上会有区别，看个人喜好。通常认为GTK的外观更加现代。

3. 自带功能

   KDE plasama桌面环境自带的无级缩放、外屏亮度调节、概览中键关闭窗口、高级网络配置、四角平铺等等功能都相当好用。虽然GNOME可以通过额外安装扩展和软件达成类似的效果，但稳定性不如KDE自带，也不如KDE自带优雅。所以在功能性上，KDE强于GNOME。

4. 中文输入法体验

   KDE的中文输入法配置起来比GNOME繁琐。GNOME只需要配置全局变量就好了，但是KDE很多应用要单独设置。

### 现在你了解了两者的区别，[GNOME](#安装GNOME)和[KDE](#安装KDE)之间选择一个安装吧。

wm相关内容施工中🚧……

# 安装GNOME

[Archwiki_GNOME](https://wiki.archlinux.org/title/GNOME)

这个部分是安装GNOME，以及一些最基本的配置。

1. 安装

   ```
   pacman -S gnome-desktop gdm ghostty gnome-control-center gnome-software flatpak file-roller nautilus-python firefox 
   ```

   jack选择pipewire-jack，因为pipewire是新技术，piperwire-jack兼容jack

   `gnome-desktop `最小化安装gnome；

   `gdm` 是显示管理器(gnome display manager)；

   `ghostty` 是一个可高度自定义，主打无缝融入任何环境的终端模拟器（terminal emulator）。当然，如果你需要可以自行更换；

   `gnome-control-center` 是设置中心；

   `gnome-software` 是软件商城；

   `nautilus-python`开启ghostty在文档管理器右键从此处打开终端的功能，对于其他终端，还需要`nautilus-open-any-terminal`；

   `flatpak` 是flatpak软件，这是一种全发行版通用的软件打包形式，软件沙盒运行；

   `file-roller`是和gnome的文档管理器集成的压缩解压缩工具；

   `firefox`是linux上最好用的浏览器。

2. 临时开启gdm

   ```
   systemctl start gdm 
   ```

3. 登录普通用户账号

4. 设置gdm开机自启

   正常开启桌面后打开ghostty设置gdm

   ```
   sudo systemctl enable gdm
   ```

   `sudo` 全称substitute user and do something，功能是以管理员身份运行命令。

### 设置系统语言

右键桌面选择setting，选择system，选择region&language

- 如果是archinstall安装，需要进行如下操作：

  1. ```
     sudo vim /etc/locale.gen 
     ```

  2. 左斜杠键搜索，取消`zh_CN.UTF-8`的注释

  3. ```
     sudo locale-gen
     ```

  4. 登出

### 声音固件和声音服务

1. 安装声音固件

   ```
   sudo pacman -S --needed sof-firmware alsa-ucm-conf alsa-firmware 
   ```

   `sof-firmware`为现代音频设备提供固件，通常装这个就可以了

   `alsa-ucm-conf`提供必要的配置文件

   `alsa-firmware`为不常见或者较旧的设备提供固件

2. 安装音视频服务

   ```
   sudo pacman -S --needed pipewire wireplumber pipewire-pulse pipewire-alsa pipewire-jack 
   ```

   `pipewire`是由redhat主导开发的现代音视频服务

   `wireplumber`会智能管理pipewire

   `pipewire-pulse pipewire-alsa pipewire-jack`分别为pulseAudio、ALSA、JACK提供兼容

3. 启用服务

   ```
   systemctl --user enable --now pipewire pipewire-pulse wireplumber
   ```

4. 可选：安装gui

   ```
   sudo pacman -S pavucontrol
   ```

### 性能模式切换工具 power-profiles-daemon

性能模式切换，有三个档位，performance性能、balance平衡、powersave节电。一般平衡档位就够用了，也不需要调节风扇什么的。

```
sudo pacman -S power-profiles-daemon
```

```
sudo systemctl enable --now power-profiles-daemon 
```

这个易用而且足够，不建议使用tlp或者auto-cpufreq，功耗上不会有明显区别。如果想折腾的话可以看[附录-tlp相关](附录#tlp相关)。

### 启用蓝牙

```
sudo pacman -S --needed bluez
```

```
sudo systemctl enable --now bluetooth
```

### 安装高级网络配置工具nm-connection-editor

```
sudo pacman -S --needed network-manager-applet dnsmasq
```

### 更换flatpak国内源

这里举例的是上交大的源，要使用其他的可以自行浏览器搜索。

```
sudo flatpak remote-modify flathub --url=https://mirror.sjtu.edu.cn/flathub
```

### 可变刷新率和分数缩放

商店安装refine修改

```
flatpak install flathub page.tesk.Refine
```

### 修改gnome默认终端

- 方法一：dconf-editor

  ```
  sudo pacman -S dconf-editor
  ```

  org.gnome.desktop.applications.terminal里的exec取消“使用默认值”，自定义值填ghostty，exec-arg同理，自定义值改成-e。这么写是因为别的程序调用ghostty运行命令时需要通过-e参数把命令传给ghostty。

- 方法二：gsettings命令

  ```
  gsettings set org.gnome.desktop.default-applications.terminal exec 'ghostty'
  gsettings set org.gnome.desktop.default-applications.terminal exec-arg '-e'
  ```

两个方法效果是一样的，可以运行这段命令查看是否修改成功：

```
gsettings get org.gnome.desktop.default-applications.terminal exec
gsettings get org.gnome.desktop.default-applications.terminal exec-arg
```

输出应该为

```
‘ghostty’
’-e‘
```

### 生成home下目录（如果没有的话）

```
xdg-user-dirs-update
```

### 睡眠到硬盘

如果需要睡眠到硬盘功能，且之前设置了硬盘swap的话。

1. 添加hook

   ```
   sudo vim /etc/mkinitcpio.conf
   ```

   ```
   在HOOKS()内添加resume,注意需要添加在udev的后面
   ```

2. 重新生成initramfs

   ```
   sudo mkinitcpio -P
   ```

3. 重启电脑

   ```
   reboot
   ```

4. 使用命令进行睡眠

   ```
   systemctl hibernate
   ```

## 下一节：[快照](#快照)

# 安装KDE

[KED-Archwiki](https://wiki.archlinux.org/title/KDE)

1. 安装

   ```
   pacman -S plasma-meta konsole dolphin flatpak flatpak-kcm kate firefox
   ```

   出现选项的话选有pipewire和ffmpeg的，字体选noto-fonts

   `plasma-meta` 其实`plasma-desktop`这个包可以像`gnome-desktop`那样进行最小化安装，但是kde自带的东西都很实用，装meta就可以了

   `konsole` 是kde标配终端仿真器

   `dolphin` 是kde标配文档管理器

   `flatpak` 是flatpak软件

   `flatpak-kcm` 通过系统设置管理flatpak应用的权限

   `kate` 是标配文本编辑器

   `firefox`是linux上最好用的浏览器

2. 开启显示管理器sddm

   ```
   systemctl start sddm
   ```

3. 登录普通用户

4. 设置sddm开机自启

   成功开启桌面后打开konsole设置显示管理器开机自启

   ```
   sudo systemctl enable sddm 
   ```

### 设置系统语言

- 系统设置 > regin&language > language边上的modify > 点击add more添加简体中文 > 移动到english上方

- 如果是archinstall安装，需要进行如下操作：

  1. ```
     sudo vim /etc/locale.gen 
     ```

  2. 左斜杠键搜索，取消`zh_CN.UTF-8`的注释

  3. ```
     sudo locale-gen
     ```

  4. 登出

### 声音固件和音视频服务

1. 安装声音固件

   ```
   sudo pacman -S --needed sof-firmware alsa-ucm-conf alsa-firmware 
   ```

   `sof-firmware`为现代音频设备提供固件，通常装这个就可以了

   `alsa-ucm-conf`提供必要的配置文件

   `alsa-firmware`为不常见或者较旧的设备提供固件

2. 安装音视频服务

   ```
   sudo pacman -S --needed pipewire wireplumber pipewire-pulse pipewire-alsa pipewire-jack 
   ```

   `pipewire`是由redhat主导开发的现代音视频服务

   `wireplumber`会智能管理pipewire

   `pipewire-pulse pipewire-alsa pipewire-jack`分别为pulseAudio、ALSA、JACK提供兼容

3. 启用服务

   ```
   systemctl --user enable --now pipewire pipewire-pulse wireplumber
   ```

### 启用蓝牙 

kde的蓝牙前端由`bluedevil`提供，`plamsa-meta`已经包含，开启服务即可。

```
sudo systemctl enable --now bluetooth
```

### 性能模式切换

```
sudo pacman -S power-profiles-daemon
sudo systemctl enable --now power-profiles-daemon
```

### 更换flatpak国内源

这里举例的是上交大的源，要使用其他的可以自行浏览器搜索。

```
sudo flatpak remote-modify flathub --url=https://mirror.sjtu.edu.cn/flathub
```

### 生成home下目录（如果没有的话）

```
xdg-user-dirs-update
```

### 睡眠到硬盘

如果需要睡眠到硬盘功能，且之前设置了硬盘swap的话。

1. 添加hook

   ```
   sudo vim /etc/mkinitcpio.conf
   ```

   ```
   在HOOKS()内添加resume,注意需要添加在udev的后面
   ```

2. 重新生成initramfs

   ```
   sudo mkinitcpio -P
   ```

3. 重启电脑

   ```
   reboot
   ```

4. 使用命令进行睡眠

   ```
   systemctl hibernate
   ```

## issue--KDE开机会卡住，必须重启sddm才好

显卡驱动没加载完sddm就加载导致的卡死。让sddm晚点加载就可以解决。

```
sudo systemctl edit sddm.service
```

```
[Service]
ExecStartPre=/bin/sleep 1
```

### 接下来你自己根据需求决定安装什么软件，进行什么配置。当然，你也可以选择参考我的。

# 快照

**快照相当于存档，养成习惯，每次做自己不了解的事情之前都存个档**，如果出了问题或者后悔了可以恢复到快照时的状态。

- 由于默认grub路径是/boot，而我们之前的grub安装在/efi，所以需要一个软链接。如果你安装的时候已经创建了的话跳过这一步。

  ```
  sudo ln -sf /efi/grub /boot/grub
  ```

主要是timeshift和snapper两种方法。timeshift操作简单，但是速度很慢且容易出bug，建议用snapper。

## snapper

- 安装snapper

  ```
  sudo pacman -S snapper snap-pac btrfs-assistant
  ```

  `snapper` 是主程序；

  `snap-pac` 利用钩子在进行pacman命令的时候自动创建快照；

  `btrfs-assistant` 是GUI（图形化交互工具）。

- 自动生成快照启动项

  1. ```
     sudo pacman -S grub-btrfs inotify-tools
     sudo systemctl enable --now grub-btrfsd
     ```

  2. 设置覆盖文件系统（overlayfs）

     因为snapper快照是只读的，所以需要设置一个overlayfs在内存中创建一个临时可写的类似live-cd的环境，否则可能无法正常从快照启动项进入系统。

     1. 编辑``/etc/mkinitcpio.conf``

        ```
        sudo vim /etc/mkinitcpio.conf
        ```

     2. 在HOOKS里添加```grub-btrfs-overlayfs```

        ```
        HOOKS= ( ...... grub-btrfs-overlayfs )
        ```

     3. 重新生成initramfs

        ```
        sudo mkinitcpio -P
        ```

     4. 重启电脑

     5. 生成一次grup的配置文件

        ```
        sudo grub-mkconfig -o /efi/grub/grub.cfg
        ```

### 具体使用方法

1. 创建配置

   打开btrfs assistant，切换到snapper settings页面。我们创建子卷的时候至少创建了一个@子卷和一个@home子卷，所以需要两个config（配置）。

   - root 根目录快照

     点击new config新建配置，config name写root，backup path选择 / ，然后点击save保存。

     接着进行一些按照时间自动生成快照的设置。systemd unit settings里面有三个服务。 timeline是按照时间计划自动创建快照；cleanup是快照数量达到number设定的数量上限之后自动清理快照；boot是每次开机自动创建快照。按需设置，设置完记得点apply。

   - home目录快照

     按照同样的方法创建一个home目录的配置。

2. 创建快照

   到snapper页面，select config选择配置，要创建root子卷的快照就选择刚刚创建的名为root的配置。点击new创建快照，description是快照的自定义文字描述（注释）。

3. 使用快照进行恢复

   snapper页面--> Browse/restore页面

   select target选择想恢复的子卷，再选择想使用的快照，点击restore，此时会自动帮你创建一个额外的子卷用来备份当前的数据然后弹出一个确认窗口让你填写这个子卷的名字（可以空着不填写）

4. 使用快照进行全盘恢复

   因为root子卷和home子卷在创建的时候是平级的，所以虽然root目录包含了home目录，但是创建root子卷的快照时不会包含home子卷里的内容。这样的子卷布局叫作“扁平布局”。因此，需要分别创建root和home的快照，然后分别恢复root子卷和home子卷。

## timeshift

[不建议使用](附录#timeshift)

## 关于滚挂和良好的系统使用习惯

- 滚挂

  archlinux是滚动发行版。滚动是英文直译，原词是rolling，指一种推送更新的方式，只要有新版本就会推送，由用户管理更新。对应的另一种更新方式是定期更新一个大版本，例如fedora是六个月一更新，由发行方管理更新。 滚挂，指的是滚动更新的发行版因为更新导致系统异常。这通常是用户操作不当、忽略官方公告等原因导致的。只要学习一下正确的更新方式和快照的使用方法就不用担心滚挂问题。

  通常软件更新不用担心。**出现密钥（keyring）、内核、驱动、固件、引导程序之类的更新要留个心眼，先不第一时间更新，等一手社区消息。** 另一个重点是滚动更新的发行版的软件通常会适配最新的依赖，如果部分更新可能会无法使用软件。

- 良好的使用习惯

  btrfs文件系统已经足够稳定，“不作死就不会死”。使用时遵循以下几点：

  1. **别第一时间更新，别长时间不更新，别部分更新，密钥单独更新，重要程序更新前创建快照**
  2. **弄坏系统的通常是用户自己的不当操作，明白自己的行为会造成怎样的后果，做不了解的事情前创建快照**

## 扩展内容：downgrade

有时候更新完之后可能反而不好用，这时就要使用downgrade退回之前的版本。

```
yay -S downgrade
```

使用方法：

```
sudo downgrade 要回退的软件包
```

比如如果我要回退ghostty的话就是：

```
sudo downgrade ghostty
```



## ⚠️现在你学会了快照的使用方法，接下来的每一步请自行判断要不要创建快照⚠️

# yay-AUR助手

AUR是archlinux用户仓库，让archlinux拥有了远超其他发行版的软件数量。aur助手用于从aur安装软件。推荐使用yay。常用的还有paru，但是paru有些软件无法安装，所以用yay。

## 方法一：直接从archlinuxcn源安装（推荐）

1. 编辑pacman配置文件添加archlinuxcn源

   ```
   sudo vim /etc/pacman.conf
   ```

2. 文件底部写入（ctrl+shift+V粘贴）

   ```
   [archlinuxcn]
   Server = https://mirrors.ustc.edu.cn/archlinuxcn/$arch 
   Server = https://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/$arch 
   Server = https://mirrors.hit.edu.cn/archlinuxcn/$arch 
   Server = https://repo.huaweicloud.com/archlinuxcn/$arch 
   ```

3. 同步数据库并安装archlinuxcn密钥

   ```
   sudo pacman -Sy archlinuxcn-keyring 
   ```

4. 安装yay

   ```
   sudo pacman -S yay 
   ```

## 方法二：从github安装

[GitHub - Jguer/yay: Yet another Yogurt - An AUR Helper written in Go](https://github.com/Jguer/yay)

```
sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si && cd.. && rm -rfv yay
```

这条命令有四步，每步之间用&&隔开，意思是前一步完成再运行下一步。第一步用`pacman`安装`git`和`base-devel`，这是git管理工具和编译软件需要的包，`--needed`跳过已经安装的包。第二步`git clone`把链接里的文件下载到本地。第三步`cd`命令进入`yay`目录。第四步`makepkg`编译包。第五步回到`yay`的上级目录删除yay文件夹。

# 中文输入法



常用的有fcitx5和ibus，fcitx5更现代，功能更多，建议使用。

GNOME和KDE桌面的配置方法会略有不同，注意区分。

## fcitx5

1. 安装需要的包

   ```
   sudo pacman -S fcitx5-im fcitx5-rime rime-ice-pinyin-git
   ```

   `fcitx5-im` 包含了fcitx5的基本包

   `fcitx5-rime`是输入法引擎

   `rime-ice-pinyin-git`是雾凇拼音输入法，实测比万象拼音好用。

   可选：`fcitx5-mozc`日语输入法

2. 编辑配置文件启用rime雾凇拼音

   ```
   mkdir -p ~/.local/share/fcitx5/rime
   vim ~/.local/share/fcitx5/rime/default.custom.yaml 
   ```

   第一行命令`mkdir -p`检查文件夹是否存在，不存在的话创建。第二行编辑配置文件，写入以下内容设置rime的默认方案为雾凇拼音：

   ```
   patch:
     # 这里的 rime_ice_suggestion 为雾凇方案的默认预设
     __include: rime_ice_suggestion:/
   ```

3. 编辑环境变量

   ```
   sudo vim /etc/environment
   ```

   GNOME和KDE会略有不同

   - GNOME的话写入

     ```
     XIM="fcitx"
     GTK_IM_MODULE=fcitx
     QT_IM_MODULE=fcitx
     XMODIFIERS=@im=fcitx
     XDG_CURRENT_DESKTOP=GNOME
     ```

     `GTK_IM_MODULE=fcitx QT_IM_MODULE=fcitx XMODIFIERS=@im=fcitx`这三个是最主要的环境变量

     `XDG_CURRENT_DESKTOP=GNOME`这一项可以解决吞字问题，建议设置

     `XIM="fcitx"`是因为我在微信的某个版本出现输入法无法使用的情况，设置这个解决了

   - KDE的话写入

     ```
     XMODIFIERS=@im=fcitx
     ```

4. 系统设置

   - GNOME的话

     商店搜索extension，安装蓝色的extensionmanager。安装[input method panel](https://extensions.gnome.org/extension/261/kimpanel/)扩展

   - KDE的话

     1. 打开系统设置 > 键盘 > 虚拟键盘， 选择fcitx5，记得应用
     2. 系统设置 > 语言和时间 > 输入法，添加rime。 “配置全局选项”可以设置切换输入法的快捷键。“配置附加选项”可以进行一些自定义设置。

5. 可选：美化

   浏览器搜索fcitx5 themes，下载自己喜欢的主题放到`~/.local/share/fcitx5/themes`目录下。在fcitx5配置里的”经典用户界面“里进行设置。

6. 干净删除fcitx5

   1. 删除包

      ```
      sudo pacman -Rns fcitx5-im fcitx5-mozc fcitx5-rime rime-ice-pinyin-git
      ```

   2. 删除配置文件

      ```
      sudo rm -rfv ~/.config/fcitx5 ~/.local/fcitx5
      ```

   3. 清理环境变量

      ```
      sudo vim /etc/environment
      ```

KDE用户接着看[KDE下输入法异常的解决办法](#KDE下输入法异常的解决办法)

## ibus

kde用fcitx5就可以。gnome和ibus兼容性更好，如果有需要可以更换。

因为是次要内容所以放在附录了，[点击此处跳转](附录#ibus)。

## KDE下输入法异常的解决办法

KDE下设置GTK和QT的IM_MODULE全局变量会导致输入法闪烁和位置错误等问题，但是不设置的话百分之一百会在xwayland应用和electron应用出现输入法异常。所以需要为出现异常的应用单独进行输入法设置。

### 从快捷方式打开的话（.desktop）

- 对于xwayland下运行的QT和GTK应用

  打开菜单编辑器，给对应程序设置IM_MODULE环境变量

  ```
  GTK_IM_MODULE=fcitx QT_IM_MODULE=fcitx
  ```

- 对于chromium和electron应用

  在linuxqq 【此处】%U添加命令行参数

  ```
  --ozone-platform=wayland
  ```

  不行的话设置：

  ```
  --enable-features=UseOzonePlatform --ozone-platform=wayland --enable-wayland-ime
  ```

### 从终端命令打开的话

上面的设置只对快捷方式打开生效，从终端用命令打开的话不一定生效。解决办法是编辑shell的配置文件单独设置alias。

- zsh/bash

  编辑`home`目录下的`.zshrc`或`.bashrc`文件，根据使用的shell而定。

  - QT或GTK应用（以typora为例）

    ```
    alias typora='GTK_IM_MODULE=fcitx QT_IM_MODULE=fcitx typora'
    ```

  - chromium和electron应用（以vscode为例）

    ```
    alias code='code --enable-features=UseOzonePlatform --ozone-platform=wayland --enable-wayland-ime'
    ```

- fish

  fish的话有两种方法，一种是`abbr`，另一种是`function`。

  - abbr

    ```
    abbr typora 'GTK_IM_MODULE=fcitx QT_IM_MODULE=fcitx typora'
    ```

    ```
    abbr code 'code --enable-features=UseOzonePlatform --ozone-platform=wayland --enable-wayland-ime'
    ```

  - function

    ```
    function typora
    	env GTK_IM_MODULE=fcitx QT_IM_MODULE=fcitx typora $argv
    end
    ```

    ```
    function code --description ‘启动code’
    	exec code --enable-features=UseOzonePlatform --ozone-platform=wayland --enable-wayland-ime $argv
    end
    ```

    `function`是函数，`typora`是要运行的命令，``--description '' ``是描述，中间是这个命令的具体内容`exec`是运行后退出终端，如果要保持终端开启的话把`exec`换成`command`，``$argv``传递``typora``命令后的选项和参数（有些应用不需要），`end`结尾。

# 软件安装相关

1. [如何安装软件](#如何安装软件)
2. [我使用的软件](#我使用的软件)
   - [pacman](#pacman)
   - [AUR](#AUR)
   - [Flatpak](#Flatpak)
3. [视频播放器开启硬件编解码](#视频播放器开启硬件编解码)
4. [GNOME如何编辑截图](#GNOME如何编辑截图)
5. [Appimage使用方法](#Appimage使用方法)
6. [隐藏不必要的快捷方式](#隐藏不必要的快捷方式)
7. [星火应用商店](#星火应用商店)

## 如何安装软件

安装软件主要分四种方式

1. `pacman`从官方仓库和archlinuxcn下载软件

2. `yay`从AUR（archlinux用户仓库）下载软件

3. `flatpak`从flathub或指定的flatpak源下载

   这是种“一次打包全发行版通用”的打包方式。浏览器搜索flathub可以获取软件的安装链接。

4. 应用官网下载appimage包直接运行

   appimage和flatpak类似，也是所有发行版通用的打包方式，可以理解为免安装便携版。

建议优先级：pacman > flatpak = aur > 官网下载

aur很方便，但要注意辨识它是否安全。

## 我使用的软件

以下是我会安装的软件，以及我认为好用的一些软件，你可以按照你的需求来。

根据使用的桌面环境进行跳转：

### pacman

- [GNOME](#GNOME)
- [KDE](#KDE)

#### GNOME

```
sudo pacman -S --needed mission-center gnome-logs gnome-text-editor gnome-disk-utility dosfstools ntfs-3g exfatprogs f2fs-tools udftools xfsprogs gnome-font-viewer gnome-clocks gnome-weather gnome-calculator loupe snapshot baobab celluloid fragments file-roller foliate firefox gst-plugin-pipewire gst-plugins-good pacman-contrib papers easyeffects
```

`mission-center` 类似win11的任务管理器，强烈推荐

`gnome-logs` 方便查看系统日志

`gnome-text-editor` gnome标配记事本

`gnome-disk-utility` 磁盘管理工具，可以调节分区大小和格式化分区等等

`dosfstools ntfs-3g exfatprogs f2fs-tools udftools xfsprogs`补全gnome-disk-utility的功能

`gnome-font-viewer` 方便安装和查看字体

`gnome-clocks` 时钟工具，可以设置闹钟和计时

`gnome-weather` 天气，设置地区之后可以在系统托盘里显示天气，安装扩展后可以在时间边上显示天气组件

`gnome-calculator` 计算器

`loupe` 图片查看工具

`snapshot `相机，摄像头

`baobab` 磁盘使用情况分析工具

`celluloid` 是基于mpv的视频播放器

`fragments` 是符合gnome设计理念的种子下载器

`foliate` 电子书阅读器

`firefox` linux上性能表现最佳的浏览器，需要别的可以商店自行搜索安装

`gst-plugin-pipewire gst-plugins-good` 是gnome截图工具自带的录屏

`pacman-contrib` 提供pacman的一些额外功能，比如checkupdates用来检查更新

`papers` pdf阅读器

`easyeffects`设置麦克风降噪、混响、音响音效之类的

#### KDE

```
sudo pacman -S --needed mission-center firefox ark gwenview kcalc kate pacman-contrib gnome-disk-utility dosfstools ntfs-3g exfatprogs f2fs-tools udftools xfsprogs baobab haruna ksystemlog easyeffects
```

`mission-center` 类win11任务管理器

`firefox`浏览器

`ark` kde标配解压缩工具

`gwenview` 图片编辑查看工具

`kcalc` 计算器

`pacman-contrib` 提供pacman的一些额外功能，比如checkupdates用来检查更新

`gnome-disk-utility`磁盘管理器

`dosfstools ntfs-3g exfatprogs f2fs-tools udftools xfsprogs`是对gnome-disk-utility功能的补全

`baobab`磁盘使用情况分析工具

`haruna`是基于mpv的视频播放器

`ksystemlog`用来查看系统日志

`easyeffects`设置麦克风降噪、混响、音响音效之类的

### AUR

yay安装软件会询问是否要清理构建文件、显示包差异，通常不用理会直接回车就行。

```
yay -S linuxqq-appimage wechat-appimage wps-office-cn wps-office-mui-zh-cn typora-free pacseek
```

`linuxqq-appimage`appimage版的qq

`wechat-appimage`appimage版的微信

`wps-office-cn` wps办公，其实我比较喜欢onlyoffice

`wps-office-mui-zh-cn` wps的中文语言包

`typora-free` typora的免费版，markdown编辑器

`pacseek` 提供TUI（终端用户交互工具）用来可视化搜索官方源和aur软件包的

### Flatpak

```
flatpak install flathub io.github.Predidit.Kazumi io.gitlab.theevilskeleton.Upscaler com.github.unrud.VideoDownloader io.github.ilya_zlobintsev.LACT com.geeks3d.furmark io.github.flattool.Warehouse com.github.tchx84.Flatseal com.dec05eba.gpu_screen_recorder
```

`kazumi`追番

`upscaler`图片超分

`video downloader`下载youtube/bilibili 144p～8k视频

`LACT `显卡超频、限制功率、风扇控制等等

`furmark` 显卡烤鸡

`Warehouse` 用来管理flatpak的源、软件、属性、用户数据之类的

`Flatseal` 管理flatpak应用的权限、环境变量之类的

`gpu_screen_recorder` 类似nvidiaApp的录屏软件

### 其他好用的软件

```
gnome-calendar 日历
gnome-music 本地音乐播放器
decibels 显示波形的音频播放器
curtail 压缩图片大小
switcheroo 变更图片格式
komikku 看漫画
secrets 本地加密保存账号密码
wordbook 英英词典
shortware 收听电台
localesend 局域网传输文件
handbrake 视频转码
```

## GNOME如何编辑截图

gradia可以用来编辑截图。

```
flatpak install be.alexandervanhee.gradia
```

在系统设置>键盘>查看自定义快捷键，设置一个自定义的截图快捷键，命令填入

```
flatpak run be.alexandervanhee.gradia --screenshot=INTERACTIVE
```

### 视频播放器开启硬件编解码

#### GNOME

- 方法一：配置文件

  1. 编辑mpv配置文件（记得打开一次mpv生成目录）

  ```
  vim ~/.config/mpv/mpv.config
  ```

  写入：

  ```
  #通用自动模式硬解
  hwdec=auto-safe
  #对于现代设备可以取消下面这行的注释设置vulkan后端
  #gpu-api=vulkan
  
  ```

  2. celluloid首选项的配置文件页面，激活“加载mpv配置文件”，手动指定一下路径

- 方法二：celluloid首选项

  在首选项的杂项页面写入

  ```
  hwdec=yes
  ```

#### KDE

haruna会自动开启

## 如何使用Appimage

需要安装`fuse3`和`fuse2`，通常已经安装好了。文件下载下来之后右键属性设置可执行权限之后即可运行，或者使用命令：

```
chmod +x ~/path/to/files.appimage
```

感兴趣的可以使用这条命令把appimage解压出来看看里面都有什么：

```
/path/to/files.appimgae --appimage-extract
```

会出现一个squashfs-root文件夹，里面就是解压出来的文件。

### 把appimage集成到系统

- 方法一：gear lever（推荐）

  flathub下载

  ```
  flatpak install flathub it.mijorus.gearlever
  ```

  或者aur下载

  ```
  yay -S gearlever
  ```

  由于appimage的安装涉及到解压和打包，所以用gearlever打开较大的appimage会有一点慢，稍等一会就会出现启动或者集成到系统的选项了。卸载也是用这个软件。

- 方法二：appimagelauncher

  ```
  yay -S appimagelauncher
  ```

  安装后启动appimage时会弹出appimagelauncher的窗口，第一次启动会让你设置安装路径，然后让你选择运行一次还是集成到系统（有时候会安装失败或者安装之后无法运行）。

  - 卸载appimage软件
    右键快捷方式，点击remove appimage from system，或者手动删除`~/.local/share/Applications`下的destop文件和安装目录下的appimage文件。

[appimagehub](https://www.appimagehub.com/browse?ord=latest)这个网址有很多有趣的appimage应用，有兴趣的可以搜索玩玩看

## 隐藏不必要的快捷方式

- 方法一：pinapp

  从应用商店搜索pinapp安装pins，图标是个图钉钉在蓝色的板子上。

  也可以用命令安装，更方便：

  ```
  flatpak install flathub io.github.fabrialberio.pinapp
  ```

  选择想隐藏的图标激活invisible即可

- 方法二：menulibre

  使用pacman安装

  ```
  sudo pacman -S menulibre
  ```

  选择想隐藏的图标激活invisible，然后保存即可

- GNOME的方法三：apphider扩展

  商店搜索extension，安装扩展管理器。然后安装apphider扩展，可以右键隐藏概览里的快捷方式。

## 星火应用商店

[Amber CE: 琥珀兼容环境：一款Bubblewrap容器，极轻量系统容器](https://gitee.com/amber-ce)

[amber-ce-bookworm: 使用bwrap的Debian 12容器](https://gitee.com/amber-ce/amber-ce-bookworm)

[Spark Store](https://www.spark-app.store/)

2025.9.7已知问题：ibus输入法只能在gtk应用中使用，qt应用中无法使用；fish下无法正常生成快捷方式，想用星火商店的话后续更换shell的部分使用zsh；KDE桌面环境似乎无法正常使用这个，创建快照后谨慎尝试。

由于特殊国情，星火应用商店里的应用可能比aur上的都好用。amber-ce是一个debian容器，可以让你在arch上快捷安装deb包。

1. 安装ace容器

   ```
   yay -S amber-ce-trixie
   ```

2. 安装完成后没有显示图标的话登出一次

3. 官网下载星火应用商店的deb包

   [Spark Store](https://www.spark-app.store/)

4. 打开ace（蓝色图标）

5. 安装星火应用商店

   ```
   sudo apt install /home/shorin/Downloads/spark-store_4.8.0_amd64.deb
   ```

   ```
   apt是debian的包管理器
   install代表安装
   后面指定了安装包的绝对路径，可以手动输入，也可以把安装包拖拽进终端里自动输入路径
   ```

### ace容器内启用输入法

- ibus

  仅gtk应用可用，解决办法暂时未知

- fcitx5

  ```
  sudo apt install fcitx5-frontend-gtk2 fcitx5-frontend-gtk3 fcitx5-frontend-gtk4 fcitx5-frontend-qt5 fcitx5-frontend-qt6
  ```

### 卸载

使用ace 软件卸载器卸载软件，或者`sudo apt remove 【包名】`，或者直接删除整个容器，删除容器之后里面的所有东西都不会留下。

```
yay -Rns amber-ce-trixie
```

# 专业软件平替

## 修图

photopea

canva

gimp

krita

## 视频剪辑

达芬奇

kdenlive

shotcut

以及各类线上剪辑网站，比如flixier

## 别的专业软件超出我的知识范围了……

## 下一节（选择对应的桌面环境）：

[我的GNOME自定义设置](#我的GNOME自定义设置)

[我的KDE自定义设置](#我的KDE自定义设置)

# 我的GNOME自定义设置

## 快捷键

- 可选：交换大写锁定键和esc键

  安装gnome-tweaks

  ```
  sudo pacman -S gnome-tweaks
  ```

  在键盘→其他布局里面交换CAPSLOCK和ESC键



设置>键盘>查看自定义快捷键

* 导航

```
super+shift+数字键 #将窗口移到工作区
super+shift+A/D #将窗口左右移动工作区
super+shift+Q/E #移动到左/右工作区
ps：gnome默认super+滚轮上下可以左右切换工作区
alt+tap #切换窗口
super+tab #切换应用程序
alt+` #在应用程序的窗口之间切换窗口
super+M #隐藏所有窗口
```

* 截图

```
ctrl+alt+A #交互式截图
```

 * 无障碍

```
屏幕阅读 禁用
```

* 窗口

```
super+Q #关闭窗口
super+F #切换最大化
super+alt+F #切换全屏
```

* 系统

```
ctrl+super+S #打开快速设置菜单
super+G #显示全部应用
```

* 自定义快捷键<快捷键>   <命令>

```
super+B   firefox
super+T   ghostty
super+`    missioncenter
super+E   nautilus
super+shift+S   flatpak run be.alexandervanhee.gradia --screenshot=INTERACTIVE
super+M gnome-text-editor
ctrl+alt+S gnome-control-center
```

## 功能性扩展

#### ⚠️ 警告：扩展在gnome桌面环境大版本更新的时候大概率会大面积失效，如果出现gnome桌面环境的大版本更新，一定要先关闭所有扩展，谨慎行事

（9月23日gnome更新了49版本，部分扩展尚未更新）

- 从商店安装蓝色的扩展管理器

```
flatpak install flathub com.mattjakeman.ExtensionManager
```

或者可以安装浏览器集成扩展[firefox-gnome-shell-extension-integration](https://addons.mozilla.org/en-US/firefox/addon/gnome-shell-integration/)，然后安装```chrome-gnome-shell```

```
yay -S chrome-gnome-shell
```

这样就可以直接在https://extensions.gnome.org/这个网站通过开关安装扩展了。

- AppIndicator and KStatusNotifierItem Support 

  面板上显示后台应用

- caffeine

  防止熄屏

- lock keys 

  装kazimieras.vaina的那个。osd显示大写锁定和小键盘锁定。设置里把指示器风格改成show/hide cap-locks only

- Fuzzy Application Search

  模糊搜索

- steal my focus window 

  如果打开窗口时窗口已经被打开则置顶

- tiling shell 

  窗口平铺，tilingshell是用布局平铺，记得自定义快捷键，我快捷键是super+w/a/s/d对应上下左右移动窗口，Super+Alt+w/a/s/d对应上下左右扩展窗口，super+Z取消平铺，super+C把窗口移动到屏幕中心

- tiling assistant

  这个扩展提供最基础的四角平铺和上下左右半屏平铺功能。设置里取消激活popup，gaps和tiling shell调成一样的，禁用keybinds里general一项的第1/2/4项，仅保留resote window size。

- 可选：forge

  如果你更喜欢sway/hyprland那样的自动平铺功能，可以安装forge。我没有深入用过这个扩展，说不定会和tiling shell和tilling assitant冲突，所以自己探索吧。

- color picker 

  获取屏幕上的颜色，对自定义非常有用

- Arch Linux Updates Indicator

  在面板上显示一个和arch更新相关的图标。要安装pacman-contrib。设置取消始终显示，高级设置里命令改成

  ```
  ghostty -e sudo pacman -Syu
  ```

- quick settings tweaks

  让右上角的快速设置面板变得更合理。包括把通知从时间面板移动到快速设置面板，缩小时间面板的占地面积，免打扰模式开关按钮移动到快速设置面板，允许调整单个应用的声音大小等等。

  扩展设置的menu页面的两项可以激活，第一项让声音调整菜单以悬浮的方式显示出来，第二项给这个功能增加动画，很酷。

- clipboard indicator 

  剪贴板历史。设置里设置super+v切换菜单

可选：使用鼠标的用户建议安装的扩展

- quick close in overview

  在概览里面不用点窗口右上角的叉关闭窗口了，而是使用鼠标中键

- Top Panel Workspace Scroll

  在顶部面板上滚动滚轮切换工作区

- dask to dock 

  把概览里的快捷栏放到桌面上（如果要用windows布局的话不要装这个）。

其他有用扩展见[其他有用的扩展](#其他有用的扩展)和[实现windows布局](#实现windows布局)

#### 其他有用的扩展

- desktop widgets （desktop clock）

  在桌面上显示一个时钟组件

- lock screen background 

  更换锁屏背景（默认锁屏是模糊，会透出桌面壁纸，已经很好看了，所以这个意义不大）

- vitals 

  右上角显示当前资源使用情况

- emoji copy 

  快捷复制emoji，很有趣

- burn my windows 

  应用开启和打开的动画

- hide activities button 

  隐藏左上角的activities按钮

- Quick Settings Audio Panel

  让你快捷地在右上角的面板里调整每个软件、网页的音频。quick settings tweaks扩展包含了这个功能，如果安装了就不要装这个啦。

- battery time

  显示电量剩余可用时间

- custom reboot

  可以快捷重启到别的系统。设置里选择使用grub，然后在快捷设置菜单里reload和enbale。（grub放在btrfs的话没法使用这个）

- search light

  可以在桌面直接调出搜索，不用进overview才能搜索了。

## 美化用扩展

- blur my shell 

  透明度美化

- hide top bar 

  隐藏面板（panel，顶部的那个面板，win叫任务栏），和app icons taskbar/ dash to panel之类的扩展冲突。设置里激活sensitivity的第一个。intellihide取消激活第二项。

- user themes 

  管理主题

- logo menu 

  在面板显示一个logo，好玩。设置里更换gnome extension为extension manager；终端换ghostty；systemmonitor换missioncenter；取消激活show activities button

- desktop cube 

  桌面端用户强烈推荐。把工作区切换从平铺变成一个可以旋转的方块的面。设置的overview里把透明度（opacity）都改成50%，超级酷！

- rounded window corners reborn 

  让所有窗口变成圆角。这个扩展是真神。 设置里取消激活skip libadwaita applications，然后把corner radius改成14，这样就和gnome的圆角没区别了。

## 实现windows布局

可以通过扩展把gnome变成windows布局

1. 安装扩展

   - app icons taskbar

     实现windows那样的任务栏。和hide top bar、dash to dock冲突。如果关闭了在所有显示器上显示就无法智能隐藏，原因不明。

   - desktop icons ng

     实现windows那样的桌面快捷方式。如果快捷方式打了个叉让你设置执行权限的话在终端去到~/Desktop目录，然后运行这个命令设置相信元数据。这是gnome的一个安全措施。

     ```
     gio set ~/Desktop/*.desktop "metadata::trusted" true
     ```

   - 可选：arcmenu

     这是功能强大的开始菜单扩展。需要pacman安装gnome-menus。

   - 可选：just perfection

     功能强大的自定义扩展，可以设置gnome各个元素的开关。不过根据gnome版本的不同能设置的选项会有所不同，稳定性堪忧。

   - 可选：用dash to panel 替换app icons taskbar

     dash to panel设置更简单，但没有app icons taskbar好看

2. 修改扩展的设置

   - app icons taskbar

     settings页面里：

     激活hide dash in overview（隐藏概览里的快捷栏）

     app icons position in panel （软件图标在面板上的位置）改成center

     激活show all apps button（显示所有软件按钮），位置选right（右边）

     icon size（图标大小）和padding（间距） 按需调整

     panel里激活intllihide（智能隐藏），设置里把only focused window （仅选中的窗口）改成all windows（所有窗口）

     panel location（面板位置）选bottom（底部）

     panel height（面板高度）调整到合适的数值。

     取消激活show activities button（显示活动按钮）

     show weather near clock（在时钟旁显示天气）选right（右边）

     clock posisiton in panel（时钟在面板中的位置）改成right

     这样布局就和win11一模一样了。

   - desktop icons ng

     取消激活显示个人文件夹、回收站图标

## 调节外接屏幕亮度

[ddcutil-service](https://github.com/digitaltrails/ddcutil-service)

gnome默认没法调节外接屏幕亮度，通过ddcutil+扩展可以进行调节。

```
yay -S ddcutil-service
```

```
sudo gpasswd -a $USER i2c
```

安装扩展[Control monitor brightness and volume with ddcutil](https://extensions.gnome.org/extension/6325/control-monitor-brightness-and-volume-with-ddcutil/)

```
reboot
```

### ddcutil使用方法

获取显示器信息

```
ddcutil detect
```

示例输出：

```shell
Display 1
   I2C bus:  /dev/i2c-14
   DRM_connector:           card1-DP-2
   EDID synopsis:
      Mfg id:               SKG - UNK
      Model:                H27T22C
      Product code:         10099  (0x2773)
      Serial number:
      Binary serial number: 1 (0x00000001)
      Manufacture year:     2024,  Week: 46
   VCP version:         2.1
```

注意第一行的Display 1

获取当前亮度

```shell
ddcutil --display 1 getvcp 10
```

加减亮度

```shell
ddcutil --display 1 setvcp 10 + 5
ddcutil --display 1 setvcp 10 -- 5
```

输出应该为

```
‘ghostty’
’-e‘
```

## 光标主题

主题下载网站 https://www.gnome-look.org/browse?cat=107&ord=latest

将下载的.tar.gz文件里面的文件夹放到`～/.local/share/icons/`目录下，没有icons文件夹的话自己创建一个

## gnome主题

gnome的默认主题已经相当漂亮，如果有修改主题的需要的话去这个网站：

https://www.gnome-look.org/browse?cat=134&ord=latest

通常下载页面都有指引，文件路径是`~/.themes/`，放进去之后在user themes扩展的设置里面改可以改主题。

主题主要分gtk-3、gtk-4和gnome-shell。user themes扩展和gnome-tweaks之类的软件修改gnome-shell比较方便。修改gkt-3主题的话建议用nwg-look，gtk-4的文件自己复制粘贴到`~/.config/gtk-4.0/`

## 下一节：[终端美化](终端美化)

# 我的KDE自定义设置

## 桌面编辑

### 桌面鼠标功能

右键桌面>桌面和壁纸>鼠标操作>添加操作

1. 中键 程序启动器
2. 垂直滚动滚轮 切换桌面

### 桌面组件

#### wallpaper effects

这个组件可以在聚焦窗口时模糊桌面

右键进入编辑模式>左上角添加组件>获取新挂件>下载plasma挂件>搜索安装wallpaper effects，或者从aur安装

```
yay -S plasma6-applets-wallpaper-effects
```

添加到桌面后进行配置：blur radius 改成 30；pixelate effect的enbale改成never；grain改成never；color effects改成never；激活rounded corners，radius改成15

#### Apdatifier

更新相关的桌面组件

#### kdeconnect

```
sudo pacman -S kdeconnect
```

可以和手机传输文件，共享剪贴板。手机也需要下载kde connect。

### 桌面面板（任务栏）

右键任务栏（kde里叫面板），显示面板配置。设置为半透明；悬浮改成仅小程序；显示隐藏改成避开窗口；删除工作区、显示桌面相关组件；添加两个间隔，把开始菜单和软件移动到中心。

#### 右下角组件

点击时间左边的上箭头，在弹出来的窗口的右上角开启系统托盘设置，项目里面按需设置。我会设置电量和电池总是显示，蓝牙总是隐藏。

## 系统设置

以下都是我的设置，你可以按照自己的来。

### 快捷键

系统设置 > 输入和输出 > 键盘 > 快捷键

- 应用程序

  kruner: meta+Z

  浏览器： meta+B

  系统设置：启动：Ctrl+alt+S

  新增：任务中心（missioncenter）： meta+esc

  konsole终端：Meta+T


- 窗口管理：

  磁贴编辑开关：meta+f9

  关闭窗口：meta+Q

  强制终止窗口：meta+crtl+Q

  全屏显示窗口：meta+alt+F

  显示隐藏桌面总览：meta

  移动窗口到中央：meta+C

  暂时显示桌面：meta+M

  自定义快速铺放窗口到上下左右：meta+WASD

  然后打开磁铁编辑器编辑一个自己喜欢的布局

  最大化窗口：meta+F

  最小化窗口：meta+H

- plasma工作空间

  激活应用程序启动器： alt

  显示活动切换器： meta+TAB

### 无障碍辅助

“抖动后放大光标”调到最大（不是）

### 窗口管理

系统设置>窗口和应用>窗口管理

### 窗口行为

标题栏操作

鼠标滚轮：移动到上个/下个桌面

### 桌面特效

- 窗口惯性晃动

  激活窗口惯性晃动，启用高级设置，调整效果到自己喜欢的程度。我的设置是25、70、15

- geometry change

  点击获取新效果，这个要加载很久很久。下载geometry change，或者从aur安装。从aur安装的话需要重新打开系统设置。

  ```
  yay -S kwin-effects-geometry-change
  ```

  这可以给窗口的快捷键平铺添加动画。动画速度设置为500ms

- 窗口透明度

  激活窗口透明度，按照喜好设置

- 窗口背景虚化和背景对比度

  按需设置

- rounded corners（圆角）

  ```
  yay -S kwin-effect-rounded-corners-git
  ```

  ```
  reboot
  ```

  - 圆角页面

    圆角半径都改为15，取消激活平铺时禁用圆角

  - 轮廓

    主轮廓的活动窗口轮廓粗细改成2，激活使用装饰色：高亮；非活动窗口的粗细改成0；

    次轮廓的活动窗口轮廓粗细改成1，激活使用装饰色：高亮；非活动窗口的粗细改成0；

    取消激活平铺时禁用轮廓。

### 虚拟桌面

按需增加，激活切换时显示屏幕提示，改成500ms

## 主题美化

### 更换桌面壁纸

系统设置>外观和样式>壁纸

按需选择壁纸类型

这里有一个小技巧，如果你按住左键把一张图片从dolphin拖放到桌面上，会跳出来一个菜单。

### 更换锁屏壁纸

系统设置>安全和隐私>锁屏>配置外观

按需选择壁纸类型

### 文字和字体

系统设置>外观和样式>文字和字体

我喜欢用adwaita字体，大小11pt

### 全局主题

我觉得breeze已经挺漂亮了，就不下载第三方主题了。

系统设置>外观和样式>颜色和主题

- 颜色

  breeze微风经典

  基于壁纸获取强调色，或者选择自定义强调色，从壁纸上提取一个合适的颜色

- 应用程序外观样式

​		选择默认的breeze 微风，点击右下角的画笔配置，菜单透明度往左2格

- plasma 外观和样式

​		breeze微风深色

- 窗口装饰元素

​		breeze微风。点击右下角的笔，设置按钮大小。配置标题栏按钮，按需调整

- 光标

​		breeze 微风深色，大小30

- 登录屏幕

​		换一个壁纸

# 终端美化

## Shell美化

### 更换shell

#### fish

fish提供了开箱即用的方便功能，缺点是语法和zsh/bash不一样。

1. 安装fish

   ```
   sudo pacman -S fish 
   ```

2. 更换shell为fish

   ```
   chsh -s /usr/bin/fish
   ```

3. 重启电脑

   ```
   reboot
   ```

4. 编辑配置文件去掉默认的启动文字

   ```
   vim ~/.config/fish/config.fish
   ```

   写入：

   ```
   set fish_greeting ""
   ```

#### zsh

1. ```
   sudo pacman -S zsh
   ```

2. ```
   chsh -s /usr/bin/zsh
   ```

3. 语法检查、自动补全、tab选择、历史记录

   ```
   sudo pacman -S zsh-syntax-highlighting zsh-autosuggestions zsh-completions
   ```

   ```
   vim ~/.zshrc
   ```

   写入：

   ```
   #语法检查和高亮
   source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
   source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
   
   #开启tab上下左右选择补全
   zstyle ':completion:*' menu select
   autoload -Uz compinit
   compinit
   
   # 设置历史记录文件的路径
   HISTFILE=~/.zsh_history
   
   # 设置在会话（内存）中和历史文件中保存的条数，建议设置得大一些
   HISTSIZE=1000
   SAVEHIST=1000
   
   # 忽略重复的命令，连续输入多次的相同命令只记一次
   setopt HIST_IGNORE_DUPS
   
   # 忽略以空格开头的命令（用于临时执行一些你不想保存的敏感命令）
   setopt HIST_IGNORE_SPACE
   
   # 在多个终端之间实时共享历史记录 
   # 这是实现多终端同步最关键的选项
   setopt SHARE_HISTORY
   
   # 让新的历史记录追加到文件，而不是覆盖
   setopt APPEND_HISTORY
   # 在历史记录中记录命令的执行开始时间和持续时间
   setopt EXTENDED_HISTORY
   ```

4. 重启终端

### starship提示符美化

[Starship](https://starship.rs/)

1. 安装nerd字体和starship

   ```
   sudo pacman -S ttf-jetbrains-mono-nerd starship
   ```

2. 编辑配置文件激活starship

   - fish

     ```
     vim ~/.config/fish/config.fish
     ```

     ```
     starship init fish | source
     ```

   - zsh

     ```
     vim ~/.zshrc
     ```

     ```
     eval "$(starship init zsh)"
     ```

3. https://starship.rs/presets/

   到这个网站下载一个自己喜欢的预设主题，重命名为`starship.toml`，放到`~/.config`，或者你有兴趣的话也可以自己做一个。

4. 重启终端

## Ghostty美化

1.2版本的ghostty的中文字体有点问题，可以downgrade到旧版本，或者凑活用着等更新。

1. 下载[catppuccin](https://github.com/catppuccin/ghostty?tab=readme-ov-file)颜色配置，或者找一个你喜欢的，粘贴到`~/.config/ghostty/themes/`

2. 修改`~/.config/ghostty/config` 配置文件，例如下载的是frappe的话

   ```
   #颜色配置文件路径要使用/开头的绝对路径
   theme = /home/shorin/.config/ghostty/catppuccin-frappe.conf
   
   #隐藏标题栏
   window-decoration = none
   
   #设置透明度
   background-opacity=0.8
   
   #设置字体和字体大小
   font-family = "Adwaita Mono" 
   font-size = 15
   
   #设置左右边距
   window-padding-x=10
   #设置上下边距
   window-padding-y=10
   ```

3. 重启终端

## Konsole美化

1. 菜单>设置>显示工具栏>去掉两个勾选

2. 右键>菜单>设置>配置konsole

   常规页面里激活“移除窗口标题和框架”。

   配置方案里新建一个配置方案；外观里点击“获新方案：下载一个自己喜欢的，我使用catppuccin frappe。选中喜欢的配色方案后点击编辑设置20%透明度；设置字体为adwaitaoMono（一个你喜欢的mono等宽字体），大小15pt；”其他“页面里设置边距，取消激活调整大小后显示终端大小提示。

   滚动里隐藏滚动条，取消激活高亮显示刚刚进入视图的行。确认。

   选中刚刚创建的配置方案设置为默认。

   确认。

   重启终端。

## Kitty美化

网上下载自己喜欢的颜色配置文件 https://github.com/catppuccin/kitty

我以catppuccin frappe为例，下载frappe.conf，复制到`~/.config/kitty/themes`目录下

编辑kitty的配置文件：

```
vim ~/.config/kitty/kitty.conf
```

```
#导入颜色文件
include themes/frappe.conf
#设置左右边距
window_padding_width 5
#隐藏标题栏
hide_window_decorations yes
#背景透明度
background_opacity 0.8
#字体
font_family Adwaita Mono
#字体大小
font_size 15
#不要记住窗口大小（yes no）
remember_window_size no
#关闭窗口时不要询问是否关闭
confirm_os_window_close 0
```

# grub美化

## grub主题

1. 网上下载grub主题放到`/efi/grub/themes`  

   其他可能会用到的路径有`/usr/share/grub/themes/`和`/boot/grub/themes`。

2. 编辑grub源文件

   ```
   /etc/default/grub
   ```

   - 主题路径
     `GRUB_THEME="/path/to/theme.txt"`

   - 分辨率
     `GRUB_GFXMODE=2560X1440,1920x1080,auto`

3. 生成grub的配置文件

   ```
   `grub-mkconfig -o /efi/grub/grub.cfg`
   ```

我喜欢的主题：

[CyberGRUB-2077](https://github.com/adnksharp/CyberGRUB-2077)

[Crossgrub](https://github.com/krypciak/crossgrub)

这个repo有一些别人收集的主题：

https://github.com/Jacksaur/Gorgeous-GRUB

# 显卡切换

## 混合模式下用独显运行

### PRIME

```
sudo pacman -S nvidia-prime
```

- 使用 `prime-run`命令使用独显运行软件

```
prime-run firefox 
```

### switcheroo-control

gnome装这个可以右键桌面快捷方式选择使用独显运行

```
sudo pacman -S switcheroo-control 
```

```
sudo systemctl enable --now switcheroo-control 
```

### KDE桌面可以直接开始菜单右键编辑应用程序在高级页面设置用独显运行

## 显卡切换

目前在wayland没有完善的显卡切换，可能只能做到从混合模式切换到核显模式。以下是几个常用的工具，可以自己试试看能不能用。建议安装时处在混合模式。从混合切到独显直连大概率会失败，谨慎操作。

### supergfxctl

asus华硕用户可以用supergfxctl

[Linux for ROG Notebooks](https://asus-linux.org/)

```
yay -S supergfxctl
```

```
sudo systemctl enable --now supergfxd
```

gnome从扩展里下载GPU supergfxctl switch

kde从aur安装这个```plasma6-applets-supergfxctl```

```
yay -S plasma6-applets-supergfxctl
```

### envycontrol

[GitHub - bayasdev/envycontrol: Easy GPU switching for Nvidia Optimus laptops under Linux](https://github.com/bayasdev/envycontrol)

```
yay -S envycontrol 
```

gnome装扩展 GPU Profile Selector

kde在桌面右键进如编辑模式，挂件商店里下载Optimus GPU Switcher

# 虚拟机

## VMware

1. 安装缺少的依赖

```
yay -S vmware-keymaps
```

2. 安装本体

```
yay -S vmware-workstation
```

3. 开启服务

```
sudo systemctl enable --now vmware-networks.service
sudo systemctl enable --now vmware-usbarbitrator.service
```

4. 重启电脑

### 卸载vmware

```
sudo systemctl disable --now vmware-networks.service
sudo systemctl disable --now vmware-usbarbitrator.service
yay -Rns vmware-workstation vmware-keymaps
```



## winboat

[winboat](https://github.com/TibixDev/winboat)

以docker容器为基础的windows虚拟机，rdp（远程桌面协议）连接，自动化配置winapps，可以与linux无缝集成，但beta版无缝集成的效果不是很好。只是用windows虚拟机做轻量的活的话可以用这个，安装很简单，缺点是资源占用比kvm/qemu虚拟机要高一些。

1. 安装

   ```
   yay -S --needed freerdp winboat
   ```

2. 开启docker服务

   ```
   sudo systemctl enable --now docker.service
   ```

3. 添加docker组

   ```
   sudo usermod -aG docker $USER
   ```

4. 开启iptables功能

   ```
   echo -e "ip_tables\niptable_nat" | sudo tee /etc/modules-load.d/iptables.conf
   ```

5. 重启电脑

   ```
   reboot
   ```

合起来：

`````````````````````````````````````
yay -S --needed freerdp winboat
sudo systemctl enable --now docker.service
sudo usermod -aG docker $USER
echo -e "ip_tables\niptable_nat" | sudo tee /etc/modules-load.d/iptables.conf
reboot
`````````````````````````````````````

#### 卸载winboat

1. 软件内关闭windows后在configuration页面选择reset winboat & remove vm

2. 清理docker资源

   ```
   sudo docker system prune -a --volumes
   ```

3. 关闭docker服务

   ```
   sudo systemctl disable --now docker.service
   ```

4. 删除winboat

   ```
   yay -Rns winboat
   ```

5. 清理残留文件

   ```
   sudo rm -rfv /var/lib/docker /etc/docker ~/.docker /var/run/docker ~/.winboat
   ```

6. 重启电脑

   ```
   reboot
   ```

合起来：

```
sudo docker system prune -a --volumes && sudo systemctl disable --now docker.service && yay -Rns winboat && sudo rm -rfv /var/lib/docker /etc/docker ~/.docker /var/run/docker ~/.winboat && reboot
```



## virtualbox

https://wiki.archlinux.org/title/VirtualBox

```
sudo pacman -S virtualbox virtualbox-host-dkms
```

不同内核需要安装的包不一样，linux内核是virtualbox-host-modules-arch，其他的看wiki。

### 卸载virtualbox

```
sudo pacman -Rns virtualbox virtualbox-host-dkms
rm -rfv ~/.config/VirtualBox/ ~/VirtualBox\ VMs/
```



## distrobox

[distrobox.it](https://distrobox.it/)

我愿称其为"Linux Subsystem for Linux"。可以利用容器创建一个跟主机Linux深度集成、共享显卡的Linux子系统。比如你想用的软件只提供deb包，那就可以创建一个debian系发行版的盒子安装。比如我最近想用达芬奇剪视频，但是在arch上安装达芬奇需要处理很多依赖和兼容问题，那我可以安装一个redhat系发行版的盒子专门装达芬奇。

disrobox是一个在linux上无缝运行其他linux发行版的项目，使用podman、docker或者lilipod创建容器。有了这个项目就可以安装别的发行版的包了。建议使用podman，这个更轻量化更简洁。

```
sudo pacman -S distrobox podman
```

选项选crun，podman和crun都是红帽主导开发的比docker和runc更新更简洁的程序。

### 创建容器

podman兼容docker镜像，可以去docker hub上搜索镜像对应的字符

比如说我想装一个debian stable

```
distrobox create -n debian -i debian:stable
```

```
#distrobox create 创建容器
#-n 指定容器名
#-i 指定镜像
```

默认会共享主机的home目录，使用--home（简写是-H）给容器指定单独的目录存放home目录下的文件，避免搞乱本机的home目录。

```
distrobox create -n debian -i debian:stable --home ~/Distroboxhome/debian
```

加上--nvidia可以共享本机的n卡驱动

```
distrobox create -n debian -i debian:stable --home ~/Distroboxhome/debian --nvidia
```

创建之后应用程序里会出现快捷方式，也可以在命令行用distrobox enter命令进入。第一次会安装各种基本包。

```
distrobox enter debian
```

创建容器时下载下来的镜像会存放在```/home/shorin/.local/share/containers/storage```目录下

#### 常用的发行版

- debian:stable

  ```
  distrobox create -n debian -i debian:stable --home ~/Distroboxhome/debian
  ```

- archlinux:latest

  ```
  distrobox create -n arch -i archlinux:latest --home ~/Distroboxhome/arch
  ```

- fedora

  ```
  distrobox create -n fedora -i fedora:latest --home ~/Distroboxhome/fedora
  ```

### 在主机创建容器内程序的快捷方式

用distrobox-exprot --app命令在主机```~/.loacl/share/applications```目录下创建对应程序的.desktop文件，比如我安装了星火应用商店

```
distrobox-exprot --app spark-store
```

想删除的话加上--delete

```
distrobox-exprot --app spark-store --delete
```

删除容器的时候也会连着这个快捷方式一起删除

### 删除容器

使用distrobox rm命令

```
distrobox rm debian
```

然后手动删除home目录下的残留

### GUI

安装boxbuddy

- aur

```
yay -S boxbuddy
```

- flathub

```
flatpak install flathub io.github.dvlv.boxbuddyrs
```

## PowerUser进阶用户

如果你需要更深入、性能更强大、功能更多的虚拟机，那就得利用linux内核中的KVM（Kernel-based Virtual Machine基于内核的虚拟机）技术了。

# KVM虚拟机

# KVM/QEMU虚拟机

1. 安装qemu，图形界面， TPM，网络组件

   ```
   sudo pacman -S qemu-full virt-manager swtpm dnsmasq
   ```

2. 开启libvirtd系统服务

   ```
   sudo systemctl enable --now libvirtd
   ```

3. 开启NAT default网络

   ```
   sudo virsh net-start default
   sudo virsh net-autostart default
   ```

4. 添加组权限 需要登出

   ```
   sudo usermod -a -G libvirt $(whoami)
   ```

5. 可选：如果运行出现异常的话编辑配置文件提高权限

   ```
   sudo vim /etc/libvirt/qemu.conf
   ```

   ```
   #把user = "libvirt-qemu"改为user = "用户名"
   #把group = "libvirt-qemu"改为group = "libvirt"
   #取消这两行的注释
   ```

   ```
   sudo systemctl restart libvirtd
   ```

6. 启动virt-manager虚拟机管理程序

有一个注意点，virtmanager默认的连接是系统范围的，如果需要用户范围的话需要左上角新增一个用户会话连接。

## 嵌套虚拟化

intel的话用 kvm_intel

- 临时生效

```
modprobe kvm_amd nested=1
```

- 永久生效

  1. 编辑配置文件

  ```
  sudo vim /etc/modprobe.d/kvm_amd.conf
  ```

  写入

  ```
  options kvm_amd nested=1
  ```

  2. 重新生成initramfs

  ```
  sudo mkinitcpio -P
  ```

  3. 重启电脑

## 配置桥接网络

无线网卡无法配置桥接

1. 启动高级网络配置工具（KDE进设置里的wifi和网络）

2. ```
   nm-connection-editor
   ```

3. 添加虚拟网桥，接口填bridge0

4. 添加网桥连接，选择以太网，选择网络设备

5. 保存后将网络连接改为刚才创建的以太网网桥连接

## 安装win11虚拟机

[手把手教你给笔记本重装系统（Windows篇）_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV16h4y1B7md/?spm_id_from=333.337.search-card.all.click)

1. 任选一个网站下载镜像

   - [HelloWindows.cn - 精校 完整 极致 Windows系统下载仓储站](https://hellowindows.cn/)

   - [下载 Windows 11](https://www.microsoft.com/zh-cn/software-download/windows11)

   - 可选：win11 iot LTS 镜像

     ```
     https://go.microsoft.com/fwlink/?linkid=2270353&clcid=0x409&culture=en-us&country=us
     ```

2. 下载virtio驱动镜像

   [Index of /groups/virt/virtio-win/direct-downloads/archive-virtio](https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/?C=M;O=A)

   点击last modified，然后下载最新版本

3. [「Archlinux究极指南」从手动安装到显卡直通](https://www.bilibili.com/video/BV1L2gxzVEgs/?spm_id_from=333.1387.homepage.video_card.click&vd_source=65a8f230813d56660e48ae1afdfa4182)按照视频里kvm虚拟机的部分安装。或者参照这篇教程[winapps/docs/libvirt.md at main · winapps-org/winapps](https://github.com/winapps-org/winapps/blob/main/docs/libvirt.md)

### 跳过联网

确保机器**没有连接到网络**，按下shift+f10 ，鼠标点击选中弹出来的cmd窗口，运行：

```
oobe\bypassnro
```

### 和本机进行文件分享

[如何在 Linux 主机和 KVM 中的 Windows 客户机之间共享文件夹 | Linux 中国 - 知乎](https://zhuanlan.zhihu.com/p/645234144)

1. 确认开启共享内存
2. 打开文件管理器，复制要共享的文件夹的路径
3. 在虚拟机管理器内添加共享文件夹,粘贴刚才复制的路径，取个名字
4. win11虚拟机内安装winFSP
   https://winfsp.dev/rel/
5. 搜索service（服务），启用VirtIO-FS Service，设置为自动

## 远程桌面

### parsec

1. win虚拟机上浏览器搜索安装

2. linux上安装

   ```
   yay -S parsec-bin
   ```

3. 两个系统都开启，登录相同账号


### sunshine+moonlight

[GitHub - LizardByte/Sunshine: Self-hosted game stream host for Moonlight.](https://github.com/LizardByte/Sunshine)

1. 虚拟机win11内安装sunshine

   https://github.com/LizardByte/Sunshine

   启动后右下角托盘右键sunshine的图标打开web网页，设置账号密码并登录。

2. 虚拟机内安装虚拟显示器

   https://github.com/VirtualDrivers/Virtual-Display-Driver

3. linux安装moonlight

   ```
   sudo pacman -S moonlight-qt
   ```

4. linux启动moonlight后会搜索到win11内的sunshine，点击连接会出现pin码，在win11的sunshine web页面设置pin码添加设备就可以了。

## 显卡直通

[PCI passthrough via OVMF - ArchWiki](https://wiki.archlinux.org/title/PCI_passthrough_via_OVMF)

需要有两个显卡。

1. 确认iommu是否开启，有输出说明开启

   ```
   sudo dmesg | grep -e DMAR -e IOMMU
   ```

   现代设备通常都支持IOMMU且默认开启，BIOS里的选项通常为`Intel VT-d`、`AMD-V`或者`IOMMU`。如果没有的话搜索一下自己的cpu和主板型号看看是否支持。

2. 获取显卡的硬件id，显卡所在group的所有设备的id都记下

   ```
   for d in /sys/kernel/iommu_groups/*/devices/*; do 
       n=${d#*/iommu_groups/*}; n=${n%%/*}
       printf 'IOMMU Group %s ' "$n"
       lspci -nns "${d##*/}"
   done
   ```

3. 隔离GPU

   ```
   sudo vim /etc/modprobe.d/vfio.conf
   ```

   写入

   ```
   options vfio-pci ids=10de:28e0,10de:22be （硬件id与硬件id之间用英文逗号隔开）
   ```

4. 编辑内核参数让vfio-pci抢先加载

   1. ```
      sudo vim /etc/mkinitcpio.conf
      ```

   2. `MODULES=（）`里面写入`vfio_pci vfio vfio_iommu_type1`

      ```
      MODULES=(... vfio_pci vfio vfio_iommu_type1  ...)
      ```

      `HOOKS=()`里面确认有 `modconf`

      ```
      HOOKS=(... modconf ...)
      ```

5. 重新生成initramfs

   ```
   sudo mkinitcpio -P
   ```

6. 安装和配置ovmf

   ```
   sudo pacman -S --needed edk2-ovmf
   ```

   编辑配置文件

   ```
   sudo vim /etc/libvirt/qemu.conf
   ```

   搜索nvram，在合适的地方写入：

   ```
   nvram = [
   	"/usr/share/ovmf/x64/OVMF_CODE.fd:/usr/share/ovmf/x64/OVMF_VARS.fd"
   ]
   ```

7. 重启电脑

   记得把显示器查到核显输出的口上。

8. virt-manager的虚拟机页面内添加设备

   PCI Host Device里找到要直通的显卡（只直通显卡，不要直通类似audio的东西，可能会43报错，安装完驱动之后再直通audio）， 然后USB hostDevice里面把鼠标键盘也直通进去。

9. 开启win11虚拟机，下载nvidia-app安装驱动

10. 关闭虚拟机，虚拟机设置里显卡改成none

### 取消显卡直通

1. ```
   sudo vim /etc/modprobe.d/vfio.conf
   ```

   注释掉里面的东西

2. 重新生成initramfs

   ```
   sudo mkinitcpio -P
   ```

3. ```
   reboot
   ```

### LookingGlass

[Installation — Looking Glass B7 documentation](https://looking-glass.io/docs/B7/install/)

[PCI passthrough via OVMF - ArchWiki](https://wiki.archlinux.org/title/PCI_passthrough_via_OVMF)

视频教程：[从这个视频的19分30秒左右开始看](https://www.bilibili.com/video/BV1zyttzPEmp/?share_source=copy_web&vd_source=1c6a132d86487c8c4a29c7ff5cd8ac50)

looking glass通过共享内存实现屏幕分享，专为显卡直通虚拟机设计。win虚拟机内需要安装虚拟显示器：[Virtual-Display-Driver](https://github.com/VirtualDrivers/Virtual-Display-Driver)

1. 计算需要的共享内存大小
   具体可以看官方档案，我是2560x1440@180hz 非HDR，需要大小是64M

2. 设置共享内存设备
   打开virt-manager，点击编辑 > 首选项，勾选启用xml编辑。
   打开虚拟机配置，找到xml底部的  ```</devices>```，在  ```</devices>```的上面添加设备，size记得该成自己需要的，就是这种感觉：

   ```
   <devices>
       ...
     <shmem name='looking-glass'>
       <model type='ivshmem-plain'/>
       <size unit='M'>64</size> 
     </shmem>
   </devices>
   ```

3. 开启终端，添加kvm组

   ```
   sudo gpasswd -a $USER kvm 
   ```

4. 重启电脑

   ```
   reboot
   ```

   

5. 确认自己在kvm组里

   ```
   groups
   ```

6. 设置共享内存设备对应的文件的规则

   ```
   sudo vim /etc/tmpfiles.d/10-looking-glass.conf
   ```

   写入（shorin改为自己的用户名）：

   ```
   f /dev/shm/looking-glass 0660 shorin kvm -
   ```

   `f` 代表定文件规则
   `/dev/shm/looking-glass`是共享内存文件的路径
   `0660` 设置所有者和所属组的读写权限
   `shorin` 设置所有者
   `kvm` 设置所属组

   `-`代表保留时间永久，不进行清理

7. 无须重启，现在手动创建文件

   ```
   sudo systemd-tmpfiles --create /etc/tmpfiles.d/10-looking-glass.conf
   ```

8. 回到虚拟机设置

   1. 设置spice协议

      确认有spice显示协议，显卡设置为none

   2. 键鼠传输

      添加virtio键盘和virtio鼠标（要在xml里面更改bus=“ps2”为bus=“virtio”）

   3. 剪贴板同步

      确认有spice信道设备，没有的话添加，设备类型为spice

   4. 声音传输

      确认有ich9声卡，点击概况，去到xml底部，在里面找到下面这段，确认type为spice

      ```
      <audio id='1' type='spice'/>
      ```

9. 开启虚拟机，安装looking glass 服务端

   [Looking Glass - Download Looking Glass](https://looking-glass.io/downloads)

   浏览器搜索 looking glass，点击download，下载bleeding-edge的windows host binary，解压后双击exe安装

10. linux安装客户端

    服务端和客户端的版本要匹配，最容易出错的就是这个地方。bleeding-edge对应git包

    ```
    yay -S looking-glass-git
    ```

11. 桌面快捷方式打开lookingglass即可连接

12. 关闭虚拟机。克隆虚拟机之后使用克隆机而不是初号机

#### 使用技巧

具体可以看这个页面：https://looking-glass.io/docs/B6-rc1/usage/

开启looking-glass后使用scroll lock键有很多功能，包括最重要的键鼠捕获。长按会显示可用功能的列表.如果你的键盘没有scroll lock键，可以修改配置文件更改。

```
 vim ~/.config/looking-glass/client.ini
```

 写入： 

 ```
[input]
escapeKey=KEY_F9
 ```

把F9换成自己想要的键，可用的键可以在终端输入 looking-glass-client -m KEY 查看

我是用桌面环境的快捷键切换全屏和窗口的，你也可以选择设置以全屏模式开启，还是刚才那个配置文件，写入：

```
[win]
fullScreen = yes 
```

## KVM虚拟机性能优化和伪装

优化后可以做到原生九成五的性能。

### 禁用memballoon

[libvirt/QEMU Installation — Looking Glass B7 documentation](https://looking-glass.io/docs/B7/install_libvirt/#memballoon)

memlbaloon的目的是提高内存的利用率，但是由于它会不停地“取走”和“归还”虚拟机内存，导致显卡 直通时虚拟机内存性能极差。

将虚拟机xml里面的memballoon改为none，这将显著提高low帧。

```
<memballoon model="none"/>
```

### 内存大页

[KVM - Arch Linux 中文维基](https://wiki.archlinuxcn.org/wiki/KVM#%E5%BC%80%E5%90%AF%E5%86%85%E5%AD%98%E5%A4%A7%E9%A1%B5)

可以大幅提高内存性能。用minecraft实测帧数提升了20%。注意，设置大页的那部分内存本机无法使用。

1. 计算大页大小

   内存（GB）* 1024 / 2 = 需要的大小

   比如16GB内存就是16*1024/2=8192，wiki建议略大一些，那就8200。

   我通常给虚拟机分24GB内存，24*1024/2=12288，略大一些就是12300。

2. 编辑虚拟机xml

   在virt-manager的g首选项里开启xml编辑，找到```<memoryBacking>```并添加```<hugepages/>```

   ```
     <memoryBacking>
       <hugepages/>
     </memoryBacking>
   ```

3. 永久生效

   记得把数字改成自己需要的

   ```
   sudo vim /etc/sysctl.d/40-hugepage.conf
   ```

   ```
   vm.nr_hugepages = 8800
   ```

4. reboot

5. 虚拟机开启后查看大页使用情况

   ```
   grep HugePages /proc/meminfo
   ```

#### 取消大页

```
sudo rm /etc/sysctl.d/40-hugepage.conf
```

```
reboot
```

### cpupin

[PCI passthrough via OVMF - ArchWiki](https://wiki.archlinux.org/title/PCI_passthrough_via_OVMF#CPU_pinning)

主要目的是提升cpu缓存性能。避免虚拟机cpu线程对应的物理cpu线程变化导致缓存性能下降。

通常在virt-manager里手动设置cpu拓扑为1插槽，核心数和线程数跟自己的cpu对应就够用了，如果要极致的优化继续往下看。

1. 查看物理cpu拓扑

   ```
   lscpu -e
   ```

   主要看3项，cpu是线程，core是物理核心，L1d:L1i:L2:L3是缓存。如果开启了超线程，会出现一个core对应两个cpu的情况。究竟该pin哪些cpu需要看缓存。

   看一个例子：

   ```
     CPU    NODE     SOCKET    CORE L1d:L1i:L2:L3 ONLINE    MAXMHZ   MINMHZ       MHZ
     0    0      0    0 0:0:0:0           是 5263.0610 402.7860 4687.7769
     1    0      0    1 1:1:1:0           是 5263.0610 402.7860 4687.6860
     2    0      0    2 2:2:2:0           是 5263.0610 402.7860 4688.5659
     3    0      0    3 3:3:3:0           是 5263.0610 402.7860 4688.6870
     4    0      0    4 4:4:4:0           是 5263.0610 402.7860 4688.7310
     5    0      0    5 5:5:5:0           是 5263.0610 402.7860 4689.5552
     6    0      0    6 6:6:6:0           是 5263.0610 402.7860 4689.2202
     7    0      0    7 7:7:7:0           是 5263.0610 402.7860 4689.5889
     8    0      0    0 0:0:0:0           是 5263.0610 402.7860 4688.2788
     9    0      0    1 1:1:1:0           是 5263.0610 402.7860 2361.5911
    10    0      0    2 2:2:2:0           是 5263.0610 402.7860 4688.4370
    11    0      0    3 3:3:3:0           是 5263.0610 402.7860 4688.4502
    12    0      0    4 4:4:4:0           是 5263.0610 402.7860 4688.4072
    13    0      0    5 5:5:5:0           是 5263.0610 402.7860 4688.2578
    14    0      0    6 6:6:6:0           是 5263.0610 402.7860 4688.2778
    15    0      0    7 7:7:7:0           是 5263.0610 402.7860 4688.3350
   ```

   这个例子里所有核心共享L3缓存，所以无法优化L3缓存性能。但是可以优化L1和L2。比如core0对应cpu0和cpu8，cpu0和cpu8共享同一个L1L2缓存，如果仅pin cpu0就会导致运行到cpu8的缓存里，导致缓存性能下降，所以必须同时pin cpu0和cpu8

2. 修改xml，在```  <vcpu placement="static">16</vcpu>```下方插入

   ```
     <iothreads>2</iothreads>
     <cputune>
       <vcpupin vcpu="0" cpuset="2"/>
       <vcpupin vcpu="1" cpuset="10"/>
       <vcpupin vcpu="2" cpuset="3"/>
       <vcpupin vcpu="3" cpuset="11"/>
       <vcpupin vcpu="4" cpuset="4"/>
       <vcpupin vcpu="5" cpuset="12"/>
       <vcpupin vcpu="6" cpuset="5"/>
       <vcpupin vcpu="7" cpuset="13"/>
       <vcpupin vcpu="8" cpuset="6"/>
       <vcpupin vcpu="9" cpuset="14"/>
       <vcpupin vcpu="10" cpuset="7"/>
       <vcpupin vcpu="11" cpuset="15"/>
       <emulatorpin cpuset="0,8,1,9"/>
       <iothreadpin iothread="1" cpuset="0.8,1,9"/>
       <iothreadpin iothread="2" cpuset="0,8,1,9"/>
     </cputune>
   ```

     ```<iothreads>2</iothreads>```设置io线程

   ```<vcpupin vcpu="0" cpuset="2"/>```虚拟机有几个线程就写几行vcpu，0算第一个。cpuset指定vcpu对应的主机cpu线程，也就是```lscpu -e```输出结果里的cpu那一列。比如举例的这段的意思是vcpu0对应本机的cpu2

   ```    <emulatorpin cpuset="0,1,8,9"/>```这一段设置专门用来处理虚拟机相关工作的cpu。

   ```<iothreadpin iothread="1" cpuset="0,1,8,9"/>```指定专门用来做io相关工作的cpu。    

3. 禁用大部分timer，以减少虚拟机空闲时的cpu占用

   ```
   <clock offset='localtime'>
     <timer name='rtc' present='no' tickpolicy='catchup'/>
     <timer name='pit' present='no' tickpolicy='delay'/>
     <timer name='hpet' present='no'/>
     <timer name='kvmclock' present='no'/>
     <timer name='hypervclock' present='yes'/>
   </clock>
   ```

4. 启用 Hyper-V enlightenments

   ```
   <hyperv>
   <relaxed state='on'/>
   <vapic state='on'/>
   <spinlocks state='on' retries='8191'/>
   <vpindex state='on'/>
   <synic state='on'/>
   <stimer state='on'>
   <direct state='on'/>
   </stimer>
   <reset state='on'/>
   <frequencies state='on'/>
   <reenlightenment state='on'/>
   <tlbflush state='on'/>
   <ipi state='on'/>
   </hyperv> 
   ```

   让 KVM “伪装”成 Hyper-V，以“欺骗”Windows 开启高性能模式，大幅提升 Windows 虚拟机的运行性能、降低CPU消耗，并改善其稳定性

### 伪装虚拟机

[How to play PUBG (with BattleEye) on a Windows VM : r/VFIO](https://www.reddit.com/r/VFIO/comments/18p8hkf/how_to_play_pubg_with_battleeye_on_a_windows_vm/)

为了避免被反作弊程序检测到虚拟机，需要修改xml伪装虚拟机。

#### ⚠️警告：进入虚拟机的反作弊之间的猫鼠游戏意味着你做好了被封号的觉悟 

#### ⚠️警告：每进行一步都要确认虚拟机能正常运行再进行下一步

1. 可选：使用sata硬盘和e1000网卡

2. 在```</hyperv> ```下面一行插入：

```
<kvm>
<hidden state="on"/>
</kvm> 
```

3. 在``` <os firmware="efi">```上面一行插入，这是伪装bios。然后复制xml顶部的uuid，替换下面这段里的【这里要粘贴自己虚拟机的uuid】。里面的name信息可以按需修改。

```
<sysinfo type="smbios">
<bios>
<entry name="vendor">American Megatrends International, LLC.</entry>
<entry name="version">F21</entry>
<entry name="date">10/01/2024</entry>
</bios>
<system>
<entry name="manufacturer">Gigabyte Technology Co., Ltd.</entry>
<entry name="product">X670E AORUS MASTER</entry>
<entry name="version">1.0</entry>
<entry name="serial">12345678</entry>
<entry name="uuid">【这里要粘贴自己虚拟机的uuid】</entry>
<entry name="sku">GBX670EAM</entry>
<entry name="family">X670E MB</entry>
</system>
</sysinfo> 
```

4. 禁用migratable

```
  <cpu mode="host-passthrough" check="none" migratable="off">  
```

 migratable是为服务器集群准备的“搬家”功能，关闭。

5. 在`    <topology sockets="1" dies="1" clusters="1" cores="8" threads="2"/>`下面一行插入（**这里仅适用于amd处理器，由于我没有intel处理器所以没法测试适用于intel的配置，可以问一问ai**）

主要是为了伪装成一个友好的hyper-v，调整cpu时钟，修复cpu安全漏洞、设置高级指令集、隐藏cpu虚拟化。顺便一提如果伪装成hyper-v的话就没法在虚拟机里面安装vmware了，` <feature policy="disable" name="svm"/> `这个申明虚拟机cpu没有虚拟化功能，也就玩不了安卓模拟器之类的东西了。

```
    <cache mode="passthrough"/>
    <feature policy="require" name="hypervisor"/> 
    <feature policy="disable" name="aes"/>
    <feature policy="require" name="topoext"/>
    <feature policy="disable" name="svm"/> 
    <feature policy="require" name="amd-stibp"/>
    <feature policy="require" name="ibpb"/>
    <feature policy="require" name="stibp"/>
    <feature policy="require" name="virt-ssbd"/>
    <feature policy="require" name="amd-ssbd"/>
    <feature policy="require" name="pdpe1gb"/>
    <feature policy="require" name="tsc-deadline"/>
    <feature policy="require" name="tsc_adjust"/>
    <feature policy="require" name="rdctl-no"/>
    <feature policy="require" name="skip-l1dfl-vmentry"/>
    <feature policy="require" name="mds-no"/>
    <feature policy="require" name="pschange-mc-no"/>
    <feature policy="require" name="invtsc"/>
    <feature policy="require" name="cmp_legacy"/>
    <feature policy="require" name="xsaves"/>
    <feature policy="require" name="perfctr_core"/>
    <feature policy="require" name="clzero"/>
    <feature policy="require" name="xsaveerptr"/>
```

6. 时钟，找到clock offset那段修改，时区可以按需修改，不改也没事。

```
  <clock offset="timezone" timezone="Asia/Japan">
    <timer name="rtc" present="no" tickpolicy="catchup"/>
    <timer name="pit" tickpolicy="discard"/>
    <timer name="hpet" present="no"/>
    <timer name="kvmclock" present="no"/>
    <timer name="hypervclock" present="yes"/>
    <timer name="tsc" present="yes" mode="native"/>
  </clock>
```

---

# Linux玩游戏

这里有这部分内容的视频教程：[「Linux游戏指南」关于Linux玩游戏的一切](https://www.bilibili.com/video/BV1zyttzPEmp/?share_source=copy_web&vd_source=1c6a132d86487c8c4a29c7ff5cd8ac50)


## 游玩前的准备

- 检查32位驱动包

  n卡注意驱动包要换成自己的

  Nvidia GPU

  ```
  sudo pacman -S --needed nvidia-open-dkms nvidia-utils lib32-nvidia-utils vulkan-icd-loader lib32-vulkan-icd-loader 
  ```

  AMD GPU

  ```
  sudo pacman -S --needed lib32-mesa vulkan-radeon lib32-vulkan-radeon vulkan-icd-loader lib32-vulkan-icd-loader
  ```

## 小黄鸭补帧

https://github.com/PancakeTAS/lsfg-vk

视频教程：[这个视频的18分左右开始看](https://www.bilibili.com/video/BV1zyttzPEmp/?share_source=copy_web&vd_source=1c6a132d86487c8c4a29c7ff5cd8ac50)

需要先下载steam正版的的小黄鸭。也许盗版也可以，但是正版就30块而已，我就不试盗版行不行了，有兴趣的可以自己试试，手动指定一下lossless.dll的路径说不定能运行。

- 从yay安装lsfg-vk，有lsfg-vk-bin、lsfg-vk、lsfg-vk-git三个包，随意装一个。

```
yay -S lsfg-vk-git
```

### 使用方法

具体的使用方法可以去看官方文档[Home · PancakeTAS/lsfg-vk Wiki](https://github.com/PancakeTAS/lsfg-vk/wiki)

我只演示一个方法。

打开lsfg-vk-ui，新建一个profile，任意取一个名字（profile name），比如我取一个miyu。常见用途有两个，看视频和玩游戏。

1. 看视频

   mpv的兼容性最好。打开终端，使用LSFG_PROCESS环境变量指定profile，空格，mpv，空格，填入视频文件的绝对路径，回车运行。比如：

   ```
   LSFG_PROCESS="miyu" mpv /home/shorin/Videos/test.mkv
   ```

2. 玩游戏

   steam右键想要运行的游戏，启动参数填入刚刚的环境变量LSFG_PROCESS="miyu"，空格， %command%。比如：

   ```
   LSFG_PROCESS="miyu" %command%
   ```

3. 其他

   同理，luris之类的也可以像steam那样设置启动参数。可以在终端输入```LSFG_PROCESS="miyu" 程序启动命令``尝试对启动任意程序开启补帧，但是不一定生效。

lsfg一旦生效，就可以修改profile，实时更改补帧倍率。

如果配置过程出错可以用快照恢复到操作前的状态，重新来过。

flatpak程序使用补帧看这里[Using lsfg‐vk in Flatpak · PancakeTAS/lsfg-vk Wiki](

## steam

[Proton (软件) - 维基百科，自由的百科全书](https://zh.wikipedia.org/wiki/Proton_(%E8%BB%9F%E9%AB%94))

[Steam - ArchWiki](https://wiki.archlinux.org/title/Steam)

1. 安装steam

   ```
   sudo pacman -S steam
   ```

2. 开启steamplay（新版本steam默认开启） 

   在设置→兼容性里面选择默认兼容性工具为proton-experimental即可运行大部分游戏

3. 禁用btrfs写时复制 

   禁用游戏存放目录的btrfs的写时复制（CoW），否则会下载速度异常。默认目录是`~/.local/share/Steam/`，通常禁用`steamapps`目录的CoW就行了


    ```
    sudo chattr +C ~/.local/share/Steam/steamapps
    ``` 

- 可选：管理`ge-proton`

  `ge-proton`比proton更加强大

  ```
  yay -S protonup-qt
  ```

- 可选：还是下载速度慢的话试试

  ```
  vim ~/.steam/steam/steam_dev.cfg
  ```


   ```
  @nClientDownloadEnableHTTP2PlatformLinux 0
  @fDownloadRateImprovementToAddAnotherConnection 1.0
   ```

 

- 卸载steam

  ```
  sudo pacman -R steam
  sudo rm -rfv ~/.steam ~/.local/share/Steam
  ```

## minecraft

- 从aur安装启动器，推荐使用xmcl

  ``` 
  yay -S xmcl
  ```

## wine兼容层运行

wine是在linux下运行windows程序的兼容层，proton是steam的母公司v社基于wine开发的专门用来玩游戏的兼容层。原理是把window程序发出的请求翻译成linux系统下的等效请求。通常使用最新的wine或者proton版本即可，或者使用GE-proton，这是GE大佬修改的proton。

wine、proton这些兼容层有一大特点叫prefix，相当于一个虚拟的c盘环境，程序的所有操作都在这个prefix中进行，完全不会影响到主机的linux。当你想卸载软件的时候，可以直接把这个prefix扬了，相当于用删除c盘的方式卸载软件，相当相当干净。

为了更好地利用prefix的优势，可以选择给每个应用单独创建一个prefix，但用命令行创建会相当繁琐，于是就有了专门用来管理prefix的工具。

### lutris

[Download Lutris](https://lutris.net/downloads)

lutris是一个专为玩游戏设计的管理工具，可以完全取代steam的“添加非steam游戏”功能。当然也可以用来管理普通软件。

1. 安装

   ```
   sudo pacman -S lutris
   ```

   第一次打开会自动下载各种需要的组件，点击左上角的加号可以看到主要功能

- 卸载lutris

  ```
  sudo pacman -Rns lutris
  ```

  ```
  sudo rm -rfv ~/.config/lutris  ~/.local/share/lutris
  ```

#### 可选：类似微星小飞机的帧数、资源监控软件

  ```
yay -S gamescope mangohud mangojuice
  ```

gamescope可以对游戏的分辨率、窗口模式、缩放进行调节，mangohub是类似微星小飞机的监控软件，mangojuice用来配置mangohub。

- 使用方法

mangojuice设置要显示的项目，然后在lutris右键想要监控的软件 > 系统选项 > Display > 激活显示帧率（MangoHud）

steam的话设置启动参数 mangohud %command%，可以和gamemode同时启用 gamemoderun mangohud %command%

### 如果要玩epic的游戏

```
yay -S heroic-games-launcher
```

## 用显卡直通玩游戏

经过前面显卡直通的操作，我已经有了一台4060显卡的win11，并且配置了looking glass，理论上所有win11能干的事情我都能在这台虚拟机上干。具体的就不用再往下说了吧🤓☝️
至于为什么显卡直通虚拟机win11而不是重启到真的win11里面。[「Linux游戏指南」关于Linux玩游戏的一切](https://www.bilibili.com/video/BV1zyttzPEmp/?spm_id_from=333.1387.homepage.video_card.click&vd_source=65a8f230813d56660e48ae1afdfa4182)这个视频表达得很清楚了。

## 安卓手游

### waydroid

[Install Instructions | Waydroid](https://docs.waydro.id/usage/install-on-desktops)

[Waydroid - Arch Linux 中文维基](https://wiki.archlinuxcn.org/wiki/Waydroid)

安卓系统也是linux内核，那linux发行版自然也能运行安卓，并且性能还是接近原生的。waydroid是linux上的安卓容器，相当于一个完整的安卓系统。

1. 安装

   ```
   yay -S waydroid
   ```

   可选：从archlinuxcn安装waydroid-image（要求添加cn仓库，按照流程，在本文档的yay安装部分已经添加）

   ```
   sudo pacman -S waydroid-image
   ```

2. 初始化

   ```
   sudo waydroid init
   ```

3. 启动服务

   ```
   sudo systemctl enable --now waydroid-container
   ```

4. 安装arm转译

   [GitHub - casualsnek/waydroid_script: Python Script to add OpenGapps, Magisk, libhoudini translation library and libndk translation library to waydroid !](https://github.com/casualsnek/waydroid_script)

   我们的cpu架构是x86_64,要运行arm应用需要安装arm转译, amd装libndk, intel装libhoudini

   ```
   sudo pacman -S lzip
   git clone https://github.com/casualsnek/waydroid_script
   cd waydroid_script
   python3 -m venv venv
   venv/bin/pip install -r requirements.txt
   sudo venv/bin/python3 main.py
   ```

   按照窗口的指引进行安装

5. 开启会话

   ```
   waydroid session start
   ```

   然后应该就能在桌面看到一大堆图标了

6. 可选：软件默认是全屏打开，可以设置窗口化打开软件，f11切换全屏和窗口化

   ```
   waydroid prop set persist.waydroid.multi_windows true
   ```

   然后用命令重启会话，这一步会隐藏桌面的waydroid图标，可以设置显示。如果开启不了的话可以stop之后在尝试用桌面快捷方式开启

   ```
   waydroid session stop
   waydroid session start 
   ```

- 安装软件

  ```
  waydroid app install /apk/的/路径
  ```

#### 安装谷歌框架

依旧是使用这个脚本安装gapps [casualsnek/waydroid_script: Python Script to add OpenGapps, Magisk, libhoudini translation library and libndk translation library to waydroid !](https://github.com/casualsnek/waydroid_script)，安装完成后用以下命令获取设备id

[Google Play Certification | Waydroid](https://docs.waydro.id/faq/google-play-certification)

```
sudo waydroid shell -- sh -c "sqlite3 /data/data/*/*/gservices.db 'select * from main where name = \"android_id\";'"
```

复制id之后去这个网站注册设备

https://www.google.com/android/uncertified

然后重启会话

```
waydroid session stop
```

#### 软件渲染

n卡用户用不了waydroid，可以用软件渲染，但是性能很差，勉强玩2d游戏。

1. 编辑配置文件

   ```
   sudo vim /var/lib/waydroid/waydroid.cfg
   ```

   ```
   [properties]
   ro.hardware.gralloc=default
   ro.hardware.egl=swiftshader
   ```

2. 本地更新应用一下更改后的配置

   ```
   sudo waydroid upgrade --offline
   ```

3. 重启服务

   ```
   systemctl restart waydroid-container
   ```

#### 卸载waydroid

```
waydroid session stop
```

```
sudo systemctl disable --now waydroid-container.service
```

```
yay -Rns waydroid
```

如果下载了waydroid-image的话需要用yay一并卸载。

卸载完后清理残留文件

```
sudo rm -rf /var/lib/waydroid ~/.local/share/waydroid ~/.local/share/applications/waydroid*
```

# Linux性能优化

## N卡动态功耗调节 

```
sudo systemctl enable --now nvidia-powerd.service
```

## LACT进行显卡offset

使用软件商城安装的lact即可

## prelaod

这是一个让软件开启速度变得更快的程序

```
yay -S preload
sudo systemctl enable --now preload
```

## 交换空间和zram

参考资料：

[电源管理/挂起与睡眠 - Arch Linux 中文维基](https://wiki.archlinuxcn.org/wiki/%E7%94%B5%E6%BA%90%E7%AE%A1%E7%90%86/%E6%8C%82%E8%B5%B7%E4%B8%8E%E4%BC%91%E7%9C%A0#%E7%A6%81%E7%94%A8_zswap_%E5%86%99%E5%9B%9E%E4%BB%A5%E4%BB%85%E5%B0%86%E4%BA%A4%E6%8D%A2%E7%A9%BA%E9%97%B4%E7%94%A8%E4%BA%8E%E4%BC%91%E7%9C%A0)

[zswap - ArchWiki](https://wiki.archlinux.org/title/Zswap)

[zram - ArchWiki](https://wiki.archlinux.org/title/Zram)

[Swap - ArchWiki](https://wiki.archlinux.org/title/Swap)

[Zram vs zswap vs swap? : r/archlinux](https://www.reddit.com/r/archlinux/comments/1ivwv1l/zram_vs_zswap_vs_swap/)

[Zswap vs zram in 2023, what's the actual practical difference? : r/linux](https://www.reddit.com/r/linux/comments/11dkhz7/zswap_vs_zram_in_2023)

[linux - ZRAM vs ZSWAP for lower end hardware? - Super User](https://superuser.com/questions/1727160/zram-vs-zswap-for-lower-end-hardware)

简单来说，硬盘swap交换空间会频繁的读写硬盘，导致硬盘寿命下降。故使用内存作为交换空间。有两种方法，zswap和zram。

zswap依托于swap运行，是硬盘swap的缓存，还是会有硬盘读写，虽然可以关闭zswap的写回，但zram更加优雅、简洁。

zram是把内存的一部分动态地作为swap交换空间，和硬盘swap一样都是swap设备。zram占满前完全不会有硬盘swap的读写。

### 不需要睡眠的话删除硬盘swap后开启zram

1. 关闭swap

```
sudo swapoff /swap/swapfile
```

2. 删除swap文件

```
sudo rm /swap/swapfile
```

3. 编辑fstab

```
sudo vim /etc/fstab
```

注释掉swap相关的内容

### zram内存压缩

1. 安装zram-generator

```
sudo pacman -S zram-generator
```

2. 编辑配置文件

```
sudo vim  /etc/systemd/zram-generator.conf
```

```
[zram0]
zram-size = ram
compression-algorithm = zstd 
```

3. 禁用zswap

```
sudo vim /etc/default/grub
```

```
#在GRUB_CMDLINE_LINUX_DEFAULT=""里写入zswap.enabled=0

GRUB_CMDLINE_LINUX_DEFAULT="... zswap.enabled=0 ... "
```

4. 重新生成grub的配置文件

```
sudo grub-mkconfig -o /efi/grub/grub.cfg
```

5. reboot

6. 验证zswap是否关闭

```
sudo grep -R . /sys/kernel/debug/zswap/
```

7. 验证zram是否开启

```
sudo zramctl
或者
swapon
```

## 安装zen内核

ps：会导致功耗略微增加

1. 安装内核和头文件

```
sudo pacman -S linux-zen linux-zen-headers
```

2. 安装显卡驱动，用nvidia-dkms替换nvidia驱动

```
sudo pacman -S nvidia-dkms
```

3. 重新生成grub

```
sudo grub-mkconfig -o /efi/grub/grub.cfg
```

4. 重启

```
reboot #重启时在grub的arch advance启动项里选择zen
```

5. 确认正常运行后删除stable内核

```
sudo pacman -R linux linux-headers
```

7. 重新生成grub

```
sudo grub-mkconfig -o /efi/grub/grub.cfg
```

# 使用小技巧

## 小技巧

- super+左键按住窗口的任意位置移动窗口

- gnome桌面，super+中键可以调整窗口大小，ctrl+c复制文件后ctrl+m可以粘贴一个链接，super+滚轮切换工作区

- kde桌面，super+右键可以可以调整窗口大小，ctrl+super+滚轮可以缩放，super+alt+滚轮切换工作区

- time命令可以计算一个程序启动的时间

  示例：

  ```
  time firefox
  ```

- 默认右键是没有新建文件选项的，要在~/Templates目录里面创建自己想要的模板之后才能右击新建文件。

---

## 更高效地使用终端

我也是初学者，如果有什么建议欢迎提出。

### 终端文本阅读器

我最近在看《linux unix 大学教程》，在里面知道了less工具，顺便一提这本书对新手太友好了，强烈推荐，可以当小说看。主要用途是在终端文本阅读器，注意不是编辑器是阅读器。终端运行命令通常会一次性输出所有内容，阅读起来相当麻烦，这个时候就可以用管道符把输出给到less进行阅读。

less每次只显示一页内容，空格下一页，b键上一页，q键退出，左斜杠键搜索，g键跳转第一行，shit+g跳转最后一行，-N显示行号，-S禁止换行，更深入的使用可以自行搜索。

```
sudo pacman -S less
```

#### 使用方法

- 打开一个文件

  ```
  less /path/to/file
  ```

- 阅读终端输出

  比如运行一个输出很长很长的命令，然后用less阅读输出结果

  ```
  find /usr | less
  ```

### 切换目录

```cd /目标/目录/位置```  可以切换目录

```cd ~```或者```cd```可以快速回家

```cd -```可以回到上一次切换到的目录

```cd ..```可以返回上级目录

但是这每次都要输入完整的路径，虽然有tab自动补全，但依旧麻烦，于是就有了zoxide。

#### zoxide

[zoxide](https://github.com/ajeetdsouza/zoxide)

```
sudo pacman -S zoxide
```

- fish

  ```
  echo 'zoxide init fish --cmd cd | source' >> ~/.config/fish/config.fish
  ```

  echo命令将后面的内容打印到终端，''单引号是字符串，>>双大于号代表把输出内容追加到右边的文件的末尾，config.fish是fish的配置文件。这样可以在fish激活zoxide，并通过--cmd cd选项把默认的z命令改成cd。

- zsh

  ```
  echo 'eval "$(zoxide init zsh --cmd cd)"' >> ~/.zshrc
  ```

使用方法和cd相同，需要使用一段时间训练它。

```
zoxide query -l -s 
```

这条命令可以显示当前记录的目录和对应的频率。```zoxide edit```可以手动修改数据库中的目录频率或者删除。```zoxide remove /path/to/path```可以删除数据中的某个目录。

原本如果我想切换到一个很深的目录需要```~/Documents/gitrepo/Archlinux-GNOME-KDE-InstallationGuide-ShorinArchExperience/dotfiles/```cd后面跟上这么长。但是现在我只需要输入完整的路径切换过一次之后，```cd dotfiles```就能切换到刚刚那个目录。如果我有两个包含dotfiles的目录，那我只需要加上一个中间结点就可以了，比如```cd arch dotfiles```

##### fzf

fuzzy finder，这个工具可以使用``fzf``命令对当前目录下所有文件当中进行模糊搜索

```
sudo pacman -S fzf
```

配合zoxide使用，可以用```cdi```命令在zoxide记录的目录进行模糊搜索。ctrl+p向上滚动，ctrl+n向下滚动。也可以```cd 目录名```然后按tab，开启一个模糊搜索的面板。

### 终端文档管理器

#### yazi

[Install Yazi](https://yazi-rs.github.io/docs/installation)

```
sudo pacman -S --needed yazi ffmpeg 7zip jq poppler fd ripgrep fzf zoxide resvg imagemagick
```

使用方法：[Quick Start](https://yazi-rs.github.io/docs/quick-start)

# 干净删除Linux

## 和windows共用efi分区时

[(重制)彻底删除Linux卸载后的无用引导项_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV14p4y1n7rJ/?spm_id_from=333.1387.favlist.content.click)

1. win+x 选择磁盘管理，找到efi在磁盘几的第几个分区，通常是磁盘0的第一个分区。

2. win+R 输入 diskpart 回车

   ```
   select disk 0 #选择efi分区所在磁盘
   select partition 1 #选择efi分区
   assign letter p # 分配一个盘符
   ```

3. 管理员运行记事本

4. ctrl+s 打开保存窗口

5. 选择p盘,删除里面的linux 启动相关文件（通常有一个和linux启动项名称相同的文件夹）

6. diskpart里移除盘符

   ```
   remove letter p
   ```

## 单独efi分区时

[windows10删除EFI分区(绝对安全)-CSDN博客](https://blog.csdn.net/sinat_29957455/article/details/88726797)

- 方法一：[图吧工具箱官方网站 - DIY爱好者的必备工具合集](https://www.tbtool.cn/)

  下载图吧工具箱，在磁盘工具里双击打开，diskgenius，右键linux对应分区删除，然后左上角保存。

- 方法二：windows自带工具

  1. 使用diskpart选中Linux的efi分区后在终端运行：

  ```
   SET ID=ebd0a0a2-b9e5-4433-87c0-68b6b72699c7
  ```

  2. 使用磁盘管理右键分区删除

---

# issues

这里是我遇到的问题以及对应的解决方案

1. [星火商店在fish下的问题](#星火商店在fish下的问题)

2. [efibootmgr里面有超级多启动项](#efibootmgr里面有超级多启动项)

3. [kde开机会卡住，必须重启sddm才好](#kde开机会卡住，必须重启sddm才好)

4. [磁盘占用异常](#磁盘占用异常)

5. [提示没有编解码器](#提示没有编解码器)

6. [NAUTILUS无法访问smb共享](#NAUTILUS无法访问smb共享)

7. [域名解析出现暂时性错误](#域名解析出现暂时性错误)

8. [扩展windwos的efi分区空间](#扩展windwos的efi分区空间)

9. [virsh list --all不显示虚拟机加上sudo后显示](#virsh不显示虚拟机加上sudo后显示)

## 星火商店在fish下的问题

（2025.9.15记：重启电脑之后桌面快捷方式还是会消失。就算自己创建.desktop新安装的软件也没法自动创建.desktop，每次手动创建太麻烦了，如果要用星火商店的话还是用[zsh](#zsh)吧 T_T）

1. 把本机shell从fish改成bash

   ```
   chsh -s /usr/bin/bash
   ```

2. 在ace容器里安装fish

   ```
   sudo apt install fish
   ```

3. 安装starship

   ```
   curl -sS https://starship.rs/install.sh | sh
   ```

   如果这条命令安装失败的话，点击[下载starship安装脚本](https://starship.rs/install.sh)，右键属性设置可执行权限，然后在ace里面

   ```
   sudo 把安装脚本文件拖拽进来
   ```

4. starship安装完成后登出

5. 把主机shell切换回fish

   ```
   chsh -s /usr/bin/fish
   ```


## efibootmgr里面有超级多启动项

这是之前其他系统和网络设备的残留的nvram。用efibootmgr清理。

用这条命令列出所有的启动项

```
sudo efibootmgr -v
```

找到无用的项目对应的编号删除

```
sudo efibootmgr -b 0001 -B
```

此处的0001是编号


## 磁盘占用异常

明明没有多少文件，磁盘占用却很高。可以试试删除btrfs快照。

## 提示没有编解码器

安装的时候应该自带了编解码器，可能是删除别的软件时不小心连带着删掉了，重新安装皆可

```
sudo pacman -S gst-plugins-good gst-libav libde265
```


## NAUTILUS无法访问smb共享

如果你的路由器或者别的设备开启了smb文件共享，安装gvfs-smb可以使你在nautilus访问那些文件

```
sudo pacman -S gvfs-smb
```

## 域名解析出现暂时性错误

[解决 Ubuntu 系统中 “Temporary Failure in Name Resolution“ 错误-CSDN博客](https://blog.csdn.net/qq_15603633/article/details/141032652)

```
sudo vim /etc/resolv.conf
```

内容修改为

```
nameserver 8.8.8.8
nameserver 8.8.4.4
```

## 扩展windwos的efi分区空间

NIUBI partition Editor free edition 使用这个工具

## grub卡顿

n卡的锅，没辙

## virsh不显示虚拟机加上sudo后显示

因为虚拟机被创建在系统范围的qemu连接里了

```
sudo vim /etc/environment
```

写入

```
VIRSH_DEFAULT_CONNECT_URI=qemu:///system
```

# 附录

这部分是一些有用但是被我弃用的东西，以及一些参考。

1. [pacman常用命令](#pacman常用命令)
2. [timeshift](#timeshift)
3. [ulauncher](#ulauncher)
4. [steam子卷](#steam子卷)
5. [ibus](#ibus)
6. [rEFInd](#rEFInd)
7. [用archinstall安装gnome后的一些清理](#用archinstall安装gnome后的一些清理)
8. [TLP相关](#TLP相关)
9. [更高效地使用终端](#更高效地使用终端)
10. [ananicy cpu资源调用优化](#ananicy-cpu资源调用优化)
11. [更换CachyOS源](#更换CachyOS源)
12. [zen浏览器](#zen浏览器)

## pacman常用命令

可以安装pacman的GUI。

```
sudo pacman -S pamac
```

常用命令：

- 下载包但不安装

```
sudo pacman -Sw
```

* 删除包，同时删除不再被其他包需要的依赖

```
sudo pacman -Rns
```

* 查询包

```
sudo pacman -Ss
```

* 列出所有已安装的包

```
sudo pacman -Qe
```

* 列出所有已安装的依赖

```
sudo pacman -Qd
```

* 清理包缓存

```
sudo pacman -Sc
```

* 列出孤立依赖包

```
sudo pacman -Qdt
```

* 清理孤立依赖包

```
sudo pacman -Rns $(pacman -Qdt)
```

- 无视依赖关系强制删除某个包

```
sudo pacman -Rdd
```



## timeshift

#### ！！！⚠️警告！！！删除timeshift创建的快照要一个个删，否则大概率崩盘

```
sudo pacman -S timeshift 
```

```
sudo systemctl enable --now cronie.service 
```

自动生成快照启动项

```
sudo pacman -S grub-btrfs inotify-tools
```

```
sudo systemctl enable --now grub-btrfsd.service 
```

修改服务配置

```
sudo systemctl edit grub-btrfsd.service 
```

```
[Service]
ExecStart=
ExecStart=/usr/bin/grub-btrfsd --syslog --timeshift-auto
```

重启服务

```
sudo systemctl daemon-reload
sudo systemctl restart grub-btrfsd.service
```



## ulauncher

ulauchner是一个启动器，支持模糊搜索，用gtk编写，支持python脚本

```
yay -S ulauncher    
```

然后设置一个自定义快捷键，命令写ulauncher-toggle，如果使用gnome的rounded corner扩展记得添加ulauncher进黑名单。

ulauncher最好用的是它的扩展功能，安装非常方便。打开设置进extensions页面，点击左侧的discover extensions就可以找到。

### ulauncher扩展

我安装的扩展：

[flathub manager](https://github.com/damian-ds7/ulauncher-flathub-manager) 可以从ulauncher管理flatpak软件

[emoji](https://github.com/Ulauncher/ulauncher-emoji) 可以快捷复制emoji

[process murderer](https://github.com/isacikgoz/ukill)可以快捷杀死进程

[youtube search](https://github.com/NastuzziSamy/ulauncher-youtube-search)快捷从youtube搜索内容

[github search](https://github.com/SHORiN-KiWATA/ShorinArchExperience-ArchlinuxGuide/blob/main/github.com/Glovecc/ulauncher-github-search)快捷从github搜索内容

[appimage launcher](https://github.com/atorresg/appimagelauncher)快捷打开指定目录里的appimage文件（记得在设置里指定存放appimage的路径，需要使用从/开始的绝对路径）

### ulauncher主题美化

浏览器搜索 ulauncher theme，存放路径在~/.config/ulauncher/user-themes

[这个主题应该是最适合gnome默认主题的](https://github.com/aceydot/ulauncher-theme-gnome)

## steam子卷

我不想快照复制steam游戏，因为这会占用大量的硬盘空间，可以创建一个和@home平级的@steamgames字卷让创建@home快照的时候排除steam的游戏。

1. 挂载根分区硬盘到/mnt下任意位置

   ```
   sudo mount --mkdir -o subvolid=5 /dev/nvme1n1p2 /mnt/btrfs_root #记得替换为自己对于的硬盘名称
   ```

2. 创建@steamgames子卷

   ```
   sudo btrfs subvolume create /mnt/btrfs_root/@steamgames
   ```

3. 禁用子卷的写时复制

   ```
   sudo chattr +C /mnt/btrfs_root/@steamgames
   ```

4. 取消挂载

   ```
   sudo umount /mnt/btrfs_root
   ```

5. 移动并备份现有steamapps文件夹

   ```
   mv ~/.local/share/Steam/steamapps ~/.local/share/Steam/steamapps.bak
   ```

6. 创建新的steamapps文件夹作为挂载点

   ```
   mkdir -p ~/.local/share/Steam/steamapps
   ```

7. 配置fstab文件

   ```
   sudo vim /etc/fstab
   ```

8. 复制粘贴fstab里面根分区的那一行

   ```
   # /dev/nvme1n1p2
   UUID=92a83c41-105d-4983-9536-2492d024bb52       /               btrfs           rw,relatime,compress=zstd:3,ssd,discard=async,space_cache=v2,subvol=/@  0 0
   ```

   粘贴到底部，把 / 修改为steamapps的路径```/home/shorin/.local/share/Steam/steamapps```，把subvol=/@改成subvol=/@steamgames。修改后是这样的：

   ```
   # steamgames subvolume
   UUID=92a83c41-105d-4983-9536-2492d024bb52       /home/shorin/.local/share/Steam/steamapps     btrfs           rw,relatime,compress=zstd:3,ssd,discard=async,space_cache=v2,subvol=/@steamgames  0 0
   ```

9. 刷新systemd缓存

   ```
   sudo systemctl daemon-reload
   ```

10. 手动挂载fstab新条目

    ```
    sudo mount -a
    ```

11. 修改权限（记得替换成自己的用户名）

    ```
    sudo chown shorin ~/.local/share/Steam/steamapps/
    ```

12. 把刚刚备份的文件移回原位

    ```
    mv ~/.local/share/Steam/steamapps.bak/* ~/.local/share/Steam/steamapps/
    ```

13. 清理残留

    ```
    rm -r ~/.local/share/Steam/steamapps.bak
    ```

现在创建home目录的快照就不会记录steam的游戏库了。对lutris也可以进行同样的操作。如果被识别成外部设备出现在文档管理器的挂载列表里面，就在fstab的那一连串逗号隔开的参数里添加```x-gvfs-hide```

## ibus

参考：[Rime - Arch Linux 中文维基](https://wiki.archlinuxcn.org/zh-hant/Rime) | [可选配置（基础篇） | archlinux 简明指南](https://arch.icekylin.online/guide/advanced/optional-cfg-1#%F0%9F%8D%80%EF%B8%8F-%E8%BE%93%E5%85%A5%E6%B3%95) | [RIME · GitHub](https://github.com/rime)

已知问题：amber-ce（后面星火应用商店的部分会用到）里安装的qt应用无法使用ibus输入法

1. 安装ibus-rime

```
sudo pacman -S ibus ibus-rime rime-ice-pinyin-git 
yay -S ibus-mozc
```

```
ibus是ibus输入法的基本包
ibus-rime是中州韵
rime-ice是雾凇拼音输入法方案，实测比万象拼音方案好用
ibus-mozc是日语输入法
```

2. 在gnome的设置中心 > 键盘 > 添加输入源 > 汉语，里面找到rime添加，如果没有的话登出一次

3. 编辑配置文件设置rime的输入法方案为ice雾凇拼音

   ```
   vim ~/.config/ibus/rime/default.custom.yaml
   ```

   如果没有文件夹的话自己创建。``` mkdir ~/.config/ibus/rime/```创建文件夹，```touch default.custom.yaml```创建文件。写入以下内容：

   ```
   patch:
     # 这里的 rime_ice_suggestion 为雾凇方案的默认预设
     __include: rime_ice_suggestion:/
   ```

   默认使用super+空格切换输入法，可以在设置里修改。第一次切换至rime输入法需要等待部署完成。

4. 安装扩展自定义ibus

   商店搜索extension安装蓝色的扩展管理器，或者用命令安装

   ```
   flatpak install flathub com.mattjakeman.ExtensionManager
   ```

   安装两个扩展：

   - ibus tweaker

     设置里激活“隐藏页按钮”

   - Customize IBus

     需要登出一次

     设置里，常规页面取消“候选框调页按钮”。主题页面可导入css自定义主题，[GitHub - openSUSE/IBus-Theme-Hub: This is the hub for IBus theme that can be used by Customize IBus GNOME Shell Extension.(可被自定义IBus GNOME Shell 扩展使用的IBus主题集合)](https://github.com/openSUSE/IBus-Theme-Hub)，这个网站有一些预设主题。背景页面可以自定义背景（这个无敌了，什么美化都比不过一张合适的自定义背景）。其他的选项就自己探索吧。

- 删除ibus输入法

1. 系统设置>键盘 移除输入源

2. 删除包

   ```
   yay -Rns ibus-mozc ibus ibus-rime rime-ice-pinyin-git
   ```

3. 删除残留

   ```
   sudo rm -rfv ~/.config/ibus /usr/share/rime-data
   ```

4. 登出

## rEFInd

```
sudo pacman -S refind
```

```
refind-install
```

- 启动项记忆

  编辑esp里的refind.conf文件

  ```
  sudo vim /efi/EFI/refind/refind.conf
  ```

  写入```default_selection +```，意思是记住启动项选择。也可以``"+,vmlinuz"``设置优先级。

- 手动启动项

  设置```menuentry{}```

  ```
  menuentry "Arch Linux" {
  	icon /EFI/refind/icons/os_arch.png
  	volume ****************
  	loader /@/boot/vmlinuz-linux-zen
  	initrd /@/boot/initramfs-linux-zen.img
  	options "root=UUID=54f285eb-8140-48df-81f8-2b03cb976fc0 rw rootflags=subvol=@ zswap.enabled=0 rootfstype=btrfs loglevel=5"
  	enabled
  }
  ```

  ``icon``设置图标路径，路径从esp的根目录开始而不是从linux的根目录开始。

  ``volume``设置分区，不能用UUID，要用PARTUUID，使用```sudo blkid```获取。

  ```loader```指定内核路径

  ``initrd``指定initramfs和ucode的路径

  ``options ""``指定启动项参数

  ``enabled``表示启用这个entry，``disabled``是禁用。

- 美化

  在/efi/EFI/refind/目录下新建一个themes文件夹

  ```
  sudo mkdir -p /efi/EFI/refind/themes
  ```

  然后浏览器搜索自己喜欢的``git clone``下来放到到刚刚创建的文件夹里

  然后编辑配置文件

  ```
  sudo vim /efi/EFI/refind/refind.conf
  ```

  ```
  include themes/**********/theme.conf
  ```

- 隐藏启动项

  可以在refind的引导界面按delete键盘隐藏启动项。

  或者编辑配置文件用```dont_scan_dirs=```指定要排除的目录。

  ```
  dont_scan_dirs=/@/boot,EFI/****
  ```

## 用archinstall安装gnome后的一些清理

```
sudo pacman -R gnome-contacts gnome-maps gnome-music totem gnome-characters gnome-connections evince gnome-logs malcontent gnome-system-monitor gnome-console gnome-tour yelp simple-scan htop sushi gnome-user-docs epiphany htop 
```

## TLP相关

（power-profiles-daemon已经足够了，故弃用）

```
sudo pacman -S tlp tlp-rdw 
```

```
yay -S tlpui
```

设置方法参考官方文档[Settings — TLP 1.8.0 documentation](https://linrunner.de/tlp/settings/index.html)

这里给一个现代电脑的通用设置：

```
processor选项卡中

CPU DRIVER OPMODE 
AC active
BAT active

CPU SCALING GOVERNOR 
AC schedutil
BAT powersave

CPU ENERGY PERF POLICY
AC balance_performance
BAT power

CPU BOOST
AC on
BAT off

PLATFORM PROFILE
AC balanced
BAT low-power

MEM SLEEP
BAT deep
```

- 开启服务

```shell
sudo systemctl enable --now tlp
```

## ananicy-cpu资源调用优化

影响steam下载速度，弃用

```
yay -S ananicy-cpp cachyos-ananicy-rules-git
sudo systemctl enable --now ananicy-cpp.service
```

## 更换CachyOS源

[Optimized Repositories | CachyOS](https://wiki.cachyos.org/features/optimized_repos/)

（因严重软件安装异常问题弃用）

如果你渴望极致的性能优化，可以使用CachyOS的源。

ps：谨慎更换cachyos的内核```linux-cachyos```，内核恐慌（kernel panic）的概率会很大。

- 安装

  ```
  curl https://mirror.cachyos.org/cachyos-repo.tar.xz -o cachyos-repo.tar.xz
  tar xvf cachyos-repo.tar.xz && cd cachyos-repo
  sudo ./cachyos-repo.sh
  ```

- 重启电脑

- 移除

  ```
  curl https://mirror.cachyos.org/cachyos-repo.tar.xz -o cachyos-repo.tar.xz
  tar xvf cachyos-repo.tar.xz
  cd cachyos-repo
  sudo ./cachyos-repo.sh --remove
  ```

- 重启电脑

## zen浏览器

```
sudo pacman -S zen-browser zen-browser-i18n-zh-cn
```