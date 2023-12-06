Windows 11
==========

Windows qemu vm with Hyper-v, Docker and WSL2 enabled.

Requirements
------------

QEMU, Packer


To build Image
--------------

Build the image using packer:

    read -p 'Enter password: ' -s password
    packer build -var username=username -var "password=$password" windows-11.pkr.hcl

Use the following config in virt-manager:

  ```
  <cpu mode='custom' match='exact' check='partial'>
    <model fallback='allow'>Skylake-Client-noTSX-IBRS</model>
    <feature policy='disable' name='hypervisor'/>
    <feature policy='require' name='vmx'/>
    <feature policy='disable' name='mpx'/>
  </cpu>
  ```
