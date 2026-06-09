# Kubernetes Notes — Overview & Deployment Evolution

## 1. Kubernetes là gì?

Kubernetes, viết tắt là **K8s**, là một nền tảng **open source** dùng để quản lý **containerized workloads** và **services**.

Kubernetes hỗ trợ:

* Declarative configuration
* Automation
* Scaling
* Failover
* Deployment patterns
* Service discovery
* Load balancing
* Secret/config management

Nói dễ hiểu:

```txt
Kubernetes là hệ thống giúp triển khai, quản lý, scale và tự phục hồi các ứng dụng chạy bằng container.
```

Câu trả lời ngắn cho mentor:

```txt
Kubernetes là nền tảng open source dùng để quản lý containerized applications. Nó giúp chạy ứng dụng theo desired state, tự phục hồi khi lỗi, scale workload, expose service, rollout/rollback version mới và quản lý config/secret.
```

---

## 2. Vì sao cần Kubernetes?

Container giúp đóng gói và chạy ứng dụng tốt hơn. Nhưng trong production, chỉ chạy container thôi là chưa đủ.

Ta cần quản lý nhiều vấn đề:

* Nếu container chết thì phải tự chạy container mới
* Nếu traffic tăng thì phải scale thêm instance
* Nếu deploy version mới thì phải rollout an toàn
* Nếu version mới lỗi thì cần rollback
* Nếu có nhiều node thì cần phân phối workload hợp lý
* Nếu app cần config/secret thì cần quản lý tập trung
* Nếu nhiều container chạy cùng lúc thì cần service discovery và load balancing

Kubernetes giải quyết các vấn đề đó bằng cách cung cấp một framework để chạy distributed systems một cách resilient.

Câu nhớ:

```txt
Docker giúp đóng gói và chạy container.
Kubernetes giúp quản lý nhiều container trong production.
```

---

## 3. Kubernetes cung cấp những gì?

### 3.1. Service discovery và load balancing

Kubernetes có thể expose container bằng DNS name hoặc IP address.

Nếu traffic cao, Kubernetes có thể load balance traffic đến nhiều container để hệ thống ổn định.

Ví dụ:

```txt
User gửi request
→ Service
→ phân phối traffic đến nhiều Pod phía sau
```

Câu nhớ:

```txt
Service discovery giúp tìm service ổn định.
Load balancing giúp phân phối traffic đến nhiều container/Pod.
```

---

### 3.2. Storage orchestration

Kubernetes có thể tự động mount storage cho container.

Storage có thể đến từ:

* Local storage
* Public cloud provider
* Network storage
* Storage system khác

Câu nhớ:

```txt
Storage orchestration giúp container dùng storage mà không cần phụ thuộc chặt vào node cụ thể.
```

---

### 3.3. Automated rollouts và rollbacks

Kubernetes cho phép bạn mô tả desired state của ứng dụng.

Ví dụ:

```txt
Tôi muốn app chạy version v2 với 3 replicas.
```

Kubernetes sẽ thay đổi actual state về desired state một cách có kiểm soát.

Nếu version mới lỗi, Kubernetes có thể rollback về version cũ.

Câu nhớ:

```txt
Rollout là triển khai version mới.
Rollback là quay lại version cũ khi có lỗi.
```

---

### 3.4. Automatic bin packing

Bạn cung cấp cho Kubernetes một cluster gồm nhiều node.

Sau đó bạn khai báo mỗi container cần bao nhiêu CPU/RAM.

Kubernetes sẽ tự chọn node phù hợp để chạy workload, nhằm tận dụng tài nguyên hiệu quả.

Câu nhớ:

```txt
Bin packing là Kubernetes xếp Pod vào node phù hợp dựa trên tài nguyên CPU/RAM.
```

---

### 3.5. Self-healing

Kubernetes có thể tự phục hồi khi workload lỗi.

Kubernetes có thể:

* Restart container bị lỗi
* Replace container chết
* Kill container không phản hồi health check
* Không gửi traffic đến container chưa ready

Ví dụ:

```txt
Desired state = 3 replicas
Actual state = 2 replicas vì 1 Pod chết
Kubernetes tạo Pod mới để quay lại 3 replicas
```

Câu nhớ:

```txt
Self-healing là khả năng tự phát hiện lỗi và đưa hệ thống về trạng thái mong muốn.
```

---

### 3.6. Secret và configuration management

Kubernetes cho phép quản lý config và secret tách khỏi container image.

Secret có thể là:

* Password
* OAuth token
* SSH key
* API key

Config có thể là:

* Environment name
* Log level
* App setting
* Feature flag

Điểm quan trọng:

```txt
Có thể update config/secret mà không cần rebuild container image.
```

Câu nhớ:

```txt
ConfigMap dùng cho config thường.
Secret dùng cho dữ liệu nhạy cảm.
```

---

### 3.7. Batch execution

Ngoài các service chạy lâu dài, Kubernetes cũng có thể quản lý batch jobs hoặc CI workloads.

Ví dụ:

* Job xử lý dữ liệu
* CronJob chạy định kỳ
* Task chạy xong rồi kết thúc

---

### 3.8. Horizontal scaling

Kubernetes có thể scale ứng dụng lên hoặc xuống.

Có thể scale bằng:

* Command
* UI
* Tự động dựa trên CPU usage hoặc metric khác

Ví dụ:

```txt
replicas: 3 → replicas: 5
```

Câu nhớ:

```txt
Horizontal scaling là tăng hoặc giảm số lượng instance/replica của ứng dụng.
```

---

## 4. Kubernetes không phải là gì?

Kubernetes không phải là một PaaS all-in-one.

Kubernetes không làm thay tất cả mọi thứ cho bạn.

Kubernetes không:

* Build source code
* Quyết định CI/CD workflow
* Cung cấp sẵn database/cache/message bus như built-in service
* Bắt buộc dùng một logging/monitoring/alerting solution cụ thể
* Bắt buộc một configuration language duy nhất
* Quản lý toàn bộ machine configuration như một hệ thống all-in-one

Kubernetes cung cấp các building blocks để xây platform.

Câu nhớ:

```txt
Kubernetes không phải PaaS hoàn chỉnh.
Kubernetes là nền tảng cung cấp building blocks để chạy và quản lý containerized applications.
```

---

## 5. Kubernetes không chỉ là orchestration truyền thống

Orchestration theo nghĩa truyền thống thường là chạy workflow theo thứ tự:

```txt
Bước 1 làm A
Bước 2 làm B
Bước 3 làm C
```

Kubernetes không hoạt động chủ yếu theo kiểu đó.

Kubernetes hoạt động theo cơ chế control loop:

```txt
Người dùng khai báo desired state
Kubernetes quan sát actual state
Nếu actual state lệch desired state
Kubernetes điều chỉnh hệ thống về desired state
```

Ví dụ:

```txt
Desired state: Deployment có 3 replicas
Actual state: chỉ còn 2 replicas
Kubernetes tạo thêm 1 Pod mới
```

Câu nhớ quan trọng:

```txt
Kubernetes continuously drives actual state toward desired state.
```

---

# Deployment Evolution

## 6. Traditional Deployment Era

Ở giai đoạn đầu, các tổ chức chạy ứng dụng trực tiếp trên physical servers.

Vấn đề chính:

```txt
Không có resource boundary rõ ràng giữa các ứng dụng.
```

Nếu nhiều app chạy chung một server, một app có thể dùng quá nhiều CPU/RAM, làm app khác bị chậm hoặc lỗi.

Một cách xử lý là chạy mỗi app trên một physical server riêng.

Nhưng cách này có vấn đề:

* Không scale tốt
* Lãng phí tài nguyên
* Tốn chi phí phần cứng
* Khó quản lý nhiều server

Câu nhớ:

```txt
Traditional deployment bị hạn chế vì resource isolation kém và chi phí physical server cao.
```

---

## 7. Virtualized Deployment Era

Virtualization cho phép chạy nhiều Virtual Machines trên cùng một physical server.

Mỗi VM có:

* Operating system riêng
* App riêng
* Libraries/dependencies riêng
* Resource được ảo hóa

Lợi ích:

* Cô lập app tốt hơn
* Tận dụng tài nguyên server tốt hơn
* Dễ scale hơn physical server
* Giảm chi phí phần cứng
* Tăng mức độ bảo mật giữa các app

Nhược điểm:

```txt
Mỗi VM là một full machine có OS riêng nên vẫn khá nặng.
```

Câu nhớ:

```txt
Virtualization cải thiện isolation và resource utilization, nhưng VM vẫn nặng vì mỗi VM có một operating system riêng.
```

---

## 8. Container Deployment Era

Container tương tự VM ở chỗ có sự cô lập, nhưng nhẹ hơn vì container chia sẻ OS/kernel với host.

Container có:

* Filesystem riêng
* CPU/memory share riêng
* Process space riêng
* Network riêng

Container được tách khỏi infrastructure bên dưới, nên portable giữa nhiều môi trường.

Lợi ích của container:

* Tạo và deploy app nhanh hơn
* CI/CD hiệu quả hơn
* Rollback nhanh do image immutable
* Tách biệt Dev và Ops rõ hơn
* Môi trường dev/test/prod nhất quán
* Portable giữa cloud và OS distributions
* Quản lý theo hướng application-centric
* Phù hợp microservices
* Resource isolation tốt hơn
* Resource utilization hiệu quả hơn

Câu nhớ:

```txt
Container nhẹ hơn VM, portable hơn, phù hợp CI/CD và microservices.
```

---

## 9. Vì sao container phù hợp với Kubernetes?

Container giúp đóng gói app tốt, nhưng production cần hệ thống quản lý container.

Kubernetes tận dụng container để:

* Chạy nhiều replicas
* Scale workload
* Restart workload lỗi
* Expose service ổn định
* Rollout/rollback version mới
* Quản lý config/secret
* Phân phối workload trên nhiều node

Câu nhớ:

```txt
Container là đơn vị đóng gói ứng dụng.
Kubernetes là hệ thống quản lý container ở quy mô production.
```

---

# 10. Câu hỏi ôn tập

1. Kubernetes là gì?
2. K8s là viết tắt của gì?
3. Vì sao cần Kubernetes nếu đã có container?
4. Kubernetes giúp gì trong production?
5. Service discovery là gì?
6. Load balancing trong Kubernetes dùng để làm gì?
7. Storage orchestration là gì?
8. Automated rollout là gì?
9. Rollback là gì?
10. Automatic bin packing là gì?
11. Self-healing trong Kubernetes nghĩa là gì?
12. Secret và configuration management dùng để làm gì?
13. Horizontal scaling là gì?
14. Kubernetes có phải PaaS all-in-one không?
15. Kubernetes có build source code không?
16. Kubernetes có cung cấp sẵn database/cache/message bus không?
17. Desired state là gì?
18. Actual state là gì?
19. Kubernetes control loop hoạt động như thế nào?
20. Traditional deployment gặp vấn đề gì?
21. Virtualized deployment giải quyết vấn đề gì?
22. VM khác container như thế nào?
23. Vì sao container nhẹ hơn VM?
24. Vì sao container phù hợp CI/CD?
25. Vì sao Kubernetes phù hợp với microservices?

---

# 11. Câu trả lời ngắn 

## Kubernetes là gì?

Kubernetes là nền tảng open source dùng để quản lý containerized workloads và services. Nó hỗ trợ declarative configuration và automation, giúp triển khai, scale, self-heal, expose service và quản lý config/secret cho ứng dụng container.

## Vì sao cần Kubernetes?

Container giúp đóng gói và chạy app, nhưng production cần quản lý nhiều container, đảm bảo downtime thấp, scale, failover, rollout/rollback và service discovery. Kubernetes cung cấp framework để quản lý các việc đó một cách tự động và resilient.

## Traditional deployment có vấn đề gì?

Traditional deployment chạy app trực tiếp trên physical server, không có resource boundary rõ ràng. Một app có thể dùng quá nhiều tài nguyên làm app khác bị ảnh hưởng. Chạy mỗi app trên một server riêng thì tốn kém và lãng phí tài nguyên.

## Virtualization giải quyết gì?

Virtualization cho phép chạy nhiều VM trên một physical server, giúp cô lập app tốt hơn, tận dụng tài nguyên tốt hơn và giảm chi phí phần cứng. Tuy nhiên mỗi VM vẫn có full OS riêng nên nặng hơn container.

## Container deployment có lợi gì?

Container nhẹ hơn VM vì chia sẻ OS/kernel, portable giữa môi trường, tạo image nhanh, hỗ trợ CI/CD, rollback nhanh, resource isolation tốt và phù hợp microservices.

## Desired state là gì?

Desired state là trạng thái mong muốn mà người dùng khai báo cho hệ thống. Kubernetes liên tục quan sát actual state và điều chỉnh để actual state tiến về desired state.

## Self-healing là gì?

Self-healing là khả năng Kubernetes tự restart container lỗi, replace container chết, kill container không phản hồi health check và không gửi traffic đến container chưa ready.

# Kubernetes Notes — Cluster Components

## 1. Kubernetes Cluster là gì?

Kubernetes cluster là một cụm máy dùng để chạy và quản lý containerized applications.

Một Kubernetes cluster thường gồm 2 phần chính:

```txt
Kubernetes Cluster
├── Control Plane
└── Worker Nodes
```

Trong đó:

* **Control Plane**: điều khiển và quản lý trạng thái toàn bộ cluster.
* **Worker Nodes**: nơi chạy workload thật, ví dụ Pod và container.

Câu nhớ:

```txt
Control Plane quản lý cluster.
Worker Node chạy ứng dụng thật.
```

---

## 2. Control Plane là gì?

Control Plane là phần “bộ não” của Kubernetes cluster.

Nó chịu trách nhiệm:

* Nhận yêu cầu từ người dùng hoặc công cụ như `kubectl`
* Lưu trạng thái cluster
* Quyết định Pod chạy ở node nào
* Theo dõi actual state và desired state
* Điều khiển cluster để actual state tiến về desired state

Các component chính của Control Plane gồm:

```txt
kube-apiserver
etcd
kube-scheduler
kube-controller-manager
cloud-controller-manager
```

Câu nhớ:

```txt
Control Plane quyết định cluster nên chạy như thế nào.
```

---

## 3. kube-apiserver

`kube-apiserver` là component trung tâm của Kubernetes Control Plane.

Nó expose Kubernetes HTTP API.

Mọi thao tác với Kubernetes gần như đều đi qua API Server.

Ví dụ khi chạy:

```bash
kubectl get pods
kubectl apply -f deployment.yaml
kubectl delete pod nginx
```

`kubectl` sẽ gửi request đến `kube-apiserver`.

API Server chịu trách nhiệm:

* Nhận request từ user, `kubectl`, controller hoặc component khác
* Validate request
* Giao tiếp với `etcd` để đọc/ghi state
* Là cổng giao tiếp chính của cluster

Câu nhớ:

```txt
kube-apiserver là cửa ngõ trung tâm để giao tiếp với Kubernetes cluster.
```

Câu trả lời mentor:

```txt
kube-apiserver là thành phần expose Kubernetes API. Mọi thao tác như kubectl apply, get, delete đều đi qua API Server. Nó là trung tâm giao tiếp giữa user, control plane components và cluster state.
```

---

## 4. etcd

`etcd` là key-value store nhất quán và highly available của Kubernetes.

Nó lưu toàn bộ dữ liệu quan trọng của cluster.

Ví dụ:

* Nodes
* Pods
* Services
* ConfigMaps
* Secrets
* Deployments
* Desired state
* Cluster metadata

Có thể hiểu:

```txt
etcd = database của Kubernetes cluster
```

Nếu `etcd` mất dữ liệu, cluster có thể mất trạng thái.

Câu nhớ:

```txt
etcd lưu state của Kubernetes cluster.
```

Câu trả lời mentor:

```txt
etcd là key-value store dùng để lưu toàn bộ state của Kubernetes cluster. API Server đọc và ghi dữ liệu cluster vào etcd.
```

---

## 5. kube-scheduler

`kube-scheduler` chịu trách nhiệm chọn node phù hợp để chạy Pod.

Khi một Pod mới được tạo nhưng chưa được gán node, scheduler sẽ quyết định Pod đó nên chạy ở node nào.

Scheduler có thể dựa vào:

* CPU/RAM còn trống trên node
* Resource requests của Pod
* Node labels
* Taints/Tolerations
* Affinity/Anti-affinity
* Constraints khác

Ví dụ:

```txt
Có Pod mới cần 500m CPU và 256Mi RAM.
Scheduler tìm node còn đủ tài nguyên.
Sau đó gán Pod vào node phù hợp.
```

Câu nhớ:

```txt
kube-scheduler chọn node cho Pod.
```

Câu trả lời mentor:

```txt
kube-scheduler tìm các Pod chưa được gán node và chọn node phù hợp để chạy Pod dựa trên tài nguyên, policy và constraints.
```

---

## 6. kube-controller-manager

`kube-controller-manager` chạy các controllers để duy trì desired state của Kubernetes.

Controller là vòng lặp điều khiển liên tục kiểm tra:

```txt
Desired state là gì?
Actual state hiện tại là gì?
Nếu lệch thì cần sửa gì?
```

Ví dụ:

Bạn khai báo Deployment cần 3 replicas.

Nếu actual state chỉ còn 2 Pod, controller sẽ tạo thêm 1 Pod để quay lại desired state.

Một số controller thường gặp:

* Node controller
* ReplicaSet controller
* Deployment controller
* Job controller
* EndpointSlice controller
* ServiceAccount controller

Câu nhớ:

```txt
kube-controller-manager chạy các controller để đưa actual state về desired state.
```

Câu trả lời mentor:

```txt
kube-controller-manager chạy các control loops trong Kubernetes. Nó liên tục quan sát trạng thái thực tế và điều chỉnh cluster để đạt desired state đã khai báo.
```

---

## 7. cloud-controller-manager

`cloud-controller-manager` là component tùy chọn, dùng để tích hợp Kubernetes với cloud provider.

Ví dụ cloud provider:

* AWS
* Azure
* Google Cloud
* OpenStack

Nó giúp Kubernetes làm việc với tài nguyên cloud như:

* Load Balancer
* Node metadata
* Cloud routes
* Persistent disk/volume
* Public IP

Ví dụ:

Khi bạn tạo Service type `LoadBalancer` trên cloud, cloud-controller-manager có thể gọi cloud provider API để tạo Load Balancer thật.

Câu nhớ:

```txt
cloud-controller-manager kết nối Kubernetes với cloud provider.
```

Câu trả lời mentor:

```txt
cloud-controller-manager là component tích hợp Kubernetes với cloud provider, ví dụ tạo Load Balancer, quản lý node, route hoặc volume thông qua cloud API.
```

---

# Node Components

## 8. Worker Node là gì?

Worker Node là máy trong cluster dùng để chạy workload thật.

Workload thường là:

* Pod
* Container
* Application service
* Batch job

Mỗi Worker Node thường có các thành phần:

```txt
kubelet
kube-proxy
container runtime
```

Câu nhớ:

```txt
Worker Node là nơi chạy Pod và container.
```

---

## 9. kubelet

`kubelet` là agent chạy trên mỗi node.

Nó chịu trách nhiệm đảm bảo các Pod được giao cho node đó đang chạy đúng.

Kubelet làm việc với:

* API Server
* Container runtime
* Pod specs

Nhiệm vụ chính:

* Nhận PodSpec từ API Server
* Yêu cầu container runtime chạy container
* Theo dõi trạng thái Pod/container
* Báo status về API Server
* Restart container nếu cần theo policy

Câu nhớ:

```txt
kubelet đảm bảo Pod chạy trên node.
```

Câu trả lời mentor:

```txt
kubelet là agent chạy trên mỗi node. Nó nhận PodSpec từ API Server, gọi container runtime để chạy container, theo dõi trạng thái Pod và báo lại status cho control plane.
```

---

## 10. kube-proxy

`kube-proxy` là component mạng chạy trên mỗi node.

Nó duy trì network rules để Kubernetes Service hoạt động.

Khi user hoặc Pod gọi đến một Service, kube-proxy giúp traffic được chuyển đến các Pod backend phù hợp.

Nhiệm vụ:

* Duy trì rules cho Service
* Hỗ trợ load balancing traffic đến Pod
* Giúp Service có IP ổn định dù Pod thay đổi

Câu nhớ:

```txt
kube-proxy giúp Service routing hoạt động trên node.
```

Câu trả lời mentor:

```txt
kube-proxy duy trì network rules trên node để implement Kubernetes Services, giúp traffic đến Service được chuyển đến các Pod backend phù hợp.
```

---

## 11. Container Runtime

Container runtime là phần mềm chịu trách nhiệm chạy container thật sự trên node.

Ví dụ container runtime:

* containerd
* CRI-O
* Docker Engine trong các hệ thống cũ

Kubernetes không tự chạy container trực tiếp. Kubelet sẽ gọi container runtime để pull image và chạy container.

Câu nhớ:

```txt
Container runtime chạy container thật sự.
```

Câu trả lời mentor:

```txt
Container runtime là phần mềm chạy container trên node. Kubelet giao tiếp với container runtime để pull image, tạo container và quản lý lifecycle container.
```

---

# Addons

## 12. Addons là gì?

Addons là các thành phần mở rộng chức năng cho Kubernetes cluster.

Chúng không phải lúc nào cũng là core component, nhưng rất quan trọng trong thực tế.

Một số addons phổ biến:

```txt
DNS
Dashboard
Container Resource Monitoring
Cluster-level Logging
```

Câu nhớ:

```txt
Addons mở rộng chức năng cho Kubernetes cluster.
```

---

## 13. DNS Addon

DNS addon cung cấp DNS resolution trong cluster.

Nó giúp Pod gọi Service bằng tên thay vì phải nhớ IP.

Ví dụ:

```txt
backend.default.svc.cluster.local
```

hoặc đơn giản:

```txt
backend
```

Câu nhớ:

```txt
DNS giúp các service trong cluster tìm nhau bằng tên.
```

---

## 14. Web UI / Dashboard

Dashboard là giao diện web để quản lý Kubernetes cluster.

Nó có thể dùng để xem:

* Nodes
* Pods
* Deployments
* Services
* Logs
* Resource status

Câu nhớ:

```txt
Dashboard giúp quan sát và quản lý cluster qua giao diện web.
```

---

## 15. Container Resource Monitoring

Monitoring addon dùng để thu thập và lưu trữ metrics của container và cluster.

Ví dụ metrics:

* CPU usage
* Memory usage
* Pod status
* Node status
* Container metrics

Các tool thường gặp:

* Metrics Server
* Prometheus
* Grafana

Câu nhớ:

```txt
Monitoring giúp theo dõi tài nguyên và sức khỏe workload.
```

---

## 16. Cluster-level Logging

Cluster-level logging giúp thu thập log container và lưu vào nơi tập trung.

Vì Pod/container có thể bị xóa và tạo lại, nếu không gom log tập trung thì log dễ mất.

Các tool thường gặp:

* Fluent Bit
* Fluentd
* Elasticsearch
* Loki
* CloudWatch Logs

Câu nhớ:

```txt
Cluster-level logging giúp lưu log tập trung thay vì chỉ nằm trong từng Pod.
```

---

# 17. Tóm tắt kiến trúc Kubernetes

Một Kubernetes cluster gồm:

```txt
Control Plane:
- kube-apiserver
- etcd
- kube-scheduler
- kube-controller-manager
- cloud-controller-manager

Worker Node:
- kubelet
- kube-proxy
- container runtime

Addons:
- DNS
- Dashboard
- Monitoring
- Logging
```

Luồng đơn giản khi tạo Pod:

```txt
1. User chạy kubectl apply -f pod.yaml
2. kubectl gửi request đến kube-apiserver
3. kube-apiserver lưu desired state vào etcd
4. kube-scheduler chọn node phù hợp cho Pod
5. kubelet trên node nhận nhiệm vụ chạy Pod
6. kubelet gọi container runtime để pull image và chạy container
7. kube-proxy hỗ trợ networking nếu Pod được expose qua Service
8. Controller liên tục theo dõi để đảm bảo actual state khớp desired state
```

---

# 18. Câu hỏi ôn tập

1. Kubernetes cluster gồm những phần chính nào?
2. Control Plane dùng để làm gì?
3. Worker Node dùng để làm gì?
4. kube-apiserver là gì?
5. etcd dùng để làm gì?
6. kube-scheduler dùng để làm gì?
7. kube-controller-manager dùng để làm gì?
8. cloud-controller-manager dùng trong trường hợp nào?
9. kubelet là gì?
10. kube-proxy là gì?
11. Container runtime là gì?
12. Addons là gì?
13. DNS addon dùng để làm gì?
14. Monitoring addon dùng để làm gì?
15. Cluster-level logging dùng để làm gì?
16. Khi chạy `kubectl apply`, request đi qua những component nào?
17. Vì sao etcd quan trọng?
18. Vì sao kubelet cần container runtime?
19. kube-scheduler khác kubelet như thế nào?
20. kube-controller-manager liên quan gì đến desired state?

---

# 19. Câu trả lời 

## Kubernetes cluster gồm gì?

Kubernetes cluster gồm Control Plane và Worker Nodes. Control Plane quản lý trạng thái cluster, còn Worker Nodes là nơi chạy Pod và container thật.

## Control Plane là gì?

Control Plane là bộ não của Kubernetes cluster. Nó nhận request, lưu state, schedule Pod, chạy controller và điều chỉnh cluster về desired state.

## kube-apiserver là gì?

kube-apiserver là cổng giao tiếp trung tâm của Kubernetes. Mọi thao tác như `kubectl apply`, `get`, `delete` đều đi qua API Server.

## etcd là gì?

etcd là key-value store lưu toàn bộ state của Kubernetes cluster, ví dụ Pod, Service, Deployment, ConfigMap, Secret và metadata.

## kube-scheduler là gì?

kube-scheduler chọn node phù hợp cho các Pod chưa được gán node dựa trên tài nguyên và constraints.

## kube-controller-manager là gì?

kube-controller-manager chạy các controllers để liên tục đưa actual state của cluster về desired state.

## kubelet là gì?

kubelet là agent chạy trên mỗi node, nhận PodSpec từ API Server và gọi container runtime để chạy container.

## kube-proxy là gì?

kube-proxy duy trì network rules trên node để Kubernetes Service có thể chuyển traffic đến các Pod backend.

## Container runtime là gì?

Container runtime là phần mềm chịu trách nhiệm chạy container thật sự, ví dụ containerd hoặc CRI-O.

## Addons là gì?

Addons là các thành phần mở rộng chức năng cluster như DNS, Dashboard, Monitoring và Logging.
