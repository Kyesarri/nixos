boot:

using 'journalctl --boot -1'

logs from boot w/o nvidia gpu enabled, prior to modifying system. will change @ next boot

Feb 06 14:24:14 nix-laptop kernel: ccp 0000:04:00.2: enabling device (0000 -> 0002)
Feb 06 14:24:14 nix-laptop kernel: ccp 0000:04:00.2: ccp: unable to access the device: you might be running a broken BIOS.
Feb 06 14:24:14 nix-laptop kernel: ccp 0000:04:00.2: tee enabled
Feb 06 14:24:14 nix-laptop kernel: ccp 0000:04:00.2: psp enabled

Feb 06 14:24:14 nix-laptop systemd-modules-load[638]: could not find module by name='off'
Feb 06 14:24:14 nix-laptop systemd-modules-load[638]: Failed to insert module 'off': No such file or directory
Feb 06 14:24:14 nix-laptop systemd-modules-load[638]: Module 'nvidia_modeset' is deny-listed (by kmod)
Feb 06 14:24:14 nix-laptop systemd-modules-load[638]: Module 'nvidia_drm' is deny-listed (by kmod)

Feb 06 14:24:15 nix-laptop systemd-vconsole-setup[1003]: KD_FONT_OP_GET failed while trying to get the font metadata: Invalid argument
Feb 06 14:24:15 nix-laptop systemd-vconsole-setup[1003]: Fonts will not be copied to remaining consoles

Feb 06 14:24:15 nix-laptop systemd-oomd[1196]: No swap; memory pressure usage will be degraded

Feb 06 14:24:15 nix-laptop (udev-worker)[884]: AC0: Process '/nix/store/vfmf8qh892jfl107hih0yfnic00byjgj-systemd-254.6/bin/systemctl --no-block start nvidia-powerd.service' failed with exit code 5.

Feb 06 14:24:27 nix-laptop kernel: amdgpu 0000:04:00.0: amdgpu: RAP: optional rap ta ucode is not available
Feb 06 14:24:27 nix-laptop kernel: [drm] psp gfx command LOAD_TA(0x1) failed and response status is (0x7)
Feb 06 14:24:27 nix-laptop kernel: [drm] psp gfx command INVOKE_CMD(0x3) failed and response status is (0x4)
Feb 06 14:24:27 nix-laptop kernel: amdgpu 0000:04:00.0: amdgpu: Secure display: Generic Failure.
Feb 06 14:24:27 nix-laptop kernel: amdgpu 0000:04:00.0: amdgpu: SECUREDISPLAY: query securedisplay TA failed. ret 0x0

