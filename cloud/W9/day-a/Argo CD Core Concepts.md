# W9-D1 — Argo CD Core Concepts

## 1. Tổng quan

Phần **Core Concepts** của Argo CD giải thích các khái niệm cốt lõi cần nắm trước khi dùng Argo CD hiệu quả.

Các khái niệm quan trọng gồm:

```txt
Application
Application Source Type
Target State
Live State
Sync Status
Sync
Sync Operation Status
Refresh
Health
Tool
Configuration Management Tool
Configuration Management Plugin
```

Tất cả xoay quanh một ý chính:

> Argo CD so sánh trạng thái mong muốn trong Git với trạng thái thật đang chạy trong Kubernetes, sau đó sync để cluster giống với Git.

Flow tổng quát:

```txt
Git Repository
  chứa manifest
      ↓
Target State
  trạng thái mong muốn
      ↓
Argo CD Refresh
  so sánh với cluster
      ↓
Live State
  trạng thái thật đang chạy
      ↓
Sync Status
  Synced hoặc OutOfSync
      ↓
Sync
  đưa cluster về đúng Git
      ↓
Health
  app chạy ổn hay không
```

---

## 2. Application

**Application** trong Argo CD là một nhóm Kubernetes resources được định nghĩa bởi manifest.

Ví dụ một app web có thể gồm:

```txt
Deployment
Service
Ingress
ConfigMap
Secret
```

Trong Argo CD, **Application là một CRD**.

CRD là viết tắt của **Custom Resource Definition**, nghĩa là Kubernetes được mở rộng thêm một loại resource mới tên là `Application`.

Ví dụ manifest Application:

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: web-app
spec:
  source:
    repoURL: https://github.com/example/repo.git
    path: k8s
  destination:
    server: https://kubernetes.default.svc
    namespace: default
```

Câu dễ nhớ:

> Application là đối tượng Argo CD dùng để biết app nằm ở repo nào, path nào, deploy vào cluster nào và namespace nào.

Keyword:

```txt
Application
CRD
Kubernetes resources
manifest
repoURL
path
destination
namespace
```

---

## 3. Application Source Type

**Application Source Type** là loại công cụ được dùng để tạo manifest cho application.

Argo CD có thể đọc nhiều loại source:

```txt
Plain YAML
Helm
Kustomize
Jsonnet
Custom Plugin
```

| Source type | Ý nghĩa                   |
| ----------- | ------------------------- |
| Plain YAML  | Manifest Kubernetes thuần |
| Helm        | Dùng Helm chart           |
| Kustomize   | Dùng base/overlay         |
| Jsonnet     | Template nâng cao         |
| Plugin      | Tool custom riêng         |

Câu dễ nhớ:

> Application Source Type cho Argo CD biết phải dùng công cụ nào để render manifest trước khi apply vào cluster.

Keyword:

```txt
source type
Helm
Kustomize
YAML
Jsonnet
plugin
render manifest
```

---

## 4. Target State

**Target State** là trạng thái mong muốn của application, được định nghĩa bằng file trong Git repository.

Ví dụ trong Git có manifest:

```yaml
replicas: 3
image: nginx:1.25
```

Thì target state là:

```txt
App phải chạy 3 replicas
Image phải là nginx:1.25
```

Câu dễ nhớ:

> Target State là trạng thái mà Git nói app nên chạy như thế nào.

Keyword:

```txt
target state
desired state
Git repository
manifest
source of truth
```

---

## 5. Live State

**Live State** là trạng thái thật đang chạy trong Kubernetes cluster.

Ví dụ cluster hiện tại đang có:

```txt
Deployment web đang chạy 2 replicas
Image hiện tại là nginx:1.24
Service đang expose port 80
Pod có 1 con CrashLoopBackOff
```

Đây là live state.

Câu dễ nhớ:

> Live State là thực tế trong cluster hiện tại đang chạy cái gì.

Keyword:

```txt
live state
running state
cluster state
Pod
Deployment
Service
Ingress
```

---

## 6. Sync Status

**Sync Status** cho biết live state có giống target state hay không.

Có 2 trạng thái quan trọng:

| Trạng thái    | Ý nghĩa                       |
| ------------- | ----------------------------- |
| **Synced**    | Live state giống target state |
| **OutOfSync** | Live state khác target state  |

Ví dụ Synced:

```txt
Git khai báo replicas = 3
Cluster cũng đang chạy replicas = 3

=> Synced
```

Ví dụ OutOfSync:

```txt
Git khai báo replicas = 3
Cluster đang chạy replicas = 5

=> OutOfSync
```

Câu dễ nhớ:

> Sync Status trả lời câu hỏi: cluster hiện tại có giống Git không?

Keyword:

```txt
sync status
Synced
OutOfSync
drift
target state
live state
```

---

## 7. Sync

**Sync** là quá trình đưa application về đúng target state.

Nói dễ hiểu:

> Sync là lúc Argo CD apply thay đổi vào Kubernetes để cluster giống với Git.

Ví dụ:

```txt
Git đổi image từ nginx:1.24 sang nginx:1.25
Argo CD thấy OutOfSync
Người dùng bấm Sync hoặc auto-sync chạy
Argo CD apply manifest mới
Cluster chạy nginx:1.25
```

Sync có thể là:

| Loại            | Ý nghĩa                          |
| --------------- | -------------------------------- |
| **Manual sync** | Người dùng bấm sync thủ công     |
| **Auto sync**   | Argo CD tự sync khi Git thay đổi |

Keyword:

```txt
sync
manual sync
auto sync
apply
desired state
target state
```

---

## 8. Sync Operation Status

**Sync Operation Status** cho biết lần sync đó thành công hay thất bại.

Ví dụ:

| Status        | Ý nghĩa                     |
| ------------- | --------------------------- |
| **Succeeded** | Sync thành công             |
| **Failed**    | Sync thất bại               |
| **Running**   | Đang sync                   |
| **Error**     | Có lỗi trong quá trình sync |

Ví dụ sync fail do:

```txt
YAML sai syntax
Image không tồn tại
Không đủ quyền RBAC
Namespace chưa tồn tại
CRD chưa được cài
Resource conflict
```

Câu dễ nhớ:

> Sync Status nói Git và cluster có giống nhau không. Sync Operation Status nói lần sync vừa rồi thành công hay thất bại.

Đây là điểm mentor rất dễ hỏi.

---

## 9. Refresh

**Refresh** là quá trình Argo CD lấy code mới nhất từ Git và so sánh với live state trong cluster.

Refresh không nhất thiết apply thay đổi ngay.

Refresh trả lời câu hỏi:

```txt
Git hiện tại có khác cluster không?
```

Còn Sync trả lời:

```txt
Hãy apply thay đổi để cluster giống Git.
```

So sánh:

| Khái niệm   | Ý nghĩa                    |
| ----------- | -------------------------- |
| **Refresh** | So sánh Git với cluster    |
| **Sync**    | Apply thay đổi vào cluster |

Ví dụ:

```txt
Refresh:
Argo CD kiểm tra Git và cluster
Phát hiện Git khác cluster
App chuyển sang OutOfSync

Sync:
Argo CD apply manifest mới
Cluster giống Git
App chuyển sang Synced
```

Keyword:

```txt
refresh
compare
diff
latest Git
live state
OutOfSync
```

---

## 10. Health

**Health** cho biết application có đang chạy đúng và phục vụ request được không.

Một số trạng thái Health thường gặp:

| Health          | Ý nghĩa                             |
| --------------- | ----------------------------------- |
| **Healthy**     | App/resource chạy ổn                |
| **Progressing** | Đang rollout hoặc đang tạo resource |
| **Degraded**    | App/resource có lỗi                 |
| **Missing**     | Resource không tồn tại              |
| **Unknown**     | Không xác định được trạng thái      |

Điểm cực kỳ quan trọng:

> Synced không có nghĩa là Healthy.

Ví dụ:

```txt
Git và cluster giống nhau
=> Synced

Nhưng Pod bị CrashLoopBackOff
=> Không Healthy, có thể là Degraded
```

Mentor có thể hỏi:

> App Synced nhưng không truy cập được thì sao?

Trả lời:

> Synced chỉ nói manifest trong cluster giống Git. App không truy cập được có thể do Health không tốt, ví dụ Pod crash, Service sai port, Ingress lỗi, readiness probe fail hoặc image pull lỗi. Cần kiểm tra `kubectl get pods`, `kubectl describe pod`, `kubectl logs`.

Keyword:

```txt
health
Healthy
Progressing
Degraded
Missing
Unknown
CrashLoopBackOff
ImagePullBackOff
readiness probe
```

---

## 11. Tool / Configuration Management Tool

**Tool** hoặc **Configuration Management Tool** là công cụ dùng để tạo manifest từ thư mục file.

Ví dụ:

```txt
Kustomize
Helm
Jsonnet
Plain YAML
```

Nói dễ hiểu:

> Tool là thứ Argo CD dùng để biến source trong Git thành Kubernetes manifest hoàn chỉnh.

Ví dụ Helm:

```txt
Chart + values.yaml
        ↓
Render
        ↓
deployment.yaml / service.yaml
```

Ví dụ Kustomize:

```txt
base + overlay
        ↓
Build
        ↓
manifest hoàn chỉnh
```

Keyword:

```txt
tool
configuration management tool
render
manifest
Helm
Kustomize
Jsonnet
YAML
```

---

## 12. Configuration Management Plugin

**Configuration Management Plugin** là tool custom do team tự định nghĩa.

Dùng khi app không dùng Helm/Kustomize/YAML tiêu chuẩn mà cần tool riêng để generate manifest.

Ví dụ:

```txt
Custom script
ytt
cue
helmfile
jsonnet custom wrapper
```

Câu dễ nhớ:

> Plugin là cách mở rộng Argo CD để dùng công cụ render manifest không có sẵn.

Keyword:

```txt
configuration management plugin
custom tool
custom render
manifest generation
```

---

## 13. So sánh các khái niệm dễ nhầm

### 13.1. Target State vs Live State

| Khái niệm        | Nằm ở đâu?         | Ý nghĩa                      |
| ---------------- | ------------------ | ---------------------------- |
| **Target State** | Git                | Trạng thái mong muốn         |
| **Live State**   | Kubernetes cluster | Trạng thái thực tế đang chạy |

Ví dụ:

```txt
Target State: Git nói replicas = 3
Live State: Cluster đang chạy replicas = 5

=> OutOfSync
```

---

### 13.2. Refresh vs Sync

| Khái niệm   | Làm gì?                  | Có apply thay đổi không? |
| ----------- | ------------------------ | ------------------------ |
| **Refresh** | So sánh Git với cluster  | Không                    |
| **Sync**    | Đưa cluster về giống Git | Có                       |

---

### 13.3. Sync Status vs Health

| Khái niệm       | Trả lời câu hỏi             |
| --------------- | --------------------------- |
| **Sync Status** | Cluster có giống Git không? |
| **Health**      | App có chạy ổn không?       |

Ví dụ quan trọng:

```txt
App Synced nhưng Degraded
=> Manifest đã đúng theo Git
=> Nhưng app vẫn lỗi runtime
```

---

### 13.4. Sync Status vs Sync Operation Status

| Khái niệm                 | Ý nghĩa                                        |
| ------------------------- | ---------------------------------------------- |
| **Sync Status**           | Trạng thái hiện tại của app có giống Git không |
| **Sync Operation Status** | Lần sync vừa rồi thành công hay thất bại       |

Ví dụ:

```txt
App đang OutOfSync
Bạn bấm Sync
Sync bị Failed do YAML sai

=> Sync Status: OutOfSync
=> Sync Operation Status: Failed
```

---

## 14. Bộ keyword quan trọng

```txt
Application
CRD
Application Source Type
Target State
Desired State
Live State
Sync Status
Synced
OutOfSync
Sync
Sync Operation Status
Refresh
Health
Healthy
Degraded
Tool
Configuration Management Tool
Configuration Management Plugin
Manifest
Helm
Kustomize
Jsonnet
GitOps
Source of Truth
```

---

## 15. Câu hỏi mentor có thể hỏi

### Câu 1: Application trong Argo CD là gì?

Trả lời:

> Application là một nhóm Kubernetes resources được định nghĩa bởi manifest. Trong Argo CD, Application là một CRD dùng để khai báo source Git, path manifest, target cluster và namespace deploy.

---

### Câu 2: Target State và Live State khác nhau thế nào?

Trả lời:

> Target State là trạng thái mong muốn được định nghĩa trong Git. Live State là trạng thái thực tế đang chạy trong Kubernetes cluster. Argo CD so sánh hai trạng thái này để biết app đang Synced hay OutOfSync.

---

### Câu 3: OutOfSync là gì?

Trả lời:

> OutOfSync là khi Live State trong cluster khác với Target State trong Git. Ví dụ Git khai báo replicas là 3 nhưng cluster đang chạy 5 replicas thì app sẽ OutOfSync.

---

### Câu 4: Refresh khác Sync như thế nào?

Trả lời:

> Refresh là quá trình Argo CD so sánh Git mới nhất với Live State trong cluster để tìm khác biệt. Sync là quá trình apply thay đổi vào cluster để đưa app về đúng Target State.

---

### Câu 5: Sync Status và Health khác nhau thế nào?

Trả lời:

> Sync Status cho biết cluster có giống Git không. Health cho biết app có chạy ổn không. Một app có thể Synced nhưng vẫn Degraded nếu Pod bị crash hoặc app không phục vụ request được.

---

### Câu 6: Sync Operation Status là gì?

Trả lời:

> Sync Operation Status cho biết lần sync vừa rồi thành công hay thất bại. Ví dụ sync có thể Failed do manifest sai, thiếu quyền RBAC, image không tồn tại hoặc namespace chưa có.

---

### Câu 7: Application Source Type là gì?

Trả lời:

> Application Source Type là loại công cụ Argo CD dùng để build hoặc render manifest từ source trong Git, ví dụ Helm, Kustomize, Jsonnet hoặc YAML thuần.

---

### Câu 8: App Synced nhưng không Healthy thì hiểu như thế nào?

Trả lời:

> Điều đó có nghĩa là manifest trong cluster đã giống với Git, nhưng app đang gặp lỗi runtime. Ví dụ Pod bị CrashLoopBackOff, image pull lỗi, readiness probe fail, Service sai port hoặc app không serve request được.

---

## 16. Bản ghi nhớ ngắn

Có thể học thuộc đoạn này:

> Trong Argo CD, Application là một CRD đại diện cho một nhóm Kubernetes resources. Target State là trạng thái mong muốn trong Git, còn Live State là trạng thái thật trong cluster. Argo CD refresh để so sánh hai trạng thái này. Nếu khác nhau thì app OutOfSync. Sync là quá trình đưa cluster về đúng Target State. Sync Status cho biết cluster có giống Git không, còn Health cho biết app có chạy ổn không.

Câu chốt:

```txt
Target State = Git muốn gì
Live State = Cluster đang chạy gì
Refresh = So sánh
Sync = Apply để giống Git
Sync Status = Có giống Git không
Health = App có chạy ổn không
```

---

## 17. Kết luận

Các core concepts này là nền tảng để hiểu Argo CD.

Điểm cần nhớ nhất:

```txt
Git là nơi định nghĩa Target State.
Kubernetes cluster là nơi có Live State.
Argo CD so sánh hai trạng thái này.
Nếu khác nhau thì app OutOfSync.
Sync là đưa cluster về đúng Git.
Health là kiểm tra app có chạy ổn không.
```

Khi mentor hỏi về Argo CD, nên nhấn mạnh:

1. Argo CD dùng Git làm source of truth.
2. Application là CRD đại diện cho app trong Argo CD.
3. Target State nằm trong Git, Live State nằm trong cluster.
4. Refresh là so sánh, Sync là apply.
5. Synced không đồng nghĩa với Healthy.
