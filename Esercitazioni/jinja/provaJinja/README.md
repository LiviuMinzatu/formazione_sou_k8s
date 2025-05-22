# Ansible Playbook: Configure User Limits

This Ansible playbook is designed to configure file descriptor limits (`nofile`) for a specified user in the `/etc/security/limits.conf` file, based on the deployment environment (e.g., production, staging, development).

## Features

- Dynamically sets user-specific limits for open files.
- Uses a Jinja2 template to define environment-based configurations.
- Inserts the configuration into `/etc/security/limits.conf` using Ansible's `blockinfile` module.

## Template: `limits.j2`

This file dynamically sets limits based on the environment:

```jinja
# Limits for user {{ utente }}

{% if ambiente == 'produzione' %}
{{ utente }} soft nofile 10000
{{ utente }} hard nofile 10000
{% elif ambiente == 'collaudo' or ambiente == 'sviluppo' %}
{{ utente }} soft nofile 1000
{{ utente }} hard nofile 1000
{% else %}
# Unknown environment: {{ ambiente }}
{% endif %}
```

## Variables (`vars.yml`)

Example content:

```yaml
utente: livio
ambiente: collaudo
```

## Usage

1. Ensure you have Ansible installed and set up.
2. Modify `vars.yml` with the desired user and environment.
3. Run the playbook:

```bash
ansible-playbook playbook.yml
```

This will:
- Render a temporary file from the template (`/tmp/limits_<user>.txt`).
- Insert the rendered limits block into `/etc/security/limits.conf`.

## Notes

- This playbook should be executed with root privileges (`become: true` is required).
- Only local execution is supported (`connection: local`).

## License

This script is intended for educational and internal system configuration purposes.