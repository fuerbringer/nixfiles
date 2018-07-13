# secrets

This directory contains secret nix expressions.

## networkShares.nix

### Example

```
{ config, ... }:

{
  fileSystems."/path/to/folder" = {
    device = "//xxxxxxx.your-storagebox.de/backup";
    fsType = "cifs";
    options =
    let automount_opts = "seal,rw,uid=1000,gid=100,x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
    in ["${automount_opts},credentials=/root/path/to/smb-secrets"];
  };
}
```