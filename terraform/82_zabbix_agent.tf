# 82_zabbix_agent.tf

resource "local_file" "zabbix_agent_playbook" {
  content = <<-YAML
  ---
  - name: zabbix_agent
    hosts: all
    become: yes
    gather_facts: yes

    vars:
      zabbix_server_host: "${yandex_compute_instance.web_zabbix.network_interface[0].ip_address}"

    tasks:
      - name: Configure Zabbix agent
        ansible.builtin.shell:
          cmd: |
            sed -i \
              -e 's/^Server=.*/Server={{ zabbix_server_host }}/' \
              -e 's/^ServerActive=.*/ServerActive={{ zabbix_server_host }}/' \
              -e 's/^Hostname=.*/Hostname={{ ansible_hostname }}/' \
              /etc/zabbix/zabbix_agentd.conf
        notify: restart zabbix-agent

      - name: Start and enable zabbix-agent
        ansible.builtin.systemd:
          name: zabbix-agent
          state: started
          enabled: yes
          daemon_reload: yes

    handlers:
      - name: restart zabbix-agent
        ansible.builtin.systemd:
          name: zabbix-agent
          state: restarted
          daemon_reload: yes
  YAML

  filename = "../ansible/playbook/zabbix_agent_playbook.yml"
}
