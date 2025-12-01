# Ansible LAMP – Praca Domowa

Ten projekt zawiera kompletne rozwiązanie pracy domowej z lekcji dotyczącej Ansible oraz konfiguracji środowiska LAMP.

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
Automatycznie wygenerowane przez ChatGPT.
