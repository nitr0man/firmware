#!/bin/bash
#
# OpenIPC.org | v.20220102
#

clone() {
  sudo apt-get update -y ; apt-get install -y bc build-essential git unzip rsync autotools-dev automake libtool
  git clone --depth=1 https://github.com/OpenIPC/firmware.git
}

fresh() {
  date >/tmp/openipc_buildtime.txt
  [ -d buildroot-2020.02.12/dl ] && mkdir -p /tmp/buildroot_dl ; cp -rv buildroot-2020.02.12/dl/* /tmp/buildroot_dl
  make distclean #clean
  [ -d buildroot* ] && echo -e "\nBuildroot found, OK\n" || make prepare
}

rename() {
  [[ $(stat --printf="%s" ./output/images/uImage) -gt 2097152 ]] && TG_NOTIFY="Warning: kernel size exceeded : $(stat --printf="%s" ./output/images/uImage) vs 2097152" && exit 1
  [[ $(stat --printf="%s" ./output/images/rootfs.squashfs) -gt 5242880 ]] && TG_NOTIFY="Warning: rootfs size exceeded - $(stat --printf="%s" ./output/images/rootfs.squashfs) vs 5242880" && exit 1
  # If board have "_ultimate" as part...
  #[[ $(stat --printf="%s" ./output/images/rootfs.squashfs) -gt 13107200 ]] && TG_NOTIFY="Warning: rootfs size exceeded - $(stat --printf="%s" ./output/images/rootfs.squashfs) vs 13107200" && exit 1
  #
  mv -v ./output/images/uImage ./output/images/uImage.${soc}
  mv -v ./output/images/rootfs.squashfs ./output/images/rootfs.squashfs.${soc}
  mv -v ./output/images/rootfs.cpio ./output/images/rootfs.${soc}.cpio
  mv -v ./output/images/rootfs.tar ./output/images/rootfs.${soc}.tar
  date >>/tmp/openipc_buildtime.txt
  echo -e "\n\n$(cat /tmp/openipc_buildtime.txt)"
}

rename_initramfs() {
  [[ $(stat --printf="%s" ./output/images/uImage) -gt 4097152 ]] && TG_NOTIFY="Warning: kernel size exceeded : $(stat --printf="%s" ./output/images/uImage) vs 2097152" && exit 1
  #
  mv -v ./output/images/uImage ./output/images/uImage.initramfs.${soc}
  mv -v ./output/images/rootfs.cpio ./output/images/rootfs.${soc}.cpio
  mv -v ./output/images/rootfs.tar ./output/images/rootfs.${soc}.tar
  date >>/tmp/openipc_buildtime.txt
  echo -e "\n\n$(cat /tmp/openipc_buildtime.txt)"
}

autoup_rootfs() {
  echo -e "\n\n"
  cp -v ./output/images/uImage.initramfs.${soc} ./output/images/autoupdate-kernel.img
  ./output/host/bin/mkimage -A arm -O linux -T filesystem -n 'OpenIPC firmware' -a 0x000000250000 -e 0x000000750000 -d ./output/images/rootfs.squashfs.${soc} ./output/images/autoupdate-rootfs.img
}

upload() {
  server="zig@172.28.200.74:/sync/Archive/Incoming/Tftp/"
  echo -e "\n\nStart transferring files to the TFTP server...\n"
  scp -P 22 -r ./output/images/rootfs.squashfs.* ./output/images/uImage.* ${server}
  echo -e "\n"
  date
}

sdk() {
  make br-sdk
}

#################################################################################

fh8852() {
  soc="fh8852"
  fresh && make PLATFORM=fullhan BOARD=unknown_unknown_${soc}_openipc all && rename
}

fh8856() {
  soc="fh8856"
  fresh && make PLATFORM=fullhan BOARD=unknown_unknown_${soc}_openipc all && rename
}

#################################################################################

gk7205v200() {
  soc="gk7205v200"
  fresh && make PLATFORM=goke BOARD=unknown_unknown_${soc}_openipc all && rename
}

gk7205v200_fpv() {
  soc="gk7205v200"
  fresh && make PLATFORM=goke BOARD=unknown_unknown_${soc}_fpv all && rename
}

gk7205v200_ufanet() {
  soc="gk7205v200"
  fresh && make PLATFORM=goke BOARD=unknown_unknown_${soc}_ufanet all && rename
}

gk7205v300() {
  soc="gk7205v300"
  fresh && make PLATFORM=goke BOARD=unknown_unknown_${soc}_openipc all && rename
}

#################################################################################

hi3516av300() {
  soc="hi3516av300"
  fresh && make PLATFORM=hisilicon BOARD=unknown_unknown_${soc}_openipc all && rename
}

hi3516cv100() {
  soc="hi3516cv100"
  fresh && make PLATFORM=hisilicon BOARD=unknown_unknown_${soc}_openipc all && rename
}

hi3516cv200() {
  soc="hi3516cv200"
  fresh && make PLATFORM=hisilicon BOARD=unknown_unknown_${soc}_openipc all && rename
}

hi3518ev200() {
  soc="hi3518ev200"
  fresh && make PLATFORM=hisilicon BOARD=unknown_unknown_${soc}_myopenipc all && rename
}

hi3518ev200_hs303v3() {
  soc="hi3518ev200"
  fresh && make PLATFORM=hisilicon BOARD=unknown_unknown_${soc}_openipc all && rename && autoup_rootfs
  #PLATFORM=hisilicon  make br-linux-{dirclean,rebuild}
  #PLATFORM=hisilicon  make br-hisilicon-osdrv-hi3516cv300-{dirclean,rebuild}
  #PLATFORM=hisilicon  make br-majestic-hi3516cv300-{dirclean,rebuild}
  #PLATFORM=hisilicon  make br-mbedtls-openipc-{dirclean,rebuild}
}

#################################################################################

hi3516cv300() {
  soc="hi3516cv300"
  fresh && make PLATFORM=hisilicon BOARD=unknown_unknown_${soc}_openipc all && rename
}

hi3516ev100() {
  soc="hi3516ev100"
  fresh && make PLATFORM=hisilicon BOARD=unknown_unknown_${soc}_openipc all && rename
}
#################################################################################
hi3516av100() {
  soc="hi3516av100"
  fresh && make PLATFORM=hisilicon BOARD=unknown_unknown_${soc}_openipc all && rename
}

hi3516dv100() {
  soc="hi3516dv100"
  fresh && make PLATFORM=hisilicon BOARD=unknown_unknown_${soc}_openipc all && rename
}

#################################################################################

hi3519v101() {
  soc="hi3519v101"
  fresh && make PLATFORM=hisilicon BOARD=unknown_unknown_${soc}_openipc all && rename
}

hi3516av200() {
  soc="hi3516av200"
  fresh && make PLATFORM=hisilicon BOARD=unknown_unknown_${soc}_openipc all && rename
}

#################################################################################

hi3516cv500() {
  soc="hi3516cv500"
  fresh && make PLATFORM=hisilicon BOARD=unknown_unknown_${soc}_openipc all && rename
}

hi3516dv300() {
  soc="hi3516dv300"
  fresh && make PLATFORM=hisilicon BOARD=unknown_unknown_${soc}_openipc all && rename
}

#################################################################################

hi3516dv200() {
  soc="hi3516dv200"
  fresh && make PLATFORM=hisilicon BOARD=unknown_unknown_${soc}_openipc all && rename
}

hi3516ev200() {
  soc="hi3516ev200"
  fresh && make PLATFORM=hisilicon BOARD=unknown_unknown_${soc}_openipc all && rename
}

hi3516ev200_dozor() {
  soc="hi3516ev200"
  fresh && make PLATFORM=hisilicon BOARD=unknown_unknown_${soc}_dozor all && rename
}

hi3516ev200_eltis() {
  soc="hi3516ev200"
  fresh && make PLATFORM=hisilicon BOARD=unknown_unknown_${soc}_eltis all && rename
}

hi3516ev200_vixand() {
  soc="hi3516ev200"
  fresh && make PLATFORM=hisilicon BOARD=unknown_unknown_${soc}_vixand all && rename
}

hi3516ev300() {
  soc="hi3516ev300"
  fresh && make PLATFORM=hisilicon BOARD=unknown_unknown_${soc}_openipc all && rename
}

hi3516ev300_dev() {
  soc="hi3516ev300"
  fresh && make PLATFORM=hisilicon BOARD=unknown_unknown_${soc}_dev all && rename
}

hi3516ev300_glibc() {
  soc="hi3516ev300"
  fresh && make PLATFORM=hisilicon BOARD=unknown_unknown_${soc}_glibc all && rename
}

hi3516ev300_tehshield() {
  soc="hi3516ev300"
  fresh && make PLATFORM=hisilicon BOARD=unknown_unknown_${soc}_tehshield all && rename
}

hi3516ev300_ultimate() {
  soc="hi3516ev300"
  fresh && make PLATFORM=hisilicon BOARD=unknown_unknown_${soc}_ultimate all && rename
}

hi3518ev300() {
  soc="hi3518ev300"
  fresh && make PLATFORM=hisilicon BOARD=unknown_unknown_${soc}_openipc all && rename
}

hi3536cv100() {
  soc="hi3536cv100"
  fresh && make PLATFORM=hisilicon BOARD=unknown_unknown_${soc}_openipc all && rename
}

hi3536dv100() {
  soc="hi3536dv100"
  fresh && make PLATFORM=hisilicon BOARD=unknown_unknown_${soc}_openipc all && rename
}

#################################################################################

nt98562() {
  soc="nt98562"
  fresh && make PLATFORM=novatek BOARD=unknown_unknown_${soc}_openipc all && rename
  #PLATFORM=novatek make br-linux-{dirclean,rebuild}
}

nt98566() {
  soc="nt98566"
  fresh && make PLATFORM=novatek BOARD=unknown_unknown_${soc}_openipc all && rename
}

#################################################################################

ssc325() {
  soc="ssc325"
  fresh && make PLATFORM=sigmastar BOARD=unknown_unknown_${soc}_openipc all && rename
}

#################################################################################

ssc333() {
  soc="ssc333"
  fresh && make PLATFORM=sigmastar BOARD=unknown_unknown_${soc}_openipc all && rename
}

ssc335() {
  soc="ssc335"
  fresh && make PLATFORM=sigmastar BOARD=unknown_unknown_${soc}_openipc all && rename
}

ssc335_blackbird() {
  soc="ssc335"
  fresh && make PLATFORM=sigmastar BOARD=unknown_unknown_${soc}_blackbird all && rename
}

ssc335_goodcam() {
  soc="ssc335"
  fresh && make PLATFORM=sigmastar BOARD=unknown_unknown_${soc}_goodcam all && rename
}

ssc335_initramfs() {
  soc="ssc335"
  fresh && make PLATFORM=sigmastar BOARD=unknown_unknown_${soc}_initramfs all && rename_initramfs
}

ssc335_musl() {
  soc="ssc335"
  fresh && make PLATFORM=sigmastar BOARD=unknown_unknown_${soc}_musl all && rename
}

ssc335_portal() {
  soc="ssc335"
  fresh && make PLATFORM=sigmastar BOARD=unknown_unknown_${soc}_portal all && rename
}

ssc335_rotek() {
  soc="ssc335"
  fresh && make PLATFORM=sigmastar BOARD=unknown_unknown_${soc}_rotek all && rename
}

ssc337() {
  soc="ssc337"
  fresh && make PLATFORM=sigmastar BOARD=unknown_unknown_${soc}_openipc all && rename
}

#################################################################################

ssc335de() {
  soc="ssc335de"
  fresh && make PLATFORM=sigmastar BOARD=unknown_unknown_${soc}_openipc all && rename
}

ssc337de() {
  soc="ssc337de"
  fresh && make PLATFORM=sigmastar BOARD=unknown_unknown_${soc}_openipc all && rename
}

#################################################################################

xm510() {
  soc="xm510"
  fresh && make PLATFORM=xiongmai BOARD=unknown_unknown_${soc}_openipc all && rename
}

xm530() {
  soc="xm530"
  fresh && make PLATFORM=xiongmai BOARD=unknown_unknown_${soc}_openipc all && rename
}

xm550() {
  soc="xm550"
  fresh && make PLATFORM=xiongmai BOARD=unknown_unknown_${soc}_openipc all && rename
}

#################################################################################


# Build firmware
#
# fh8852                        # testing..
# fh8856                        # testing..
#
#######
#
# gk7202v300                   # testing..
# gk7205v200                   # OpenIPC
# gk7205v200_fpv               # FPV
# gk7205v200_ufanet            # Ufanet
# gk7205v300                   # OpenIPC
# gk7605v100                   # testing..
#
#######
#
hi3516cv100                   # OpenIPC
#
# hi3516cv200                   # testing..
# hi3518ev200                   # testing..
# hi3516cv200                   # testing..
hi3518ev200                   # testing..
# hi3518ev200_hs303v3             # testing..
#
# hi3516av100                   # OpenIPC
# hi3516dv100                   # OpenIPC
#
# hi3516cv300                   # OpenIPC
# hi3516ev100                   # OpenIPC
#
# hi3516dv200                   # OpenIPC
# hi3516ev200                   # OpenIPC
# hi3516ev200_dozor             # Dozor
# hi3516ev200_eltis             # Eltis
# hi3516ev200_vixand            # Vixand
# hi3516ev300                   # OpenIPC
# hi3516ev300_dev               # OpenIPC development
# hi3516ev300_glibc             # testing..
# hi3516ev300_tehshield         # Tehshield
# hi3516ev300_ultimate          # OpenIPC_ultimate version
# hi3518ev300                   # OpenIPC
#
# hi3519v101                    # OpenIPC
# hi3516av200                   # OpenIPC
#
# hi3516av300                   # testing..
# hi3516cv500                   # testing..
# hi3516dv300                   # testing..
#
# hi3536dv100                   # OpenIPC
#
#######
#
# nt98562                       # OpenIPC
# nt98566                       # OpenIPC
#
#######
#
# ssc325                        # OpenIPC
#
# ssc333                        # OpenIPC
#
# ssc335                        # OpenIPC
# ssc335_blackbird              # BlackBird
# ssc335_goodcam                # GoodCam
# ssc335_initramfs              # Initramfs
# ssc335_musl                   # Musl
# ssc335_portal                 # Portal (partner)
# ssc335_rotek                  # Rotek
#
# ssc335de                      # OpenIPC
#
# ssc337                        # OpenIPC => musl
#
# ssc337de                      # OpenIPC
#
#######
#
# xm510                         # testing
# xm530                         # OK
# xm550                         # OK
#
#
#
# More examples see here: https://github.com/OpenIPC/firmware/wiki/source_code
#
