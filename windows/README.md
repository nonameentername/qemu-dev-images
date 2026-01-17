Windows 11
==========

Windows qemu vm with Hyper-v, Docker and WSL2 enabled.

Requirements
------------

QEMU, Packer


To build Image
--------------

Build the image using packer:

    cd windows
    packer build windows-11.pkr.hcl
    vagrant box add windows_11 windows_11_libvirt.box

Run with vagrant
----------------

    vagrant plugin install winrm
    vagrant plugin install winrm-elevated
    vagrant plugin install winrm-fs
    vagrant plugin install vagrant-libvirt

    vagrant up

Use the following config in virt-manager:

  ```
  <cpu mode='custom' match='exact' check='partial'>
    <model fallback='allow'>Skylake-Client-noTSX-IBRS</model>
    <feature policy='disable' name='hypervisor'/>
    <feature policy='require' name='vmx'/>
    <feature policy='disable' name='mpx'/>
  </cpu>
  ```
