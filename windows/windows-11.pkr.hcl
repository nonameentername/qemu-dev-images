packer {
  required_version = ">= 1.9.0"
  required_plugins {
    qemu = {
      source  = "github.com/hashicorp/qemu"
      version = ">= 1.0.10"
    }
  }
}

variable "cd_files_list" {
  type    = string
  default = "drivers/*"
}

variable "cpus" {
  type    = string
  default = "4"
}

variable "disk_size" {
  type    = string
  default = "130048"
}

variable "floppy_files_list" {
  type    = string
  default = "floppy/*"
}

variable "headless" {
  type    = string
  default = "false"
}

variable "iso_checksum" {
  type    = string
  default = "f2ddae5e4fd954c1cb35ba90c5fddf56"
}

variable "iso_checksum_type" {
  type    = string
  default = "md5"
}

variable "iso_url" {
  type    = string
  default = "file:///${env("HOME")}/Downloads/Win11_23H2_English_x64.iso"
}

variable "memory" {
  type    = string
  default = "8192"
}

variable "version" {
  type    = string
  default = "1"
}

variable "vm_name" {
  type    = string
  default = "windows-11"
}

source "qemu" "windows_11" {
  boot_command = ["<enter><wait><enter><wait><enter>"]
  boot_wait    = "2s"
  cd_files     = ["${var.cd_files_list}"]
  cd_label     = "drivers"
  communicator = "winrm"
  disk_size    = "${var.disk_size}"
  floppy_files = ["floppy/setup.cmd", "floppy/Autounattend.ps1", "floppy/Autounattend.xml"]
  headless         = "${var.headless}"
  iso_checksum     = "${var.iso_checksum_type}:${var.iso_checksum}"
  iso_urls         = ["${var.iso_url}"]
  output_directory = "output-${var.vm_name}"
  qemuargs         = [["-m", "4048M"], ["-cpu", "Skylake-Server-noTSX-IBRS,hypervisor=off,vmx=on,mpx=off,hv-time=on,hv-relaxed=on,hv-vapic=on,hv-spinlocks=0x1fff"], ["-m", "${var.memory}"], ["-smp", "cpus=${var.cpus}"]]
  shutdown_command = "shutdown /s /t 10 /f /d p:4:1 /c \"Packer Shutdown\""
  vm_name          = "${var.vm_name}"
  winrm_password   = "vagrant"
  winrm_timeout    = "10000s"
  winrm_username   = "vagrant"
}

build {
  sources = ["source.qemu.windows_11"]

  provisioner "powershell" {
    valid_exit_codes = [0, 259]
    inline = [
      "pnputil.exe /add-driver 'E:\\virtio-win-0.1.135\\NetKVM\\w11\\amd64\\netkvm.inf' /install",
      "pnputil.exe /add-driver 'E:\\virtio-win-0.1.135\\viostor\\w11\\amd64\\viostor.inf' /install"
    ]
  } 

  provisioner "windows-shell" {
    scripts = [
      "scripts/unlimited-password-expiration.bat",
      "scripts/enable-rdp.bat",
      "scripts/uac-disable.bat",
      "scripts/disablewinupdate.bat",
      "scripts/disable-hibernate.bat",
      "scripts/firewall-open-ping.bat",
      "scripts/firewall-open-rdp.bat",
      "scripts/firewall-open-smb.bat",
    ]
  }

  provisioner "powershell" {
    scripts = [
      "scripts/Install-Hyper-V-Containers.ps1"
    ]
  }

  provisioner "windows-restart" {
    check_registry  = true
    restart_timeout = "10m"
  }

  provisioner "powershell" {
    scripts = [
      "scripts/Install-WSL2.ps1",
      "scripts/Install-Docker.ps1"
    ]
  }

  provisioner "windows-restart" {
    check_registry  = true
    restart_timeout = "10m"
  }

  provisioner "windows-shell" {
    inline = ["net user vagrant vagrant"]
  }

  post-processors {
    post-processor "vagrant" {
      keep_input_artifact = true
      output = "windows_11_{{.Provider}}.box"
      vagrantfile_template = "vagrantfile-windows_11.template"
    }
  }
}
