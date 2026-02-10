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
      filebeat_dir: /filebeat
      filebeat_image: docker.elastic.co/beats/filebeat:8.19.11

    tasks:
      - name: Create filebeat directory
        file:
          path: "{{ filebeat_dir }}"
          state: directory
          mode: "0755"

      - name: Create filebeat config
        copy:
          dest: "{{ filebeat_dir }}/filebeat.yml"
          mode: "0644"
          content: |
            filebeat.inputs:
              - type: log
                enabled: true
                paths:
                  - /var/log/nginx/access.log
                  - /var/log/nginx/error.log
                fields:
                  service: nginx
                fields_under_root: true

            processors:
              - add_host_metadata: {}
              - add_cloud_metadata: {}
              - add_docker_metadata: {}

            output.elasticsearch:
              hosts: ["{{ elasticsearch_host }}"]
              index: "nginx-%%{+yyyy.MM.dd}"

            setup.kibana:
              host: ["{{ kibana_host }}"]

            setup.ilm.enabled: false
            setup.template.enabled: true
            setup.template.name: "nginx"
            setup.template.pattern: "nginx-*"
            setup.template.overwrite: true
            setup.template.settings:
              index:
                number_of_shards: 1
                number_of_replicas: 0

            logging.level: info

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
          command: >
            filebeat -e --strict.perms=false
          volumes:
            - "{{ filebeat_dir }}/filebeat.yml:/usr/share/filebeat/filebeat.yml:ro"
            - "/var/log/nginx:/var/log/nginx:ro"
            - "/var/lib/filebeat:/usr/share/filebeat/data"
          state: started
  YAML

  filename = "../ansible/playbook/filebeat_for_nginx_docker.yml"
}
