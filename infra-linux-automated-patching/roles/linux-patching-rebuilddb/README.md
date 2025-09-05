# linux-patching-rebuilddb

Ansible role to check and automatically fix RPM database issues on Linux systems (RHEL, CentOS, Fedora, etc.).

## Features
- Checks RPM database health using `rpm --verifydb`.
- Detects lock/corruption files.
- Removes lock/corrupt files if found.
- Rebuilds RPM database automatically.
- Reports status and actions taken.

## Usage
Add this role to your playbook:

```yaml
- hosts: all
  become: true
  roles:
    - linux-patching-rebuilddb
```

## Variables
No variables required by default.

## Requirements
- Ansible 2.9+
- Target hosts must use RPM (RHEL, CentOS, Fedora, etc.)

## License
MIT
