# Exercise 2
File contents:

# File `whitelist.j2`

This file is a template that generates lines for each authorized user, in the format required by `access.conf`.

Content:
```
# AUTOMATIC WHITELIST

{% for utente in utenti_autorizzati %}
+ : {{ utente }} : ALL
{% endfor %}
```
Example output if the variable `utenti_autorizzati` contains ["livio", "ludo"]:
```
# AUTOMATIC WHITELIST

+ : livio : ALL
+ : ludo : ALL
```

# File `playbook.yml`
Content:

```yml
- name: Insert user whitelist into /etc/security/access.conf
  hosts: localhost
  become: true
  connection: local
  vars_files:
    - vars.yml
```
This code segment sets up the execution environment for a playbook that inserts a user whitelist into /etc/security/access.conf, executing locally with administrative privileges and loading variables from vars.yml.

```yml
  tasks:
    - name: Generate whitelist file from template
      template:
        src: templates/whitelist.j2
        dest: /tmp/access_whitelist.txt
```
Generates a temporary file /tmp/access_whitelist.txt from the Jinja2 template whitelist.j2, replacing the defined variables.

```yml
    - name: Insert the whitelist before the total block
      blockinfile:
        path: /etc/security/access.conf
        marker: "# {{mark}} ANSIBLE WHITELIST"
        insertbefore: '^\- : ALL : ALL'
        block: "{{ lookup('file', '/tmp/access_whitelist.txt') }}"
```
Inserts the whitelist content into the /etc/security/access.conf file before the line that blocks all access (- : ALL : ALL), wrapping it in identifiable markers.

# File `vars.yml` (Variables)

Contains the list of authorized users to be inserted into the whitelist.

Content:
```
utenti_autorizzati:
  - livio
  - ludo
  - alessandro
  - giulia
  - andrea
```
So it's an array.
