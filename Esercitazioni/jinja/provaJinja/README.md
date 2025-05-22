# Jinja Exercise 1

In this exercise, I created an Ansible playbook that adds specific settings for the user in the `/etc/security/limits.conf` file.

## File `limits.j2`

Code explanation:

```jinja
{% if ambiente == 'produzione' %}
{{ utente }} soft nofile 10000
{{ utente }} hard nofile 10000
```

In this initial part, it specifies that if the variable `ambiente` is equal to the string "produzione", the user specified in the vars.yml file should have the limits set to a certain value.

```jinja
{% elif ambiente == 'collaudo' or ambiente == 'sviluppo' %}
{{ utente }} soft nofile 1000
{{ utente }} hard nofile 1000
```

If the variable has the value "collaudo" or "sviluppo", other limits are set.

## File `vars.yml`

```yaml
utente: livio
ambiente: collaudo
```

This file specifies the values of the variables that will be used later.

## File `playbook.yml`

```yaml
- name: Configure limits for user in /etc/security/limits.conf
  hosts: localhost
  become: true
  connection: local
  vars_files:
    - vars.yml
```

This code segment configures system limits for a user in the /etc/security/limits.conf file. The playbook runs on the local machine (hosts: localhost) with administrative privileges (become: true) and without SSH connection (connection: local). The variables used in the playbook are loaded from the vars.yml file.

```yaml
tasks:
    - name: Generate temporary file from template
      template:
        src: templates/limits.j2
        dest: /tmp/limits_{{ utente }}.txt
```

This Ansible task generates a temporary file from a Jinja2 template called limits.j2, replacing the defined variables. The resulting file is saved in /tmp/limits_{{ utente }}.txt, where {{ utente }} is a variable representing the user's name.

```yaml
- name: Insert limits into the /etc/security/limits.conf file
      blockinfile:
        path: /etc/security/limits.conf
        marker: "# {mark} ANSIBLE LIMITS {{ utente }}"
        block: "{{ lookup('file', '/tmp/limits_' + utente + '.txt') }}"
```

This task inserts into the /etc/security/limits.conf file a block of text previously generated, using the blockinfile module. The content is read from the temporary file /tmp/limits_{{ utente }}.txt, and is enclosed between custom markers that include the user's name for easier identification.
