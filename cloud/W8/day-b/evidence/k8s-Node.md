# Kubernetes Notes — Nodes

## 1. Node là gì?

Node là một máy trong Kubernetes cluster dùng để chạy workload.

Node có thể là:

```txt
Virtual machine
Physical machine
```

Kubernetes không chạy container trực tiếp một cách rời rạc. Kubernetes chạy container bên trong Pod, sau đó đặt Pod lên Node.

Câu nhớ:

```txt
Node = máy chạy Pod trong Kubernetes cluster.
```

Ví dụ:

```txt
Cluster
├── Node 1
│   ├── Pod A
│   └── Pod B
├── Node 2
│   └── Pod C
└── Node 3
    └── Pod D
```

---

## 2. Node nằm ở đâu trong kiến trúc Kubernetes?

Một Kubernetes cluster thường gồm:

```txt
Control Plane
Worker Nodes
```

Trong đó:

```txt
Control Plane = quản lý cluster
Node = nơi chạy Pod và container thật
```

Control Plane quyết định Pod nên chạy ở Node nào. Node thực hiện việc chạy Pod đó.

---

## 3. Một Node có những component nào?

Trên mỗi Node thường có 3 thành phần chính:

```txt
kubelet
container runtime
kube-proxy
```

## 3.1. kubelet

`kubelet` là agent chạy trên mỗi Node.

Nhiệm vụ:

```txt
Nhận PodSpec từ API Server
Gọi container runtime để chạy container
Theo dõi trạng thái Pod/container
Báo status về control plane
Đảm bảo Pod được giao cho Node đang chạy đúng
```

Câu nhớ:

```txt
kubelet = agent đảm bảo Pod chạy trên Node.
```

---

## 3.2. Container Runtime

Container runtime là phần mềm chạy container thật sự.

Ví dụ:

```txt
containerd
CRI-O
Docker Engine trong hệ thống cũ
```

Kubernetes không tự chạy container trực tiếp. `kubelet` sẽ nói chuyện với container runtime để pull image, tạo container và quản lý vòng đời container.

Câu nhớ:

```txt
Container runtime = thành phần chạy container thật.
```

---

## 3.3. kube-proxy

`kube-proxy` là thành phần mạng trên Node.

Nhiệm vụ:

```txt
Duy trì network rules
Hỗ trợ Service routing
Giúp traffic đến Service được chuyển đến Pod backend phù hợp
```

Câu nhớ:

```txt
kube-proxy = hỗ trợ networking và Service routing trên Node.
```

---

## 4. Cluster có bao nhiêu Node?

Thông thường một Kubernetes cluster có nhiều Node.

Ví dụ production:

```txt
Node 1
Node 2
Node 3
Node 4
```

Nhưng trong môi trường học hoặc tài nguyên hạn chế, cluster có thể chỉ có một Node.

Ví dụ với Minikube:

```txt
Cluster minikube thường chỉ có 1 Node.
```

Câu nhớ:

```txt
Production thường nhiều Node.
Lab/minikube có thể chỉ 1 Node.
```

---

# Node Management

## 5. Node được thêm vào API Server như thế nào?

Có 2 cách chính để Node được thêm vào Kubernetes API Server:

```txt
1. kubelet trên Node tự đăng ký với control plane
2. Người dùng hoặc admin tự tạo Node object thủ công
```

Cách phổ biến nhất là:

```txt
kubelet self-register
```

Tức là khi kubelet chạy trên máy Node, nó tự đăng ký Node đó với API Server.

---

## 6. Node object là gì?

Node cũng là một Kubernetes object.

Khi Node được đăng ký, Kubernetes tạo Node object để đại diện cho máy đó trong cluster.

Ví dụ xem Node:

```bash
kubectl get nodes
```

Xem chi tiết Node:

```bash
kubectl describe node <node-name>
```

Câu nhớ:

```txt
Node object = bản ghi đại diện cho một máy trong Kubernetes API.
```

---

## 7. Node name uniqueness

Tên Node phải unique trong cluster.

Không thể có 2 Node cùng tên tại cùng một thời điểm.

Điểm quan trọng:

```txt
Kubernetes coi resource có cùng tên là cùng một object.
```

Với Node, nếu một máy mới dùng lại cùng tên Node cũ mà không xóa Node object cũ trước, Kubernetes có thể hiểu nhầm máy mới là máy cũ. Điều này có thể gây inconsistency.

Câu nhớ:

```txt
Node name phải unique.
Nếu thay Node lớn, nên xóa Node object cũ rồi đăng ký lại.
```

---

## 8. Node name phải hợp lệ DNS

Tên Node phải là DNS subdomain name hợp lệ.

Thường nên dùng:

```txt
Chữ thường
Số
Dấu -
Dấu .
```

Không nên dùng:

```txt
Dấu _
Chữ hoa
Ký tự đặc biệt
```

---

# Self-registration of Nodes

## 9. Node self-registration là gì?

Self-registration là cơ chế kubelet tự đăng ký Node với API Server.

Mặc định kubelet có flag:

```txt
--register-node=true
```

Nghĩa là kubelet sẽ tự cố gắng đăng ký Node với control plane.

Đây là pattern phổ biến trong hầu hết Kubernetes distributions.

Câu nhớ:

```txt
Self-registration = kubelet tự đăng ký Node với API Server.
```

---

## 10. Một số kubelet option liên quan đến registration

Một số option quan trọng:

```txt
--kubeconfig
--cloud-provider
--register-node
--register-with-taints
--node-ip
--node-labels
--node-status-update-frequency
```

Ý nghĩa đơn giản:

```txt
--kubeconfig
= file credentials để kubelet xác thực với API Server

--cloud-provider
= cách kubelet nói chuyện với cloud provider để đọc metadata

--register-node
= tự đăng ký Node với API Server

--register-with-taints
= đăng ký Node kèm taints

--node-ip
= IP của Node

--node-labels
= labels gắn vào Node khi đăng ký

--node-status-update-frequency
= tần suất kubelet cập nhật status lên API Server
```

---

## 11. Lưu ý khi đổi cấu hình Node

Nếu cần thay đổi cấu hình Node lớn, ví dụ đổi labels khi kubelet restart, nên re-register Node.

Lý do:

```txt
Một số label chỉ được set hoặc modify khi Node registration.
Pod đang chạy có thể bị ảnh hưởng nếu Node config đổi nhưng Node object cũ vẫn giữ trạng thái không nhất quán.
```

Câu nhớ:

```txt
Đổi cấu hình Node lớn → nên drain/re-register Node đúng cách.
```

---

# Manual Node Administration

## 12. Quản trị Node thủ công

Admin có thể tạo hoặc sửa Node object bằng `kubectl`.

Ví dụ có thể:

```txt
Gắn label cho Node
Mark Node unschedulable
Cordon Node
Drain Node
```

---

## 13. Node labels

Có thể gắn labels cho Node để kiểm soát scheduling.

Ví dụ:

```bash
kubectl label node minikube disk=ssd
```

Sau đó Pod có thể dùng nodeSelector để chỉ chạy trên Node có label đó:

```yaml
spec:
  nodeSelector:
    disk: ssd
```

Câu nhớ:

```txt
Node label + nodeSelector giúp điều khiển Pod chạy trên nhóm Node cụ thể.
```

---

## 14. Node role labels

Có thể gắn role cho Node bằng label dạng:

```txt
node-role.kubernetes.io/<role>
```

Ví dụ:

```txt
node-role.kubernetes.io/worker
node-role.kubernetes.io/control-plane
```

Kubernetes thường không quan tâm value của label role. Theo convention, value có thể để giống role.

---

## 15. Cordon Node là gì?

Cordon nghĩa là đánh dấu Node là **unschedulable**.

Khi Node bị cordon, scheduler sẽ không đặt Pod mới lên Node đó.

Lệnh:

```bash
kubectl cordon <node-name>
```

Ví dụ:

```bash
kubectl cordon minikube
```

Ý nghĩa:

```txt
Không schedule Pod mới lên Node minikube nữa.
```

Lưu ý:

```txt
Cordon không ảnh hưởng Pod đang chạy sẵn trên Node.
```

Câu nhớ:

```txt
cordon = chặn Pod mới schedule vào Node.
```

---

## 16. Uncordon Node là gì?

Uncordon là cho phép scheduler đặt Pod mới lên Node trở lại.

Lệnh:

```bash
kubectl uncordon <node-name>
```

Ví dụ:

```bash
kubectl uncordon minikube
```

Câu nhớ:

```txt
uncordon = cho Node nhận Pod mới trở lại.
```

---

## 17. Drain Node là gì?

Drain dùng để chuẩn bị bảo trì Node.

Drain sẽ:

```txt
Đánh dấu Node unschedulable
Evict các Pod đang chạy trên Node
Cho các Pod được controller tạo lại ở Node khác nếu có thể
```

Lệnh thường dùng:

```bash
kubectl drain <node-name> --ignore-daemonsets
```

Lưu ý:

```txt
DaemonSet Pods thường vẫn chạy trên unschedulable Node.
```

Câu nhớ:

```txt
drain = đưa workload ra khỏi Node để bảo trì.
```

---

# Node Status

## 18. Node status gồm những gì?

Node status chứa các thông tin chính:

```txt
Addresses
Conditions
Capacity and Allocatable
Info
```

Xem chi tiết:

```bash
kubectl describe node <node-name>
```

---

## 19. Addresses

Addresses là thông tin địa chỉ của Node.

Có thể gồm:

```txt
InternalIP
ExternalIP
Hostname
```

Ví dụ:

```txt
InternalIP: 192.168.x.x
Hostname: minikube
```

---

## 20. Conditions

Conditions mô tả trạng thái sức khỏe của Node.

Condition quan trọng nhất:

```txt
Ready
```

Ví dụ:

```txt
Ready=True
Ready=False
Ready=Unknown
```

Ý nghĩa:

```txt
Ready=True
→ Node khỏe và có thể chạy Pod

Ready=False
→ Node không khỏe

Ready=Unknown
→ Control plane không liên lạc được với Node
```

Câu nhớ:

```txt
Node Ready=True thì Node có thể chạy workload.
```

---

## 21. Capacity and Allocatable

Node object theo dõi tài nguyên của Node.

```txt
Capacity = tổng tài nguyên Node có
Allocatable = tài nguyên có thể cấp cho Pod
```

Ví dụ:

```txt
Capacity:
  cpu: 4
  memory: 8Gi

Allocatable:
  cpu: 3800m
  memory: 7Gi
```

Vì một phần tài nguyên cần dành cho system daemons, nên `allocatable` thường nhỏ hơn `capacity`.

Câu nhớ:

```txt
Capacity = tổng tài nguyên.
Allocatable = phần tài nguyên Pod có thể dùng.
```

---

## 22. Info

Info chứa thông tin hệ thống của Node.

Ví dụ:

```txt
OS image
Kernel version
Container runtime version
Kubelet version
Kube-proxy version
Architecture
```

---

# Node Heartbeats

## 23. Node heartbeat là gì?

Heartbeat là tín hiệu Node gửi về control plane để báo rằng Node còn sống.

Có 2 dạng heartbeat:

```txt
1. Update vào .status của Node
2. Lease object trong namespace kube-node-lease
```

Mỗi Node có một Lease object tương ứng trong namespace:

```txt
kube-node-lease
```

Câu nhớ:

```txt
Heartbeat giúp control plane biết Node còn sống hay bị lỗi.
```

---

## 24. kube-node-lease namespace liên quan gì đến Node?

`kube-node-lease` chứa Lease object của mỗi Node.

Lease object giúp kubelet gửi heartbeat nhẹ hơn và giúp control plane phát hiện Node failure nhanh hơn.

Câu nhớ:

```txt
kube-node-lease = nơi chứa heartbeat lease của Node.
```

---

# Node Controller

## 25. Node controller là gì?

Node controller là component của control plane chịu trách nhiệm quản lý các khía cạnh liên quan đến Node.

Nhiệm vụ:

```txt
Theo dõi danh sách Node
Theo dõi sức khỏe Node
Cập nhật Ready condition
Xử lý khi Node unreachable
Evict Pod khỏi Node lỗi nếu cần
Tương tác với cloud provider trong cloud environment
```

Câu nhớ:

```txt
Node controller = control plane component quản lý Node health và lifecycle.
```

---

## 26. Node controller làm gì khi Node unreachable?

Nếu Node không liên lạc được:

```txt
Node controller cập nhật Ready condition thành Unknown.
```

Nếu Node tiếp tục unreachable trong một khoảng thời gian:

```txt
Node controller có thể trigger eviction cho Pod trên Node đó.
```

Mặc định, node controller chờ khoảng 5 phút giữa lúc mark Node là Unknown và eviction request đầu tiên.

Câu nhớ:

```txt
Node unreachable → Ready=Unknown → sau một thời gian có thể evict Pod.
```

---

## 27. Node controller kiểm tra Node bao lâu một lần?

Mặc định, node controller kiểm tra trạng thái mỗi Node khoảng mỗi 5 giây.

Tham số này có thể cấu hình qua:

```txt
--node-monitor-period
```

trên `kube-controller-manager`.

---

## 28. Eviction rate limit

Node controller giới hạn tốc độ evict Pod để tránh gây ảnh hưởng lớn khi nhiều Node lỗi cùng lúc.

Mặc định:

```txt
--node-eviction-rate = 0.1 node/second
```

Tức là khoảng:

```txt
1 node / 10 seconds
```

Khi nhiều Node trong một zone bị unhealthy, eviction rate có thể bị giảm hoặc dừng tùy quy mô cluster và mức độ lỗi.

Câu nhớ:

```txt
Eviction có rate limit để tránh làm cluster biến động quá mạnh.
```

---

## 29. Taints khi Node có vấn đề

Node controller có thể thêm taints tương ứng với vấn đề của Node.

Ví dụ:

```txt
node unreachable
node not ready
```

Scheduler sẽ không đặt Pod mới lên Node unhealthy nếu Pod không tolerate taint đó.

Câu nhớ:

```txt
Taints giúp ngăn Pod chạy trên Node không phù hợp hoặc không khỏe.
```

---

# Resource Capacity Tracking

## 30. Node theo dõi tài nguyên như thế nào?

Node object lưu thông tin tài nguyên Node có, ví dụ:

```txt
CPU
Memory
Ephemeral storage
Pods capacity
```

Kubelet tự đăng ký Node sẽ báo capacity khi registration.

Nếu admin tạo Node thủ công, admin cần khai báo capacity đúng.

---

## 31. Scheduler dùng capacity như thế nào?

Scheduler kiểm tra tổng resource requests của các container trên Node.

Quy tắc:

```txt
Tổng requests của Pods trên Node <= Node capacity/allocatable
```

Nếu Pod yêu cầu nhiều tài nguyên hơn Node còn lại, scheduler sẽ không đặt Pod đó lên Node.

Câu nhớ:

```txt
Scheduler dựa vào resource requests và allocatable để chọn Node phù hợp.
```

---

## 32. Resource requests là gì?

Resource requests là lượng tài nguyên tối thiểu Pod yêu cầu để scheduler đặt Pod lên Node.

Ví dụ:

```yaml
resources:
  requests:
    cpu: "100m"
    memory: "128Mi"
```

Scheduler dùng requests để tính xem Node có đủ tài nguyên không.

---

# Node Topology

## 33. Node topology là gì?

Node topology liên quan đến cách tài nguyên phần cứng được tổ chức trên Node, ví dụ CPU socket, NUMA node, device locality.

Kubelet có thể dùng topology hints để đưa ra quyết định gán tài nguyên tối ưu hơn.

Phần này nâng cao, chỉ cần nhớ:

```txt
Node topology giúp tối ưu resource assignment trên Node.
```

---

# 34. Lệnh kubectl quan trọng với Node

Xem Node:

```bash
kubectl get nodes
```

Xem chi tiết Node:

```bash
kubectl describe node <node-name>
```

Gắn label cho Node:

```bash
kubectl label node <node-name> disk=ssd
```

Cordon Node:

```bash
kubectl cordon <node-name>
```

Uncordon Node:

```bash
kubectl uncordon <node-name>
```

Drain Node:

```bash
kubectl drain <node-name> --ignore-daemonsets
```

Xem Lease object:

```bash
kubectl get lease -n kube-node-lease
```

Xem Pod theo Node:

```bash
kubectl get pods -A --field-selector spec.nodeName=<node-name>
```

---

# 35. Câu hỏi ôn tập

1. Node là gì?
2. Node có thể là máy vật lý hay máy ảo không?

