

/usr/libexec/qemu-kvm --name centos-12.04 -hda openstack.img -boot d -cdrom CentOS-6.5-x86_64-minimal.iso -m 2048 -device e1000,netdev=net0,mac=DE:AD:BE:EF:CC:56 -netdev tap,id=net0,script=/root/qemu-ifup.sh
