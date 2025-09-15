【github】https://github.com/shorinkiwata/archlinuxinstall/tree/main 

【度盘】https://pan.baidu.com/s/1QUzz10hxc7HIlRzhB0jVKg?pwd=arch

网盘的文档更新会比github慢，传不到git上的文件会在网盘里。

本文档创建时制作的视频，虽然已经过时，但是依旧值得一看：

[「Archlinux究极指南」从手动安装到显卡直通，最后删除Linux_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1L2gxzVEgs/?spm_id_from=333.1387.homepage.video_card.click&vd_source=65a8f230813d56660e48ae1afdfa4182)

```
更新日志：
2025.7.23 修改原本的fcitx5内容，添加fcitx5-rime和ibus-rime输入法相关内容
2025.7.24 添加在linux上玩游戏（minecraft、steam、lutris、waydroid）相关的内容
2025.7.26 添加looking glass相关内容。修改了输入法的环境变量。
2025.7.30 添加了flatpak更换上海交大源的内容
2025.7.30 添加了fcitx5美化相关内容
2025.7.30 移除fcitx5相关内容，转而使用ibus-rime，用gnome扩展解决ibus美化问题
2025.7.31 更新looking glass使用技巧，包括键鼠捕获
2025.8.1  新增安装前准备
2025.8.4  新增小黄鸭 Lossless Scaling相关内容
2025.8.5  修复了错误，优化了排版
2025.8.12 新增虚拟机性能优化和伪装相关内容
2025.8.16 新增蓝牙配置、wps中文语言包、常用办公字体相关内容
2025.8.20 新增swap大小参考、脚本安装后的双系统配置、星火应用商店、更改gnome为windows布局相关内容；新增小技巧章节；优化了排版；修复了若干错误
2025.8.27 新增更换CachyOS源相关内容
2025.8.31 新增专业软件替代品一栏
2025.9.2  附录新增vmware相关内容
2025.9.6  找到了steam下载时无法正常调用cpu的元凶——btrfs写时复制
2025.9.6  原timeshift移至附录，换用snapper+btrfs assitent
2025.9.10 新增KDE桌面安装和美化教程；原zsh内容移至附录，换用fish
2025.9.11 更新archinstall相关内容
```


1. [安装前的准备](#安装前的准备)
2. [手动安装系统](#手动安装)
3. [archintsall脚本安装系统](#脚本安装)
4. [安装桌面环境前的准备（创建用户、显卡驱动）](#安装桌面环境前的准备)
5. [GNOME桌面安装](#GNOME)
6. [GNOME美化](#GNOME美化)
7. [KDE桌面安装](#KDE)
8. [KDE系统设置和美化](#KDE系统设置和美化)
9. [显卡切换](#显卡切换)
10. [虚拟机](#虚拟机)
11. [显卡直通](#显卡直通)
12. [虚拟机性能优化](#KVM/QEMU虚拟机性能优化和伪装)
13. [在linux上玩游戏](#在linux上玩游戏)
14. [性能优化](#性能优化)
15. [删除linux](#删除linux)
16. [小技巧](#小技巧)
17. [专业软件平替](#专业软件平替)
18. [issues](#issues)
15. [附录](#附录)
15. [许可证信息](#许可证)

## vim基础操作
i 键进入编辑模式

esc 退出编辑模式

:q 冒号小写q，退出

:w 冒号小写w，写入

:wq 冒号小写wq保存并退出

# 安装前的准备

## 解决双系统安装后时间错乱

参考链接：
[双系统时间同步-CSDN博客](https://blog.csdn.net/zhouchen1998/article/details/108893660)

windows下管理员身份打开powershell 运行
```
Reg add HKLM\SYSTEM\CurrentControlSet\Control\TimeZoneInformation /v RealTimeIsUniversal /t REG_DWORD /d 1
```
windows默认读取主板硬件时间作为本地时间，如果你在中国就是UTC+8。而当你使用linux时，硬件时间会被改成标准UTC时间，linux读取到硬件时间之后根据系统内部设置的时区对UTC时间进行加减。当你这时重启到windows，windows读取到的硬件时间就是标准UTC时间，而windows默认硬件时间就是本地时间，所以会直接把这个标准UTC时间显示出来。

上面这条命令修改注册表，让windows采用和Linux相同的策略，默认硬件时间为UTC，根据系统设置的时区进行相应的加减后再显示。

## 开箱即用的基于arch的发行版

## EndeavourOS

[Home - EndeavourOS](https://endeavouros.com/)

仅帮你做好初期配置，提供了一些便利工具。不过这个发行版把initramfs生成工具从mkinitcpio改成了dracut，本文中一切关于mkinitcpio的操作都不适用于dracut。

dracut重视自动化和智能检测，提供更好的UKI（Unified Kernel Image）支持。mkinicpio更透明、可控，比dracut更符合arch的设计理念。

### CachyOS

[下载 — CachyOS --- Download — CachyOS](https://cachyos.org/download/)

应该是最火的arch-based发行版，做了很多性能方面的优化。也把mkinitcpio改成了dracut，本文中关于mkinicpio的操作不适用于dracut。如果你不要续航不要稳定只想要**极致的性能**，那么建议安装CachyOS。它默认搭载了KDE桌面，如果你不喜欢CachyOS的桌面设计，可以选择no desktop不安装桌面环境。

PS：handheld是掌机版，类似steamdeck上的steamos，不过也可以当桌面用，因为是KDE桌面环境。

## Garuda Linux

[Garuda Linux | Downloads](https://garudalinux.org/editions)

这个发行版真的超级漂亮，而且提供了超级方便的工具，只需要打打勾就能帮你把很多事情自动处理好，推荐。

## Nyarch

[nyarchlinux.moe](https://nyarchlinux.moe/)

虽然但是，我必须把这个放上来，这个发行版太有梗了。如果你是个二次元，一定要试试这个开箱即用的二次元arch-based发行版



### 如果你想要自己掌控archlinux的安装，继续往下看

## 下载archlinux iso文件

[官网下载](https://archlinux.org/download/)

[阿里云镜像站下载](https://mirrors.aliyun.com/archlinux/iso/)

## 制作系统u盘

### 方法一 ：压缩卷（没有u盘使用这个方法）

1. windows系统内win+x键，选择磁盘管理。找到想安装archlinux的位置，右键选择压缩卷，空出磁盘空间。

2. 右击空出的空间选择新增简单卷，大小设置为4096MB（足够装下iso文件就行），盘符随意，格式化选择FAT32。

3. 把iso文件里面的内容解压进刚刚新建的盘符里。

4. 重启选择bios启动项

### 方法二：ventoy

[ventoy/Ventoy: A new bootable USB solution.](https://github.com/ventoy/Ventoy)

ventoy制作的系统盘可以存放多个系统镜像，推荐。

---



# 安装

## 手动安装
参考链接：

[archlinux 简明指南](https://arch.icekylin.online/)

[安装指南 - Arch Linux 中文维基](https://wiki.archlinuxcn.org/wiki/%E5%AE%89%E8%A3%85%E6%8C%87%E5%8D%97)

### 确认网络
```
ip a #查看网络连接信息
ping bilibili.com #确认网络正常
```
#### iwctl工具连接wifi
```
iwctl
```
```
station wlan0 connect <wifiname> 
```
```
exit
```

### 同步时间
```
timedatectl set-ntp true 
```

### 硬盘分区
```
lsblk -pf  #查看当前分区情况
fdisk -l /dev/想要查询详细情况的硬盘  #小写字母l，查看详细分区信息
```
```
cfdisk /dev/nvme0n1 #选择自己要使用的硬盘进行分区
```
创建1g的分区，类型（type）选择efi system

其余全部分到一个分区里，类型linux filesystem 


#### 格式化分区
```
lsblk -pf #查看分区情况
fdisk -l /dev/想要查询详细情况的硬盘  #小写字母l，查看详细分区信息
```

- 格式化efi启动分区
```
mkfs.fat -F 32 /dev/nvme0n1p1（EFI分区名）
```
- 格式化btrfs根分区
```
mkfs.btrfs /dev/nvme0n1p2（根分区名）

#加上-f参数可以强制格式化
```

#### btrfs子卷

- 挂载
```
mount -t btrfs -o compress=zstd /dev/nvme0n1p2（根分区名） /mnt
```

- 创建子卷
```
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@swap
```

- 可选：确认
```
btrfs subvolume list -p /mnt
```

- 取消挂载
```
umount /mnt
```

### 挂载

```
mount -t btrfs -o subvol=/@,compress=zstd /dev/nvme0n1p2 /mnt #根目录
mount --mkdir -t btrfs -o subvol=/@home,compress=zstd /dev/nvme0n1p2 /mnt/home #/home目录
mount --mkdir -t btrfs -o subvol=/@swap,compress=zstd /dev/nvme0n1p2 /mnt/swap #/swap目录
mount --mkdir /dev/nvme0n1p1 /mnt/boot #/boot目录，/dev/nvme0n1p1替换为自己对应的efi分区名
mount --mkdir /dev/nvme1n1p1 /mnt/winboot #windows的启动分区，为双系统引导做准备。/dev/nvme1n1p1替换为自己win启动分区对应的设备名
```
```
df -h 复查挂载情况
```

### 安装系统
- 设置镜像源

  方法一：reflector自动设置

```
reflector -a 24 -c cn -f 10 --sort score --save /etc/pacman.d/mirrorlist --v

-a（age） 24 指定最近24小时更新过的源
-c（country） cn 指定国家为中国（可以增加邻国）
-f（fastest） 10 筛选出下载速度最快的10个
--sort score 按照下载速度和同步时间综合评分并排序，比单纯按照下载速度排序更可靠
--save /etc/pacman.d/mirrorlist 将结果保存到/etc/pacman.d/mirrorlist
--v（verbose） 过程可视化
```
​		方法二：手动设置

```
vim /etc/pacman.d/mirrorlist

拿出手机，浏览器搜索 archlinux中国镜像源，找合适的镜像添加
```

- 更新密钥
```
pacman -Sy archlinux-keyring

pacman是包管理器，管理软件的安装、卸载之类的
-S代表安装
-Sy代表同步数据库然后安装
```

- 安装系统
```
pacstrap -K /mnt base base-devel linux linux-firmware btrfs-progs

-K 复制密钥
base-devel是编译其他软件的时候用的
linux是内核，可以更换
linux-firmware是固件
btrfs-progs是btrfs文件系统的管理工具
```

- 安装必要的功能性软件
```
pacstrap /mnt networkmanager vim sudo amd-ucode

networkmanager 是联网用的，和kde和gnome深度集成，也可以换成别的
vim 是文本编辑器，也可以换成别的，比如nano
sudo 和权限管理有关
amd-ucode 是微码，用来修复和优化cpu，intel用户安装intel-ucode
```

### swap交换空间

参考链接：

[Swap - ArchWiki](https://wiki.archlinux.org/title/Swap)

[Swap - Manjaro](https://wiki.manjaro.org/index.php/Swap)

如果你不需要睡眠功能的话跳过这一步。睡眠指的是把系统当前状态写入硬盘，然后电脑完全断电，下一次开机恢复到睡眠前的状态。

swap与虚拟内存和睡眠有关。建议设置zram作为日常swap，**仅在需要睡眠的时候设置硬盘swap**。有swap分区或者swap文件两种方式，前者配置更简单，后者配置稍复杂，但是更加灵活。这里采用交换文件的方式。

```
SWAP大小参考
       内存  		      不需要睡眠          需要睡眠   不建议超过
       1GB              1GB                 2GB        2GB
       2GB              2GB                 3GB        4GB
       3GB              3GB                 5GB        6GB
       4GB              4GB                 6GB        8GB
       5GB              2GB                 7GB       10GB
       6GB              2GB                 8GB       12GB
       8GB              3GB                 11GB       16GB
      12GB              3GB                 15GB        24GB
      16GB              4GB                 20GB       32GB
      24GB              5GB                 29GB       48GB
      32GB              6GB                 38GB       64GB
      64GB              8GB                 72GB       128GB
     128GB             11GB                 139GB       256GB
     256GB             16GB                 272GB       512GB
     512GB             23GB                 535GB       1TB
       1TB             32GB                1056GB       2TB
       2TB             46GB                2094GB       4TB
       4TB             64GB                4160GB       8TB
       8TB             91GB                8283GB       16TB
```

1. 创建swap文件

```
btrfs filesystem mkswapfile --size 64g --uuid clear /mnt/swap/swapfile
```

2. 启动swap

```
swapon /mnt/swap/swapfile
```

### 生成fstab文件

这可以让系统自动完成挂载

```
genfstab -U /mnt > /mnt/etc/fstab

genfstab（生成文件系统表）
-U 用uuid指定分区
 > 大于号代表输出结果覆盖写入到有右边的文件里，>>两个大于号代表追加写入
```

### change root

进入刚刚安装的系统

```
arch-chroot /mnt
```

此时根目录从U盘的live环境变成了/mnt

### 设置时间和时区

```
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

#ln 是link的缩写，-s代表跨文件系统的软链接，-f代表强制执行，所以这条命令的意思是在/etc/目录下创建/usr/.../Shanghai这个文件的链接，取名为localtime。zoneinfo里面包含了所有可用时区的文件，localtime是系统确认时间的依据。
```
```
hwclock --systohc #系统时钟写入主板硬件时钟
```

### 本地化设置
```
vim /etc/locale.gen

左斜杠键进行搜索，取消en_US.UTF-8 UTF-8和zh_CN.UTF-8的注释
```
```
locale-gen
```
```
vim /etc/locale.conf

写入 LANG=en_US.UTF-8
```

### 设置root密码
```
passwd 
```

### 安装引导程序
```
pacman -S grub efibootmgr os-prober

grub是最常用的工具，其他还有systemd-boot，有需要自行查找
efibootmgr 管理uefi启动项
os-prober 用来搜索win11
```
```
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=ARCH 

--target指定架构
--efi-directory指定目录
--bootloader-id任意取一个启动项在bios里显示的名字
```

- 编辑grub的源文件
```
vim /etc/default/grub
```

  1. GRUB_DEFAULT=0改成saved，再取消GRUB_SAVEDEFAULT=true的注释。这一步是记住开机的选择。

  2. GRUB_CMDLINE_LINUX_DEFAULT里面去掉quiet以显示开机日志，loglevel设置日志等级为5。再添加nowatchdog modprobe.blacklist=sp5100_tco，禁用watchdog。intelcpu用户把sp5100_tco换成iTCO_wdt。

     loglevel共7级，5级是一个信息量的平衡点。watchdog的目的简单来说是在系统死机的时候自动重启系统。这在服务器或者嵌入式上有用，但是对个人用户来说没有意义，禁用以节省系统资源、提高开机和关机速度

3. 手动写入或者取消最后一行GRUB_DISABLE_OS_PROBER=false的注释。这一步让grub使用os-prober生成其他系统的启动项

- 生成配置文件
```
grub-mkconfig -o /boot/grub/grub.cfg
```

### 完成安装

```
exit 退出changeroot
reboot 重启，会自动取消所有的挂载
```
如果u盘没拔掉的话记得拔掉

### 启动网络

登录root账号

- 开启networkmanager服务，注意大小写

```
systemctl enable --now NetworkManager 

enbale代表开机自启
--now代表现在启动
```

#### 连接wifi

- 方法一：nmtui

```
nmtui开启工具
选择activate a connection
选择自己的wifi，回车，，输入密码，回车，esc退出软件
clear清屏，或者ctrl+L清屏
```

- 方法二：nmcli

```
nmcli dev wifi connect <wifiname> password <password>
```

- 确认网络连接

```
ip a
ping bilibili.com
```

### 放松一下吧

```
pacman -S fastfetch lolcat cmatrix
```

使用示例： fastfetch | lolcat，竖线代表把左边程序的输出结果输入到右边的程序里。

cmatrix是代码雨，输入cmatrix回车运行。

接下来看[配置系统](#配置系统)

---



## 脚本安装
### 确认网络连接
```
ip a #确认网络连接
ping bilibili.com #ping一个网址确认网络正常
```

* iwctl工具连接wifi
```
iwctl
```
```
station wlan0 connect 【wifi名】 #回车后会跳出passwd提示你输入密码
```

```
exit #退出iwctl
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

- 情况一：整块空闲硬盘安装arch

  1. 选择第一项进行自动分区 > 要使用的硬盘 > btrfs（这是文件系统） > yes（这里是问你是否使用推荐子卷布局） > ues compression（透明压缩）
  2. 选择btrfs snapshots（这是快照软件） >  Snapper 

  选择back返回

- 情况二：和其他系统共享同一块硬盘

  选择第二项手动分区 > 要使用的硬盘 

  1. 创建启动分区

      选中要使用的空闲空间 > Size（分区大小）1024MB > Filesystem（文件系统）FAT32 > Mountpoint（挂载点）/boot

  2. 创建swap分区

     **如果你不需要睡眠功能的话跳过这一步**。睡眠指的是把系统当前状态写入硬盘，然后电脑完全断电，下一次开机恢复到睡眠前的状态。

     swap交换空间与虚拟内存和睡眠有关。建议设置zram作为日常swap，**仅在需要睡眠的时候设置硬盘swap**。有swap分区或者swap文件两种方式，前者配置更简单，后者配置稍复杂，但是更加灵活。这里采用交换文件的方式。

     ```
     SWAP大小参考
            内存  			  不需要睡眠    		 需要睡眠   不建议超过
            1GB              1GB                 2GB        2GB
            2GB              2GB                 3GB        4GB
            3GB              3GB                 5GB        6GB
            4GB              4GB                 6GB        8GB
            5GB              2GB                 7GB       10GB
            6GB              2GB                 8GB       12GB
            8GB              3GB                 11GB       16GB
           12GB              3GB                 15GB        24GB
           16GB              4GB                 20GB       32GB
           24GB              5GB                 29GB       48GB
           32GB              6GB                 38GB       64GB
           64GB              8GB                 72GB       128GB
          128GB             11GB                 139GB       256GB
          256GB             16GB                 272GB       512GB
          512GB             23GB                 535GB       1TB
            1TB             32GB                1056GB       2TB
            2TB             46GB                2094GB       4TB
            4TB             64GB                4160GB       8TB
            8TB             91GB                8283GB       16TB
     ```

     Size参考上面的表 > linux-swap

  3. 创建root分区

     Size部分直接回车分配全部空间 > btrfs >

     选中刚刚创建的btrfs，回车。选择Mark/Unmark as compressed设置透明压缩；再选择Set subvolumes（创建子卷）> Add subvolume 

     至少需要创建root子卷和home子卷，Subvolume name设置成 @，对应Subvolume mountpoint是 / ； @home 对应 /home

     confirm and exit > confirm and exit > back 退出出硬盘分区

### Swap（zram交换空间）

这一步是自动帮你配置zram交换空间，yes开启即可。

### Bootloader引导系统

最常用的是Grub，选Grub就行。有其他需求可以自己网上查找。

### Hostname主机名

不用改

### Authentication身份认证

- Root password设置管理员密码

- User account > Add a user 创建普通用户

  Should "" be a superuser(sudo)是问你要不要给这个用户管理员权限，选yes就行。

- U2F login setup这个是物理密钥，有需要的自行设置

### Profile

这里可以选择自动安装桌面、最小化安装等等。都选择用archinstall自动安装系统那，那就顺便自动安装一下桌面吧。如果不知道自己想安装哪个就从Gnome和KDE Plasma里随便选一个。KDE更符合windows用户的直觉，系统占用更低，个性化起来更方便，多显示器支持更好。Gnome的中文输入法体验更好，更符合mac用户的直觉，外观更好看，更流畅，更简洁，更稳定。

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

可选安装中文字体：wqy-zenhei（文泉驿字体）、noto-fonts（谷歌开源字体）、noto-fonts-emoji（表情）

### Timezone（时区）

左斜杠键搜索Shanghai

### Automatic time sync (NTP) （自动启用网络时间同步）

默认开启，不用修改

### Install

选择install安装

### 双系统

安装完成后配置windows和linux的双系统。

1.  选择exit archinstall，退出archinstall

2. 挂载windwos的启动分区

   ```
   lsblk -pf 列出当前分区情况
   ```

   找到ntfs上面的fat分区，通常是nvme1n1p1或者0n1p1。可以用fdisk -l （小写字母l）查看更详细的分区信息。找到后挂载到/mnt下的任意一个目录，比如/mnt/winboot。

   ```
   mount /dev/nvme1n1p1 /mnt/winboot 
   ```

3. arch-chroot 

   ```
   arch-chroot /mnt 进入刚刚安装的系统
   ```

4. 编辑grub源文件启用os-prober

   ```
   vim /etc/default/grub 
   
   i键进入编辑模式
   
   取消最后一行GRUB_DISABLE_OS_PROBER=false的注释
   
   esc退出编辑模式
   
   :wq 冒号小写wq保存并退出
   ```

5. 禁用watchdog

   在GRUB_CMDLNE_LINUX_DEFAULT=""里面添加参数

   ```
   nowatchdog modprobe.blacklist=sp5100_tco
   ```

    intelcpu用户把sp5100_tco换成iTCO_wdt

5. GRUB_DEFAULT=0改成saved，再取消GRUB_SAVEDEFAULT=true的注释。这一步是记住开机的选择。

5. 生成grub的配置文件

   ```
   grub-mkconfig -o /boot/grub/grub.cfg
   ```

6. exit 退出chroot

7. reboot 重启

8. 更改bios启动项

### 接下来看[桌面环境](#桌面环境)部分

---



# 安装桌面环境前的准备

## 创建普通用户

没有普通用户无法登入桌面环境，有些软件会拒绝在root权限下运行，所以普通用户是必须的。

(archinstall安装的可以跳过)

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
vim /etc/sudoers
```

* 搜索 wheel，取消注释
```
%wheel ALL=（ALL：ALL） ALL
```
## 开启32位源

32位源建议开启，因为steam需要，wine运行exe也需要

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
sudo pacman -S wqy-zenhei noto-fonts noto-fonts-emoji
```

```
wqy-zenhei是文泉驿的中文字体
noto-fonts是谷歌字体，包含多个国家的语言
noto-fonts-emoji是emoji
```

## 显卡驱动和硬件编解码

以4060和780m为例

参考链接：[NVIDIA - ArchWiki](https://wiki.archlinux.org/title/NVIDIA)、[AMDGPU](https://wiki.archlinux.org/title/AMDGPU)

### 检查头文件

```
sudo pacman -S linux-headers
```

linux替换为自己的内核，比如zen内核是linux-zen-headers

### 安装显卡驱动 

- Nvidia

  ```
  sudo pacman -S nvidia-open nvidia-utils lib32-nvidia-utils
  ```

  显卡驱动的选择在[CodeNames · freedesktop.org](https://nouveau.freedesktop.org/CodeNames.html)这个页面搜索自己的显卡，看看对应的family是什么。然后在[NVIDIA - ArchWiki](https://wiki.archlinux.org/title/NVIDIA)这个页面查找对应的显卡驱动。nv160family往后的显卡用nvidia-open，nv110到190如果nvidia-open表现不佳的话可以使用nvidia。nvidia-open是内核模块开源的驱动，不是完全的开源驱动。非stable内核要安装的驱动不一样，具体看wiki，例如zen内核装nvidia-open-dkms。

- AMD

  A卡不需要自己安装驱动，检查一下vulkan驱动就行

  ```
  sudo pacman -S --needed vulkan-radeon vulkan-mesa-layers
  ```


### 硬件编解码

 - nvidia

   ```
   sudo pacman -S libva-nvidia-driver
   ```

* amd

  自带

* 重启激活显卡驱动和字体

  ```
  reboot 
  ```

## 桌面环境 

### [KDE Plasma](#KDE)和[GNOME](#GNOME) 自己选择一个安装 点击即可跳转

kde和gnome的区别可以自行网上搜索，简单来说：

KDE更符合windows用户的直觉，系统占用更低，个性化起来更方便，多显示器和缩放支持更好。

Gnome的中文输入法体验更好，更符合mac用户的直觉，外观更好看，动画更流畅，设计更简洁，运行更稳定。

值得一提的是，Debian、Ubuntu、Fedora这样的主流发行版都默认使用Gnome。

##  GNOME

```
pacman -S gnome-desktop gdm ghostty gnome-control-center gnome-software flatpak
```

jack选择pipewire-jack

```
gnome-desktop 最小化安装gnome
gdm 是显示管理器(gnome display manager)
ghostty 是一个可高度自定义的终端模拟器（terminal emulator)
gnome-control-center 是设置中心
gnome-software 是软件商城
flatpak 是flatpak软件，这是一种全发行版通用的软件打包形式，通常flatpak软件是最好用的
```

* 临时开启GDM

```
systemctl start gdm 
```

* 正常开启后设置gdm开机自启

```
sudo systemctl enable gdm
```

sudo，全称substitute userid and do something，希望我没有记错，功能是以管理员身份运行命令。

### 生成home下目录（如果没有的话）

```
xdg-user-dirs-update
```

### 设置系统语言

右键桌面选择setting，选择system，选择region&language

如果是archinstall安装，这里只有英文选项，解决办法：

* 本地化设置

```
sudo vim /etc/locale.gen 
```

```
左斜杠键搜索，取消zh_CN.UTF-8的注释
```

```
sudo locale-gen
```

### 安装声音固件和声音服务

- 安装声音固件

```
sudo pacman -S --needed sof-firmware alsa-firmware alsa-ucm-conf
```

- 安装声音服务

```
sudo pacman -S --needed pipewire pipewire-pulse pipewire-alsa pipewire-jack wireplumber
```

* 启用服务

```
systemctl --user enable --now pipewire pipewire-pulse wireplumber
```

* 可选：安装GUI（图形界面管理工具）

```
sudo pacman -S pavucontrol 
```

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

### 安装yay

yay是aur助手，可以从aur安装软件（paru也是一个aur助手，但是会出现有些软件无法安装的情况，所以建议还是用yay）

- 方法一：直接从archlinuxcn源安装

  ```
  sudo vim /etc/pacman.conf
  ```

  文件底部写入（ctrl+shift+V粘贴）：

  ```
  [archlinuxcn]
  Server = https://mirrors.ustc.edu.cn/archlinuxcn/$arch 
  Server = https://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/$arch 
  Server = https://mirrors.hit.edu.cn/archlinuxcn/$arch 
  Server = https://repo.huaweicloud.com/archlinuxcn/$arch 
  ```

  同步数据库并安装archlinuxcn密钥

  ```
  sudo pacman -Sy archlinuxcn-keyring 
  ```

  安装yay

  ```
  sudo pacman -S yay 
  ```

- 方法二：从github安装

  [GitHub - Jguer/yay: Yet another Yogurt - An AUR Helper written in Go](https://github.com/Jguer/yay)

  ```
  sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si
  ```

  这条命令有四步，每步之间用&&隔开。第一步用pacman安装git和base-devel，这是git管理工具和编译软件需要的包。第二步git clone把连接里的文件下载到本地。第三步cd命令进入yay目录。第四步makepkg编译包。

- 方法三：从cachyos源安装

  见[更换CachyOS源](#更换CachyOS源)

  ```
  sudo pacman -S yay
  ```

### 安装输入法

[ibus](#ibus-rime)和[fcitx5](#fcitx5)，按喜好选择。fcitx5跟gnome的兼容性一般，但是功能更强大，推荐使用。

#### fcitx5

已知问题：在某些应用里面会吞字，或者某个按键没能被输入法获取直接变成英文字母输入。

```
sudo pacman -S fcitx5-im fcitx5-mozc fcitx5-rime rime-ice-pinyin-git
```

```
fcitx5-im 包含了fcitx5的基本包
fcitx5-mozc是开源谷歌日语输入法
fcitx5-rime是输入法引擎
rime-ice-pinyin-git是雾凇拼音输入法
```

- 打开fcitx 5 configuration添加rime和mozc输入法，没有的话登出一次

- 编辑rime的配置文件设置输入法方案为雾凇拼音，如果没有文件夹和文件的话自己创建文件夹，然后编辑配置文件

```
vim ~/.local/share/fcitx5/rime/default.custom.yaml 
```

```
patch:
  # 这里的 rime_ice_suggestion 为雾凇方案的默认预设
  __include: rime_ice_suggestion:/
```

- 商店搜索extension，安装蓝色的extensionmanager

- 安装扩展：input method panel
  https://extensions.gnome.org/extension/261/kimpanel/

- 编辑环境变量

```
sudo vim /etc/environment
```

```
XIM="fcitx" #解决wechat用不了输入法的问题
GTK_IM_MODULE=fcitx
QT_IM_MODULE=fcitx
XMODIFIERS=@im=fcitx
XDG_CURRENT_DESKTOP=GNOME #解决某些软件里面输入法吞字的问题
```

- 美化

1. 关闭“Input Method Panel”扩展

2. 浏览器搜索fcitx5 themes，下载自己喜欢的，存放路径为：~/.local/share/fcitx5/themes

3. 打开fcitx配置 选择附组件，点击“经典用户界面”右边的扳手螺丝刀图标，设置主题。这里有一大堆自定义的选项，自己研究吧。


- 卸载fcitx5

1. 删除包

   ```
   sudo pacman -Rns fcitx5-im fcitx5-mozc fcitx5-rime rime-ice-pinyin-git
   ```

2. 删除残留文件

   ```
   sudo rm -rfv ~/.config/fcitx5 ~/.local/fcitx5
   ```

3. 清理环境变量

   ```
   sudo vim /etc/environment
   ```

4. 如果之前禁用过系统设置里的打字快捷键记得恢复

#### ibus-rime

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

### 自定义安装软件

这是我会安装的，你可以按自己的需求安装

**安装软件后没显示图标的话登出一次**

- pacman

  ```
  sudo pacman -S --needed mission-center gnome-text-editor gnome-disk-utility gnome-font-viewer gnome-clocks gnome-weather gnome-calculator loupe snapshot baobab celluloid fragments file-roller foliate firefox gst-plugin-pipewire gst-plugins-good pacman-contrib decibels
  ```

  ```
  mission-center 类似win11的任务管理器，强烈推荐
  gnome-text-editor gnome标配记事本
  gnome-disk-utility 磁盘管理工具，可以调节分区大小和格式化分区等等
  gnome-font-viewer 方便安装和查看字体
  gnome-clocks 时钟工具，可以设置闹钟和计时
  gnome-weather 天气，设置地区之后可以在系统托盘里显示天气，安装扩展后可以在时间边上显示天气组件
  gnome-calculator 计算器
  loupe 图片查看工具
  snapshot 相机，摄像头
  baobab 磁盘使用情况分析工具
  celluloid 是基于mpv的视频播放器
  fragments 是符合gnome设计理念的种子下载器，或者安装qtbittorrent
  file-roller 压缩解压缩
  foliate 电子书阅读器
  firefox linux上性能表现最佳的浏览器，需要别的可以商店自行搜索安装
  gst-plugin-pipewire gst-plugins-good 是gnome截图工具自带的录屏，需登出一次
  pacman-contrib 提供pacman的一些额外功能，比如checkupdates用来检查更新
  decibels 是可以显示波形的音频播放器，这只是个音频播放器，不是音乐播放器
  ```
  
- 从aur安装常用软件

  [WPS Office - Arch Linux 中文维基](https://wiki.archlinuxcn.org/wiki/WPS_Office)

  ```
  yay -S linuxqq-appimage wechat-appimage wps-office-cn wps-office-mui-zh-cn typora-free
  ```

  ```
  linuxqq-appimage 是appimgae版qq
  wechat-appimage 是appimage版微信
  wps-office-cn 是wps
  wps-office-mui-zh-cn 是wps的中文语言包
  typora-free 是markdown编辑器
  ```
  
  - 关于字体
  
    从网上搜索常用办公字体，下载解压后存放到```~/.local/share/fonts```里面（在这个目录下新建文件夹整理字体文件）。放进去之后刷新字体缓存 。
  
    ```
    fc-cache --force
    ```
  
- flatpak

  这里都是些有趣或者实用的工具，可以从商店搜索安装，也可以用命令

  ```
  flatpak install flathub be.alexandervanhee.gradia io.github.Predidit.Kazumi io.gitlab.theevilskeleton.Upscaler com.github.unrud.VideoDownloader io.github.ilya_zlobintsev.LACT com.geeks3d.furmark io.github.flattool.Warehouse com.github.tchx84.Flatseal com.dec05eba.gpu_screen_recorder
  ```

  ```
  gradia编辑截图
  kazumi追番
  upscaler图片超分
  video downloader下载youtube/bilibili 144p～8k视频
  LACT 显卡超频、限制功率、风扇控制等等
  furmark 显卡烤鸡
  Warehouse 用来管理flatpak的源、软件、属性、用户数据之类的
  Flatseal 管理flatpak应用的权限、环境变量之类的
  gpu_screen_recorder 类似nvidiaApp的录屏软件
  ```
  
  - gradia可以对截图进行一些简单的添加文字、马赛克、图表、背景之类的操作
  
    使用方法：
  
    设置自定义快捷键的时候命令写
  
    ```
    flatpak run be.alexandervanhee.gradia --screenshot=INTERACTIVE
    ```
  
- 如果flatpak没速度或者加载不出来的话更换flatpak国内源，这里举例的是上交大的

  ```
  sudo flatpak remote-modify flathub --url=https://mirror.sjtu.edu.cn/flathub
  ```

### 视频播放器开启硬件编解码

- 方法一：配置文件

  1. 编辑mpv配置文件（记得打开一次mpv生成目录）

  ```
  vim ~/.config/mpv/mpv.config
  ```

  写入：

  ```
  #使用vulkan后端
  gpu-api=vulkan
  #通用自动模式硬解
  hwdec=auto-safe
  ```

  2. celluloid首选项的配置文件页面，激活“加载mpv配置文件”，手动指定一下路径

- 方法二：celluloid首选项

  在首选项的杂项页面写入

  ```
  hwdec=yes
  ```

### 删除或隐藏不必要的快捷方式

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

- 方法三：gnome扩展

  商店搜索extension，安装扩展管理器。然后安装apphider扩展。就可以右键概览里的快捷方式隐藏了。

### amber-ce和星火应用商店（国产商店）

[Amber CE: 琥珀兼容环境：一款Bubblewrap容器，极轻量系统容器](https://gitee.com/amber-ce)

[amber-ce-bookworm: 使用bwrap的Debian 12容器](https://gitee.com/amber-ce/amber-ce-bookworm)

[Spark Store](https://www.spark-app.store/)

2025.9.7已知问题：ibus输入法只能在gtk应用中使用，qt应用中无法使用。

由于特殊国情，星火应用商店里的应用可能比aur上的都好用，建议安装。amber-ce是一个debian容器，可以让你在arch上快捷安装deb包。

1. 安装ace容器

   这是一个极其轻量的debian容器，系统占用可以忽略不计。trixie是debian13，bookworm是debian12

   ```
   yay -S amber-ce-trixie
   ```

2. 安装完成后重启电脑

3. 官网下载星火应用商店的deb包

   [Spark Store](https://www.spark-app.store/)

4. 打开ace（蓝色图标）

5. 安装星火应用商店

   ```
   sudo apt install /home/shorin/Downloads/spark-store_4.8.0_amd64.
   ```

   ```
   apt是debian的包管理器
   install代表安装
   后面指定了安装包的绝对路径，可以手动输入，也可以把安装包拖拽进终端里输入路径
   ```

#### 启用输入法

- ibus

  仅gtk应用可用，解决办法暂时未知

- fcitx5

  ```
  sudo apt install fcitx5-frontend-gtk2 fcitx5-frontend-gtk3 fcitx5-frontend-gtk4 fcitx5-frontend-qt5 fcitx5-frontend-qt6
  ```

#### 卸载

使用ace 软件卸载器卸载软件，或者sudo apt remove 【包名】，或者直接删除整个容器，删除容器之后里面的所有东西都不会留下。

```
yay -Rns amber-ce-trixie
```

### 快照

**快照相当于存档，每次做自己不了解的事情之前都存个档**

timeshift操作简单，但是速度很慢且容易出bug，建议用snapper

#### 方法一：snapper

```
sudo pacman -S snapper snap-pac btrfs-assistant
```

```
snapper 是创建快照的主要程序
snap-pac 是利用钩子在进行一些pacman命令的时候自动创建快照
btrfs-assistant 是图形化管理btrfs和快照的软件
```

- 自动生成快照启动项

```
sudo pacman -S grub-btrfs inotify-tools
```

```
reboot
```

```
sudo systemctl enable --now grub-btrfsd
```

##### 具体使用方法

打开btrfs assistant，切换到snapper settings页面。我们创建子卷的时候至少创建了一个@子卷和一个@home子卷，所以需要两个config（配置）。创建一个root配置，再创建一个home配置。然后到snapper页面下的New/Delete页面就可以新建和管理快照了，Browse/Restore页面选中快照后点restore可以恢复到那个快照的状态。如果你要同时快照root和home的话就分别创建一个root快照和home快照，恢复的时候各自恢复就行了。

#### 方法二：[timeshift](#timeshift)

我已弃用，有需要的可以看附录。

### 关于滚挂和良好的系统使用习惯

- 滚挂

  archlinux是滚动发行版。滚动是英文直译，原词是rolling，指一种推送更新的方式，只要有新版本就会推送，由用户管理更新。对应的另一种更新方式是定期更新一个大版本，例如fedora是六个月一更新，由发行方管理更新。 滚挂，指的是滚动更新的发行版因为更新导致系统异常。这通常是用户操作不当、忽略官方公告等原因导致的。只要学习一下正确的更新方式和快照的使用方法就不用担心滚挂问题。 

  通常软件更新不用担心。**出现密钥（keyring）、内核、驱动、固件、引导程序之类的更新要留个心眼，先不第一时间更新，等一手社区或者官方消息。** 另一个重点是滚动更新的发行版的软件通常会适配最新的依赖，如果长期不更新可能会无法使用软件。

- 良好的使用习惯

  btrfs文件系统已经足够稳定，“不作死就不会死”。使用时遵循以下几点：

  1. **别第一时间更新，别长时间不更新，密钥单独更新，重要程序更新前创建快照**
2. **非必要不修改，明白自己的行为会造成怎样的后果，做不了解的事情前创建快照**

### open in any terminal

[GitHub - Stunkymonkey/nautilus-open-any-terminal](https://github.com/Stunkymonkey/nautilus-open-any-terminal)

这是一个在文件管理器“右键在此处打开终端”的功能

- 如果用的是ghostty

```
sudo pacman -S nautilus-python
```

- 其他终端仿真器

```
yay -S nautilus-open-any-terminal 
```

```
sudo glib-compile-schemas /usr/share/glib-2.0/schemas 
```

```
sudo pacman -S dconf-editor
```

```
修改配置，路径为/com/github/stunkymonkey/nautilus-open-any-terminal
```

重载nautilus

```
nautilus -q 
```

### 可变刷新率和分数缩放

商店安装refine修改

```
flatpak install flathub page.tesk.Refine
```

### 配置系统快捷键

- 可选：交换大写锁定键和esc键

  安装gnome-tweaks

  ```
  sudo pacman -S gnome-tweaks
  ```

  在键盘→其他布局里面交换CAPSLOCK和ESC键

#### 我的快捷键配置：

设置>键盘>查看自定义快捷键

* 导航

```
super+shift+数字键 #将窗口移到工作区
super+shift+A/D #将窗口左右移动工作区
super+shift+Q/E #移动到左/右工作区
ps：gnome默认super+滚轮上下可以左右切换工作区
alt+tab #切换应用程序
alt+` #在应用程序的窗口之间切换窗口
```

* 截图

```
ctrl+alt+A #交互式截图
```

 * 无障碍

```
全部backspace退格键禁用
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
super+B   zen
super+T   ghostty
super+`    missioncenter
super+E   nautilus
super+shift+S   flatpak run be.alexandervanhee.gradia --screenshot=INTERACTIVE
super+R wofi --show drun
super+M gnome-text-editor
ctrl+alt+S gnome-control-center
```

### 功能性扩展

#### ⚠️ 警告：扩展在gnome桌面环境大版本更新的时候大概率会大面积失效，如果出现gnome桌面环境的大版本更新，一定要先关闭所有扩展，谨慎行事

- 从商店安装蓝色的扩展管理器

```
flatpak install flathub com.mattjakeman.ExtensionManager
```

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

  窗口平铺，tilingshell是用布局平铺,另一个叫forge是hyprland那种自动平铺但是很卡。推荐用tilingshell，记得自定义快捷键，我快捷键是super+w/a/s/d对应上下左右移动窗口，Super+Alt+w/a/s/d对应上下左右扩展窗口，super+Z取消平铺，super+C把窗口移动到屏幕中心

- tiling assistant

  这个扩展提供最基础的四角平铺和上下左右半屏平铺功能。设置里gaps和tiling shell调成一样的，禁用keybinds里general一项的第1/2/4项，仅保留resote window size。

- 可选：forge

  如果你更喜欢窗口管理器那样无预设布局的自动平铺功能，可以安装forge。装了这个就不要装tiling shell和tilling assitant了。我没有深入用过这个扩展，所以设置的部分就自己探索吧。

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

### 调节外接屏幕亮度

[ddcutil-service](https://github.com/digitaltrails/ddcutil-service)

gnome默认没法调节外接屏幕亮度，通过ddcutil+扩展可以进行调节。

```
yay -S ddcutil-service
```

```
sudo gpasswd -d $USER i2c
```

安装扩展display ajustment

```
reboot
```

### 睡眠到硬盘

硬盘上必须有交换空间才能睡眠到硬盘

- 添加hook

```
sudo vim /etc/mkinitcpio.conf
```

```
在HOOKS()内添加resume,注意需要添加在udev的后面
```

- 重新生成initramfs

```
sudo mkinitcpio -P
```

- reboot

```
reboot
```

- 使用命令进行睡眠

```
systemctl hibernate
```

### 性能模式切换工具 power-profiles-daemon

性能模式切换，有三个档位，performance性能、balance平衡、powersave节电。一般平衡档位就够用了，也不需要调节风扇什么的。

```
sudo pacman -S power-profiles-daemon
```

```
sudo systemctl enable --now power-profiles-daemon 
```

不建议使用tlp或者auto-cpufreq，意义不大，这个易用而且足够。如果想折腾的话可以看附录[TLP相关](#TLP相关)。tlp和auto-cpufreq都有对应的gnome扩展，但未经验证，不保证能用。

#### 实用插件扩展

power tracker 显示电池充放电
auto power profile 配合powerProfilesDaemon使用，可以自动切换模式
power profile indicator  配合powerProfilesDaemon使用，面板显示当前模式

### 设置充电阈值 

未经验证，不一定生效。

安装扩展：Battery Health Charging，然后在设置里面安装polkit。在系统快捷设置面板里面可以快速调节充电阈值。

---



### GNOME美化

#### 更换壁纸

```
右键桌面选择更换背景
```

#### 扩展美化

##### ⚠️ 警告：扩展在gnome桌面环境大版本更新的时候大概率会大面积失效，如果出现gnome桌面环境的更新，一定要先关闭所有扩展，谨慎行事

我会使用的扩展：

[arch + gnome美化教程_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1ym4y1G76s/?share_source=copy_web&vd_source=1c6a132d86487c8c4a29c7ff5cd8ac50)

- blur my shell 

  透明度美化

- hide top bar 

  隐藏面板（panel，顶部的那个面板，win叫任务栏）。设置里激活sensitivity的第一个。intellihide取消激活第二项。

- user themes 

  管理主题

- logo menu 

  在面板显示一个logo，好玩。设置里更换gnome extension为extension manager；终端换ghostty；systemmonitor换missioncenter；取消激活show activities button

- desktop cube 

  桌面端用户强烈推荐。把工作区切换从平铺变成一个可以旋转的方块的面。设置的overview里把透明度（opacity）都改成50%，超级酷！

- rounded window corners reborn 

  让所有窗口变成圆角。这个扩展是真神。 设置里取消激活skip libadwaita applications，然后把corner radius改成14，这样就和gnome的圆角没区别了。

#### 实现windows布局

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

     这是功能强大的开始菜单扩展

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



#### 光标主题

主题下载网站 https://www.gnome-look.org/browse?cat=107&ord=latest

将下载的.tar.gz文件里面的文件夹放到～/.local/share/icons/目录下，没有icons文件夹的话自己创建一个

#### gnome主题

gnome的默认主题已经相当漂亮，如果有修改主题的需要的话去这个网站：

https://www.gnome-look.org/browse?cat=134&ord=latest

通常下载页面都有指引，文件路径是~/.themes/，放进去之后在user themes扩展的设置里面改可以改



#### shell美化

##### 更换终端为fish，想用zsh可以看附录：[zsh](#zsh)

更换为fish之后amber-ce的星火应用商店可能无法正常运行，解决办法看：[解决amber-ce无法在主机使用fish shell时正常运行的问题](#星火商店在fish下的问题)

- 安装终端字体

```
sudo pacman -S ttf-jetbrains-mono-nerd
```

- 安装fish

```
sudo pacman -S fish 
```

更改shell

```
chsh -s /usr/bin/fish
```

编辑配置文件去掉默认的启动文字

```
vim ~/.config/fish/config.fish
```

写入

```
set fish_greeting ""
```

#### starship Shell主题

[Starship](https://starship.rs/)

```
sudo pacman -S starship
```

```
vim ~/.config/fish/config.fish
```

在文件末尾写入

```
starship init fish | source
```

https://starship.rs/presets/
挑一个自己喜欢的预设主题，下载后改名为starship.toml，移动到~/.config/目录下，重启终端即可

#### ghostty美化

- 下载[catppuccin](https://github.com/catppuccin/ghostty?tab=readme-ov-file)颜色配置，或者找一个你喜欢的，粘贴到~/.config/ghostty/themes/

- 修改~/.config/ghostty/conf 配置文件，例如下载的是frappe的话：

```
#颜色配置文件路径
theme = /home/shorin/.config/ghostty/catppuccin-frappe.conf

#隐藏标题栏
window-decoration = none

#设置透明度
background-opacity=0.8

#设置字体和字体大小
font-family = "Adwaita Mono" 
font-size = 15

#设置左右边距
window-padding-x=5
#设置上下边距
window-padding-y=5
```

## GNOME接着看[显卡切换](#显卡切换)

---



## KDE 

[KED-Archwiki](https://wiki.archlinux.org/title/KDE)

```
pacman -S plasma-meta konsole dolphin flatpak flatpak-kcm kate
```

出现选项的话选有pipewire和ffmpeg的，字体选noto-fonts

```
konsole 是kde标配终端仿真器
dolphin 是kde标配文档管理器
flatpak 是flatpak软件
flatpak-kcm 通过系统设置管理flatpak应用的权限
kate 是标配文本编辑器
```

- 开启显示管理器

```
systemctl start sddm
```

- 登录普通用户
- 成功后打开konsole设置显示管理器开机自启

```
sudo systemctl enable sddm 
```

- 可选：卸载用不上的软件

```
sudo pacman -Rdd plasma-welcome plasma-systemmonitor 
```

-Rdd代表无视依赖关系强制删除

### 生成home下目录（如果没有的话）

```
xdg-user-dirs-update
```

### 设置系统语言

- 系统设置 > regin&language > 添加简体中文，移动到english上方
- 登出

### 安装声音固件和声音服务

- 安装声音固件

```
sudo pacman -S --needed sof-firmware alsa-firmware alsa-ucm-conf
```

- 安装声音服务

```
sudo pacman -S --needed pipewire pipewire-pulse pipewire-alsa pipewire-jack wireplumber
```

* 启用服务

```
systemctl --user enable --now pipewire pipewire-pulse wireplumber
```

### 启用蓝牙 

```
sudo systemctl enable --now bluetooth
```

### 性能模式切换

```
sudo pacman -S power-profiles-daemon
sudo systemctl enable --now power-profiles-daemon
```

### 安装yay

##### 方法一 ：archlinuxCN

- 编辑pacman配置文件

```
sudo vim /etc/pacman.conf
```

- 在文件底部写入以下内容

```
[archlinuxcn]
Server = https://mirrors.ustc.edu.cn/archlinuxcn/$arch 
Server = https://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/$arch 
Server = https://mirrors.hit.edu.cn/archlinuxcn/$arch 
Server = https://repo.huaweicloud.com/archlinuxcn/$arch 
```

- 安装密钥

```
sudo pacman -Sy archlinuxcn-keyring 
```

- 安装yay

```
sudo pacman -S yay 
```

##### 方法二：从github安装

[GitHub - Jguer/yay: Yet another Yogurt - An AUR Helper written in Go](https://github.com/Jguer/yay)

```
sudo pacman -S git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si
```

### 输入法

（用fcitx，别在kde使用ibus输入法）

### fcitx5-rime 雾凇拼音

[Using Fcitx 5 on Wayland - Fcitx](https://fcitx-im.org/wiki/Using_Fcitx_5_on_Wayland#KDE_Plasma)

```
sudo pacman -S fcitx5-im fcitx5-rime rime-ice-pinyin-git fcitx5-mozc
```

```
fcitx5-im 包含了fcitx5的基本包
fcitx5-rime是中州韵输入法引擎
rime-ice-pinyin-git是雾凇拼音输入法,这个包在archlinuxcn里面
fcitx5-mozc是开源谷歌日语输入法
```

- 打开系统设置 > 键盘 > 虚拟键盘， 选择fcitx5，记得应用

- 系统设置 > 语言和时间 > 输入法，添加rime和mozc

- 编辑rime的配置文件设置输入法方案为雾凇拼音，如果没有文件夹和文件的话自己创建文件夹，然后运行如下命令编辑配置文件

```
vim ~/.local/share/fcitx5/rime/default.custom.yaml 
```

```
patch:
  # 这里的 rime_ice_suggestion 为雾凇方案的默认预设
  __include: rime_ice_suggestion:/
```

- 编辑环境变量

```
sudo vim /etc/environment
```

```
XMODIFIERS=@im=fcitx
```

- 如果输入法在某个软件出现吞字之类异常，在开始菜单右键该软件>编辑应用程序>修改命令行参数

  先试试仅添加这一段，添加位置为程序名后面，%U之类的字符前面，比如typora 【此处】%U

  ```
  --enable-wayland-ime
  ```

  如果不行的话改成这一段：

  ```
  --enable-features=UseOzonePlatform --ozone-platform=wayland --enable-wayland-ime
  ```

  还不行的话改成在环境变量里添加这一段：

  ```
  GTK_IM_MODULE=fcitx
  QT_IM_MODULE=fcitx
  XMODIFIERS=@im=fcitx
  ```

- 更换切换输入法快捷键

```
系统设置 > 输入法 > 配置全局选项
```

#### 美化

1. 浏览器搜索fcitx5 themes，下载自己喜欢的，存放路径为：~/.local/share/fcitx5/themes

2. 打开fcitx配置，选择附加组件，设置经典用户界面，设置主题。这里有一大堆自定义的选项，自己研究吧。

### 自定义安装软件

这是我会安装的，你可以按需求选择

- 安装后没显示图标的话登出一次

```
sudo pacman -S --needed mission-center zen-browser zen-browser-i18n-zh-cn ark gwenview kcalc kate pacman-contrib gnome-disk-utility baobab haruna 
```

```
mission-center 类win11任务管理器
zen-browser zen浏览器，也可以安装firefox或者discover商店搜索chrome或edge
zen-browser-i18n-zh-cn zen的中文语言包
ark kde标配解压缩工具
gwenview 图片编辑查看工具
kcalc 计算器
pacman-contrib 提供pacman的一些额外功能，比如checkupdates用来检查更新
gnome-disk-utility磁盘管理器
baobab磁盘使用情况分析工具
haruna是基于mpv的视频播放器
```

- aur

```
yay -S linuxqq-appimage wechat-appimage wps-office-cn wps-office-mui-zh-cn typora-free gpu-screen-recorder
```

```
linuxqq-appimage是appimgae版qq
wechat-appimage是appimage版微信
wps-office-cn是wps
wps-office-mui-zh-cn是wps的中文语言包
typora-free是markdown编辑器
gpu-screen-recorder 是类似win上nvidiaapp那样的录制/回放软件
```

- flathub

```
flatpak install io.github.Predidit.Kazumi io.gitlab.theevilskeleton.Upscaler com.github.unrud.VideoDownloader io.github.ilya_zlobintsev.LACT com.geeks3d.furmark com.google.Chrome
```

```
kazumi追番
upscaler图片超分
video downloader下载youtube/bilibili 144p～8k视频
LACT 显卡超频、限制功率、风扇控制等等
furmark 显卡烤鸡
chrome 浏览器。有些网站或者浏览器功能在firefox下无法正常运行，所以装一个chromium的浏览器做备用
```

- 如果flatpak没速度或者加载不出来的话更换flatpak国内源，这里举例的是上交大的

```
sudo flatpak remote-modify flathub --url=https://mirror.sjtu.edu.cn/flathub
```

### 删除或隐藏不必要的快捷方式

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

### amber-ce和星火应用商店（国产商店）

[Amber CE: 琥珀兼容环境：一款Bubblewrap容器，极轻量系统容器](https://gitee.com/amber-ce)

[amber-ce-bookworm: 使用bwrap的Debian 12容器](https://gitee.com/amber-ce/amber-ce-bookworm)

[Spark Store](https://www.spark-app.store/)

由于特殊国情，星火应用商店里的应用可能比aur上的都好用，建议安装。

1. 安装ace容器

   这是一个极其轻量的debian容器，系统占用可以忽略不计。trixie是debian13，bookworm是debian12

   ```
   yay -S amber-ce-trixie
   ```

2. 安装完成后重启电脑

3. 官网下载星火应用商店的deb包

   [Spark Store](https://www.spark-app.store/)

4. 打开ace（蓝色图标）

   如果打不开的话

   ```
   kate $(which trixie-run)
   ```

   找到

   ```
   non_root_user=$(who  | awk '{print $1}' | head -n 1)
   uid=$(id -u $non_root_user)
   ```

   上面这两行内容替换为

   ```
   uid=$(id -u)
   ```

   然后在BIND_DIRS=()里面添加这两行：

   ```
       "--ro-bind /etc/passwd /etc/passwd"     
       "--ro-bind /etc/group /etc/group"
   ```

5. 安装星火应用商店

   ```
   sudo apt install /home/shorin/Downloads/spark-store_4.8.0_amd64.
   ```

   ```
   apt是debian的包管理器
   install代表安装
   后面指定了安装包的绝对路径，可以手动输入，也可以把安装包拖拽进终端里输入路径
   ```

#### 启用输入法

```
sudo apt install fcitx5-frontend-gtk2 fcitx5-frontend-gtk3 fcitx5-frontend-gtk4 fcitx5-frontend-qt5 fcitx5-frontend-qt6
```

#### 卸载

使用ace bookworm软件卸载器卸载软件，或者sudo apt remove 【包名】，或者直接删除整个容器，删除容器之后里面的所有东西都不会留下。

```
yay -Rns amber-ce-trixie
```



### 快照

**快照相当于恢复点，每次试验什么之前最好都创建一下快照**

#### 方法一：snapper

```
sudo pacman -S snapper snap-pac btrfs-assistant 
```

```
snapper 是创建快照的主要程序
snap-pac 是利用钩子在进行一些pacman命令的时候自动创建快照
btrfs-assistant 是图形化管理btrfs和快照的软件
```

- 自动生成快照启动项

```
sudo pacman -S grub-btrfs inotify-tools
```

```
reboot
```

```
sudo systemctl enable --now grub-btrfsd
```

##### 具体使用方法

打开btrfs assistant，切换到snapper settings页面。我们创建子卷的时候创建了一个@（root）子卷和一个@home（home）子卷，所以需要两个config（配置）。创建一个root配置，再创建一个home配置。然后到snapper页面下的New/Delete页面就可以新建和管理快照了，Browse/Restore页面选中快照后点restore可以恢复到那个快照的状态。如果你要同时快照root和home的话就分别创建一个root快照和home快照，恢复的时候各自恢复就行了。

#### 方法二：[附录 timeshift](#timeshift)

虽然简单易用，但是比snapper慢且容易出bug，有需要的看附录

### 关于滚挂和良好的系统使用习惯

- 滚挂

  archlinux是滚动发行版。滚动是英文直译，原词是rolling，指一种推送更新的方式，只要有新版本就会推送，由用户管理更新。对应的另一种更新方式是定期更新一个大版本，例如fedora是六个月一更新，由发行方管理更新。 滚挂，指的是滚动更新的发行版因为更新导致系统异常。这通常是用户操作不当、忽略官方公告等原因导致的。只要学习一下正确的更新方式和快照的使用方法就不用担心滚挂问题。 

  通常软件更新不用担心。**出现密钥（keyring）、内核、驱动、固件、引导程序之类的更新要留个心眼，先不第一时间更新，等一手社区或者官方消息。** 另一个重点是滚动更新的发行版的软件通常会适配最新的依赖，如果长期不更新可能会无法使用软件。

- 良好的使用习惯

  btrfs文件系统已经足够稳定，“不作死就不会死”。使用时遵循以下几点：

  1. **别第一时间更新，别长时间不更新，密钥单独更新，重要程序更新前创建快照**

  2. **明白自己的行为会造成怎样的后果，做不了解的事情前创建快照**



### KDE系统设置和美化

以下都是我的设置，你可以按照自己的来。

#### 快捷键

系统设置 > 输入和输出 > 键盘 > 快捷键

- 应用程序

  kruner: meta+R

  浏览器： meta+B

  系统设置：Ctrl+alt+S

  任务中心（missioncenter）： meta+esc

  konsole终端：Meta+T


- 窗口管理：

  窗口右移一个桌面：meta+shift+D

  窗口左移一个桌面：meta+shift+A

  磁铁编辑开关：任意一个别的

  关闭窗口：meta+Q

  强制终止窗口：meta+crtl+Q

  切换到右侧桌面：meta+shift+E

  切换到左侧桌面：meta+shift+Q

  全屏显示窗口：meta+alt+F

  显示隐藏标题栏和框架：meta+shift+T

  显示隐藏桌面总览：meta

  移动窗口到屏幕中央：meta+C

  暂时显示桌面：meta+M

  自定义快速铺放窗口到上下左右：meta+WASD；然后打开磁铁编辑器编辑一个自己喜欢的布局

  最大化窗口：meta+F

  最小化窗口：meta+H

- plasma工作空间

  激活应用程序启动器： alt

  显示活动切换器： meta+TAB

#### 无障碍辅助

“抖动后放大光标”调到最大 

#### 窗口管理

系统设置>窗口和应用>窗口管理

#### 窗口行为

标题栏操作

鼠标滚轮：移动到上个/下个桌面

#### 桌面特效

- 惯性晃动

  激活窗口惯性晃动，启用高级设置，调整效果到自己喜欢的程度。我的设置是25、70、15

- geometry change

  点击获取新效果，下载geometry change，或者从aur安装。这可以给窗口的快捷键平铺添加动画。动画速度设置为500ms

  ```
  yay -S kwin-effects-geometry-change
  ```

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

    取消主轮廓的激活

    secondary outline的活动窗口轮廓粗细改成3，激活使用装饰色；非活动窗口的粗细改成0；取消激活平铺时禁用轮廓。

#### 虚拟桌面

按需增加，激活切换时显示屏幕提示，改成500ms

#### 更换桌面壁纸

系统设置>外观和样式>壁纸

按需选择壁纸类型

这里有一个小技巧，如果你按住左键把一张图片从dolphin拖放到桌面上，会跳出来一个菜单。

#### 更换锁屏壁纸

系统设置>安全和隐私>锁屏>配置外观

按需选择壁纸类型

#### 主题美化

这里是我自己的配置，你可以按照你的喜好来。

#### 全局主题

点击右上角获取全局主题，下载apple macos(whitesur-dark)。nordic也不错。商店加载不出来的话可以从aur安装

```
yay -S whitesur-kde-theme
```

- 颜色

​		选择自定义强调色，从壁纸上提取一个合适的颜色

​		更换为whiteSur

- 应用程序外观样式

​		选择默认的breeze 微风，点击右下角的画笔配置，菜单透明度往左一格

- plasma 外观和样式

​		breeze微风深色

- 窗口装饰元素

​		whitesur-sharp。点击右下角的笔，设置按钮大小

​		配置标题栏按钮，按需调整

- 光标

​		breeze 微风深色，大小30

- 登录屏幕

​		whitesur-dark，换一个壁纸

#### 文字和字体

按需调整

### konsole美化和配置

菜单>设置>显示工具栏>去掉两个勾选

常规页面里激活“移除窗口标题和框架”

设置里新建一个配置方案；外观里下载一个自己喜欢的，我使用catppuccin frappe

```
yay -S catppuccin-konsole-colorscheme-frappe-git
```

点击编辑可以设置透明度和背景图片；设置字体；光标页面里激活闪烁；杂项里取消激活调整大小后显示终端大小提示。

滚动里隐藏滚动条，取消激活高亮显示刚刚进入视图的行。

设置为默认

重启终端

#### 更换终端为fish

注意：更换为fish之后amber-ce的星火商店可能无法正常运行，解决办法看：[解决amber-ce无法在主机使用fish shell时正常运行的问题](#星火商店在fish下的问题)

想用ZSH可以看附录：[zsh](#zsh)

- 安装终端字体

```
sudo pacman -S ttf-jetbrains-mono-nerd
```

- 安装fish

```
sudo pacman -S fish 
```

```
chsh -s /usr/bin/fish
```

```
reboot 
```

编辑配置文件去掉默认的启动文字

```
vim ~/.config/fish/config.fish
```

写入

```
set fish_greeting ""
```

#### starship Shell主题

[Starship](https://starship.rs/)

```
sudo pacman -S starship
```

```
vim ~/.config/fish/config.fish
```

在文件末尾写入

```
starship init fish | source
```

https://starship.rs/presets/
挑一个自己喜欢的预设主题，下载后改名为starship.toml，移动到~/.config/目录下，重启终端即可



### 桌面组件

##### wallpaper effects

这个组件可以在聚焦窗口时模糊桌面

右键进入编辑模式>左上角添加组件>获取新挂件>下载plasma挂件>搜索安装wallpaper effects，或者从aur安装

```
yay -S plasma6-applets-wallpaper-effects
```

添加到桌面后进行配置：blur radius 改成 30；pixelate effect的enbale改成never；grain改成never；color effects改成never；激活rounded corners，radius改成15

### 桌面面板（任务栏）

右键任务栏（kde里叫面板），显示面板配置。设置为半透明；悬浮改成仅小程序；显示隐藏改成避开窗口；删除工作区相关组件；添加两个间隔，把开始菜单和软件移动到中心。

#### 右下角组件

点击时间左边的上箭头，在弹出来的窗口的右上角开启系统托盘设置，项目里面按需设置。我会设置电量和电池总是显示，蓝牙总是隐藏。

---



## 显卡切换

linux由于没有厂家专门做显卡切换工具，只能用通用工具，所以功能通常不完整，尤其在wayland下可能只能做到从混合模式切换到核显模式。以下是几个常用的工具，可以自己试试看能不能用。建议安装时处在混合模式。从混合切到独显直连要动bios，所以大概率会失败，谨慎操作。

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

## 混合模式下用独显运行程序

KDE桌面可以直接开始菜单右键编辑应用程序设置用独显运行

### PRIME

```
sudo pacman -S nvidia-prime
```

- 命令行内使用 prime-run命令使用独显运行软件

```
prime-run firefox 
```

- 使用软件修改.desktop文件，加上 prime-run 

### switcheroo-control

gnome装这个可以右键桌面快捷方式选择使用独显运行

```
sudo pacman -S switcheroo-control 
```

```
sudo systemctl enable --now switcheroo-control 
```



  

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

2025.9.14记 这个包会因为下载vmware-tools失败而安装失败。解决办法是先yay -S vmware-workstation下载其他需要的文件，然后修改PKGBUILD跳过vmware-tools相关的内容，然后进行本地安装。修改后的PKGBUILD文件我分享在文件里了，下载后替换到```~/.cache/yay/vmware-workstation```目录里，然后在该目录打开终端运行命令本地安装：

```
makepkg -si --skipinteg
```

## winboat

[winboat](https://github.com/TibixDev/winboat)

以docker容器为基础的windows虚拟机，rdp连接，自动化配置winapps，可以与linux无缝集成，但beta版无缝集成的效果不是很好。只是用windows虚拟机做轻量的活的话可以用这个，安装很简单，缺点是资源占用比kvm/qemu虚拟机要高一些。

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

4. 删除docker（如果从aur安装的winboat直接yay -Rns winboat）

   ```
   yay -Rns freerdp winboat
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
sudo docker system prune -a --volumes
sudo systemctl disable --now docker.service
yay -Rns freerdp winboat
sudo rm -rfv /var/lib/docker /etc/docker ~/.docker /var/run/docker ~/.winboat
reboot
```

## virtualbox

https://wiki.archlinux.org/title/VirtualBox

```
sudo pacman -S virtualbox virtualbox-host-modules-arch
```

不同内核需要安装的包不一样，zen内核是virtualbox-host-dkms，其他的看wiki。

## Linux上的Linux子系统：distrobox

我愿称其为"Linux Subsystem for Linux"。可以利用容器创建一个跟主机Linux深度集成、共享显卡的Linux子系统。比如你想用的软件只提供deb包，那就可以创建一个debian系发行版的盒子安装。比如我最近想用达芬奇剪视频，但是在arch上安装达芬奇需要处理很多依赖和兼容问题，那我可以安装一个redhat系发行版的盒子专门装达芬奇。

由于内容偏离虚拟机这一节的主题所以放在附录了，有兴趣的看[附录 distrobox](#distrobox)

## KVM/QEMU虚拟机

[[已解决] KVM Libvirt 中无法访问存储文件，权限被拒绝错误](https://cn.linux-terminal.com/?p=4593)

[How to Install KVM on Ubuntu | phoenixNAP KB](https://phoenixnap.com/kb/ubuntu-install-kvm)

[如何在 Linux 主机和 KVM 中的 Windows 客户机之间共享文件夹 | Linux 中国 - 知乎](https://zhuanlan.zhihu.com/p/645234144)

1. 安装qemu，图形界面， TPM

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
5. 编辑配置文件提高权限

```
sudo vim /etc/libvirt/qemu.conf
```
```
#把user = "libvirt-qemu"改为user = "用户名"
#把group = "libvirt-qemu"改为group = "libvirt"
#取消这两行的注释
```
6. 重启服务

```
sudo systemctl restart libvirtd
```
### 嵌套虚拟化
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

### 配置桥接网络

无线网卡无法配置桥接

* 启动高级网络配置工具（KDE进设置里的wifi和网络）
```
nm-connection-editor
```
```
#添加虚拟网桥，接口填bridge0或者别的
```
```
#添加网桥连接，选择以太网，选择网络设备
```
```
#保存后将网络连接改为刚才创建的以太网网桥连接
```
### 安装win11虚拟机

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

#### 跳过联网

确保机器**没有连接到网络**，按下shift+f10 ，鼠标点击选中弹出来的cmd窗口，运行：

```
oobe\bypassnro
```
#### 和本机进行文件分享
[如何在 Linux 主机和 KVM 中的 Windows 客户机之间共享文件夹 | Linux 中国 - 知乎](https://zhuanlan.zhihu.com/p/645234144)

```
确认开启共享内存
```
```
打开文件管理器，复制要共享的文件夹的路径
```
```
在虚拟机管理器内添加共享文件夹,粘贴刚才复制的路径，取个名字
```
```
win11虚拟机内安装winFSP
https://winfsp.dev/rel/
```
```
搜索service（服务），启用VirtIO-FS Service，设置为自动
```
### 显卡直通
[PCI passthrough via OVMF - ArchWiki](https://wiki.archlinux.org/title/PCI_passthrough_via_OVMF)

- 确认iommu是否开启，有输出说明开启

```
sudo dmesg | grep -e DMAR -e IOMMU
```
- 获取显卡的硬件id，如果是显卡所在group的所有设备的id都记下。如果group里有cpu的话去看wiki。

```
for d in /sys/kernel/iommu_groups/*/devices/*; do 
    n=${d#*/iommu_groups/*}; n=${n%%/*}
    printf 'IOMMU Group %s ' "$n"
    lspci -nns "${d##*/}"
done
```
- 隔离GPU

```
sudo vim /etc/modprobe.d/vfio.conf
```
写入
```
options vfio-pci ids=10de:28e0,10de:22be （硬件id与硬件id之间用英文逗号隔开）
```
- 编辑内核参数让vfio-pci抢先加载

  1. 

  ```
  sudo vim /etc/mkinitcpio.conf
  ```

  2. MODULES=（）里面写入vfio_pci vfio vfio_iommu_type1 

  ```
  MODULES=(... vfio_pci vfio vfio_iommu_type1  ...)
  ```

  3. HOOKS=()里面写入 modconf

  ```
  HOOKS=(... modconf ...)
  ```

- 重新生成initramfs

```
sudo mkinitcpio -P
```
- 安装和配置ovmf

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

- 重启电脑

- virt-manager的虚拟机页面内添加设备

   PCI Host Device里找到要直通的显卡（只直通显卡，不要直通类似audio的东西，可能会43报错，安装完驱动之后再直通audio）， 然后USB hostDevice里面把鼠标键盘也直通进去。

- 取消显卡直通

  ```
  sudo vim /etc/modprobe.d/vfio.conf
  ```

  注释掉里面的东西

  重新生成initramfs

  ```
  sudo mkinitcpio -P
  ```

  重启

## 远程桌面

三种方案，parsec、sunshineo+moonlight、looking glass，配置难度和最终效果逐级上升。looking glass仅显卡直通虚拟机可用

### parsec
- windows上浏览器搜索安装
- linux上安装
```
yay -S parsec-bin
```
- 登录相同账号


### sunshine+moonlight
[GitHub - LizardByte/Sunshine: Self-hosted game stream host for Moonlight.](https://github.com/LizardByte/Sunshine)

虚拟机win11内安装sunshine

```
https://github.com/LizardByte/Sunshine
```
安装虚拟显示器（parsec-vdd很好用但是有bug,重启会重置）
```
https://github.com/VirtualDrivers/Virtual-Display-Driver
```
客机安装moonlight
https://moonlight-stream.org/

```
sudo pacman -S moonlight-qt
```
sunshine在web设置pin码添加设备之后就可以连接了。

### looking glass

[Installation — Looking Glass B7 documentation](https://looking-glass.io/docs/B7/install/)

[PCI passthrough via OVMF - ArchWiki](https://wiki.archlinux.org/title/PCI_passthrough_via_OVMF)

视频教程：[两分钟学会looking glass使用方法_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1w6tDzKEn1?spm_id_from=333.788.videopod.sections&vd_source=65a8f230813d56660e48ae1afdfa4182)

looking glass通过共享内存实现屏幕分享，也需要安装[Virtual-Display-Driver](https://github.com/VirtualDrivers/Virtual-Display-Driver)

- 计算需要的共享内存大小
具体可以看官方档案，我是2560x1440@180hz 非HDR，需要大小是64M
- 设置共享内存设备
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
64改为自己需要的大小

- 开启终端，添加kvm组，记得重启
```
sudo gpasswd -a $USER kvm 
```

添加自己到kvm组里面， 需要重启，重启后用groups确认自己的组

- 每次开机检查文件，不存在的话创建并编辑权限

```
sudo vim /etc/tmpfiles.d/10-looking-glass.conf
```
写入（shorin改为自己的用户名）：
```
f /dev/shm/looking-glass 0660 shorin kvm -
```
```
f 代表定文件规则
/dev/shm/looking-glass是共享内存文件的路径
0660 设置所有者和所属组的读写权限
user 设置所有者
kvm 设置所属组
- 代表保留时间永久，不进行清理
```
- 无须重启，现在手动创建文件

```
sudo systemd-tmpfiles --create /etc/tmpfiles.d/10-looking-glass.conf
```

- 回到虚拟机设置
  确认有spice显示协议
  显卡设置为none
  添加virtio键盘和virtio鼠标（要在xml里面更改bus=“ps2”为bus=“virtio”）
  确认有spice信道设备，没有的话添加，设备类型为spice，开启剪贴板同步
  确认有ich9声卡，点击概况，去到xml底部，在里面找到下面这段，把type从none 改成spice，开启声音传输

```
<audio id='1' type='spice'/>
```

- 开启虚拟机，安装looking glass 服务端

 [Looking Glass - Download Looking Glass](https://looking-glass.io/downloads)

浏览器搜索 looking glass，点击download，下载bleeding-edge的windows host binary，解压后双击exe安装

- linux安装客户端

 服务端和客户端的版本要匹配，最容易出错的就是这个地方。如果出现问题可以去aur搜索一下looking glass的包，多试一试，或者从[GitHub - gnif/LookingGlass: An extremely low latency KVMFR (KVM FrameRelay) implementation for guests with VGA PCI Passthrough.](https://github.com/gnif/LookingGlass)自己编译。

```
yay -S looking-glass-git
```
- 桌面快捷方式打开lookingglass即可连接
- 使用技巧

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

我是用gnome系统快捷键切换全屏和窗口的，你也可以选择设置以全屏模式开启，还是刚才那个配置文件，写入：

```
[win]
fullScreen = yes 
```

- 关于虚拟机性能优化，见[虚拟机性能优化](#KVM/QEMU虚拟机性能优化和伪装)
- 推荐： 配置完looking glass之后克隆虚拟机，用克隆机而不是初号机，好处不用多说了吧

## KVM/QEMU虚拟机性能优化和伪装

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

可以大幅提高内存性能。用minecraft实测帧数提升了20%

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
   
   vm.nr_hugepages = 8800
   ```

4. reboot

6. 虚拟机开启后查看大页使用情况

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

### 可选：cpupin

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

   这个例子里所有核心共享L3缓存，所以无法优化L3缓存性能。但是可以优化L1和L2。比如core0对应cpu0和cpu1，cpu0和cpu1共享同一个L1L2缓存，如果仅pin cpu0就会导致运行到cpu1的缓存里，导致缓存性能下降，所以必须同时pin cpu0和cpu1

   

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
  migratable是为服务器集群准备的“搬家”功能，关闭。
```

5. 在```    <topology sockets="1" dies="1" clusters="1" cores="8" threads="2"/>```下面一行插入（**这里仅适用于amd处理器，由于我没有intel处理器所以没法测试适用于intel的配置，可以问一问ai**）

主要是为了伪装成一个友好的hyper-v，调整cpu时钟，修复cpu安全漏洞、设置高级指令集、隐藏cpu虚拟化。顺便一提如果伪装成hyper-v的话就没法在虚拟机里面安装vmware了，``` <feature policy="disable" name="svm"/> ```这个申明虚拟机cpu没有虚拟化功能，也就玩不了安卓模拟器之类的东西了。

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





# 在linux上玩游戏

[「Linux游戏指南」关于Linux玩游戏的一切](https://www.bilibili.com/video/BV1zyttzPEmp/?spm_id_from=333.1387.homepage.video_card.click&vd_source=65a8f230813d56660e48ae1afdfa4182)

这一节不仅适用于windows的游戏程序，还适用于windows的软件。
首选用steam玩游戏，steam没有的游戏通过lutris管理，使用proton或者wine运行。安卓手游用waydroid运行。如果都不行，用配置了显卡直通的win11虚拟机。

## 游玩前的准备

- 检查32位显卡工具和驱动

[docs/InstallingDrivers.md at master · lutris/docs](https://github.com/lutris/docs/blob/master/InstallingDrivers.md)

n卡注意驱动包要换成自己的

Nvidia GPU

```
sudo pacman -S --needed nvidia-open-dkms nvidia-utils lib32-nvidia-utils vulkan-icd-loader lib32-vulkan-icd-loader 
```
AMD GPU

```
sudo pacman -S --needed lib32-mesa vulkan-radeon lib32-vulkan-radeon vulkan-icd-loader lib32-vulkan-icd-loader
```
## 小黄鸭 Lossless Scaling

[Lossless Scaling Frame Generation for Linux hits 1.0 with a new UI making it easier than ever | GamingOnLinux](https://www.gamingonlinux.com/2025/08/lossless-scaling-frame-generation-for-linux-hits-1-0-with-a-new-ui-making-it-easier-than-ever/)

视频教程：[60秒学会在Linux上使用小黄鸭补帧_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1ABtDzqEcq?spm_id_from=333.788.videopod.sections&vd_source=65a8f230813d56660e48ae1afdfa4182)

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

flatpak程序使用补帧看这里[Using lsfg‐vk in Flatpak · PancakeTAS/lsfg-vk Wiki](https://github.com/PancakeTAS/lsfg-vk/wiki/Using-lsfg%E2%80%90vk-in-Flatpak)

## 玩steam游戏

[Proton (软件) - 维基百科，自由的百科全书](https://zh.wikipedia.org/wiki/Proton_(%E8%BB%9F%E9%AB%94))

[Steam - ArchWiki](https://wiki.archlinux.org/title/Steam)

```
sudo pacman -S steam
```
在设置→兼容性里面选择默认兼容性工具为proton-experimental即可运行大部分游戏

- 管理ge-proton
ge-proton比proton更加强大
```
yay -S protonup-qt
```

- 禁用游戏存放目录的btrfs的写时复制（CoW），这可以解决下载速度异常的问题。默认目录是~/.local/share/Steam/，通常禁用steamapps目录的CoW就行了


```
sudo chattr +C ~/.local/share/Steam/steamapps
```

- 可选：还是下载速度慢的话试试

```
vim ~/.steam/steam/steam_dev.cfg
```
​		写入：
```
@nClientDownloadEnableHTTP2PlatformLinux 0
@fDownloadRateImprovementToAddAnotherConnection 1.0
```

- 卸载steam

```
sudo pacman -R steam
sudo rm -rfv ~/.steam ~/.local/share/Steam
```

#### 可选：为steam创建专门的btrfs子卷

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

11. 把刚刚备份的文件移回原位

    ```
    mv ~/.local/share/Steam/steamapps.bak/* ~/.local/share/Steam/steamapps/
    ```

12. 清理残留

    ```
    rm -r ~/.local/share/Steam/steamapps.bak
    ```

现在创建home目录的快照就不会记录steam的游戏库了。对lutris也可以进行同样的操作。如果被识别成外部设备出现在文档管理器的挂载列表里面，就在fstab的那一连串逗号隔开的参数里添加```x-gvfs-hide```

## 玩minecraft

- 从aur安装启动器，推荐使用xmcl
``` 
yay -S minecraft-launcher #官方启动器
yay -S hmcl-bin #hmcl
yay -S xmcl #xmcl
```
## 玩安卓手游
### waydroid
[Install Instructions | Waydroid](https://docs.waydro.id/usage/install-on-desktops)

[Waydroid - Arch Linux 中文维基](https://wiki.archlinuxcn.org/wiki/Waydroid)

安卓系统也是linux内核，那linux发行版自然也能运行安卓，并且性能还是接近原生的。waydroid是linux上的安卓容器，相当于一个完整的安卓系统。

- 安装
```
yay -S waydroid
```
可选：从archlinuxcn安装waydroid-image（要求添加cn仓库，按照流程，在本文档的yay安装部分已经添加）
```
sudo pacman -S waydroid-image
```
- 初始化
```
sudo waydroid init
```
- 启动服务
```
sudo systemctl enable --now waydroid-container
```
- 安装arm转译
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

- 开启会话
```
waydroid session start
```
然后应该就能在桌面看到一大堆图标了
- 软件默认是全屏打开，可以设置窗口化打开软件，f11切换全屏和窗口化
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
- 编辑配置文件
```
sudo vim /var/lib/waydroid/waydroid.cfg
```
```
[properties]
ro.hardware.gralloc=default
ro.hardware.egl=swiftshader
```
- 本地更新应用一下更改后的配置
```
sudo waydroid upgrade --offline
```
- 重启服务
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

## wine/proton 兼容层运行windows软件

wine是在linux下运行windows程序的兼容层，proton是steam的母公司v社基于wine开发的专门用来玩游戏的兼容层。原理是把window程序发出的请求翻译成linux系统下的等效请求。通常使用最新的wine或者proton版本即可，或者使用GE-proton，这是GE大佬修改的proton。

wine、proton这些兼容层有一大特点叫prefix，相当于一个虚拟的c盘环境，程序的所有操作都在这个prefix中进行，完全不会影响到主机的linux。当你想卸载软件的时候，可以直接把这个prefix扬了，相当于用删除c盘的方式卸载软件，相当相当干净。

为了更好地利用prefix的优势，可以选择给每个应用单独创建一个prefix，但用命令行创建会相当繁琐，于是就有了专门用来管理prefix的工具。

### lutris
[Download Lutris](https://lutris.net/downloads)

lutris是一个专为玩游戏设计的管理工具，可以完全取代steam的“添加非steam游戏”功能。当然也可以用来管理普通软件。

- 安装
```
sudo pacman -S lutris
```
- 第一次打开会自动下载各种需要的组件，点击左上角的加号可以看到主要功能
- 卸载lutris
```
sudo pacman -Rns lutris
```
```
sudo rm -rfv ~/.config/lutris ~/.cache/lutris ~/.local/share/lutris ~/.local/share/applications/net.lutris.Lutris.desktop ~/.local/share/applications/lutris-game-*.desktop
```
steam下载proton之后可以在lutris里面设置wine版本为proton

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

---





# 性能优化

## N卡动态功耗调节 

```
sudo systemctl enable --now nvidia-powerd.service
```
## LACT进行显卡offset

使用软件商城安装的lact即可

## prelaod

这是一个让软件开启速度变得更快的程序，实测有效。

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

#### zram内存压缩

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
zram-size = "ram*3" 
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
sudo grub-mkconfig -o /boot/grub/grub.cfg
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
sudo grub-mkconfig -o /boot/grub/grub.cfg
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
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

## 更换CachyOS源

[Optimized Repositories | CachyOS](https://wiki.cachyos.org/features/optimized_repos/)

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

---




# 删除linux

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

5. 选择p盘,删除里面的linux 启动相关文件

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



# 小技巧

- super+左键按住窗口的任意位置移动窗口

- gnome桌面，super+中键可以调整窗口大小，ctrl+c复制文件后ctrl+m可以粘贴一个链接，super+滚轮切换工作区

- kde桌面，super+右键可以可以调整窗口大小，ctrl+super+滚轮可以缩放，super+alt+滚轮切换工作区

- time命令可以计算一个程序启动的时间

  示例：

  ```
  time firefox
  ```

---



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



# issues

这里是我使用过程中遇到的问题以及对应的解决方案

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

   

## kde开机会卡住，必须重启sddm才好

显卡驱动没加载完sddm就加载导致的卡死。让sddm晚2s加载就可以解决。

```
sudo systemctl edit sddm.service
```

```
[Service]
ExecStartPre=/bin/sleep 2
```

## 磁盘占用异常

明明没有多少文件，磁盘占用却很高。可以试试删除btrfs快照。

## 提示没有编解码器

安装的时候应该自带了编解码器，可能是删除别的软件时不小心连带着删掉了，重新安装皆可

```
sudo pacman -S gst-plugins-good gst-libav libde265
```

## windows时间错乱，开机磁盘检查
[双系统时间同步-CSDN博客](https://blog.csdn.net/zhouchen1998/article/details/108893660)

管理员打开powershell 运行

```
Reg add HKLM\SYSTEM\CurrentControlSet\Control\TimeZoneInformation /v RealTimeIsUniversal /t REG_DWORD /d 1
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

## virsh list --all不显示虚拟机加上sudo后显示

```
sudo vim /etc/environment
```

写入

```
VIRSH_DEFAULT_CONNECT_URI=qemu:///system
```

## wps用不了fcitx5

手动设置变量，使用任意文本编辑器打开以下文件

- 文字 (Writer): `/usr/bin/wps`
- 表格 (Spreadsheets): `/usr/bin/et`
- 演示 (Presentation): `/usr/bin/wpp`

```
export XMODIFIERS=@im=fcitx 
export QT_IM_MODULE=fcitx 
export GTK_IM_MODULE=fcitx
```



# 附录

这里是一些有用但是被我弃用的内容，以及一些额外的补充内容。

## pacman常用指令

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

## ananicy cpu资源调用优化
（会导致steam下载速度异常，故弃用。）
```
yay -S ananicy-cpp cachyos-ananicy-rules-git
```
```
sudo systemctl enable --now ananicy-cpp.service
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
```
sudo systemctl enable --now tlp
```

## ranger预览图片

（rander是一款终端文档管理器，yazi比ranger更好用，故弃用）

```
sudo pacman -S python-pillow ranger kitty 
```
```
vim ~/.config/ranger/rc.conf
```
```
set preview_images true
set preview_images_method kitty
```

## 美化kitty
（多个显示器的情况下，kitty用tiling shell扩展的自动平铺有bug，无法在当前显示器开启第一个窗口，所以换成了ghostty）
```
sudo pacman -S kitty
```
```
#下载配置文件 https://github.com/catppuccin/kitty
以frappe为例，下载frappe.conf，复制到~/.config/kitty/目录下，重命名为kitty.conf
```
```
#编辑配置文件
写入：
linux_display_server x11 #修复kitty奇怪的刘海
hide_window_decorations yes #隐藏顶栏，隐藏后无法调整窗口大小，建议配合tiling shell扩展使用
background_opacity 0.8 #设置背景透明度
font_family 字体名
font_size 字体大小数字
```
```
#如果波浪号在左上角，配置文件写入：
symbol_map U+007E Adwaita Mono
#强制指定notosansmono字体，也可以选择别的
```
```
#我的示例配置
hide_window_decorations yes
background_opacity 0.8
font_family Adwaita Mono
font_size 14
```
```
#重启终端
```

## appimagelauncher

（appimgae文件已经足够方便了，这个意义不大且容易出bug，故弃用）

appimage是一个下载即用、无需安装的文件。需要确认安装了fuse才能运行appimage。


安装appimagelauncher管理appimage软件
```
yay -S appimagelauncher
```
安装后启动appimage时会弹出appimagelauncher的窗口，第一次启动会让你设置安装路径，默认是home目录下的Applications目录。然后让你选择运行一次还是集成到系统。不过有时候会安装失败或者安装之后无法运行。
- 卸载appimage软件
右键快捷方式，点击remove appimage from system，或者手动删除~/.local/share/Applications下的destop文件和安装目录下的appimage文件。

### 其他有用的扩展

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

## 用archinstall安装gnome后的一些清理

```
sudo pacman -R gnome-contacts gnome-maps gnome-music totem gnome-characters gnome-connections evince gnome-logs malcontent gnome-system-monitor gnome-console gnome-tour yelp simple-scan htop sushi gnome-user-docs epiphany htop 
```

## 麦克风降噪软件

noisetorch

easyeffect

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

避免id变更导致挂载失败

```
sudo sed -i -E 's/(subvolid=[0-9]+,)|(,subvolid=[0-9]+)//g' /etc/fstab
```

## zsh

```
 sudo pacman -S zsh
```

- 修改shell为zsh

```
chsh -s /usr/bin/zsh
```

- 激活starship

```
vim ~/.zshrc
```

写入

```
eval "$(starship init zsh)"
```

- 语法检查、自动补全、tab选择、历史记录

```
sudo pacman -S zsh-syntax-highlighting zsh-autosuggestions zsh-completions
```

```
vim ~/.zshrc
```

写入

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

```
source ~/.zshrc
```

## zen浏览器

```
sudo pacman -S zen-browser zen-browser-i18n-zh-cn
```

## distrobox

[distrobox.it](https://distrobox.it/)

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
  distrobox create -n debian -i debian:stable --home ~/Distroboxhome/debian --nvidia
  ```

- archlinux:latest

  ```
  distrobox create -n arch -i archlinux:latest --home ~/Distroboxhome/arch --nvidia
  ```

- fedora

  ```
  distrobox create -n fedora -i fedora:latest --home ~/Distroboxhome/fedora --nvidia
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



## 更高效地使用终端

我也是初学者，如果有什么建议欢迎提出。

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

---

## 许可证

本文档的所有内容均采用 [知识共享 署名-相同方式共享 4.0 国际 许可协议](http://creativecommons.org/licenses/by-sa/4.0/) 进行许可。
