# NixOS Btrfs 安装笔记

这份文档记录一次手动安装 NixOS 的流程：UEFI、GPT、Btrfs 子卷，以及由 NixOS 自动管理的 swapfile。

## 目标布局

- 分区表：GPT
- EFI 分区：`1G`，FAT32，卷标 `BOOT`
- Root 分区：剩余空间，Btrfs，卷标 `nixos`
- Swap：Btrfs swapfile，路径 `/swap/swapfile`，由 NixOS 配置自动创建

示例磁盘布局：

```text
/dev/nvme0n1p1  1G   vfat   BOOT
/dev/nvme0n1p2  剩余 btrfs  nixos
```

下面命令里的 `/dev/nvme0n1` 只是示例，实际操作前必须用 `lsblk` 确认目标磁盘。

## 分区

进入 root shell 并查看磁盘：

```bash
sudo -i
lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINTS,MODEL,LABEL
```

使用 `cfdisk` 分区：

```bash
cfdisk /dev/nvme0n1
```

在 `cfdisk` 中选择：

```text
Label type: gpt
New 1G    -> Type: EFI System
New rest  -> Type: Linux filesystem
Write -> yes
Quit
```

## 格式化

```bash
mkfs.fat -F32 -n BOOT /dev/nvme0n1p1
mkfs.btrfs -f -L nixos /dev/nvme0n1p2
```

## 创建 Btrfs 子卷

先临时挂载 Btrfs 顶层卷：

```bash
mount /dev/disk/by-label/nixos /mnt
```

创建子卷：

```bash
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@nix
btrfs subvolume create /mnt/@swap
```

卸载顶层卷：

```bash
umount /mnt
```

## 安装前挂载

挂载 root 子卷，启用压缩和 `noatime`：

```bash
mount -o subvol=@,compress=zstd,noatime /dev/disk/by-label/nixos /mnt
```

创建挂载点：

```bash
mkdir -p /mnt/{boot,home,nix,swap}
```

挂载其它子卷：

```bash
mount -o subvol=@home,compress=zstd,noatime /dev/disk/by-label/nixos /mnt/home
mount -o subvol=@nix,compress=zstd,noatime /dev/disk/by-label/nixos /mnt/nix
mount -o subvol=@swap,noatime /dev/disk/by-label/nixos /mnt/swap
mount /dev/disk/by-label/BOOT /mnt/boot
```

这里不要手动创建 swapfile，后面交给 NixOS 配置自动创建。

## 生成 NixOS 配置

```bash
nixos-generate-config --root /mnt
```

生成的文件：

```text
/mnt/etc/nixos/configuration.nix
/mnt/etc/nixos/hardware-configuration.nix
```

## 修改硬件配置

编辑 `/mnt/etc/nixos/hardware-configuration.nix`。

建议改成使用 label 挂载，普通 Btrfs 子卷启用压缩，swap 子卷不压缩，EFI 分区限制为 root-only，并让 NixOS 自动创建 swapfile：

```nix
fileSystems."/" = {
  device = "/dev/disk/by-label/nixos";
  fsType = "btrfs";
  options = [ "subvol=@" "compress=zstd" "noatime" ];
};

fileSystems."/home" = {
  device = "/dev/disk/by-label/nixos";
  fsType = "btrfs";
  options = [ "subvol=@home" "compress=zstd" "noatime" ];
};

fileSystems."/nix" = {
  device = "/dev/disk/by-label/nixos";
  fsType = "btrfs";
  options = [ "subvol=@nix" "compress=zstd" "noatime" ];
};

fileSystems."/swap" = {
  device = "/dev/disk/by-label/nixos";
  fsType = "btrfs";
  options = [ "subvol=@swap" "noatime" ];
};

fileSystems."/boot" = {
  device = "/dev/disk/by-label/BOOT";
  fsType = "vfat";
  options = [ "umask=0077" ];
};

swapDevices = [
  {
    device = "/swap/swapfile";
    size = 8 * 1024;
  }
];
```

说明：

- `compress=zstd` 是现代 Btrfs root、home、nix 子卷的常见选择。
- `noatime` 可以减少无意义的元数据写入，现代 Linux 系统一般没有问题。
- `/swap` 子卷不应该用于压缩 swapfile。
- `umask=0077` 会让 EFI 分区只有 root 可访问。
- `size` 单位是 MiB，`8 * 1024` 表示创建 8 GiB swapfile。

## 修改主配置

编辑 `/mnt/etc/nixos/configuration.nix`。

建议至少启用这些设置：

```nix
boot.loader.systemd-boot.enable = true;
boot.loader.efi.canTouchEfiVariables = true;

boot.kernelPackages = pkgs.linuxPackages_latest;

networking.hostName = "nixos";
networking.networkmanager.enable = true;
time.timeZone = "Asia/Shanghai";
i18n.defaultLocale = "en_US.UTF-8";
console.keyMap = "us";

users.users.fc = {
  isNormalUser = true;
  extraGroups = [ "wheel" "networkmanager" ];
};

environment.systemPackages = with pkgs; [
  git
  vim
  wget
];
```

保持生成出来的 `system.stateVersion` 不要随意修改。

## 安装系统

执行安装：

```bash
nixos-install
```

如果需要给普通用户设置密码：

```bash
nixos-enter --root /mnt -c 'passwd fc'
```

然后重启：

```bash
reboot
```

## 在 Live ISO 中临时使用 Git

把 `git` 加到 `configuration.nix` 只会影响安装后的新系统，不会影响当前 Live ISO。

如果安装前就要拉仓库，可以临时进入带 Git 的 shell：

```bash
nix-shell -p git
git clone <repo-url>
```

## 启动后验证 swapfile

检查 swap 是否启用：

```bash
swapon --show
free -h
```

`swapon --show` 里应该能看到 `/swap/swapfile`，类型是 `file`。

检查 Btrfs 是否接受这个 swapfile：

```bash
sudo btrfs inspect-internal map-swapfile -r /swap/swapfile
```

这个命令应该成功，并输出物理偏移地址。

检查 `NOCOW`：

```bash
nix-shell -p e2fsprogs
lsattr /swap/swapfile
```

输出中应该有 `C`：

```text
---------------C------ /swap/swapfile
```

检查压缩属性：

```bash
sudo btrfs property get /swap/swapfile compression
```

返回空是正常的，表示这个文件没有设置单独的压缩属性。

`findmnt /swap` 可能仍然显示 `compress=zstd`，这是 Btrfs 在同一个 filesystem 上展示全局挂载选项的结果，不代表 `/swap/swapfile` 本身被压缩。判断 swapfile 是否正确，主要看 `swapon --show`、`btrfs inspect-internal map-swapfile`、`lsattr` 和 Btrfs compression property。

## 安装后应用配置修改

进入安装好的系统后，修改配置并应用：

```bash
sudo nixos-rebuild switch
```
