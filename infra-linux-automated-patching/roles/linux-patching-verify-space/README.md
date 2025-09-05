# linux-patching-verify-space

Ansible role to check and recover disk space in /, /var, and /boot before patching. Automatically calculates required space based on packages to be updated, and attempts multiple safe cleanup strategies. Fails if required space cannot be freed.


## Features

- Checks available space in `/`, `/var`, `/boot` before patching
- Calculates required space based on update package list (especially kernel updates)
- Smart logic: If no kernel update, `/boot` can be nearly full
- Attempts space recovery in order:
  - Logrotate for `/var/log`
  - Clean package manager cache (`dnf/yum clean all`)
  - Remove old journal logs (`journalctl --vacuum-size`/`--vacuum-time`)
  - Delete old mail spools
  - Remove unused crash dumps and core dumps
  - Purge old audit logs
  - Remove orphaned RPMs
  - Remove unused packages (`dnf autoremove`)
  - Delete files in `/tmp` and `/var/tmp`
  - Remove old kernels from `/boot` (keep at least two, never remove running kernel)
  - Remove duplicate/unused initramfs images and rescue kernels
  - Remove unused containers/images (Docker/Podman)
  - Remove old backups/ISOs
  - Remove old LVM snapshots
  - Clean up unused user files in `/home` (with caution)
- Detects if `/`, `/var`, or `/boot` are on LVM
- Checks for available space in the volume group (VG)
- Automatically extends logical volume and filesystem if VG has free space (after cleanup)
- Supports `notify-only` tag:
  - Only checks space against minimums
  - Sends email alert if space is low (no cleanup performed)
  - Email includes hostname and free space details
- Fails and aborts patching if required space cannot be freed automatically
- VM snapshot recommended for aggressive cleanup

## Custom Log Directory Cleanup

You can specify additional directories to clean up old log files in `defaults/main.yml`:

```yaml
additional_log_dirs:
  - path: /var/spool/postfix/maildrop
    retention_days: 30
  - path: /var/log/myapp
    retention_days: 7
```

For each entry, files older than `retention_days` will be deleted, leaving recent logs intact.

## Usage
Add this role to your playbook:

```yaml
- hosts: all
  become: true
  roles:
    - linux-patching-verify-space
```

## Requirements
- Ansible 2.9+
- Target hosts must use DNF/YUM (RHEL, CentOS, Fedora, etc.)
- VM snapshot recommended for aggressive cleanup

## License
MIT
