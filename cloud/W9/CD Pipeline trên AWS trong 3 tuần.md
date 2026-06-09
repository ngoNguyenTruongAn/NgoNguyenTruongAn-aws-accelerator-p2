# Kế hoạch phân task dự án CI/CD Pipeline trên AWS trong 3 tuần

## 1. Tổng quan dự án

### Bối cảnh

XBRAIN đang triển khai một hệ thống mới cho khách hàng doanh nghiệp. Team cần xây dựng một pipeline CI/CD hoàn chỉnh trên AWS, từ lúc developer push code lên GitHub cho đến khi hệ thống tự động build và deploy lên môi trường staging.

### Mục tiêu đầu ra

Sau 3 tuần, tương đương 15 ngày làm việc, team cần hoàn thành:

1. Một pipeline CI/CD end-to-end hoạt động được.
2. Tài liệu setup để các team khác có thể làm theo.
3. Một buổi demo 10 phút cho khách hàng.

### Stack yêu cầu

```text
GitHub Actions → AWS CodeBuild → Amazon ECR → Amazon ECS Fargate
```

### Ràng buộc

* Không được có quá 3 môi trường cùng lúc do giới hạn tài khoản AWS.
* Khách hàng muốn có demo vào cuối tuần 2, tức Day 10.
* Team có 5 người.
* Thời gian làm việc ước tính: khoảng 4 giờ/người/ngày.

---

# 2. Phân vai trong team

| Vai trò     | Trách nhiệm                                                                                |
| ----------- | ------------------------------------------------------------------------------------------ |
| PM / Leader | Điều phối team, chia task, quản lý timeline, theo dõi blocker, chuẩn bị demo flow          |
| Tech Lead   | Thiết kế kiến trúc kỹ thuật, review pipeline, hỗ trợ xử lý lỗi kỹ thuật                    |
| Dev 1       | Setup hạ tầng AWS như ECR, ECS Cluster, Task Definition, ECS Service, networking           |
| Dev 2       | Cấu hình CI/CD pipeline gồm GitHub Actions, CodeBuild, buildspec.yml, push ECR, deploy ECS |
| Doc / QA    | Viết tài liệu, tạo checklist test, thu thập evidence, chuẩn bị demo script                 |

---

# 3. Milestone dự án

## Milestone 1: Lập kế hoạch và thiết kế kiến trúc

**Thời gian:** Day 1 – Day 2
**Mục tiêu:** Hiểu rõ yêu cầu, phân vai, chuẩn bị Jira board và thiết kế kiến trúc ban đầu.

### Deliverables

* Phân tích yêu cầu dự án.
* Phân chia vai trò team.
* Jira board có epic và task rõ ràng.
* Sơ đồ kiến trúc ban đầu.
* GitHub repository được chuẩn bị.
* Chọn sample application để deploy.

---

## Milestone 2: Setup hạ tầng AWS

**Thời gian:** Day 3 – Day 5
**Mục tiêu:** Dựng các thành phần AWS cần thiết để app có thể chạy trên ECS Fargate.

### Deliverables

* Amazon ECR repository.
* ECS Cluster.
* ECS Task Definition.
* ECS Service.
* IAM roles và policies.
* Networking configuration.
* Application chạy được trên môi trường staging.

---

## Milestone 3: Xây dựng CI/CD Pipeline MVP

**Thời gian:** Day 6 – Day 8
**Mục tiêu:** Xây dựng pipeline hoạt động từ GitHub đến ECS Fargate.

### Deliverables

* GitHub Actions workflow.
* AWS CodeBuild project.
* File `buildspec.yml`.
* Docker image build process.
* Docker image được push lên ECR.
* ECS Service được update tự động.
* Pipeline MVP chạy end-to-end.

---

## Milestone 4: Chuẩn bị demo cho khách hàng

**Thời gian:** Day 9 – Day 10
**Mục tiêu:** Chuẩn bị và thực hiện demo cho khách hàng vào cuối tuần 2.

### Deliverables

* Pipeline end-to-end đã được test.
* Demo script hoàn chỉnh.
* Evidence screenshots/logs.
* Backup demo plan.
* Hoàn thành demo 10 phút cho khách hàng.

---

## Milestone 5: Ổn định hệ thống và hoàn thiện tài liệu

**Thời gian:** Day 11 – Day 13
**Mục tiêu:** Cải thiện độ ổn định của pipeline và hoàn thiện documentation.

### Deliverables

* Setup documentation.
* Troubleshooting guide.
* QA checklist.
* Rollback notes.
* Bổ sung evidence test.
* Pipeline ổn định hơn.

---

## Milestone 6: Chuẩn bị trình bày cuối

**Thời gian:** Day 14 – Day 15
**Mục tiêu:** Hoàn thiện sản phẩm, slide và demo cuối.

### Deliverables

* Slide trình bày cuối.
* Architecture diagram hoàn chỉnh.
* Final demo script.
* Lessons learned.
* Jira board ở trạng thái final.

---

# 4. Cấu trúc Jira Board đề xuất

Các cột nên dùng trên Jira:

```text
Backlog → To Do → In Progress → Review/Test → Done
```

Ý nghĩa:

| Cột         | Ý nghĩa                                       |
| ----------- | --------------------------------------------- |
| Backlog     | Task đã được ghi nhận nhưng chưa đưa vào làm  |
| To Do       | Task sẽ làm trong sprint/tuần hiện tại        |
| In Progress | Task đang được thực hiện                      |
| Review/Test | Task đã làm xong nhưng cần review hoặc test   |
| Done        | Task đã hoàn thành và đạt acceptance criteria |

---

# 5. Danh sách Epic và Task chi tiết

## Epic 1: Project Planning

### Task 1.1: Phân tích yêu cầu đề bài

**Assignee:** PM
**Priority:** High
**Estimate:** 2 giờ

#### Mô tả

Phân tích project brief, xác định mục tiêu, output, constraint, timeline và các rủi ro chính của dự án.

#### Acceptance Criteria

* Xác định được stack bắt buộc.
* Nắm rõ deadline demo Day 10.
* Ghi nhận giới hạn không quá 3 môi trường AWS.
* Liệt kê được các deliverables chính.

---

### Task 1.2: Tạo Jira Board

**Assignee:** PM
**Priority:** High
**Estimate:** 2 giờ

#### Mô tả

Tạo Jira board với đầy đủ epic, task, assignee, priority và timeline.

#### Acceptance Criteria

* Jira board có đầy đủ epic chính.
* Mỗi task có assignee rõ ràng.
* Mỗi task có priority và estimate.
* Milestone demo Day 10 được thể hiện rõ.

---

### Task 1.3: Phân chia vai trò trong team

**Assignee:** PM
**Priority:** Medium
**Estimate:** 1 giờ

#### Mô tả

Phân công trách nhiệm cho từng thành viên và thống nhất quy trình làm việc.

#### Acceptance Criteria

* Mỗi thành viên có vai trò rõ ràng.
* Có quy trình daily check-in.
* Có cách báo cáo blocker.

---

## Epic 2: Chuẩn bị ứng dụng mẫu

### Task 2.1: Chuẩn bị sample application

**Assignee:** Tech Lead / Dev 1
**Priority:** High
**Estimate:** 4 giờ

#### Mô tả

Chuẩn bị một ứng dụng mẫu đơn giản để deploy thông qua pipeline.

#### Acceptance Criteria

* App chạy được ở local.
* App có health check endpoint, ví dụ `/health`.
* Source code được push lên GitHub.

---

### Task 2.2: Tạo Dockerfile

**Assignee:** Dev 1
**Priority:** High
**Estimate:** 3 giờ

#### Mô tả

Tạo Dockerfile để containerize ứng dụng.

#### Acceptance Criteria

* Build Docker image local thành công.
* Run Docker container local thành công.
* App phản hồi đúng khi chạy trong container.

---

### Task 2.3: Thêm test command cơ bản

**Assignee:** Doc / QA
**Priority:** Medium
**Estimate:** 2 giờ

#### Mô tả

Thêm một lệnh test đơn giản để pipeline có thể chạy kiểm tra trước khi build hoặc deploy.

#### Acceptance Criteria

* Có test command trong project.
* Test pass ở local.
* Test có thể chạy trong CodeBuild.

---

## Epic 3: AWS Infrastructure

### Task 3.1: Tạo ECR Repository

**Assignee:** Dev 1
**Priority:** High
**Estimate:** 2 giờ

#### Mô tả

Tạo Amazon ECR repository để lưu Docker image.

#### Acceptance Criteria

* ECR repository được tạo.
* Có repository URI.
* IAM permission cho push/pull image được cấu hình đúng.

---

### Task 3.2: Tạo ECS Cluster

**Assignee:** Dev 1
**Priority:** High
**Estimate:** 3 giờ

#### Mô tả

Tạo ECS Cluster sử dụng Fargate launch type.

#### Acceptance Criteria

* ECS Cluster được tạo.
* Cluster sẵn sàng để tạo ECS Service.
* Sử dụng Fargate, không dùng EC2 launch type.

---

### Task 3.3: Tạo ECS Task Definition

**Assignee:** Dev 1
**Priority:** High
**Estimate:** 4 giờ

#### Mô tả

Tạo ECS Task Definition cho container application.

#### Acceptance Criteria

* Task Definition sử dụng image từ ECR.
* CPU và memory được cấu hình.
* Container port được cấu hình đúng.
* ECS execution role được gắn vào task.

---

### Task 3.4: Tạo ECS Service cho môi trường staging

**Assignee:** Dev 1
**Priority:** High
**Estimate:** 4 giờ

#### Mô tả

Tạo ECS Service để chạy application trên môi trường staging.

#### Acceptance Criteria

* ECS Service được tạo.
* Có ít nhất 1 task ở trạng thái RUNNING.
* ECS Service có thể update khi có image mới.

---

### Task 3.5: Cấu hình networking và Security Group

**Assignee:** Dev 1 / Tech Lead
**Priority:** High
**Estimate:** 4 giờ

#### Mô tả

Cấu hình networking và security group cho ECS Service và staging endpoint.

#### Acceptance Criteria

* Security Group mở đúng port cần thiết.
* ECS task có network configuration đúng.
* Application có thể truy cập được qua staging endpoint.

---

## Epic 4: CI/CD Pipeline

### Task 4.1: Cấu hình GitHub Actions trigger

**Assignee:** Dev 2
**Priority:** High
**Estimate:** 4 giờ

#### Mô tả

Tạo GitHub Actions workflow chạy khi có code được push lên branch được chọn.

#### Acceptance Criteria

* Workflow chạy khi push code.
* Workflow có thể trigger AWS CodeBuild.
* AWS credentials được lưu an toàn bằng GitHub Secrets.

---

### Task 4.2: Tạo CodeBuild Project

**Assignee:** Dev 2
**Priority:** High
**Estimate:** 4 giờ

#### Mô tả

Tạo AWS CodeBuild project để build Docker image.

#### Acceptance Criteria

* CodeBuild project được tạo.
* CodeBuild có IAM role phù hợp.
* Build logs hiển thị được trên AWS Console.

---

### Task 4.3: Viết file buildspec.yml

**Assignee:** Dev 2
**Priority:** High
**Estimate:** 5 giờ

#### Mô tả

Viết file `buildspec.yml` cho CodeBuild.

#### Expected Flow

```text
Login to ECR → Build Docker Image → Tag Image → Push Image to ECR → Update ECS Service
```

#### Acceptance Criteria

* Docker image được build thành công.
* Docker image được tag đúng.
* Docker image được push lên ECR.
* Lệnh update ECS Service chạy thành công.

---

### Task 4.4: Thêm bước deploy lên ECS

**Assignee:** Dev 2 / Tech Lead
**Priority:** High
**Estimate:** 4 giờ

#### Mô tả

Thêm bước deployment để cập nhật ECS Fargate sau khi image mới được push lên ECR.

#### Acceptance Criteria

* ECS Service tạo deployment mới.
* ECS Task mới sử dụng image mới nhất.
* Staging application phản ánh code mới sau khi deploy.

---

### Task 4.5: Test pipeline end-to-end

**Assignee:** Dev 2 / Doc QA
**Priority:** High
**Estimate:** 3 giờ

#### Mô tả

Test toàn bộ pipeline từ lúc push code lên GitHub đến khi ECS tự động deploy.

#### Acceptance Criteria

* Push code trigger GitHub Actions.
* GitHub Actions trigger CodeBuild.
* CodeBuild build và push image lên ECR.
* ECS deploy version mới.
* Staging endpoint hoạt động đúng.

---

## Epic 5: QA, Evidence và Demo

### Task 5.1: Tạo QA checklist

**Assignee:** Doc / QA
**Priority:** High
**Estimate:** 2 giờ

#### Mô tả

Tạo checklist để kiểm thử application và pipeline.

#### Acceptance Criteria

* Có checklist test application.
* Có checklist test pipeline.
* Có checklist cho các lỗi cơ bản.

---

### Task 5.2: Thu thập evidence

**Assignee:** Doc / QA
**Priority:** High
**Estimate:** 3 giờ

#### Mô tả

Thu thập screenshot và log cho các bước quan trọng trong pipeline.

#### Evidence cần có

* GitHub Actions success.
* CodeBuild success.
* Docker image trong ECR.
* ECS Service deployment.
* ECS Task running.
* Staging endpoint hoạt động.

---

### Task 5.3: Chuẩn bị demo script cho Day 10

**Assignee:** PM / Doc QA
**Priority:** High
**Estimate:** 3 giờ

#### Mô tả

Chuẩn bị kịch bản demo 10 phút cho khách hàng.

#### Demo Flow

```text
1. Giới thiệu bối cảnh dự án.
2. Giải thích kiến trúc CI/CD.
3. Thực hiện một thay đổi nhỏ trong code.
4. Push code lên GitHub.
5. Show GitHub Actions đang chạy.
6. Show CodeBuild build image.
7. Show image đã được push lên ECR.
8. Show ECS auto-deployment.
9. Mở staging endpoint để kiểm tra.
10. Tổng kết giá trị của pipeline.
```

#### Acceptance Criteria

* Demo script rõ ràng.
* Mỗi người biết phần mình cần trình bày.
* Backup screenshots đã sẵn sàng.
* Demo hoàn thành trong 10 phút.

---

## Epic 6: Documentation và Final Presentation

### Task 6.1: Viết Setup Guide

**Assignee:** Doc / QA
**Priority:** High
**Estimate:** 4 giờ

#### Mô tả

Viết tài liệu setup để các team khác có thể tái sử dụng và làm theo pipeline.

#### Acceptance Criteria

* Có danh sách prerequisites.
* Các AWS services được giải thích rõ.
* Các bước setup dễ hiểu.
* Các biến môi trường cần thiết được document.

---

### Task 6.2: Viết Troubleshooting Guide

**Assignee:** Doc / QA / Tech Lead
**Priority:** Medium
**Estimate:** 3 giờ

#### Mô tả

Ghi lại các lỗi thường gặp và cách xử lý.

#### Acceptance Criteria

* Có lỗi liên quan đến IAM permission.
* Có lỗi liên quan đến Docker build.
* Có lỗi liên quan đến ECR push.
* Có lỗi liên quan đến ECS deployment.

---

### Task 6.3: Chuẩn bị Final Presentation

**Assignee:** PM / Tech Lead
**Priority:** High
**Estimate:** 4 giờ

#### Mô tả

Chuẩn bị nội dung trình bày cuối dự án.

#### Acceptance Criteria

* Slide hoàn chỉnh.
* Có architecture diagram.
* Có demo flow.
* Có lessons learned.

---

# 6. Timeline 15 ngày

| Day    | Mục tiêu chính                          | Output                           |
| ------ | --------------------------------------- | -------------------------------- |
| Day 1  | Kickoff, phân tích yêu cầu, phân vai    | Jira board, project plan         |
| Day 2  | Thiết kế architecture và chuẩn bị app   | Diagram, GitHub repo, sample app |
| Day 3  | Tạo ECR và ECS Cluster                  | ECR repo, ECS Cluster            |
| Day 4  | Tạo Task Definition và ECS Service      | App chạy trên ECS                |
| Day 5  | Cấu hình networking và staging endpoint | Staging app truy cập được        |
| Day 6  | Cấu hình GitHub Actions                 | Workflow trigger được            |
| Day 7  | Cấu hình CodeBuild và buildspec         | Docker build hoạt động           |
| Day 8  | Push image lên ECR và deploy ECS        | Pipeline MVP                     |
| Day 9  | Test end-to-end và fix lỗi              | Evidence, demo flow ổn định      |
| Day 10 | Demo cho khách hàng                     | Hoàn thành demo 10 phút          |
| Day 11 | Hoàn thiện documentation                | Setup guide                      |
| Day 12 | Bổ sung QA và rollback notes            | QA checklist, rollback guide     |
| Day 13 | Ổn định pipeline                        | CI/CD pipeline ổn định           |
| Day 14 | Chuẩn bị final presentation             | Slide, final script              |
| Day 15 | Rehearsal và final delivery             | Final demo ready                 |

---

# 7. Demo Script cho Day 10

## Mục tiêu demo

Cho khách hàng thấy team đã xây dựng được một CI/CD pipeline hoạt động từ lúc code được push lên GitHub đến khi ứng dụng được tự động deploy lên AWS ECS Fargate.

## Demo Flow

1. Giới thiệu bài toán và mục tiêu dự án.
2. Show sơ đồ kiến trúc.
3. Giải thích luồng CI/CD:

   * GitHub Actions
   * AWS CodeBuild
   * Amazon ECR
   * Amazon ECS Fargate
4. Thực hiện một thay đổi nhỏ trong application.
5. Push code lên GitHub.
6. Show GitHub Actions workflow đang chạy.
7. Show CodeBuild build logs.
8. Show Docker image trong ECR.
9. Show ECS Service deployment.
10. Mở staging endpoint và kiểm tra version mới.

---

# 8. Risk Management

| Risk                          | Impact                               | Mitigation                                      |
| ----------------------------- | ------------------------------------ | ----------------------------------------------- |
| Pipeline lỗi khi live demo    | Demo có thể thất bại                 | Chuẩn bị screenshot hoặc video backup           |
| Thiếu IAM permission          | CodeBuild hoặc ECS deploy lỗi        | Chuẩn bị IAM checklist từ sớm                   |
| Docker image build lỗi        | Pipeline bị block                    | Test Docker build local trước                   |
| ECS task không start được     | Application không chạy               | Kiểm tra logs, task definition, port mapping    |
| Sai networking                | Không truy cập được staging endpoint | Kiểm tra Security Group, subnet và port         |
| Vượt giới hạn environment AWS | Không tạo thêm được resource         | Chỉ dùng dev và staging, không quá 3 môi trường |
| Team bị trễ tiến độ           | Không kịp demo Day 10                | Daily check-in và ưu tiên MVP trước             |

---

# 9. Definition of Done

Dự án được xem là hoàn thành khi:

* Code được push lên GitHub.
* GitHub Actions trigger pipeline.
* AWS CodeBuild build Docker image thành công.
* Docker image được push lên Amazon ECR.
* Amazon ECS Fargate deploy image mới tự động.
* Staging endpoint truy cập được.
* Setup documentation hoàn chỉnh.
* Evidence được thu thập đầy đủ.
* Demo 10 phút hoàn thành.
* Final presentation sẵn sàng.

---

# 10. Bản ngắn để đưa nhanh vào Jira

```text
Epic 1: Planning & Architecture
- Phân tích yêu cầu dự án
- Phân chia vai trò team
- Tạo Jira board
- Thiết kế architecture

Epic 2: Application Preparation
- Chuẩn bị sample app
- Thêm Dockerfile
- Thêm health check endpoint
- Thêm basic test command

Epic 3: AWS Infrastructure
- Tạo ECR repository
- Tạo ECS Cluster
- Tạo ECS Task Definition
- Tạo ECS Service
- Cấu hình networking và IAM

Epic 4: CI/CD Pipeline
- Cấu hình GitHub Actions
- Tạo CodeBuild project
- Viết buildspec.yml
- Push image lên ECR
- Deploy lên ECS Fargate
- Test pipeline end-to-end

Epic 5: QA & Demo
- Tạo QA checklist
- Thu thập evidence
- Chuẩn bị demo script Day 10
- Chuẩn bị backup screenshots

Epic 6: Documentation & Final Presentation
- Viết setup guide
- Viết troubleshooting guide
- Chuẩn bị final slides
- Rehearsal
```
