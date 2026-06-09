# W9-D1 — GitHub Actions Quickstart

## 1. GitHub Actions là gì?

**GitHub Actions** là nền tảng **CI/CD** của GitHub, cho phép tự động hóa các bước trong quy trình phát triển phần mềm như:

```txt
Build code
Test code
Scan code
Build Docker image
Push image lên registry
Deploy app
Tự động hóa task trong repository
```

Trong W9, GitHub Actions thường đóng vai trò **CI**, còn Argo CD đóng vai trò **CD/GitOps**.

Flow dễ hiểu:

```txt
Developer push code
        ↓
GitHub Actions chạy workflow
        ↓
Test / build / scan / build image
        ↓
Push Docker image lên registry
        ↓
Update manifest trong Git
        ↓
Argo CD sync manifest vào Kubernetes
```

Câu chốt:

> GitHub Actions giúp tự động hóa pipeline. Argo CD giúp sync trạng thái mong muốn từ Git vào Kubernetes.

---

## 2. GitHub Actions dùng để làm gì?

GitHub Actions có thể dùng cho nhiều việc:

| Nhóm              | Ý nghĩa                                          |
| ----------------- | ------------------------------------------------ |
| **CI**            | Build và test code khi có push hoặc pull request |
| **Deployment**    | Deploy app sau khi merge                         |
| **Automation**    | Tự động hóa task trong repo                      |
| **Code Scanning** | Scan bảo mật hoặc code quality                   |
| **Pages**         | Build và deploy GitHub Pages                     |

Ví dụ thực tế trong DevOps:

```txt
Push code lên GitHub
→ GitHub Actions tự chạy test
→ Nếu test pass thì build Docker image
→ Push image lên Amazon ECR
→ Update image tag trong manifest
→ Argo CD deploy vào Kubernetes
```

---

## 3. Workflow là gì?

**Workflow** là file YAML mô tả pipeline tự động.

Workflow phải nằm trong thư mục:

```txt
.github/workflows/
```

Ví dụ:

```txt
.github/workflows/github-actions-demo.yml
```

GitHub chỉ nhận workflow nếu file nằm đúng trong thư mục `.github/workflows`.

File workflow có thể dùng đuôi:

```txt
.yml
.yaml
```

Câu dễ nhớ:

> Workflow là file YAML định nghĩa GitHub Actions sẽ chạy khi nào, chạy ở đâu và chạy những bước nào.

---

## 4. Ví dụ workflow trong tài liệu

```yaml
name: GitHub Actions Demo
run-name: ${{ github.actor }} is testing out GitHub Actions 🚀

on: [push]

jobs:
  Explore-GitHub-Actions:
    runs-on: ubuntu-latest
    steps:
      - run: echo "🎉 The job was automatically triggered by a ${{ github.event_name }} event."
      - run: echo "🐧 This job is now running on a ${{ runner.os }} server hosted by GitHub!"
      - run: echo "🔎 The name of your branch is ${{ github.ref }} and your repository is ${{ github.repository }}."

      - name: Check out repository code
        uses: actions/checkout@v6

      - run: echo "💡 The ${{ github.repository }} repository has been cloned to the runner."
      - run: echo "🖥️ The workflow is now ready to test your code on the runner."

      - name: List files in the repository
        run: |
          ls ${{ github.workspace }}

      - run: echo "🍏 This job's status is ${{ job.status }}."
```

---

## 5. Giải thích các thành phần chính

## 5.1. `name`

`name` là tên của workflow.

```yaml
name: GitHub Actions Demo
```

Tên này sẽ hiển thị trong tab **Actions** của GitHub.

---

## 5.2. `run-name`

`run-name` là tên của một lần chạy workflow.

```yaml
run-name: ${{ github.actor }} is testing out GitHub Actions 🚀
```

`${{ github.actor }}` là người trigger workflow.

Ví dụ:

```txt
ngobap is testing out GitHub Actions 🚀
```

---

## 5.3. `on`

`on` khai báo sự kiện làm workflow chạy.

```yaml
on: [push]
```

Nghĩa là mỗi lần có code được push lên repository, workflow sẽ chạy.

Một số trigger thường gặp:

```yaml
on: [push]
```

```yaml
on:
  pull_request:
```

```yaml
on:
  push:
    branches:
      - main
```

Mentor có thể hỏi:

> Workflow chạy khi nào?

Trả lời:

> Workflow chạy khi có event được khai báo trong `on`, ví dụ `push`, `pull_request`, hoặc merge vào branch `main`.

---

## 5.4. `jobs`

`jobs` là danh sách công việc cần chạy trong workflow.

```yaml
jobs:
  Explore-GitHub-Actions:
```

Một workflow có thể có nhiều job, ví dụ:

```txt
test
build
docker-build
deploy
```

Câu dễ nhớ:

> Một workflow có thể có nhiều job, mỗi job là một nhóm công việc riêng.

---

## 5.5. `runs-on`

`runs-on` khai báo môi trường chạy job.

```yaml
runs-on: ubuntu-latest
```

Nghĩa là job sẽ chạy trên máy ảo Ubuntu do GitHub host.

Keyword cần nhớ:

```txt
runner
GitHub-hosted runner
ubuntu-latest
```

---

## 5.6. `steps`

`steps` là các bước nhỏ trong một job.

```yaml
steps:
  - run: echo "Hello"
```

Một job có nhiều step, chạy lần lượt từ trên xuống dưới.

Câu dễ nhớ:

> Job gồm nhiều step. Step là từng lệnh hoặc từng action cụ thể được chạy trên runner.

---

## 5.7. `run`

`run` dùng để chạy command trực tiếp trên runner.

```yaml
- run: echo "Hello GitHub Actions"
```

Ví dụ DevOps thực tế:

```yaml
- run: npm install
- run: npm test
- run: docker build -t my-app .
```

---

## 5.8. `uses`

`uses` dùng để gọi một action có sẵn.

```yaml
- name: Check out repository code
  uses: actions/checkout@v6
```

`actions/checkout` dùng để clone source code của repo vào runner.

Nếu không checkout code, runner có thể không có source code để build/test.

---

## 5.9. Context `${{ }}`

GitHub Actions dùng context để lấy thông tin runtime.

Ví dụ:

```yaml
${{ github.actor }}
${{ github.event_name }}
${{ github.ref }}
${{ github.repository }}
${{ runner.os }}
${{ github.workspace }}
${{ job.status }}
```

Ý nghĩa:

| Context             | Ý nghĩa                         |
| ------------------- | ------------------------------- |
| `github.actor`      | Người trigger workflow          |
| `github.event_name` | Event kích hoạt workflow        |
| `github.ref`        | Branch hoặc ref đang chạy       |
| `github.repository` | Tên repo                        |
| `runner.os`         | Hệ điều hành runner             |
| `github.workspace`  | Thư mục source code trên runner |
| `job.status`        | Trạng thái job                  |

---

## 6. Cách tạo workflow đầu tiên

Các bước cơ bản:

```txt
Repository trên GitHub
→ Tạo thư mục .github/workflows
→ Tạo file github-actions-demo.yml
→ Dán nội dung YAML workflow
→ Commit changes
→ Workflow tự chạy nếu event khớp
```

Lưu ý:

```txt
File workflow phải nằm trong .github/workflows
File phải có đuôi .yml hoặc .yaml
Commit workflow lên repo sẽ trigger nếu có on: [push]
```

---

## 7. Cách xem kết quả workflow

Sau khi commit file workflow, GitHub sẽ tự chạy workflow nếu event khớp.

Cách xem:

```txt
Repository
→ Actions tab
→ Chọn workflow
→ Chọn workflow run
→ Chọn job
→ Xem log từng step
```

Trong log, bạn sẽ thấy từng step chạy thành công hay thất bại.

Nếu workflow lỗi, cần mở step bị fail để xem log chi tiết.

---

## 8. GitHub Actions liên quan gì đến Argo CD?

Đây là điểm quan trọng trong W9.

GitHub Actions và Argo CD thường không làm cùng một việc.

| Công cụ            | Vai trò                                        |
| ------------------ | ---------------------------------------------- |
| **GitHub Actions** | CI: build, test, scan, build image, push image |
| **Argo CD**        | CD/GitOps: sync manifest từ Git vào Kubernetes |

Flow chuẩn:

```txt
Code repo
   ↓ push
GitHub Actions
   ↓ test/build
Docker image
   ↓ push
Amazon ECR / Docker Hub
   ↓ update image tag in manifest repo
Argo CD
   ↓ sync
Kubernetes cluster
```

Ví dụ trong AWS:

```txt
GitHub Actions build Docker image
→ Push image lên Amazon ECR
→ Update deployment.yaml image tag
→ Argo CD sync vào EKS/minikube
```

---

## 9. GitHub Actions có deploy trực tiếp vào Kubernetes được không?

Có thể deploy trực tiếp bằng GitHub Actions, ví dụ chạy:

```bash
kubectl apply -f k8s/
```

Tuy nhiên trong mô hình GitOps, nên hạn chế cách này.

Lý do:

```txt
GitHub Actions deploy trực tiếp
→ Dễ lệch Git với cluster
→ Khó audit theo GitOps
→ Khó rollback chuẩn bằng Git
```

Mô hình nên dùng trong W9:

```txt
GitHub Actions build/test/push image
→ Update manifest trong Git
→ Argo CD sync vào Kubernetes
```

Câu dễ nhớ:

> GitHub Actions lo CI. Argo CD lo CD/GitOps.

---

## 10. Workflow template là gì?

GitHub cung cấp sẵn nhiều **workflow templates** để tạo workflow nhanh.

Ví dụ template cho:

```txt
Node.js
Python
Java
Docker
Code scanning
GitHub Pages
Deployment
```

GitHub có thể phân tích repository và đề xuất template phù hợp.

Ví dụ repo có Node.js thì GitHub có thể gợi ý workflow cho Node.js.

---

## 11. Bộ keyword quan trọng

### 11.1. Nhóm GitHub Actions

```txt
GitHub Actions
Workflow
Job
Step
Runner
Action
Event
Trigger
Context
Log
```

---

### 11.2. Nhóm file workflow

```txt
.github/workflows
.yml
.yaml
github-actions-demo.yml
```

---

### 11.3. Nhóm CI/CD

```txt
CI
CD
Pipeline
Build
Test
Deploy
Automation
Code Scanning
Pull Request
Merge
Production
```

---

### 11.4. Nhóm YAML syntax

```txt
name
run-name
on
jobs
runs-on
steps
run
uses
```

---

### 11.5. Nhóm context

```txt
github.actor
github.event_name
github.ref
github.repository
runner.os
github.workspace
job.status
```

---

### 11.6. Nhóm DevOps AWS

```txt
Docker image
Container registry
Amazon ECR
Kubernetes
Argo CD
GitOps
Manifest
Image tag
```

---

## 12. Câu hỏi mentor có thể hỏi

### Câu 1: GitHub Actions là gì?

Trả lời:

> GitHub Actions là nền tảng CI/CD của GitHub, cho phép tự động hóa các bước build, test, scan và deploy thông qua workflow viết bằng YAML trong thư mục `.github/workflows`.

---

### Câu 2: Workflow file phải đặt ở đâu?

Trả lời:

> Workflow file phải nằm trong thư mục `.github/workflows` và có đuôi `.yml` hoặc `.yaml` thì GitHub mới nhận diện và chạy workflow.

---

### Câu 3: `on: [push]` nghĩa là gì?

Trả lời:

> Nghĩa là workflow sẽ được trigger mỗi khi có code được push lên repository hoặc branch phù hợp.

---

### Câu 4: `runs-on: ubuntu-latest` nghĩa là gì?

Trả lời:

> Nghĩa là job sẽ chạy trên một runner dùng hệ điều hành Ubuntu do GitHub cung cấp.

---

### Câu 5: `actions/checkout` dùng để làm gì?

Trả lời:

> `actions/checkout` dùng để checkout hoặc clone source code của repository vào runner, để các step sau có thể build, test hoặc đọc file trong repo.

---

### Câu 6: GitHub Actions và Argo CD khác nhau thế nào?

Trả lời:

> GitHub Actions thường xử lý CI như build, test, scan, build Docker image và push image lên registry. Argo CD xử lý CD/GitOps bằng cách theo dõi manifest trong Git và sync vào Kubernetes cluster.

---

### Câu 7: GitHub Actions có deploy trực tiếp vào Kubernetes được không?

Trả lời:

> Có thể, nhưng trong mô hình GitOps nên hạn chế deploy trực tiếp bằng GitHub Actions. Thay vào đó, GitHub Actions nên build/test/push image và cập nhật manifest trong Git, sau đó Argo CD sẽ sync manifest vào Kubernetes.

---

### Câu 8: Làm sao biết workflow chạy thành công hay thất bại?

Trả lời:

> Vào tab Actions trong repository, chọn workflow run, chọn job rồi xem log từng step. Nếu step nào lỗi, GitHub sẽ hiển thị trạng thái failed và log chi tiết.

---

### Câu 9: `run` và `uses` khác nhau như thế nào?

Trả lời:

> `run` dùng để chạy command trực tiếp trên runner, ví dụ `npm test` hoặc `docker build`. `uses` dùng để gọi một action có sẵn, ví dụ `actions/checkout`.

---

### Câu 10: Runner là gì?

Trả lời:

> Runner là môi trường máy ảo hoặc máy thật dùng để chạy job trong GitHub Actions. Ví dụ `ubuntu-latest` là GitHub-hosted runner chạy Ubuntu.

---

## 13. Bản ghi nhớ ngắn

Có thể học thuộc đoạn này:

> GitHub Actions là công cụ CI/CD của GitHub. Workflow được viết bằng YAML và đặt trong thư mục `.github/workflows`. Workflow chạy dựa trên event như `push` hoặc `pull_request`. Một workflow gồm nhiều job, mỗi job chạy trên runner và gồm nhiều step. Trong GitOps, GitHub Actions thường dùng để build/test/push Docker image, còn Argo CD dùng để sync manifest từ Git vào Kubernetes.

Câu chốt:

```txt
GitHub Actions = CI pipeline
Argo CD = GitOps CD

GitHub Actions build/test/push image
Argo CD sync manifest vào Kubernetes
```

---

## 14. Kết luận

GitHub Actions là phần quan trọng trong W9 vì nó giúp tự động hóa bước CI trước khi Argo CD deploy.

Điểm cần nhớ nhất:

```txt
Workflow nằm trong .github/workflows
Workflow viết bằng YAML
Workflow chạy theo event như push hoặc pull_request
Job chạy trên runner
Step là từng lệnh hoặc action
GitHub Actions thường lo build/test/push image
Argo CD lo sync manifest vào Kubernetes
```

Khi mentor hỏi về GitHub Actions, nên nhấn mạnh:

1. GitHub Actions là nền tảng CI/CD.
2. Workflow là file YAML trong `.github/workflows`.
3. Workflow chạy theo event được khai báo trong `on`.
4. Job chạy trên runner, step chạy từng lệnh/action.
5. Trong GitOps, GitHub Actions không nên thay thế Argo CD mà nên phối hợp với Argo CD.
