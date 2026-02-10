resource "local_file" "elasticsearch_docker_playbook" {
  content = <<-YAML
  ---
  - name: elasticsearch_docker
    hosts: elasticsearch
    become: yes
    gather_facts: yes

    vars:
      elasticsearch_dir: /elasticsearch
      elasticsearch_image: docker.elastic.co/elasticsearch/elasticsearch:8.19.11

    tasks:
      - name: Create Elasticsearch data directory
        file:
          path: "{{ elasticsearch_dir }}/data"
          state: directory
          owner: 1000
          group: 1000
          mode: "0770"

      - name: Create Elasticsearch logs directory
        file:
          path: "{{ elasticsearch_dir }}/logs"
          state: directory
          owner: 1000
          group: 1000
          mode: "0770"

      - name: Pull Elasticsearch image
        docker_image:
          name: "{{ elasticsearch_image }}"
          source: pull

      - name: Stop old Elasticsearch container if exists
        docker_container:
          name: elasticsearch-server
          state: absent
          force_kill: yes

      - name: Run Elasticsearch container
        docker_container:
          name: elasticsearch-server
          image: "{{ elasticsearch_image }}"
          restart_policy: unless-stopped
          published_ports:
            - "9200:9200"
          env:
            discovery.type: single-node
            cluster.name: alexey-zayac
            network.host: 0.0.0.0
            xpack.security.enabled: "false"
          volumes:
            - "{{ elasticsearch_dir }}/data:/usr/share/elasticsearch/data"
            - "{{ elasticsearch_dir }}/logs:/usr/share/elasticsearch/logs"
          state: started
  YAML

  filename = "../ansible/playbook/elasticsearch_docker.yml"
}
