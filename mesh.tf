locals {
  has_mesh     = data.ns_connection.mesh.workspace_id != ""
  mesh_name    = local.has_mesh ? data.ns_connection.mesh.outputs.appmesh_name : ""
  virtual_name = "${data.ns_workspace.this.block}.local"
}

resource "aws_appmesh_virtual_service" "service" {
  name      = local.virtual_name
  mesh_name = local.mesh_name

  spec {
    provider {
      virtual_node {
        virtual_node_name = aws_appmesh_virtual_node.service[count.index].name
      }
    }
  }

  count = local.has_mesh ? 1 : 0
}

resource "aws_appmesh_virtual_node" "service" {
  mesh_name = local.mesh_name
  name      = data.ns_workspace.this.block
  tags      = data.ns_workspace.this.tags

  spec {
    backend {
      virtual_service {
        virtual_service_name = local.virtual_name
      }
    }

    listener {
      port_mapping {
        port     = 80
        protocol = "http"
      }
    }

    service_discovery {
      aws_cloud_map {
        namespace_name = data.ns_connection.network.outputs.service_discovery_id
        service_name   = aws_service_discovery_service.this.name
      }
    }
  }

  count = local.has_mesh ? 1 : 0
}

locals {
  mesh_env_vars = concat(local.has_mesh ? [{
    name  = "APPMESH_VIRTUAL_NODE_NAME"
    value = "mesh/${local.mesh_name}/virtualNode/${data.ns_workspace.this.block}"
    }] : [],
    var.enable_xray ? [{
      name  = "AWS_XRAY_DAEMON_ADDRESS"
      value = "xray-daemon:2000"
    }] : []
  )

  mesh_container_definition = {
    name              = "envoy"
    image             = local.envoy_image
    essential         = true
    memoryReservation = 256
    user              = "1337"
    environment       = local.mesh_env_vars

    portMappings = [
      {
        protocol      = "tcp"
        containerPort = 9901
        hostPort      = 9901
      }
    ]

    healthCheck = {
      command = [
        "CMD-SHELL",
        "curl -s http://localhost:9901/server_info | grep state | grep -q LIVE"
      ]
      startPeriod = 10
      interval    = 5
      timeout     = 2
      retries     = 3
    }

    ulimts = [
      {
        softLimit = 15000
        hardLimit = 15000
        name      = "nofile"
      }
    ]
  }
}
