# Ansible LAMP – Praca Domowa

Ten projekt zawiera rozwiązanie pracy domowej z lekcji nr 18 dotyczącej Ansible oraz konfiguracji środowiska LAMP.

## Struktura projektu
- `ansible.cfg` – konfiguracja Ansible  
- `inventory.ini` – lista hostów  
- `playbooks/` – główne playbooki  
- `roles/` – role: base, web, php, database, app  
- `group_vars/` – zmienne środowiskowe (dev/staging/prod)  

## Uruchomienie
```
ansible-playbook playbooks/site.yml -l dev
```

## Autor
Sebastian Gęza
## Schemat
```
ansible-lamp/ 
├── ansible.cfg 
├── inventory.ini 
├── playbooks/
│ ├── site.yml
│ └── deploy_app.yml 
├── roles/ 
│ ├── base/ 
│ │ ├── tasks/main.yml 
│ │ ├── defaults/main.yml 
│ │ └── handlers/main.yml 
│ ├── web/ 
│ │ ├── tasks/main.yml 
│ │ ├── defaults/main.yml 
│ │ ├── handlers/main.yml 
│ │ └── templates/vhost.conf.j2 
│ ├── database/ 
│ │ ├── tasks/main.yml 
│ │ ├── defaults/main.yml 
│ │ └── templates/my.cnf.j2 
│ ├── php/ 
│ │ ├── tasks/main.yml 
│ │ └── defaults/main.yml 
│ └── app/ 
│ ├── tasks/main.yml 
│ ├── defaults/main.yml 
│ └── templates/index.php.j2 
├── group_vars/ 
│ ├── dev.yml 
│ ├── staging.yml 
│ └── prod.yml 
├── host_vars/ 
├── tests/ 
│ └── assert_checks.yml 
└── README.md
```
