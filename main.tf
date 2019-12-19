terraform {
    required_providers {
        // https://github.com/rancher/terraform-provider-rke/releases/tag/0.14.1
        rke = "= 0.14.1"
    }
}

variable "nodes" {
    type = map(map(any))
    description = "cluster nodes info"
}

variable "pre-install" {
    type = list
    description = "pre install system package or shell operations for nodes"
}

variable "kube-conf" {
    type = map
    description = "kubernetes config output config"
}


# docker installation
resource "null_resource" "nodes" {
    for_each = var.nodes

    // mapper for connections
    connection {
        type = each.value.type
        host = each.value.host
        port = each.value.port
        user = each.value.user
        private_key = file(each.value.private_key)
    }

    // install docker 
    provisioner "remote-exec" {
        inline = var.pre-install
    }
}

# kubernetes cluster installation
resource "rke_cluster" "kubernetes-cluster" {
    dynamic nodes {
        for_each = var.nodes
        content {
            address = nodes.value.host
            user = nodes.value.user
            role = split(",", nodes.value.role)
            ssh_key = file(nodes.value.private_key)
        }
    }
}

# kubernetes cluster config output
resource "local_file" "kube-conf" {
    filename = format("%s/%s", var.kube-conf.filepath, var.kube-conf.filename)
    content = rke_cluster.kubernetes-cluster.kube_config_yaml
}


/**
1. 配置远程集群 ssh 连接信息
2. 配置 repo 信息, 安装 docker
3. 下载安装 rke
4. 调用 rke provider 安装 kubernetes 集群
5. 安装平台项目及相关组件
**/