variable "nodes" {
    type = map(map(string))
}

resource "null_resource" "cluster" {
    for_each = var.nodes

    connection {
        type = each.value.type
        host = each.value.host
        port = each.value.port
        user = each.value.user
        private_key = file(each.value.private_key)
    }

    provisioner "remote-exec" {
        inline = [
            "hostname",
        ]
    }
}

/**
1. 配置远程集群 ssh 连接信息
2. 配置 repo 信息, 安装 docker
3. 下载安装 rke
4. 调用 rke provider 安装 kubernetes 集群
5. 安装平台项目及相关组件
**/