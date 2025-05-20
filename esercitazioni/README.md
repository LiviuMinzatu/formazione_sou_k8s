# Ansible Exercise: Package Management from Dictionary

This Ansible playbook installs or removes packages on the local machine based on a dictionary defined in the `vars` section.

Each entry in the `packages` dictionary includes:
- The key: the package name
- The value: the desired state (`present` to install, `absent` to remove)

The playbook uses the `ansible.builtin.package` module to manage packages in an OS-independent way.

Example: with the current settings, it will install `vim` and `git`, and remove `nano`.

# Ansible Exercise: User Creation from a List of Dictionaries

This Ansible playbook creates users and their associated groups on the local machine, based on a list of dictionaries defined in the `users` variable.

Each dictionary represents a user and specifies:
- `name`: username
- `group`: user's group
- `home`: home directory
- `shell`: default shell

The playbook performs two main operations:
1. Creates the specified groups if they do not exist (`ansible.builtin.group`).
2. Creates users with the specified properties (`ansible.builtin.user`), ensuring that the home directory is created.

Example: creates users `alice` (group `dev`, shell `/bin/bash`) and `matteo` (group `ops`, shell `/bin/zsh`).