resource "local_file" "kibana_docker_playbook" {
  content = <<-YAML
  ---
  - name: kibana_docker
    hosts: kibana
    become: yes
    gather_facts: yes

    vars:
      kibana_image: docker.elastic.co/kibana/kibana:8.19.11
      elasticsearch_host: "http://${yandex_compute_instance.web_elasticsearch.network_interface[0].nat_ip_address}:9200"

    tasks:
      - name: Pull Kibana image
        docker_image:
          name: "{{ kibana_image }}"
          source: pull

      - name: Stop old Kibana container if exists
        docker_container:
          name: kibana-server
          state: absent
          force_kill: yes

      - name: Run Kibana container
        docker_container:
          name: kibana-server
          image: "{{ kibana_image }}"
          restart_policy: unless-stopped
          published_ports:
            - "5601:5601"
          env:
            SERVER_HOST: "0.0.0.0"
            ELASTICSEARCH_HOSTS: "{{ elasticsearch_host }}"
          state: started
  YAML

  filename = "../ansible/playbook/kibana_docker.yml"
}
