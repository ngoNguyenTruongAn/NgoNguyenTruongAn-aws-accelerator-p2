# Scenario A — Missed Deadlines

## 1. Tóm tắt tình huống

Trong Sprint 1, Day 4, task của Dev A đã bị trễ deadline 2 lần. Nguyên nhân chính là Dev A đang gặp vấn đề **version conflict**, nhưng bạn ấy không chủ động báo blocker cho team hoặc PM. Trong khi đó, Dev B lại đang rảnh và chờ việc.

Tình huống này cho thấy team đang gặp vấn đề ở 3 điểm:

1. Dev A bị blocker nhưng không raise kịp thời.
2. PM/Leader chưa phát hiện blocker đủ sớm.
3. Resource trong team chưa được sử dụng hiệu quả, vì Dev B đang idle trong khi Dev A cần hỗ trợ.

Vấn đề không chỉ nằm ở việc một task bị trễ, mà còn nằm ở cách team giao tiếp, quản lý blocker và phối hợp trong sprint.

---

## 2. Nhận định của PM

Với vai trò PM, tôi sẽ không xem đây đơn giản là lỗi cá nhân của Dev A. Đây là một vấn đề về **process** và **communication** trong team.

Nếu Dev A bị version conflict nhưng không báo, PM sẽ không có đủ thông tin để hỗ trợ. Nếu Dev B đang idle nhưng không được điều phối vào hỗ trợ, nghĩa là team đang mất đi năng suất có thể tận dụng.

Điểm quan trọng nhất cần xử lý là:

```text
Blocker phải được phát hiện sớm, báo sớm và xử lý sớm.
```

Nếu một blocker bị giấu đến khi task miss deadline, nó sẽ ảnh hưởng không chỉ task đó mà còn ảnh hưởng timeline chung, morale của team và độ tin cậy của kế hoạch sprint.

---

## 3. Mục tiêu xử lý tình huống

Khi xử lý Scenario A, mục tiêu của PM không phải là “trách phạt” Dev A, mà là:

1. Unblock task càng nhanh càng tốt.
2. Tìm hiểu lý do vì sao Dev A không raise blocker.
3. Điều phối Dev B hỗ trợ để tránh idle resource.
4. Cập nhật lại Jira để cả team nhìn thấy trạng thái thật.
5. Thiết lập rule rõ ràng để blocker không bị giấu trong tương lai.
6. Giữ tinh thần team tích cực, không tạo cảm giác sợ báo lỗi.

---

## 4. Hành động ngay lập tức của PM

### Bước 1: Kiểm tra trạng thái task trên Jira

Đầu tiên, tôi sẽ mở Jira để kiểm tra:

* Task của Dev A đang ở trạng thái nào?
* Deadline đã miss bao lâu?
* Task có dependency với task khác không?
* Có comment nào về blocker chưa?
* Dev B đang idle vì chưa có task hay đang chờ output từ Dev A?

Nếu task chưa được đánh dấu blocked, tôi sẽ cập nhật lại ngay trạng thái hoặc comment blocker để team có visibility.

Ví dụ comment trên Jira:

```md
Current status: Blocked

Reason:
Dev A is facing a version conflict issue and cannot continue implementation.

Impact:
The task has missed deadline twice and may affect the Sprint 1 delivery timeline.

Action plan:
Dev B will pair with Dev A to resolve the conflict today.
PM will re-check progress at the end of the day.
```

---

### Bước 2: Gặp riêng Dev A bằng 1-on-1

Tôi sẽ không nhắc nhở Dev A trước toàn team vì điều đó dễ làm bạn ấy phòng thủ hoặc mất tự tin. Thay vào đó, tôi sẽ có một cuộc trao đổi riêng ngắn, khoảng 10–15 phút.

Tôi sẽ dùng mô hình **SBI feedback**:

## S — Situation

```text
Trong Sprint 1, đến Day 4, task của em đã bị miss deadline 2 lần.
```

## B — Behaviour

```text
Em đang gặp version conflict nhưng chưa raise blocker lên Jira hoặc báo sớm cho team.
```

## I — Impact

```text
Việc này làm timeline của task bị trễ, Dev B đang bị idle trong khi có thể hỗ trợ, và PM không có đủ thông tin để điều phối team kịp thời.
```

Sau đó tôi sẽ hỏi theo hướng hỗ trợ, không phán xét:

```text
Hiện tại conflict đang nằm ở phần nào?
Em đã thử những cách nào rồi?
Em cần ai hỗ trợ để unblock trong hôm nay?
Có lý do gì khiến em chưa raise blocker sớm không?
```

Mục tiêu của cuộc 1-on-1 là hiểu vấn đề thật sự, không phải chỉ để nhắc lỗi.

---

### Bước 3: Điều phối Dev B hỗ trợ Dev A

Vì Dev B đang idle, tôi sẽ điều phối Dev B hỗ trợ Dev A theo hình thức **pair debugging** hoặc **code review nhanh**.

Cách phân công:

| Người     | Việc cần làm                                                                   |
| --------- | ------------------------------------------------------------------------------ |
| Dev A     | Giải thích conflict, phần code đang bị ảnh hưởng, hướng xử lý đã thử           |
| Dev B     | Hỗ trợ debug, kiểm tra branch, dependency, version package hoặc merge conflict |
| PM        | Theo dõi tiến độ, cập nhật Jira, đảm bảo task được unblock trong ngày          |
| Tech Lead | Hỗ trợ nếu conflict liên quan đến kiến trúc hoặc quyết định kỹ thuật           |

Nếu blocker phức tạp hơn dự kiến, tôi sẽ kéo Tech Lead vào hỗ trợ, nhưng chỉ sau khi Dev A và Dev B đã xác định rõ vấn đề.

---

## 5. Cách xử lý version conflict cụ thể

Nếu blocker là version conflict, tôi sẽ yêu cầu team làm rõ conflict thuộc loại nào:

### Trường hợp 1: Conflict do branch/git merge

Action:

```text
- Pull latest code từ main/develop branch.
- Rebase hoặc merge branch hiện tại.
- Resolve conflict file-by-file.
- Chạy test local.
- Push lại branch.
- Tạo pull request để review.
```

### Trường hợp 2: Conflict do package/library version

Action:

```text
- Kiểm tra file package.json, package-lock.json hoặc requirements.txt.
- Xác định version nào đang gây lỗi.
- So sánh version giữa local và branch chính.
- Chốt một version thống nhất.
- Cập nhật documentation nếu cần.
```

### Trường hợp 3: Conflict do environment

Action:

```text
- Kiểm tra version Node.js/Python/Docker/AWS CLI.
- Đồng bộ environment bằng README hoặc .nvmrc/.tool-versions nếu có.
- Chạy lại app local.
- Cập nhật setup guide để tránh người khác gặp lại lỗi này.
```

### Trường hợp 4: Conflict do API/interface thay đổi

Action:

```text
- Xác định ai đã thay đổi interface.
- Cập nhật lại contract giữa các phần.
- Thông báo cho các member liên quan.
- Update ticket dependency trên Jira.
```

---

## 6. Cập nhật lại Jira sau khi xử lý

Sau khi xác định được blocker, tôi sẽ yêu cầu cập nhật Jira rõ ràng.

Task của Dev A cần có:

```text
Status: Blocked hoặc In Progress
Assignee: Dev A
Supporter: Dev B
Priority: High
Due date: Updated nếu cần
Label: blocker
```

Comment mẫu:

```md
Blocker identified:
Version conflict in application dependencies.

Support plan:
Dev B will pair with Dev A to resolve the conflict.

Expected resolution:
By end of Day 4.

Next check:
PM will review progress at 4:30 PM.
```

Nếu task quá lớn hoặc có nguy cơ tiếp tục trễ, tôi sẽ tách task thành các sub-task nhỏ hơn:

```text
Sub-task 1: Identify conflict source
Sub-task 2: Resolve version conflict
Sub-task 3: Run local test
Sub-task 4: Push fixed branch and create PR
Sub-task 5: Review and merge
```

Việc tách nhỏ giúp team dễ theo dõi hơn và giảm rủi ro task bị “mắc kẹt” quá lâu.

---

## 7. Điều chỉnh kế hoạch sprint

Sau khi Dev A được unblock, tôi sẽ kiểm tra ảnh hưởng đến sprint:

### Nếu task không ảnh hưởng critical path

Tôi giữ nguyên timeline nhưng theo dõi sát hơn trong 1–2 ngày tiếp theo.

### Nếu task ảnh hưởng critical path

Tôi sẽ điều chỉnh bằng một trong các cách:

1. Cho Dev B tiếp tục hỗ trợ Dev A.
2. Giảm scope của task để kịp deadline.
3. Chuyển một phần task cho member khác.
4. Đẩy task ít quan trọng hơn sang backlog.
5. Báo sớm risk cho stakeholder nếu ảnh hưởng đến milestone lớn.

Với dự án CI/CD 3 tuần, nếu task này ảnh hưởng đến demo Day 10, tôi sẽ ưu tiên giữ pipeline MVP trước, còn phần polish hoặc nâng cấp sẽ để sau.

---

## 8. Quy tắc mới cho team sau tình huống

Sau khi xử lý xong, tôi sẽ không biến tình huống này thành buổi chỉ trích cá nhân. Thay vào đó, tôi sẽ đưa ra rule chung cho cả team:

```text
Rule 1: Blocker phải được raise trong vòng 2 giờ.
Rule 2: Nếu task có nguy cơ trễ deadline, phải báo PM trước khi deadline kết thúc.
Rule 3: Asking for help is professional, not weak.
Rule 4: Jira là nơi cập nhật trạng thái chính thức.
Rule 5: Nếu member idle, PM cần điều phối hỗ trợ task đang blocked hoặc critical.
```

Tôi sẽ nhấn mạnh:

```text
Báo blocker không phải là dấu hiệu yếu kém. Báo blocker sớm là hành động chuyên nghiệp vì nó giúp cả team xử lý rủi ro sớm.
```

---

## 9. Cách giao tiếp với cả team

Trong daily meeting hoặc team sync, tôi sẽ nói theo hướng trung lập, không nêu tên để tránh tạo áp lực cá nhân:

```text
Hôm nay team có một blocker liên quan đến version conflict. Bài học ở đây là nếu ai bị stuck quá 2 giờ thì cần raise blocker ngay trên Jira hoặc Slack để team hỗ trợ. Mục tiêu không phải là tìm lỗi cá nhân, mà là đảm bảo task không bị trễ âm thầm. Từ hôm nay, mọi blocker cần được báo trong vòng 2 giờ.
```

Cách nói này giúp cả team học được bài học mà không làm Dev A bị “bêu tên”.

---

## 10. Follow-up sau khi unblock

Sau khi Dev A và Dev B xử lý xong conflict, tôi sẽ follow-up:

1. Task đã được unblock chưa?
2. Có cần update documentation không?
3. Có test lại phần bị conflict không?
4. Có ảnh hưởng đến task khác không?
5. Có cần thay đổi deadline không?

Nếu lỗi version conflict có khả năng lặp lại, tôi sẽ yêu cầu bổ sung vào troubleshooting guide:

```md
## Common Issue: Version Conflict

### Symptom
Application fails to build or run after pulling latest code.

### Possible Causes
- Dependency version mismatch
- Outdated local environment
- Merge conflict not fully resolved
- Different Node.js/Python version

### Resolution
- Pull latest code
- Check dependency lock file
- Reinstall dependencies
- Run local tests
- Ask for support if blocked more than 2 hours
```

---

## 11. Bài học rút ra

Từ Scenario A, bài học quan trọng nhất là:

```text
Raise blockers within 2 hours.
Asking for help is professional, not weak.
```

Một team chuyên nghiệp không phải là team không bao giờ gặp lỗi, mà là team phát hiện vấn đề sớm, nói rõ vấn đề và cùng nhau xử lý trước khi nó trở thành rủi ro lớn.

Với vai trò PM, tôi cần đảm bảo team có môi trường an toàn để mọi người dám báo blocker. Đồng thời, tôi cũng cần theo dõi Jira và daily update đủ sát để không để task bị trễ nhiều lần mới phát hiện.

---

