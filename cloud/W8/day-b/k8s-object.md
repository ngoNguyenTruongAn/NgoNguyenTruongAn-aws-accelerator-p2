# Kubernetes Notes — Objects in Kubernetes

## 1. Kubernetes Object là gì?

Kubernetes object là các thực thể bền vững trong hệ thống Kubernetes.

Kubernetes dùng object để biểu diễn trạng thái của cluster.

Ví dụ object có thể mô tả:

* Ứng dụng container nào đang chạy
* Ứng dụng chạy trên node nào
* Ứng dụng cần bao nhiêu replica
* Ứng dụng dùng image nào
* Ứng dụng cần tài nguyên CPU/RAM nào
* Chính sách restart, upgrade, fault tolerance
* Config, secret, network, storage liên quan đến workload

Nói dễ hiểu:

```txt
Kubernetes object là bản ghi mô tả thứ mình muốn Kubernetes tạo và duy trì trong cluster.
```

Ví dụ các Kubernetes object thường gặp:

```txt
Pod
Deployment
Service
ConfigMap
Secret
Namespace
ReplicaSet
StatefulSet
Job
CronJob
Ingress
```

Câu nhớ:

```txt
Kubernetes Object = record of intent.
```

Nghĩa là khi tạo object, ta đang nói với Kubernetes rằng:

```txt
Tôi muốn cluster có trạng thái như thế này.
```

---

## 2. Object là “record of intent” nghĩa là gì?

Kubernetes object được gọi là **record of intent** vì nó ghi lại ý định mong muốn của người dùng.

Ví dụ bạn tạo Deployment với:

```txt
replicas: 3
image: nginx:1.27
```

Nghĩa là bạn nói với Kubernetes:

```txt
Tôi muốn luôn có 3 Pod chạy image nginx:1.27.
```

Sau khi object được tạo, Kubernetes control plane sẽ liên tục làm việc để đảm bảo object đó tồn tại và trạng thái thật của cluster khớp với trạng thái mong muốn.

Nếu một Pod chết, Kubernetes sẽ tạo Pod mới để đưa hệ thống về lại desired state.

Câu nhớ:

```txt
Tạo object = khai báo mong muốn.
Kubernetes = liên tục đưa actual state về desired state.
```

---

## 3. Desired State là gì?

**Desired state** là trạng thái mong muốn mà người dùng khai báo cho Kubernetes.

Desired state thường nằm trong phần `spec` của object.

Ví dụ:

```yaml
spec:
  replicas: 3
```

Nghĩa là:

```txt
Tôi muốn có 3 replica.
```

Hoặc:

```yaml
containers:
  - name: nginx
    image: nginx:1.27
```

Nghĩa là:

```txt
Tôi muốn container chạy image nginx:1.27.
```

Câu nhớ:

```txt
Desired state = trạng thái mong muốn do người dùng khai báo.
```

---

## 4. Actual State là gì?

**Actual state** là trạng thái thực tế hiện tại của cluster.

Ví dụ:

```txt
Desired state: 3 Pods
Actual state: 2 Pods đang chạy vì 1 Pod bị lỗi
```

Kubernetes sẽ phát hiện sự khác biệt này và tạo thêm Pod mới.

Câu nhớ:

```txt
Actual state = trạng thái thật hiện tại của cluster.
```

---

## 5. Spec và Status

Hầu hết Kubernetes object có 2 phần quan trọng:

```txt
spec
status
```

## 5.1. spec là gì?

`spec` là phần mô tả **desired state** của object.

Người dùng khai báo `spec` khi tạo object.

Ví dụ Deployment:

```yaml
spec:
  replicas: 2
  template:
    spec:
      containers:
        - name: nginx
          image: nginx:1.14.2
```

Ý nghĩa:

```txt
Tôi muốn Deployment chạy 2 Pod nginx.
```

Câu nhớ:

```txt
spec = trạng thái mong muốn.
```

---

## 5.2. status là gì?

`status` là phần mô tả **current state / actual state** của object.

Phần này không phải do người dùng tự khai báo chính, mà do Kubernetes system và các component cập nhật.

Ví dụ Deployment có thể có status như:

```txt
availableReplicas: 2
readyReplicas: 2
updatedReplicas: 2
```

Ý nghĩa:

```txt
Hiện tại có bao nhiêu replica đang chạy, ready, updated.
```

Câu nhớ:

```txt
status = trạng thái hiện tại do Kubernetes cập nhật.
```

---

## 6. Spec và Status hoạt động cùng nhau như thế nào?

Kubernetes control plane liên tục so sánh:

```txt
spec   = trạng thái mong muốn
status = trạng thái hiện tại
```

Nếu hai trạng thái khác nhau, Kubernetes sẽ điều chỉnh cluster.

Ví dụ:

```txt
spec.replicas = 3
status.readyReplicas = 2
```

Kubernetes hiểu rằng còn thiếu 1 replica, nên sẽ tạo thêm Pod mới.

Câu nhớ quan trọng:

```txt
Kubernetes continuously reconciles status toward spec.
```

Hoặc nói dễ hơn:

```txt
Kubernetes liên tục đưa trạng thái thật về trạng thái mong muốn.
```

---

## 7. Làm việc với Kubernetes Object bằng gì?

Để tạo, sửa, xóa Kubernetes object, ta phải dùng Kubernetes API.

Có 3 cách phổ biến:

```txt
kubectl
manifest YAML/JSON
client libraries
```

Trong thực tế học/lab, thường dùng:

```bash
kubectl apply -f file.yaml
```

Khi bạn dùng `kubectl`, phía sau `kubectl` sẽ gọi Kubernetes API đến `kube-apiserver`.

Luồng đơn giản:

```txt
kubectl apply -f web.yaml
→ kubectl gửi request đến kube-apiserver
→ kube-apiserver validate request
→ state được lưu vào etcd
→ control plane điều chỉnh cluster theo spec
```

Câu nhớ:

```txt
kubectl là CLI gọi Kubernetes API giúp người dùng làm việc với object.
```

---

## 8. Manifest là gì?

Manifest là file mô tả Kubernetes object.

Manifest thường được viết bằng YAML.

Ví dụ:

```txt
web.yaml
deployment.yaml
service.yaml
configmap.yaml
secret.yaml
```

Khi chạy:

```bash
kubectl apply -f web.yaml
```

`kubectl` sẽ đọc file YAML, chuyển thành request gửi đến Kubernetes API.

Câu nhớ:

```txt
Manifest = file YAML/JSON mô tả Kubernetes object.
```

---

## 9. Các field bắt buộc trong manifest

Một Kubernetes manifest thường cần 4 field quan trọng:

```yaml
apiVersion:
kind:
metadata:
spec:
```

## 9.1. apiVersion

`apiVersion` cho biết version của Kubernetes API dùng để tạo object.

Ví dụ:

```yaml
apiVersion: apps/v1
```

Deployment dùng:

```yaml
apiVersion: apps/v1
```

Pod thường dùng:

```yaml
apiVersion: v1
```

Câu nhớ:

```txt
apiVersion = dùng API version nào để tạo object.
```

---

## 9.2. kind

`kind` cho biết loại object muốn tạo.

Ví dụ:

```yaml
kind: Deployment
```

Một số kind thường gặp:

```txt
Pod
Deployment
Service
ConfigMap
Secret
Namespace
Job
CronJob
StatefulSet
```

Câu nhớ:

```txt
kind = loại object muốn tạo.
```

---

## 9.3. metadata

`metadata` chứa thông tin định danh object.

Thông tin quan trọng nhất là:

```yaml
metadata:
  name: nginx-deployment
```

Metadata có thể chứa:

```txt
name
namespace
labels
annotations
UID
```

Câu nhớ:

```txt
metadata = thông tin nhận diện object.
```

---

## 9.4. spec

`spec` mô tả desired state của object.

Ví dụ với Deployment:

```yaml
spec:
  replicas: 2
```

Ý nghĩa:

```txt
Tôi muốn Deployment có 2 replicas.
```

Cấu trúc `spec` khác nhau tùy từng loại object.

Ví dụ:

* Pod spec mô tả container image, port, env, volume
* Deployment spec mô tả selector, replicas, Pod template
* Service spec mô tả port, targetPort, selector
* StatefulSet spec mô tả replicas, volumeClaimTemplates, serviceName

Câu nhớ:

```txt
spec = trạng thái mong muốn của object.
```

---

## 10. Ví dụ Deployment manifest

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  selector:
    matchLabels:
      app: nginx
  replicas: 2
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
        - name: nginx
          image: nginx:1.14.2
          ports:
            - containerPort: 80
```

Giải thích:

```txt
apiVersion: apps/v1
→ dùng API group apps/v1 để tạo Deployment.

kind: Deployment
→ loại object là Deployment.

metadata.name: nginx-deployment
→ tên object là nginx-deployment.

spec.replicas: 2
→ muốn chạy 2 Pod.

spec.selector.matchLabels.app: nginx
→ Deployment quản lý các Pod có label app=nginx.

spec.template
→ template để Deployment tạo Pod.

template.metadata.labels.app: nginx
→ Pod được tạo sẽ có label app=nginx.

template.spec.containers
→ danh sách container trong Pod.

image: nginx:1.14.2
→ container chạy image nginx version 1.14.2.

containerPort: 80
→ container expose port 80.
```

---

## 11. Vì sao Deployment có selector và template?

Deployment không trực tiếp chạy container.

Deployment tạo ReplicaSet, ReplicaSet tạo Pod.

Để biết Pod nào thuộc Deployment, Kubernetes dùng label selector.

Trong ví dụ:

```yaml
selector:
  matchLabels:
    app: nginx
```

Deployment sẽ quản lý các Pod có label:

```yaml
labels:
  app: nginx
```

Vì vậy trong Deployment, `selector.matchLabels` và `template.metadata.labels` phải khớp nhau.

Câu nhớ:

```txt
selector dùng để chọn Pod.
template dùng để mô tả Pod sẽ được tạo.
```

---

## 12. kubectl apply

Tạo object từ manifest:

```bash
kubectl apply -f deployment.yaml
```

Nếu object chưa tồn tại:

```txt
Kubernetes sẽ tạo mới.
```

Nếu object đã tồn tại:

```txt
Kubernetes sẽ cập nhật theo manifest.
```

Câu nhớ:

```txt
kubectl apply dùng để khai báo hoặc cập nhật desired state từ file YAML.
```

---

## 13. Server-side field validation

Kubernetes API server có thể kiểm tra field trong object.

Nó giúp phát hiện:

```txt
field không hợp lệ
field bị viết sai tên
field bị duplicate
```

`kubectl` có flag:

```bash
kubectl apply -f file.yaml --validate=true
```

Các mức validate:

```txt
strict = lỗi thì reject request
warn   = chỉ cảnh báo
ignore = không validate server-side
```

Mặc định `kubectl` thường validate ở mức strict/true.

Ví dụ nếu viết sai:

```yaml
replica: 2
```

thay vì:

```yaml
replicas: 2
```

Kubernetes có thể báo lỗi hoặc cảnh báo vì field không hợp lệ.

Câu nhớ:

```txt
Field validation giúp phát hiện YAML sai field trước khi object được tạo/cập nhật.
```

---

## 14. Object liên quan gì đến desired state?

Toàn bộ cách Kubernetes hoạt động xoay quanh object và desired state.

Ví dụ:

```yaml
kind: Deployment
spec:
  replicas: 3
```

Bạn không ra lệnh từng bước:

```txt
Tạo Pod 1
Tạo Pod 2
Tạo Pod 3
Nếu Pod chết thì tạo lại
```

Bạn chỉ khai báo:

```txt
Tôi muốn 3 replicas.
```

Kubernetes tự duy trì trạng thái đó.

Câu nhớ:

```txt
Kubernetes là declarative system: khai báo mong muốn, hệ thống tự điều chỉnh.
```

---

## 15. Câu hỏi ôn tập

1. Kubernetes object là gì?
2. Vì sao Kubernetes object được gọi là persistent entity?
3. Kubernetes object mô tả những gì trong cluster?
4. Object là “record of intent” nghĩa là gì?
5. Desired state là gì?
6. Actual state là gì?
7. `spec` là gì?
8. `status` là gì?
9. Ai cập nhật `status` của object?
10. Control plane dùng `spec` và `status` như thế nào?
11. Manifest là gì?
12. Manifest thường viết bằng định dạng gì?
13. 4 field quan trọng trong manifest là gì?
14. `apiVersion` dùng để làm gì?
15. `kind` dùng để làm gì?
16. `metadata` chứa gì?
17. `spec` chứa gì?
18. `kubectl apply -f` dùng để làm gì?
19. Deployment object dùng để làm gì?
20. Trong Deployment, `replicas` nghĩa là gì?
21. Trong Deployment, `selector` dùng để làm gì?
22. Trong Deployment, `template` dùng để làm gì?
23. Vì sao `selector.matchLabels` phải khớp với `template.metadata.labels`?
24. Server-side field validation dùng để làm gì?
25. Nếu `spec.replicas = 3` nhưng chỉ còn 2 Pod chạy, Kubernetes sẽ làm gì?

---

## 16. Câu trả lời ngắn cho mentor

### Kubernetes Object là gì?

Kubernetes object là thực thể bền vững trong Kubernetes dùng để biểu diễn trạng thái của cluster. Object mô tả workload, resource, policy và desired state mà người dùng muốn Kubernetes duy trì.

### Vì sao object được gọi là record of intent?

Vì khi tạo object, người dùng đang ghi lại ý định mong muốn cho cluster. Sau đó Kubernetes sẽ liên tục làm việc để đảm bảo object tồn tại và actual state khớp với desired state.

### Spec là gì?

`spec` là phần mô tả desired state của object. Người dùng khai báo spec để nói Kubernetes muốn object có trạng thái như thế nào.

### Status là gì?

`status` là phần mô tả trạng thái hiện tại của object. Kubernetes system và control plane cập nhật status dựa trên trạng thái thật của cluster.

### Manifest là gì?

Manifest là file YAML hoặc JSON mô tả Kubernetes object. Thường dùng YAML và apply bằng lệnh `kubectl apply -f`.

### Các field bắt buộc trong manifest là gì?

Các field quan trọng gồm `apiVersion`, `kind`, `metadata` và `spec`.

### apiVersion là gì?

`apiVersion` cho biết version của Kubernetes API dùng để tạo object.

### kind là gì?

`kind` cho biết loại object muốn tạo, ví dụ Pod, Deployment, Service, ConfigMap hoặc Secret.

### metadata là gì?

`metadata` chứa thông tin nhận diện object như name, namespace, labels, annotations và UID.

### spec là gì?

`spec` mô tả trạng thái mong muốn của object. Mỗi loại object có cấu trúc spec khác nhau.

### kubectl apply dùng để làm gì?

`kubectl apply -f` dùng để tạo hoặc cập nhật Kubernetes object từ manifest YAML.

### Deployment selector và template dùng để làm gì?

`selector` dùng để chọn các Pod mà Deployment quản lý. `template` mô tả Pod sẽ được Deployment tạo ra. Label trong selector phải khớp với label trong template để Deployment quản lý đúng Pod.


# Kubernetes Notes — Object Management

## 1. Kubernetes Object Management là gì?

Kubernetes Object Management là cách dùng `kubectl` để tạo, cập nhật, xóa và quản lý Kubernetes objects trong cluster.

Kubernetes hỗ trợ nhiều cách quản lý object khác nhau, ví dụ:

* Imperative commands
* Imperative object configuration
* Declarative object configuration

Câu nhớ:

```txt
Object Management = cách quản lý Kubernetes objects bằng kubectl.
```

---

## 2. Lưu ý quan trọng: không nên trộn nhiều cách quản lý cho cùng một object

Kubernetes khuyến cáo:

```txt
Một Kubernetes object chỉ nên được quản lý bằng một kỹ thuật.
```

Không nên cùng lúc dùng nhiều cách khác nhau cho cùng một object.

Ví dụ không nên làm như sau cho cùng Deployment `web`:

```bash
kubectl create deployment web --image=nginx
kubectl apply -f web.yaml
kubectl replace -f web.yaml
kubectl edit deployment web
```

Lý do:

```txt
Trộn nhiều cách quản lý có thể làm trạng thái object khó dự đoán.
```

Câu nhớ:

```txt
One object should be managed using one technique.
```

---

# 3. Ba kỹ thuật quản lý Kubernetes object

Kubernetes có 3 nhóm kỹ thuật chính:

```txt
1. Imperative commands
2. Imperative object configuration
3. Declarative object configuration
```

So sánh nhanh:

| Kỹ thuật                         | Làm việc trên           | Phù hợp                    | Độ khó     |
| -------------------------------- | ----------------------- | -------------------------- | ---------- |
| Imperative commands              | Live objects            | Development / one-off task | Thấp nhất  |
| Imperative object configuration  | File YAML/JSON riêng lẻ | Production nhỏ / đơn giản  | Trung bình |
| Declarative object configuration | Thư mục nhiều file YAML | Production / GitOps        | Cao hơn    |

---

# 4. Imperative Commands

## 4.1. Imperative command là gì?

Imperative command là cách dùng `kubectl` để thao tác trực tiếp lên object đang sống trong cluster.

Người dùng chỉ định hành động trực tiếp qua command và flags.

Ví dụ:

```bash
kubectl create deployment nginx --image=nginx
```

Lệnh trên nghĩa là:

```txt
Tạo Deployment tên nginx chạy image nginx.
```

Đây là cách nhanh nhất để bắt đầu hoặc làm việc thử nghiệm.

Câu nhớ:

```txt
Imperative command = ra lệnh trực tiếp cho cluster bằng kubectl.
```

---

## 4.2. Khi nào dùng Imperative Commands?

Dùng khi:

* Học Kubernetes
* Test nhanh
* Debug nhanh
* Làm one-off task
* Tạo object tạm thời

Ví dụ:

```bash
kubectl run hello --image=nginx:1.27 --port=80
kubectl create deployment web --image=nginx
kubectl expose deployment web --port=80 --type=NodePort
kubectl delete pod hello
```

---

## 4.3. Ưu điểm của Imperative Commands

Ưu điểm:

```txt
- Nhanh
- Dễ học
- Ít bước
- Phù hợp test nhanh
- Không cần viết YAML
```

Ví dụ chỉ cần một dòng:

```bash
kubectl create deployment nginx --image=nginx
```

---

## 4.4. Nhược điểm của Imperative Commands

Nhược điểm:

```txt
- Không có file cấu hình lưu lại
- Khó review thay đổi
- Không có audit trail rõ ràng qua Git
- Không có template để tái tạo object
- Không phù hợp production lâu dài
```

Nếu chỉ tạo bằng command, sau này người khác khó biết object đó được tạo với cấu hình ban đầu như thế nào.

Câu nhớ:

```txt
Imperative commands nhanh nhưng không tốt cho quản lý lâu dài.
```

---

# 5. Imperative Object Configuration

## 5.1. Imperative object configuration là gì?

Imperative object configuration là cách dùng `kubectl` với một file YAML/JSON, nhưng người dùng vẫn chỉ định rõ hành động cần làm.

Ví dụ:

```bash
kubectl create -f nginx.yaml
```

```bash
kubectl replace -f nginx.yaml
```

```bash
kubectl delete -f nginx.yaml
```

Ở đây:

```txt
YAML mô tả object.
Command chỉ định hành động: create, replace, delete.
```

Câu nhớ:

```txt
Imperative object configuration = dùng file YAML nhưng vẫn ra lệnh rõ create/replace/delete.
```

---

## 5.2. Ví dụ

Tạo object từ file:

```bash
kubectl create -f nginx.yaml
```

Xóa object từ nhiều file:

```bash
kubectl delete -f nginx.yaml -f redis.yaml
```

Ghi đè object đang tồn tại bằng file:

```bash
kubectl replace -f nginx.yaml
```

---

## 5.3. Ưu điểm so với Imperative Commands

Ưu điểm:

```txt
- Có file YAML để lưu lại cấu hình
- Có thể đưa file vào Git
- Dễ review thay đổi
- Có audit trail qua Git
- Có template để tạo lại object
```

So với việc chỉ gõ command, YAML giúp quản lý cấu hình rõ hơn.

---

## 5.4. Nhược điểm so với Imperative Commands

Nhược điểm:

```txt
- Cần biết cấu trúc object schema
- Cần viết YAML
- Mất thêm bước chuẩn bị file
```

---

## 5.5. Nhược điểm so với Declarative Object Configuration

Lệnh `replace` có thể nguy hiểm vì nó thay thế spec hiện tại bằng file mới.

Nếu object thật trong cluster có field được cập nhật bởi hệ thống khác nhưng file YAML không có field đó, lần `replace` tiếp theo có thể làm mất thay đổi đó.

Ví dụ:

```bash
kubectl replace -f nginx.yaml
```

Lệnh này không phải patch nhẹ, mà thay thế object theo file cung cấp.

Câu nhớ:

```txt
replace có thể làm mất thay đổi live object nếu file YAML không chứa đầy đủ field.
```

---

# 6. Declarative Object Configuration

## 6.1. Declarative object configuration là gì?

Declarative object configuration là cách khai báo desired state trong file YAML, sau đó dùng `kubectl apply`.

Người dùng không cần chỉ rõ là create hay update. `kubectl apply` sẽ tự xác định object cần tạo mới, cập nhật hoặc patch.

Ví dụ:

```bash
kubectl apply -f nginx.yaml
```

Hoặc apply cả thư mục:

```bash
kubectl apply -f configs/
```

Câu nhớ:

```txt
Declarative = khai báo trạng thái mong muốn, kubectl tự quyết định create/update/patch.
```

---

## 6.2. Ví dụ

Xem trước khác biệt:

```bash
kubectl diff -f configs/
```

Apply toàn bộ file trong thư mục:

```bash
kubectl apply -f configs/
```

Apply đệ quy các thư mục con:

```bash
kubectl apply -R -f configs/
```

---

## 6.3. Ưu điểm

Ưu điểm:

```txt
- Phù hợp production
- Phù hợp GitOps
- Quản lý được nhiều file trong thư mục
- Tự phát hiện create/update/patch
- Giữ lại một số thay đổi live object do writer khác tạo ra
- Dễ review qua Git
- Dễ tái tạo môi trường
```

Đây là cách thường được khuyến nghị cho production.

---

## 6.4. Nhược điểm

Nhược điểm:

```txt
- Khó hiểu hơn với người mới
- Khi kết quả bất ngờ thì debug khó hơn
- Patch/merge có thể phức tạp
```

---

# 7. So sánh create, replace, apply

## 7.1. kubectl create

```bash
kubectl create -f nginx.yaml
```

Ý nghĩa:

```txt
Tạo object mới từ file.
Nếu object đã tồn tại thì thường báo lỗi.
```

Dùng khi chắc chắn object chưa tồn tại.

---

## 7.2. kubectl replace

```bash
kubectl replace -f nginx.yaml
```

Ý nghĩa:

```txt
Thay thế object hiện tại bằng nội dung trong file.
```

Rủi ro:

```txt
Có thể làm mất field đang tồn tại trên live object nhưng không có trong file.
```

---

## 7.3. kubectl apply

```bash
kubectl apply -f nginx.yaml
```

Ý nghĩa:

```txt
Khai báo desired state.
Nếu object chưa có thì tạo.
Nếu object đã có thì cập nhật/patch.
```

Đây là cách phổ biến nhất khi làm việc với manifest YAML.

Câu nhớ:

```txt
create = tạo mới
replace = ghi đè
apply = khai báo desired state và patch
```

---

# 8. Imperative vs Declarative

## Imperative

Imperative nghĩa là bạn nói rõ hành động cần làm.

Ví dụ:

```bash
kubectl create deployment nginx --image=nginx
kubectl delete pod hello
```

Bạn đang nói:

```txt
Hãy tạo cái này.
Hãy xóa cái kia.
```

## Declarative

Declarative nghĩa là bạn khai báo trạng thái mong muốn.

Ví dụ:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx
spec:
  replicas: 3
```

Sau đó:

```bash
kubectl apply -f deployment.yaml
```

Bạn đang nói:

```txt
Tôi muốn cluster có Deployment nginx với 3 replicas.
```

Kubernetes sẽ tự điều chỉnh actual state về desired state.

Câu nhớ:

```txt
Imperative = làm gì.
Declarative = muốn trạng thái cuối cùng là gì.
```

---

# 9. Nên dùng cách nào?

## Khi học hoặc test nhanh

Dùng Imperative Commands:

```bash
kubectl run hello --image=nginx
kubectl create deployment web --image=nginx
```

Lý do:

```txt
Nhanh, dễ hiểu, ít YAML.
```

## Khi làm lab có evidence hoặc production

Nên dùng Declarative Object Configuration:

```bash
kubectl apply -f web.yaml
```

Lý do:

```txt
Có file YAML lưu trong Git.
Dễ review.
Dễ tái tạo.
Dễ làm evidence.
Phù hợp GitOps/production.
```

## Khi cần tạo/xóa theo file cụ thể

Có thể dùng Imperative Object Configuration:

```bash
kubectl create -f file.yaml
kubectl delete -f file.yaml
```

Nhưng với update, nên cẩn thận với `replace`.

---
# 11. Các lệnh quan trọng

## Imperative commands

```bash
kubectl run hello --image=nginx:1.27 --port=80
kubectl create deployment web --image=nginx:1.27
kubectl expose deployment web --port=80 --type=NodePort
kubectl delete pod hello
```

## Imperative object configuration

```bash
kubectl create -f web.yaml
kubectl replace -f web.yaml
kubectl delete -f web.yaml
```

## Declarative object configuration

```bash
kubectl diff -f web.yaml
kubectl apply -f web.yaml
kubectl apply -f configs/
kubectl apply -R -f configs/
```

---

# 12. Câu hỏi ôn tập

1. Kubernetes Object Management là gì?
2. Có những kỹ thuật quản lý object nào trong Kubernetes?
3. Vì sao không nên trộn nhiều kỹ thuật quản lý cho cùng một object?
4. Imperative command là gì?
5. Cho ví dụ imperative command.
6. Khi nào nên dùng imperative command?
7. Nhược điểm của imperative command là gì?
8. Imperative object configuration là gì?
9. `kubectl create -f` dùng để làm gì?
10. `kubectl replace -f` dùng để làm gì?
11. Rủi ro của `kubectl replace -f` là gì?
12. Declarative object configuration là gì?
13. `kubectl apply -f` dùng để làm gì?
14. `kubectl diff -f` dùng để làm gì?
15. `kubectl apply -R -f` dùng để làm gì?
16. `create`, `replace`, `apply` khác nhau như thế nào?
17. Imperative khác declarative như thế nào?
18. Cách nào phù hợp để test nhanh?
19. Cách nào phù hợp cho production/GitOps?
20. Trong lab, `kubectl create deployment web --image=nginx` thuộc kỹ thuật nào?
21. Trong lab, `kubectl apply -f web.yaml` thuộc kỹ thuật nào?
22. Vì sao declarative configuration phù hợp với Git?
23. Vì sao imperative command không có audit trail tốt?
24. Vì sao `apply` an toàn hơn `replace` trong nhiều trường hợp?
25. Nếu object đã tồn tại, `kubectl create -f` thường xảy ra gì?

---

# 13. Câu trả lời ngắn cho mentor

## Kubernetes Object Management là gì?

Kubernetes Object Management là các cách dùng `kubectl` để tạo, cập nhật, xóa và quản lý Kubernetes objects trong cluster.

## Kubernetes có những cách quản lý object nào?

Có 3 cách chính: imperative commands, imperative object configuration và declarative object configuration.

## Imperative command là gì?

Imperative command là cách thao tác trực tiếp lên live object bằng một lệnh `kubectl`, ví dụ `kubectl create deployment nginx --image=nginx`. Cách này nhanh, dễ học, phù hợp test nhanh nhưng không có file cấu hình để review hoặc tái sử dụng.

## Imperative object configuration là gì?

Imperative object configuration là cách dùng file YAML/JSON nhưng vẫn chỉ rõ hành động như `kubectl create -f`, `kubectl replace -f`, `kubectl delete -f`. Cách này có file cấu hình để lưu Git nhưng `replace` có thể ghi đè live object và làm mất thay đổi không có trong file.

## Declarative object configuration là gì?

Declarative object configuration là cách khai báo desired state trong file YAML và dùng `kubectl apply -f`. Người dùng không cần chỉ rõ create hay update, `kubectl` sẽ tự xác định cần tạo mới hay patch object.

## create, replace, apply khác nhau thế nào?

`create` dùng để tạo object mới và thường lỗi nếu object đã tồn tại. `replace` ghi đè object hiện tại bằng file mới. `apply` khai báo desired state, nếu object chưa có thì tạo, nếu đã có thì patch/cập nhật.

## Imperative khác declarative thế nào?

Imperative là ra lệnh làm hành động cụ thể, ví dụ tạo hoặc xóa object. Declarative là khai báo trạng thái mong muốn trong YAML, Kubernetes tự điều chỉnh actual state về desired state.

## Vì sao nên dùng declarative trong production?

Vì cấu hình được lưu trong Git, dễ review, audit, tái tạo môi trường, phù hợp CI/CD và GitOps. `kubectl apply` cũng hỗ trợ làm việc với thư mục nhiều file và tự xác định create/update/patch.

## Vì sao không nên trộn nhiều kỹ thuật cho cùng object?

Vì mỗi kỹ thuật quản lý object theo cách khác nhau. Trộn nhiều kỹ thuật có thể làm trạng thái object khó dự đoán, mất thay đổi hoặc gây hành vi không xác định.
