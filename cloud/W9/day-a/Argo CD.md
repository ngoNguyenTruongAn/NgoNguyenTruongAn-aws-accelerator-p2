# W9-D1 — Argo CD Overview

## 1. Argo CD là gì?

**Argo CD** là một công cụ **GitOps Continuous Delivery cho Kubernetes**.

Nói đơn giản:

> Thay vì dùng `kubectl apply` thủ công để deploy app lên Kubernetes, ta lưu toàn bộ manifest trong Git. Argo CD sẽ theo dõi Git repo đó và tự đồng bộ trạng thái trong cluster sao cho giống với trạng thái mong muốn trong Git.

Ví dụ:

```txt
Git repo có deployment.yaml replicas = 3
Kubernetes cluster thực tế đang chạy replicas = 2

=> Argo CD phát hiện lệch trạng thái
=> App bị OutOfSync
=> Argo CD có thể tự sync hoặc cho người dùng sync thủ công
=> Cluster quay về đúng replicas = 3
```

Điểm quan trọng nhất:

```txt
Git = source of truth
Cluster = nơi chạy thực tế
Argo CD = controller so sánh và đồng bộ Git với cluster
```

---

## 2. Vì sao cần Argo CD?

Trong DevOps/Cloud thực tế, deploy app không nên làm thủ công như:

```bash
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
kubectl edit deployment ...
```

Vì cách này có nhiều vấn đề:

* Không biết rõ ai đã thay đổi gì
* Không dễ rollback
* Không có lịch sử rõ ràng
* Dễ lệch giữa Git và môi trường thật
* Khó audit khi mentor hoặc team hỏi
* Dễ gây lỗi khi thao tác trực tiếp trên cluster

Argo CD giải quyết bằng cách:

```txt
Mọi cấu hình app nằm trong Git
Mọi thay đổi đi qua commit / pull request
Argo CD tự deploy vào Kubernetes
Có UI để xem app đang Healthy / Synced hay lỗi
Có lịch sử deploy và rollback
```

Trong W9, ý chính là:

> Không apply manifest tay nữa. Mọi thứ đi qua Git và được Argo CD sync vào cluster.

---

## 3. Cách Argo CD hoạt động

Luồng cơ bản:

```txt
Developer sửa manifest
        ↓
Push lên Git repo
        ↓
Argo CD theo dõi repo
        ↓
Argo CD so sánh Git với Kubernetes cluster
        ↓
Nếu khác nhau → OutOfSync
        ↓
Sync tự động hoặc thủ công
        ↓
Cluster trở về đúng desired state
```

Có 2 trạng thái cần nhớ:

| Khái niệm         | Ý nghĩa                                        |
| ----------------- | ---------------------------------------------- |
| **Desired state** | Trạng thái mong muốn được định nghĩa trong Git |
| **Live state**    | Trạng thái thực tế đang chạy trong Kubernetes  |
| **Synced**        | Git và cluster giống nhau                      |
| **OutOfSync**     | Git và cluster đang lệch nhau                  |
| **Healthy**       | App/resource đang chạy ổn                      |
| **Degraded**      | App/resource có vấn đề                         |

Ví dụ:

```txt
Git khai báo replicas = 3
Cluster thực tế đang chạy replicas = 5

=> Live state khác Desired state
=> Argo CD báo OutOfSync
```

---

## 4. Argo CD hỗ trợ những loại manifest nào?

Argo CD không chỉ đọc YAML thuần. Nó có thể deploy app từ nhiều dạng cấu hình Kubernetes khác nhau.

| Loại                                | Ý nghĩa                                                     |
| ----------------------------------- | ----------------------------------------------------------- |
| **Plain YAML/JSON**                 | Manifest Kubernetes thường như Deployment, Service, Ingress |
| **Helm Chart**                      | Package manager cho Kubernetes                              |
| **Kustomize**                       | Quản lý nhiều environment như dev, staging, prod            |
| **Jsonnet**                         | Cấu hình dạng template nâng cao                             |
| **Custom config management plugin** | Dùng tool custom riêng                                      |

Ví dụ repo YAML thường:

```txt
repo/
  k8s/
    deployment.yaml
    service.yaml
    ingress.yaml
```

Ví dụ repo Helm:

```txt
repo/
  helm-chart/
    Chart.yaml
    values.yaml
```

Ví dụ repo Kustomize:

```txt
repo/
  overlays/
    dev/
    staging/
    prod/
```

---

## 5. Kiến trúc Argo CD

Argo CD được triển khai như một **Kubernetes controller**.

Nó liên tục quan sát app đang chạy trong cluster, sau đó so sánh với cấu hình trong Git.

Mô hình đơn giản:

```txt
Git Repository
     ↓
Argo CD Controller
     ↓
Kubernetes API Server
     ↓
Deployment / Service / Ingress / Pod
```

Cần nhớ:

> Argo CD không thay thế Kubernetes. Argo CD chỉ quản lý cách manifest được đưa vào Kubernetes.

Một câu dễ nhớ:

```txt
Kubernetes đảm bảo Pod chạy đúng theo manifest.
Argo CD đảm bảo manifest trong cluster đúng với Git.
```

---

## 6. Các tính năng chính của Argo CD

### 6.1. Automated Deployment

Argo CD có thể tự deploy app vào cluster khi Git thay đổi.

Keyword:

```txt
auto-sync
manual sync
desired state
target environment
```

---

### 6.2. Drift Detection

Nếu cluster bị sửa tay, Argo CD phát hiện cấu hình bị lệch.

Keyword:

```txt
configuration drift
OutOfSync
self-heal
```

Ví dụ:

```bash
kubectl scale deployment web --replicas=5
```

Nhưng trong Git là:

```yaml
replicas: 3
```

Khi đó Argo CD sẽ thấy cluster đang lệch với Git.

Nếu bật **self-heal**, Argo CD có thể tự đưa cluster quay về đúng trạng thái trong Git.

---

### 6.3. Rollback

Vì mọi config nằm trong Git nên rollback rất rõ ràng.

Cách rollback theo GitOps:

```bash
git revert <commit>
```

Sau đó Argo CD sync lại cluster.

So sánh:

| Cách rollback          | Ý nghĩa                                          |
| ---------------------- | ------------------------------------------------ |
| `git revert`           | Rollback theo GitOps, nên dùng với Argo CD       |
| `kubectl rollout undo` | Rollback trực tiếp trên cluster, dễ làm lệch Git |

Khi dùng Argo CD, nên ưu tiên rollback bằng Git:

> Git là source of truth, nên muốn rollback thì revert commit trong Git rồi để Argo CD sync lại.

---

### 6.4. Multi-cluster

Argo CD có thể quản lý nhiều Kubernetes cluster.

Ví dụ:

```txt
Argo CD
 ├── dev cluster
 ├── staging cluster
 └── production cluster
```

Điều này phù hợp với môi trường công ty có nhiều môi trường khác nhau.

---

### 6.5. RBAC và SSO

Argo CD hỗ trợ phân quyền và đăng nhập qua nhiều hệ thống.

Keyword:

```txt
RBAC
SSO
OIDC
OAuth2
LDAP
SAML
GitHub
GitLab
```

Trong môi trường thực tế, không phải ai cũng được quyền sync production. Vì vậy RBAC rất quan trọng.

---

### 6.6. Sync Hooks

Argo CD có các hook hỗ trợ rollout phức tạp:

```txt
PreSync
Sync
PostSync
```

| Hook         | Chạy lúc nào        |
| ------------ | ------------------- |
| **PreSync**  | Trước khi deploy    |
| **Sync**     | Trong lúc deploy    |
| **PostSync** | Sau khi deploy xong |

Có thể dùng cho:

```txt
database migration
blue/green deployment
canary deployment
smoke test
```

---

### 6.7. Prometheus Metrics

Argo CD có metric để Prometheus scrape.

Liên quan trực tiếp đến W9 Observability:

```txt
Argo CD → Prometheus → Grafana dashboard / alert
```

---

## 7. Lệnh cài đặt Argo CD Quick Start

Tạo namespace riêng cho Argo CD:

```bash
kubectl create namespace argocd
```

Cài Argo CD vào namespace `argocd`:

```bash
kubectl apply -n argocd --server-side --force-conflicts -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

Giải thích nhanh:

| Thành phần          | Ý nghĩa                      |
| ------------------- | ---------------------------- |
| `kubectl apply`     | Apply manifest vào cluster   |
| `-n argocd`         | Cài trong namespace `argocd` |
| `--server-side`     | Dùng server-side apply       |
| `--force-conflicts` | Ép xử lý conflict khi apply  |
| `install.yaml`      | Manifest cài Argo CD         |

Trong tài liệu có nhắc `--server-side --force-conflicts` cần dùng do giới hạn kích thước CRD.

Keyword cần nhớ:

```txt
namespace argocd
CRD
server-side apply
force-conflicts
```

---


## 9. Câu hỏi mentor có thể hỏi

### Câu 1: Argo CD là gì?

Trả lời:

> Argo CD là công cụ GitOps Continuous Delivery cho Kubernetes. Nó dùng Git làm source of truth, theo dõi manifest trong Git và đồng bộ trạng thái trong Kubernetes cluster sao cho giống với desired state trong Git.

---

### Câu 2: Vì sao dùng Argo CD thay vì `kubectl apply` thủ công?

Trả lời:

> Vì Argo CD giúp deployment có version control, audit trail, rollback dễ hơn và tránh cấu hình bị lệch. Khi mọi manifest nằm trong Git, team có thể review qua pull request, biết ai thay đổi gì và Argo CD tự sync vào cluster.

---

### Câu 3: OutOfSync là gì?

Trả lời:

> OutOfSync là trạng thái khi live state trong Kubernetes khác với desired state trong Git. Ví dụ Git khai báo replicas là 3 nhưng cluster đang chạy 5 replicas thì Argo CD sẽ báo OutOfSync.

---

### Câu 4: Git là source of truth nghĩa là gì?

Trả lời:

> Nghĩa là trạng thái mong muốn của hệ thống được định nghĩa trong Git. Cluster phải chạy theo những gì Git khai báo, không phải theo những thay đổi thủ công ngoài Git.

---

### Câu 5: Argo CD có tự rollback được không?

Trả lời:

> Argo CD có thể rollback về bất kỳ cấu hình nào đã được commit trong Git. Theo GitOps, cách tốt nhất là dùng `git revert` để quay lại commit trước, sau đó Argo CD sync lại cluster.

---

### Câu 6: Nếu có người dùng `kubectl edit` sửa trực tiếp Deployment trong cluster thì Argo CD sẽ làm gì?

Trả lời:

> Argo CD sẽ phát hiện live state khác desired state trong Git, đánh dấu app là OutOfSync. Nếu bật auto-sync hoặc self-heal, Argo CD sẽ đưa cluster quay lại đúng cấu hình trong Git.

---

### Câu 7: Rollback nên dùng `git revert` hay `kubectl rollout undo`?

Trả lời:

> Nên dùng `git revert` vì Git là source of truth. Nếu dùng `kubectl rollout undo`, cluster có thể rollback nhưng Git vẫn giữ version cũ, dẫn đến OutOfSync.

---

## 10. Bản ghi nhớ ngắn

Có thể học thuộc đoạn này:

> Argo CD là công cụ GitOps CD cho Kubernetes. Nó dùng Git làm source of truth, liên tục so sánh desired state trong Git với live state trong cluster. Nếu hai trạng thái khác nhau, app sẽ bị OutOfSync và Argo CD có thể sync lại tự động hoặc thủ công. Lợi ích chính là deploy có kiểm soát, dễ audit, dễ rollback, phát hiện drift và giảm thao tác `kubectl apply` thủ công.

Câu chốt cho W9:

```txt
Trước W9: kubectl apply manifest thủ công
Sau W9: Git commit → Argo CD sync → Kubernetes tự cập nhật
```

---

## 11. Flow cần nắm cho W9

```txt
Git commit / push
        ↓
GitHub Actions chạy CI/CD
        ↓
Manifest được lưu trong Git
        ↓
Argo CD phát hiện thay đổi
        ↓
Argo CD sync vào Kubernetes cluster
        ↓
App được deploy/update
        ↓
Prometheus/Grafana theo dõi metric
        ↓
Nếu deploy lỗi hoặc metric xấu → rollback/abort
```

---

## 12. Kết luận

Argo CD là phần rất quan trọng trong W9 vì nó chuyển cách deploy từ thủ công sang GitOps.

Điểm cần nhớ nhất:

```txt
Không deploy bằng tay trực tiếp lên cluster.
Mọi thay đổi phải đi qua Git.
Argo CD chịu trách nhiệm sync Git với Kubernetes.
```

Nếu mentor hỏi về Argo CD, cần nhấn mạnh 4 ý:

1. Git là source of truth.
2. Argo CD so sánh desired state và live state.
3. Nếu lệch thì báo OutOfSync và có thể sync lại.
4. Rollback nên đi qua Git, thường là `git revert`.
