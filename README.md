# NixOS 配置

基于 Flakes + home-manager 的个人 NixOS 配置，使用 [niri](https://github.com/YaLTeR/niri)（Wayland 滚动平铺合成器）作为桌面环境。

## 特性

- **Flake 驱动** — 可复现构建，多主机共享公共模块
- **niri** — Wayland 滚动平铺窗口管理器
- **home-manager** — 用户级配置管理（zsh / git / waybar / 终端等）
- **waybar** — zinc 配色状态栏，数字工作区（1-9）
- **fcitx5** — 自定义 zinc-950 主题，rime-ice 输入方案
- **greetd + tuigreet** — TUI 登录管理器
- **ext4 单一分区 + zram swap** — 简洁磁盘布局，无磁盘 swapfile
- **anyrun** — 应用启动器

## 目录结构

```text
.
├── flake.nix                  # Flake 入口，定义所有主机
├── hosts/                     # 每台机器的专属配置
│   ├── yoga/                  # 主力机（AMD 笔记本）
│   │   ├── default.nix
│   │   └── hardware-configuration.nix
│   └── vmware/                # VMware 虚拟机
│       ├── default.nix
│       └── hardware-configuration.nix
└── modules/
    ├── system/                # 系统级公共模块
    │   ├── desktop.nix        # niri / greetd / portal
    │   ├── locale.nix
    │   ├── networking.nix
    │   ├── users.nix
    │   ├── packages.nix
    │   ├── fonts.nix
    │   ├── gaming.nix
    │   ├── services.nix
    │   ├── nix.nix
    │   └── zram.nix           # zram swap
    └── home/                  # 用户级公共模块（home-manager）
        ├── shell.nix
        ├── niri.nix           # niri 键位 / 窗口规则
        ├── waybar.nix         # 状态栏
        ├── anyrun.nix
        ├── ghostty.nix / kitty.nix
        ├── fcitx5/            # 输入法配置与主题
        └── ...
```

## 主机

| 主机 | 说明 |
|------|------|
| `yoga` | 主力 AMD 笔记本 |
| `vmware` | VMware 测试虚拟机 |

## 安装

目标布局：UEFI + GPT，**ext4 单一大分区 + ESP**，swap 用 zram（无需磁盘 swapfile）。

```text
/dev/nvme0n1p1  1G    vfat   BOOT    (ESP)
/dev/nvme0n1p2  剩余  ext4   nixos   (根分区)
```

> 命令中的 `/dev/nvme0n1` 仅为示例，操作前务必用 `lsblk` 确认目标磁盘。

### 1. 分区与格式化

```bash
sudo -i
lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINTS,LABEL

cfdisk /dev/nvme0n1
# Label type: gpt
# New 1G   -> Type: EFI System
# New rest -> Type: Linux filesystem
# Write -> yes -> Quit

mkfs.fat -F32 -n BOOT  /dev/nvme0n1p1
mkfs.ext4 -L nixos     /dev/nvme0n1p2
```

### 2. 挂载

```bash
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/BOOT /mnt/boot
```

### 3. 拉取配置

```bash
git clone <本仓库地址> /mnt/etc/nixos
cd /mnt/etc/nixos
```

### 4. 生成并合并硬件配置

```bash
nixos-generate-config --root /mnt
```

把生成的 `/mnt/etc/nixos/hardware-configuration.nix` 中的内核模块、CPU 微码等内容合并进 `hosts/<主机>/hardware-configuration.nix`（保留本仓库里的 ext4 + ESP 挂载配置，不要用生成出来的 btrfs 默认值）。可删掉生成出来的 `configuration.nix`。

### 5. 设置用户密码并安装

```bash
nixos-install --flake .#yoga    # 或 .#vmware
# 安装过程中按提示设置 root 密码；装好后给用户设密码：
nixos-enter --root /mnt -c 'passwd fc'
reboot
```

## 日常使用

```bash
# 应用配置变更
sudo nixos-rebuild switch --flake .#yoga

# 更新 flake 输入
nix flake update
sudo nixos-rebuild switch --flake .#yoga

# 清理旧世代
sudo nix-collect-garbage -d
```

## 备注

- zram swap 不支持休眠（hibernate），如需休眠要加回磁盘 swap。
- 历史安装文档见 `nixos-btrfs-install.md`（旧 btrfs 布局，仅供参考）。
