resource "local_file" "filebeat_for_nginx_playbook" {
  content = <<-YAML
  ---
  - name: filebeat_for_nginx
    hosts: nginx
    become: yes
    gather_facts: yes

    vars:
      elasticsearch_host: "http://${yandex_compute_instance.web_elasticsearch.network_interface[0].nat_ip_address}:9200"
      kibana_host: "http://${yandex_compute_instance.web_kibana.network_interface[0].nat_ip_address}:5601"
      filebeat_image: docker.elastic.co/beats/filebeat:8.19.11

    tasks:
      - name: Create filebeat directory
        file:
          path: "/filebeat"
          state: directory
          mode: "0755"

      - name: Create filebeat data directory
        file:
          path: "/var/lib/filebeat"
          state: directory
          mode: "0755"

      - name: Create filebeat config
        copy:
          dest: "/filebeat/filebeat.yml"
          mode: "0644"
          content: |
            filebeat.inputs:
              - type: log
                enabled: true
                paths:
                  - /var/log/nginx/access.log
                fields:
                  index_name: "nginx-access"
                fields_under_root: true
                
              - type: log
                enabled: true
                paths:
                  - /var/log/nginx/error.log
                fields:
                  index_name: "nginx-error"
                fields_under_root: true

            setup.template:
              name: "nginx"
              pattern: "filebeat-nginx-*"

            setup.ilm:
              enabled: false

            output.elasticsearch:
              hosts: ["{{ elasticsearch_host }}"]
              indices:
                - index: "filebeat-nginx-access-%%{+yyyy.MM.dd}"
                  when.equals:
                    index_name: "nginx-access"
                - index: "filebeat-nginx-error-%%{+yyyy.MM.dd}"
                  when.equals:
                    index_name: "nginx-error"
              
            logging.level: info
            logging.to_files: true
            logging.files:
              path: /var/log/filebeat
              name: filebeat
              keepfiles: 7
              permissions: 0644

      - name: Pull Filebeat image
        docker_image:
          name: "{{ filebeat_image }}"
          source: pull

      - name: Stop old filebeat container if exists
        docker_container:
          name: filebeat
          state: absent
          force_kill: yes

      - name: Run Filebeat container
        docker_container:
          name: filebeat
          image: "{{ filebeat_image }}"
          user: root
          restart_policy: unless-stopped
          network_mode: host
          command: >
            filebeat -e --strict.perms=false
          volumes:
            - "/filebeat/filebeat.yml:/usr/share/filebeat/filebeat.yml:ro"
            - "/var/log/nginx:/var/log/nginx:ro"
            - "/var/lib/filebeat:/usr/share/filebeat/data"
          state: started
  YAML

  filename = "../ansible/playbook/filebeat_for_nginx_docker.yml"
}