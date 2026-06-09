# Kubernetes Notes — Namespaces

## 1. Namespace là gì?

Namespace là cơ chế trong Kubernetes dùng để cô lập và tổ chức các nhóm resource bên trong cùng một cluster.

Hiểu đơn giản:

```txt
Namespace = không gian logic để chia resource trong cùng một Kubernetes cluster.
```

Ví dụ trong một cluster có thể có nhiều namespace:

```txt
dev
staging
production
monitoring
team-a
team-b
```

Mỗi namespace giống như một “khu vực riêng” trong cluster.

---

## 2. Namespace dùng để làm gì?

Namespace giúp:

```txt
- Tách resource theo team
- Tách resource theo project
- Tách resource theo môi trường dev/staging/prod
- Giới hạn tài nguyên bằng ResourceQuota
- Quản lý quyền truy cập dễ hơn bằng RBAC
- Tránh trùng tên resource giữa các nhóm
```

Ví dụ:

```txt
Namespace dev:
  Deployment/web
  Service/web

Namespace production:
  Deployment/web
  Service/web
```

Hai Deployment cùng tên `web` vẫn được phép tồn tại vì chúng nằm ở hai namespace khác nhau.

---

## 3. Name unique trong Namespace

Tên resource cần unique **trong cùng một namespace**, nhưng không cần unique giữa các namespace khác nhau.

Ví dụ hợp lệ:

```txt
namespace: dev
Deployment name: web

namespace: production
Deployment name: web
```

Ví dụ không hợp lệ:

```txt
namespace: dev
Pod name: nginx
Pod name: nginx
```

Trong cùng namespace `dev`, không thể có 2 Pod cùng tên `nginx`.

Câu nhớ:

```txt
Resource name unique trong namespace, không unique toàn cluster.
```

---

## 4. Namespace áp dụng cho resource nào?

Namespace chỉ áp dụng cho **namespaced objects**.

Ví dụ resource có namespace:

```txt
Pod
Deployment
Service
ConfigMap
Secret
ReplicaSet
Job
CronJob
Ingress
```

Nhưng có một số resource là **cluster-wide**, không thuộc namespace nào.

Ví dụ resource không có namespace:

```txt
Node
PersistentVolume
StorageClass
Namespace
ClusterRole
ClusterRoleBinding
```

Câu nhớ:

```txt
Pod, Deployment, Service nằm trong namespace.
Node, PV, StorageClass là cluster-wide.
```

---

## 5. Khi nào nên dùng nhiều Namespace?

Nên dùng nhiều namespace khi cluster có:

```txt
- Nhiều team
- Nhiều project
- Nhiều môi trường
- Cần tách quyền truy cập
- Cần giới hạn tài nguyên từng nhóm
```

Ví dụ:

```txt
team-a-dev
team-a-prod
team-b-dev
team-b-prod
```

Hoặc:

```txt
dev
staging
prod
monitoring
logging
```

---

## 6. Khi nào không cần nhiều Namespace?

Nếu cluster chỉ có ít người dùng, ít project, hoặc đang học/lab đơn giản, có thể chưa cần tạo nhiều namespace.

Không nên dùng namespace để tách những resource chỉ khác nhẹ nhau, ví dụ nhiều version khác nhau của cùng một app. Trường hợp đó nên dùng **labels**.

Ví dụ không nhất thiết tạo namespace:

```txt
web-v1
web-v2
```

Có thể dùng label:

```yaml
labels:
  app: web
  version: v1
```

và:

```yaml
labels:
  app: web
  version: v2
```

Câu nhớ:

```txt
Namespace dùng để tách nhóm lớn như team/project/env.
Label dùng để phân loại resource bên trong namespace.
```

---

## 7. Không nên dùng default namespace trong production

Kubernetes có sẵn namespace `default` để người mới có thể dùng cluster ngay mà chưa cần tạo namespace.

Nhưng trong production, nên tạo namespace riêng thay vì dùng `default`.

Ví dụ:

```txt
production
staging
dev
monitoring
```

Lý do:

```txt
- Quản lý rõ ràng hơn
- Dễ áp dụng RBAC
- Dễ đặt ResourceQuota
- Dễ tổ chức workload
- Tránh cluster bị lộn xộn
```

Câu nhớ:

```txt
Lab có thể dùng default.
Production nên dùng namespace riêng.
```

---

# Initial Namespaces

## 8. Các namespace mặc định ban đầu

Kubernetes thường có 4 namespace ban đầu:

```txt
default
kube-node-lease
kube-public
kube-system
```

---

## 9. default namespace

`default` là namespace mặc định.

Nếu bạn tạo resource mà không chỉ định namespace, resource thường được tạo trong `default`.

Ví dụ:

```bash
kubectl run nginx --image=nginx
```

Pod sẽ được tạo trong namespace `default`.

Câu nhớ:

```txt
default = namespace mặc định cho người dùng mới.
```

---

## 10. kube-node-lease namespace

`kube-node-lease` chứa các Lease object liên quan đến node.

Node lease giúp `kubelet` gửi heartbeat để control plane phát hiện node còn sống hay đã lỗi.

Câu nhớ:

```txt
kube-node-lease = namespace dùng cho heartbeat của node.
```

---

## 11. kube-public namespace

`kube-public` là namespace có thể đọc bởi tất cả client, kể cả client chưa xác thực trong một số trường hợp.

Namespace này chủ yếu được dành cho cluster usage nếu có resource cần public-read trong toàn cluster.

Câu nhớ:

```txt
kube-public = namespace dành cho thông tin có thể đọc công khai trong cluster.
```

---

## 12. kube-system namespace

`kube-system` là namespace chứa các object do hệ thống Kubernetes tạo ra.

Ví dụ:

```txt
CoreDNS
kube-proxy
metrics-server
system controllers
```

Câu nhớ:

```txt
kube-system = namespace của component hệ thống Kubernetes.
```

---

## 13. Không nên tạo namespace bắt đầu bằng kube-

Không nên tạo namespace có prefix:

```txt
kube-
```

Vì prefix này được dành cho Kubernetes system namespaces.

Ví dụ không nên tạo:

```txt
kube-myapp
kube-dev
```

Câu nhớ:

```txt
Prefix kube- dành cho Kubernetes system.
```

---

# Working with Namespaces

## 14. Xem danh sách namespaces

Lệnh:

```bash
kubectl get namespace
```

Hoặc viết ngắn:

```bash
kubectl get ns
```

Output ví dụ:

```txt
NAME              STATUS   AGE
default           Active   1d
kube-node-lease   Active   1d
kube-public       Active   1d
kube-system       Active   1d
```

---

## 15. Tạo namespace

Có thể tạo namespace bằng lệnh:

```bash
kubectl create namespace dev
```

Hoặc viết YAML:

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: dev
```

Apply:

```bash
kubectl apply -f namespace-dev.yaml
```

---

## 16. Xóa namespace

Lệnh:

```bash
kubectl delete namespace dev
```

Lưu ý:

```txt
Xóa namespace sẽ xóa các resource nằm trong namespace đó.
```

Vì vậy cần cẩn thận khi xóa namespace.

---

## 17. Chỉ định namespace khi chạy lệnh

Dùng flag:

```bash
--namespace
```

hoặc viết ngắn:

```bash
-n
```

Ví dụ tạo Pod trong namespace `dev`:

```bash
kubectl run nginx --image=nginx --namespace=dev
```

Xem Pod trong namespace `dev`:

```bash
kubectl get pods --namespace=dev
```

Hoặc:

```bash
kubectl get pods -n dev
```

Câu nhớ:

```txt
-n dev = thao tác trong namespace dev.
```

---

## 18. Xem resource trong tất cả namespace

Dùng:

```bash
kubectl get pods --all-namespaces
```

Hoặc viết ngắn:

```bash
kubectl get pods -A
```

Ví dụ:

```bash
kubectl get svc -A
kubectl get deploy -A
```

Câu nhớ:

```txt
-A = all namespaces.
```

---

## 19. Set namespace mặc định cho kubectl context

Nếu thường xuyên làm việc trong namespace `dev`, có thể set namespace mặc định:

```bash
kubectl config set-context --current --namespace=dev
```

Kiểm tra:

```bash
kubectl config view --minify
```

Sau khi set, lệnh:

```bash
kubectl get pods
```

sẽ mặc định xem Pod trong namespace `dev`.

Câu nhớ:

```txt
Set context namespace để khỏi phải gõ -n dev mỗi lần.
```

---

# Namespaces and DNS

## 20. Namespace ảnh hưởng đến DNS như thế nào?

Khi tạo Service, Kubernetes tạo DNS record cho Service.

DNS đầy đủ có dạng:

```txt
<service-name>.<namespace-name>.svc.cluster.local
```

Ví dụ Service tên `web` trong namespace `dev`:

```txt
web.dev.svc.cluster.local
```

Service tên `web` trong namespace `production`:

```txt
web.production.svc.cluster.local
```

---

## 21. Gọi Service trong cùng namespace

Nếu Pod và Service cùng namespace, Pod có thể gọi Service bằng tên ngắn:

```txt
web
```

Ví dụ:

```bash
curl http://web
```

Kubernetes sẽ hiểu là Service `web` trong cùng namespace.

---

## 22. Gọi Service khác namespace

Nếu muốn gọi Service ở namespace khác, nên dùng tên đầy đủ hơn.

Ví dụ Pod ở namespace `dev` muốn gọi Service `web` ở namespace `production`:

```txt
web.production.svc.cluster.local
```

Hoặc có thể dùng:

```txt
web.production
```

Câu nhớ:

```txt
Cùng namespace: gọi bằng service-name.
Khác namespace: gọi bằng service-name.namespace.
```

---

## 23. Vì sao namespace name phải hợp lệ DNS?

Vì namespace tham gia vào DNS name của Service.

Ví dụ:

```txt
web.dev.svc.cluster.local
```

Do đó namespace name phải hợp lệ theo RFC 1123 DNS label.

Tên namespace nên:

```txt
- Chữ thường
- Số
- Dấu -
- Không dùng chữ hoa
- Không dùng dấu _
```

Ví dụ hợp lệ:

```txt
dev
staging
production
team-a
```

Ví dụ không hợp lệ:

```txt
Team_A
Dev.Namespace
-prod
```

---

## 24. Cảnh báo về namespace trùng public top-level domain

Không nên tạo namespace có tên giống public top-level domain như:

```txt
com
net
org
vn
dev
```

Tuy nhiên trong thực tế lab, `dev` vẫn hay dùng. Cảnh báo này quan trọng hơn trong cluster production có policy DNS nghiêm ngặt.

Lý do là Service trong namespace đó có thể tạo short DNS name trùng với public DNS records.

Câu nhớ:

```txt
Production nên kiểm soát quyền tạo namespace và tránh namespace trùng public TLD.
```

---

# Namespaced vs Cluster-wide Resources

## 25. Xem resource nào có namespace

Lệnh:

```bash
kubectl api-resources --namespaced=true
```

Lệnh này liệt kê resource thuộc namespace.

Ví dụ thường có:

```txt
pods
services
deployments
configmaps
secrets
jobs
```

---

## 26. Xem resource nào không thuộc namespace

Lệnh:

```bash
kubectl api-resources --namespaced=false
```

Ví dụ thường có:

```txt
nodes
namespaces
persistentvolumes
storageclasses
clusterroles
clusterrolebindings
```

Câu nhớ:

```txt
namespaced=true: resource nằm trong namespace.
namespaced=false: resource cấp cluster.
```

---

## 27. Namespace tự có label nào?

Từ Kubernetes 1.22, control plane tự gắn label bất biến cho namespace:

```txt
kubernetes.io/metadata.name
```

Giá trị của label này là tên namespace.

Ví dụ namespace `dev` có label:

```yaml
kubernetes.io/metadata.name: dev
```

Câu nhớ:

```txt
Namespace có label tự động kubernetes.io/metadata.name=<namespace-name>.
```

---

# 28. Namespace khác Label như thế nào?

Namespace và Label đều giúp tổ chức resource, nhưng mục đích khác nhau.

| Thành phần | Mục đích                            | Ví dụ                  |
| ---------- | ----------------------------------- | ---------------------- |
| Namespace  | Chia cluster thành không gian logic | dev, staging, prod     |
| Label      | Gắn nhãn để phân loại/chọn object   | app=web, tier=frontend |

Ví dụ:

```txt
Namespace dev:
  Pod web-v1 labels: app=web, version=v1
  Pod web-v2 labels: app=web, version=v2
```

Ở đây:

```txt
namespace = dev
labels = app=web, version=v1/v2
```

Câu nhớ:

```txt
Namespace chia vùng.
Label phân loại object trong vùng đó.
```

---

# 29. Câu hỏi ôn tập

1. Namespace là gì?
2. Namespace dùng để làm gì?
3. Name của resource phải unique trong phạm vi nào?
4. Có thể có Deployment cùng tên ở 2 namespace khác nhau không?
5. Namespace có thể nested không?
6. Một resource có thể nằm trong nhiều namespace không?
7. Những resource nào thường thuộc namespace?
8. Những resource nào không thuộc namespace?
9. Khi nào nên dùng nhiều namespace?
10. Khi nào không cần dùng nhiều namespace?
11. Vì sao không nên dùng default namespace trong production?
12. Kubernetes có những namespace mặc định nào?
13. default namespace dùng để làm gì?
14. kube-system namespace chứa gì?
15. kube-public namespace là gì?
16. kube-node-lease namespace dùng để làm gì?
17. Vì sao không nên tạo namespace bắt đầu bằng kube-?
18. Lệnh xem namespace là gì?
19. Lệnh tạo namespace là gì?
20. Lệnh xóa namespace là gì?
21. Cách chạy Pod trong namespace cụ thể?
22. `-n` trong kubectl nghĩa là gì?
23. `-A` trong kubectl nghĩa là gì?
24. Cách set namespace mặc định cho kubectl context?
25. DNS của Service trong Kubernetes có dạng gì?
26. Cách gọi Service cùng namespace?
27. Cách gọi Service khác namespace?
28. Vì sao namespace name phải hợp lệ DNS?
29. Cách xem resource nào namespaced?
30. Namespace khác label như thế nào?

---

# 30. Câu trả lời ngắn cho mentor

## Namespace là gì?

Namespace là cơ chế trong Kubernetes dùng để chia một cluster thành nhiều không gian logic, giúp cô lập và tổ chức resource theo team, project hoặc môi trường.

## Namespace dùng để làm gì?

Namespace dùng để tách resource, tránh trùng tên trong cùng cluster, hỗ trợ phân quyền bằng RBAC và chia tài nguyên bằng ResourceQuota.

## Name unique trong namespace nghĩa là gì?

Tên resource phải unique trong cùng namespace và cùng loại resource, nhưng có thể trùng tên ở namespace khác.

## Có thể có Deployment cùng tên ở hai namespace khác nhau không?

Có. Ví dụ có thể có Deployment `web` trong namespace `dev` và Deployment `web` trong namespace `production`.

## Namespace có nested được không?

Không. Namespace không thể lồng nhau.

## Một resource có thể nằm trong nhiều namespace không?

Không. Mỗi namespaced resource chỉ nằm trong một namespace.

## Những namespace mặc định là gì?

Kubernetes có các namespace mặc định: `default`, `kube-node-lease`, `kube-public`, và `kube-system`.

## kube-system là gì?

`kube-system` là namespace chứa các object do hệ thống Kubernetes tạo ra, ví dụ CoreDNS, kube-proxy hoặc các component hệ thống.

## Vì sao production không nên dùng default namespace?

Vì dùng namespace riêng giúp quản lý rõ hơn, dễ phân quyền, dễ áp quota và tránh lộn xộn giữa các workload.

## Namespace khác label như thế nào?

Namespace dùng để chia cluster thành các không gian logic. Label dùng để phân loại và chọn object bên trong namespace.

## Service DNS theo namespace như thế nào?

Service DNS có dạng `<service-name>.<namespace-name>.svc.cluster.local`. Nếu Pod gọi Service cùng namespace thì có thể dùng tên ngắn `<service-name>`. Nếu gọi khác namespace thì nên dùng `<service-name>.<namespace-name>`.
