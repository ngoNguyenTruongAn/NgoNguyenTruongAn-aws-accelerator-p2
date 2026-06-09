# W9-D1 — Understanding GitHub Actions

## 1. Tổng quan

**GitHub Actions** là nền tảng **CI/CD** của GitHub, giúp tự động hóa các quy trình như:

```txt
Build → Test → Scan → Package → Deploy
```

GitHub Actions không chỉ dùng cho DevOps. Nó còn có thể tự động hóa các việc trong repository, ví dụ:

```txt
Tự thêm label khi có issue mới
Tự chạy test khi có pull request
Tự deploy khi merge vào main
Tự build Docker image khi push code
```

Trong DevOps Cloud/AWS, GitHub Actions thường dùng để:

```txt
Test code
Build Docker image
Push image lên Amazon ECR
Chạy Terraform plan/apply
Update Kubernetes manifest
Trigger GitOps flow với Argo CD
```

---

## 2. Các thành phần chính của GitHub Actions

Flow tổng quát:

```txt
Event xảy ra
   ↓
Workflow được trigger
   ↓
Workflow chạy một hoặc nhiều Jobs
   ↓
Mỗi Job chạy trên một Runner
   ↓
Mỗi Job có nhiều Steps
   ↓
Step có thể chạy script hoặc gọi Action có sẵn
```

Ví dụ dễ hiểu:

```txt
Push code lên GitHub
   ↓
Workflow CI chạy
   ↓
Job test chạy trên ubuntu-latest
   ↓
Step 1: checkout code
Step 2: install dependencies
Step 3: run test
Step 4: build Docker image
```

---

## 3. Workflow là gì?

**Workflow** là một quy trình tự động được viết bằng file YAML.

Workflow nằm trong thư mục:

```txt
.github/workflows/
```

Ví dụ:

```txt
.github/workflows/ci.yml
.github/workflows/docker-build.yml
.github/workflows/deploy.yml
```

Một repository có thể có nhiều workflow khác nhau.

| Workflow           | Mục đích                   |
| ------------------ | -------------------------- |
| `ci.yml`           | Build và test pull request |
| `docker-build.yml` | Build Docker image         |
| `deploy.yml`       | Deploy khi tạo release     |
| `label-issue.yml`  | Tự động label issue        |

Câu dễ nhớ:

> Workflow là file YAML mô tả pipeline sẽ chạy khi có event xảy ra.

Keyword:

```txt
workflow
YAML
.github/workflows
automated process
manual trigger
schedule trigger
```

---

## 4. Event là gì?

**Event** là sự kiện kích hoạt workflow chạy.

Ví dụ event:

```txt
push
pull_request
issues
release
workflow_dispatch
schedule
repository_dispatch
```

Ví dụ:

```yaml
on: push
```

Nghĩa là workflow chạy khi có code được push.

```yaml
on: pull_request
```

Nghĩa là workflow chạy khi có pull request.

```yaml
on:
  schedule:
    - cron: "0 0 * * *"
```

Nghĩa là workflow chạy theo lịch.

```yaml
on: workflow_dispatch
```

Nghĩa là workflow có thể chạy thủ công bằng nút **Run workflow**.

Câu dễ nhớ:

> Event trả lời câu hỏi: khi nào workflow chạy?

Keyword:

```txt
event
trigger
push
pull_request
issues
release
schedule
workflow_dispatch
REST API
```

---

## 5. Job là gì?

**Job** là một nhóm các step trong workflow.

Một workflow có thể có một hoặc nhiều job.

Ví dụ:

```yaml
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - run: echo "Run tests"

  build:
    runs-on: ubuntu-latest
    steps:
      - run: echo "Build app"
```

Theo mặc định, các job không phụ thuộc nhau sẽ chạy **song song**.

Ví dụ:

```txt
job test frontend ┐
job test backend  ├── chạy song song
job security scan ┘
```

Nếu muốn job này chạy sau job kia, dùng `needs`.

Ví dụ:

```yaml
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - run: echo "Testing"

  build:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - run: echo "Building"
```

Nghĩa là job `build` chỉ chạy sau khi job `test` thành công.

Câu dễ nhớ:

> Job là một nhóm step chạy trên cùng một runner.

Keyword:

```txt
job
steps
runner
parallel
sequential
needs
dependency
matrix
```

---

## 6. Step là gì?

**Step** là từng bước nhỏ trong một job.

Mỗi step có thể là:

```txt
Một shell script
Hoặc một action có sẵn
```

Ví dụ step chạy command:

```yaml
- run: npm install
- run: npm test
```

Ví dụ step dùng action:

```yaml
- uses: actions/checkout@v6
```

Các step trong cùng một job chạy theo thứ tự từ trên xuống dưới.

Câu dễ nhớ:

> Step là từng hành động cụ thể trong job.

Keyword:

```txt
step
run
uses
script
shell command
action
```

---

## 7. Action là gì?

**Action** là một đoạn logic có sẵn, tái sử dụng được trong workflow.

Ví dụ action phổ biến:

```yaml
- uses: actions/checkout@v6
```

Action này dùng để clone source code của repository vào runner.

Một số action thường gặp trong DevOps:

```txt
actions/checkout
actions/setup-node
docker/login-action
docker/build-push-action
aws-actions/configure-aws-credentials
```

Action giúp không cần tự viết lại logic lặp đi lặp lại.

Ví dụ thay vì tự cấu hình AWS CLI phức tạp, có thể dùng:

```yaml
- uses: aws-actions/configure-aws-credentials@v4
```

Câu dễ nhớ:

> Action là block tái sử dụng để làm một task cụ thể trong workflow.

Keyword:

```txt
action
reusable
GitHub Marketplace
checkout
setup toolchain
cloud authentication
```

---

## 8. Runner là gì?

**Runner** là máy chủ dùng để chạy job.

Mỗi job chạy trên một runner riêng.

GitHub cung cấp runner mặc định:

```txt
Ubuntu Linux
Windows
macOS
```

Ví dụ:

```yaml
runs-on: ubuntu-latest
```

Nghĩa là job chạy trên máy ảo Ubuntu do GitHub cung cấp.

Có 2 loại runner chính:

| Loại runner              | Ý nghĩa                                                         |
| ------------------------ | --------------------------------------------------------------- |
| **GitHub-hosted runner** | Máy ảo do GitHub cung cấp                                       |
| **Self-hosted runner**   | Máy do mình tự quản lý, có thể nằm trong data center hoặc cloud |

Trong AWS thực tế, self-hosted runner có thể chạy trên:

```txt
EC2
EKS
ECS
Private subnet
Data center riêng
```

Câu dễ nhớ:

> Runner là nơi thực sự chạy command trong workflow.

Keyword:

```txt
runner
GitHub-hosted runner
self-hosted runner
ubuntu-latest
windows-latest
macos-latest
virtual machine
container
```

---

## 9. Matrix là gì?

**Matrix** cho phép chạy cùng một job nhiều lần với nhiều biến khác nhau.

Ví dụ test app trên nhiều version Node.js:

```yaml
strategy:
  matrix:
    node-version: [18, 20, 22]
```

Hoặc test trên nhiều OS:

```yaml
strategy:
  matrix:
    os: [ubuntu-latest, windows-latest, macos-latest]
```

Dễ hiểu:

```txt
Cùng một job test
Nhưng chạy trên Node 18
Chạy trên Node 20
Chạy trên Node 22
```

Keyword:

```txt
matrix
strategy
multiple versions
multiple OS
parallel testing
```

---

## 10. GitHub Actions trong flow AWS DevOps

Một flow thực tế với AWS + Kubernetes + Argo CD:

```txt
Developer tạo Pull Request
        ↓
GitHub Actions chạy CI
        ↓
Lint / Test / Build
        ↓
Merge vào main
        ↓
GitHub Actions build Docker image
        ↓
Push image lên Amazon ECR
        ↓
Update image tag trong manifest repo
        ↓
Argo CD phát hiện manifest thay đổi
        ↓
Argo CD sync vào Kubernetes cluster
```

Trong đó:

| Thành phần              | Vai trò                   |
| ----------------------- | ------------------------- |
| GitHub Actions          | CI, build/test/push image |
| Amazon ECR              | Lưu Docker image          |
| Kubernetes/EKS/minikube | Chạy app                  |
| Argo CD                 | GitOps CD, sync manifest  |
| Git repo                | Source of truth           |

---

## 11. GitHub-hosted runner vs Self-hosted runner

| Tiêu chí        | GitHub-hosted runner      | Self-hosted runner                         |
| --------------- | ------------------------- | ------------------------------------------ |
| Quản lý bởi ai? | GitHub                    | Mình/team                                  |
| Cài đặt         | Có sẵn                    | Tự cài                                     |
| Môi trường      | Chuẩn, reset mỗi lần chạy | Tùy chỉnh được                             |
| Phù hợp         | CI phổ thông              | Cần network riêng, tool riêng, quyền riêng |
| Ví dụ           | `ubuntu-latest`           | EC2 trong AWS                              |

Mentor có thể hỏi:

> Khi nào dùng self-hosted runner?

Trả lời:

> Khi cần môi trường đặc biệt, cần truy cập tài nguyên private trong VPC, cần phần cứng riêng, cần cài tool custom hoặc muốn kiểm soát network/security chặt hơn.

---

## 12. Bộ keyword quan trọng

### 12.1. Nhóm core concepts

```txt
Workflow
Event
Job
Step
Action
Runner
Matrix
```

### 12.2. Nhóm workflow file

```txt
.github/workflows
YAML
on
jobs
steps
runs-on
run
uses
needs
strategy
matrix
```

### 12.3. Nhóm trigger

```txt
push
pull_request
issues
release
schedule
workflow_dispatch
repository_dispatch
```

### 12.4. Nhóm runner

```txt
GitHub-hosted runner
Self-hosted runner
Ubuntu
Windows
macOS
Virtual machine
Container
```

### 12.5. Nhóm DevOps/AWS

```txt
CI/CD
Pipeline
Build
Test
Deploy
Docker image
Amazon ECR
AWS credentials
Kubernetes
Argo CD
GitOps
```

---

## 13. Câu hỏi mentor có thể hỏi

### Câu 1: GitHub Actions là gì?

Trả lời:

> GitHub Actions là nền tảng CI/CD của GitHub, giúp tự động hóa build, test, deploy và các workflow khác trong repository thông qua file YAML.

---

### Câu 2: Workflow là gì?

Trả lời:

> Workflow là một quy trình tự động được định nghĩa bằng file YAML trong thư mục `.github/workflows`. Nó chạy khi có event như push, pull request, schedule hoặc manual trigger.

---

### Câu 3: Event là gì?

Trả lời:

> Event là sự kiện kích hoạt workflow chạy, ví dụ push commit, mở pull request, tạo issue, tạo release, chạy thủ công hoặc chạy theo lịch.

---

### Câu 4: Job là gì?

Trả lời:

> Job là một nhóm các step trong workflow, chạy trên cùng một runner. Một workflow có thể có nhiều job và các job có thể chạy song song hoặc phụ thuộc nhau bằng `needs`.

---

### Câu 5: Step là gì?

Trả lời:

> Step là từng bước trong job. Step có thể chạy shell command bằng `run` hoặc gọi một action có sẵn bằng `uses`.

---

### Câu 6: Action là gì?

Trả lời:

> Action là một đoạn logic tái sử dụng được trong workflow, giúp thực hiện một task cụ thể như checkout code, setup Node.js, login Docker registry hoặc cấu hình AWS credentials.

---

### Câu 7: Runner là gì?

Trả lời:

> Runner là máy chủ hoặc máy ảo thực thi job. GitHub cung cấp runner Ubuntu, Windows, macOS, hoặc mình có thể tự host runner trên hạ tầng riêng như EC2.

---

### Câu 8: Jobs chạy song song hay tuần tự?

Trả lời:

> Mặc định các job không phụ thuộc nhau sẽ chạy song song. Nếu muốn job chạy sau job khác, dùng `needs` để khai báo dependency.

---

### Câu 9: Matrix dùng để làm gì?

Trả lời:

> Matrix dùng để chạy cùng một job nhiều lần với các biến khác nhau, ví dụ test app trên nhiều version Node.js hoặc nhiều hệ điều hành khác nhau.

---

### Câu 10: Khi nào dùng self-hosted runner?

Trả lời:

> Khi cần môi trường custom, cần truy cập tài nguyên private trong VPC, cần cài tool riêng, cần phần cứng đặc biệt hoặc muốn kiểm soát network/security tốt hơn.

---

## 14. Bản ghi nhớ ngắn

Có thể học thuộc đoạn này:

> GitHub Actions gồm các thành phần chính: workflow, event, job, step, action và runner. Workflow là file YAML nằm trong `.github/workflows`. Event là thứ kích hoạt workflow. Workflow gồm nhiều job. Job chạy trên runner và gồm nhiều step. Step có thể chạy command bằng `run` hoặc dùng action có sẵn bằng `uses`. Các job mặc định chạy song song, nhưng có thể phụ thuộc nhau bằng `needs`.

Câu chốt:

```txt
Event trigger Workflow
Workflow chứa Jobs
Job chạy trên Runner
Job gồm nhiều Steps
Step chạy Script hoặc Action
```

---

## 15. So sánh nhanh với Argo CD

| GitHub Actions            | Argo CD                           |
| ------------------------- | --------------------------------- |
| CI/CD automation platform | GitOps CD tool                    |
| Chạy workflow theo event  | Sync manifest theo Git            |
| Build/test/push image     | Deploy manifest vào Kubernetes    |
| Dùng runner               | Chạy như controller trong cluster |
| Có thể deploy trực tiếp   | Nên để Argo CD deploy theo GitOps |

Câu mentor nên trả lời:

> Trong GitOps, GitHub Actions nên lo phần CI như test, build image, push image và cập nhật manifest. Argo CD sẽ lo phần CD bằng cách sync manifest từ Git vào Kubernetes cluster.

---

## 16. Kết luận

GitHub Actions là phần quan trọng trong W9 vì nó giúp tự động hóa CI/CD pipeline trước khi Argo CD sync manifest.

Điểm cần nhớ nhất:

```txt
Workflow nằm trong .github/workflows
Workflow viết bằng YAML
Event là thứ trigger workflow
Job chạy trên runner
Step là từng lệnh hoặc action
Action là logic tái sử dụng
Runner là máy thực thi job
```

Khi mentor hỏi về GitHub Actions, nên nhấn mạnh:

1. Workflow là pipeline tự động.
2. Event là thứ kích hoạt workflow.
3. Job là nhóm step chạy trên runner.
4. Step có thể dùng `run` hoặc `uses`.
5. GitHub Actions thường lo CI, còn Argo CD lo GitOps CD.
