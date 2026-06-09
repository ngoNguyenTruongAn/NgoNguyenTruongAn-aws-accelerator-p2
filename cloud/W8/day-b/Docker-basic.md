# Docker Notes — D2 Foundation

## 1. Docker giải quyết vấn đề gì?

Một ứng dụng khi chạy không chỉ cần source code. Nó còn cần nhiều thành phần đi kèm như:

* Phiên bản ngôn ngữ lập trình, ví dụ Node.js, Python, Java
* Thư viện và dependencies
* Biến môi trường
* Cấu hình hệ điều hành
* Runtime và command để khởi động app

Khi chuyển ứng dụng từ máy này sang máy khác, các thành phần này có thể khác nhau. Vì vậy có trường hợp app chạy tốt trên máy developer nhưng lỗi khi chạy trên server.

Đây là vấn đề thường được gọi là:

```txt
It works on my machine
```

Docker giải quyết vấn đề này bằng cách đóng gói ứng dụng cùng môi trường chạy của nó vào một container.

Nhờ đó, ứng dụng chạy trong container sẽ nhất quán hơn giữa các môi trường như máy developer, server, staging hoặc production.

## 2. Docker là gì?

Docker là công cụ giúp đóng gói, phân phối và chạy ứng dụng dưới dạng container.

Docker giúp ứng dụng chạy nhất quán hơn vì container chứa sẵn:

* Application code
* Runtime
* Libraries
* Dependencies
* Configuration cần thiết

Hiểu đơn giản:

```txt
Docker giúp đóng gói app và môi trường chạy của app thành một đơn vị độc lập gọi là container.
```

## 3. Container là gì?

Container là một môi trường chạy ứng dụng được cô lập.

Container chứa ứng dụng và những thành phần cần thiết để ứng dụng chạy được.

Container nhẹ hơn virtual machine vì nó không cần chạy một hệ điều hành đầy đủ riêng. Container chia sẻ kernel của host OS.

Đặc điểm của container:

* Nhẹ
* Khởi động nhanh
* Dễ đóng gói
* Dễ di chuyển giữa các môi trường
* Cô lập app với môi trường host ở mức phù hợp

## 4. Container khác Virtual Machine như thế nào?

Virtual Machine và container đều giúp cô lập môi trường chạy ứng dụng, nhưng cách hoạt động khác nhau.

### Virtual Machine

VM ảo hóa cả một máy tính.

Mỗi VM có:

* Một hệ điều hành đầy đủ
* Libraries
* Application
* Runtime riêng

VM chạy trên hypervisor.

Nhược điểm:

* Nặng
* Tốn nhiều tài nguyên
* Khởi động chậm
* Mỗi VM có thể chiếm vài GB

### Container

Container không chạy một hệ điều hành đầy đủ riêng. Nó chia sẻ kernel của host OS và chỉ đóng gói app cùng dependencies.

Ưu điểm:

* Nhẹ hơn VM
* Khởi động nhanh hơn
* Chạy được nhiều container hơn trên cùng một máy
* Phù hợp để đóng gói và deploy ứng dụng

Câu nhớ:

```txt
VM virtualizes hardware.
Container virtualizes the operating system.
```

## 5. Image là gì?

Image là gói read-only chứa ứng dụng và mọi thứ ứng dụng cần để chạy.

Có thể hiểu image là bản mẫu hoặc blueprint.

Từ một image, có thể tạo ra nhiều container giống nhau.

Ví dụ:

```txt
Image = khuôn mẫu
Container = sản phẩm được tạo ra từ khuôn mẫu đó
```

## 6. Container và Image khác nhau thế nào?

Image là bản mẫu read-only.

Container là instance đang chạy từ image.

Ví dụ:

```txt
Image: nginx:latest
Container: một tiến trình nginx đang chạy từ image nginx:latest
```

Một image có thể tạo ra nhiều container.

Câu nhớ:

```txt
Image là blueprint.
Container là instance chạy từ image.
```

## 7. Registry là gì?

Registry là nơi lưu trữ Docker image.

Registry cho phép:

* Pull image về máy
* Push image lên để chia sẻ
* Lưu version image theo tag

Registry phổ biến nhất là Docker Hub.

Ví dụ:

```txt
docker pull nginx
docker push my-app:1.0
```

## 8. Dockerfile là gì?

Dockerfile là file text mô tả cách build một Docker image.

Dockerfile thường định nghĩa:

* Image nền
* Thư mục làm việc
* File cần copy vào image
* Lệnh cài dependencies
* Port app sử dụng
* Command chạy khi container start

Lifecycle cơ bản:

```txt
Viết Dockerfile
→ build image
→ run image thành container
→ push image lên registry nếu cần
```

## 9. Docker lifecycle cơ bản

Quy trình cơ bản khi làm việc với Docker:

```txt
1. Viết Dockerfile
2. Build image
3. Run container từ image
4. Kiểm tra container
5. Push image lên registry nếu cần
6. Cleanup container/image khi không dùng nữa
```

Ví dụ lifecycle:

```txt
Dockerfile → Image → Container → Registry
```

## 10. Orchestration là gì?

Khi chỉ chạy vài container trên một máy, Docker cơ bản là đủ.

Nhưng khi hệ thống lớn hơn, cần:

* Chạy nhiều container trên nhiều máy
* Scale nhiều instance
* Cân bằng tải
* Restart container khi chết
* Rolling update
* Quản lý service ở quy mô lớn

Việc điều phối container như vậy gọi là orchestration.

## 11. Docker Swarm là gì?

Docker Swarm là công cụ orchestration được tích hợp trong Docker.

Swarm cho phép gom nhiều máy thành một cluster.

Sau đó có thể khai báo mong muốn như:

```txt
Chạy 5 instances của service này
```

Swarm sẽ tự xử lý:

* Phân phối container lên các node
* Theo dõi trạng thái container
* Thay thế container chết
* Scale service
* Rolling update
* Load balancing trong cluster

Docker Swarm đơn giản hơn Kubernetes, nên phù hợp để làm bước đệm trước khi học Kubernetes.

# Docker Architecture — Important Definitions

## 1. Docker Client

**Docker Client** là công cụ dòng lệnh `docker` mà người dùng gõ trong terminal.

Ví dụ:

```bash
docker run nginx
docker ps
docker images
```

Docker Client không trực tiếp tạo container. Nó chỉ nhận lệnh từ người dùng, chuyển thành API request và gửi đến Docker Daemon.

Câu nhớ:

```txt
Docker Client = nơi người dùng gõ lệnh Docker.
```

---

## 2. Docker Daemon

**Docker Daemon**, hay `dockerd`, là process chạy nền chịu trách nhiệm quản lý các Docker objects như:

```txt
images
containers
networks
volumes
```

Docker Client gửi request đến Docker Daemon thông qua Docker API. Docker Daemon mới là thành phần xử lý chính các thao tác như tạo container, quản lý image, network và volume.

Câu nhớ:

```txt
Docker Daemon = process chạy nền quản lý Docker objects.
```

---

## 3. Docker API

**Docker API** là giao diện giao tiếp giữa Docker Client và Docker Daemon.

Khi người dùng gõ lệnh Docker, Docker Client sẽ gửi request đến Docker Daemon thông qua API này.

Trên Linux, Docker Client thường giao tiếp với Docker Daemon qua socket:

```txt
/var/run/docker.sock
```

Câu nhớ:

```txt
Docker API = cầu nối giữa Docker Client và Docker Daemon.
```

---

## 4. Docker Socket

**Docker Socket** là kênh giao tiếp giữa Docker Client và Docker Daemon.

Trên Linux, socket mặc định thường là:

```txt
/var/run/docker.sock
```

Nếu gặp lỗi:

```txt
Cannot connect to the Docker daemon
```

thì thường có nghĩa là:

```txt
Docker Daemon chưa chạy
hoặc user không có quyền truy cập Docker Socket.
```

Câu nhớ:

```txt
Docker Socket = đường giao tiếp local giữa client và daemon.
```

---

## 5. containerd

**containerd** là tầng runtime trung gian bên dưới Docker Daemon.

Nó chịu trách nhiệm:

```txt
pull image
quản lý image storage
chuẩn bị container
quản lý lifecycle container
```

Docker Daemon không trực tiếp làm tất cả việc ở tầng thấp. Nó giao việc quản lý container lifecycle cho `containerd`.

Câu nhớ:

```txt
containerd = tầng trung gian quản lý image và lifecycle container.
```

---

## 6. runc

**runc** là OCI runtime trực tiếp tạo container.

Nó sử dụng các tính năng của Linux kernel như:

```txt
namespaces
cgroups
filesystem mounts
```

để tạo môi trường cô lập cho process bên trong container.

Điểm quan trọng:

```txt
runc tạo container xong thì thoát.
runc không ở lại để giám sát container.
```

Câu nhớ:

```txt
runc = runtime thật sự tạo container.
```

---

## 7. containerd-shim

**containerd-shim** là process ở lại theo dõi container sau khi `runc` tạo container xong và thoát.

Shim là parent của process chạy trong container.

Nhờ `containerd-shim`, container có thể tiếp tục chạy ngay cả khi Docker Daemon restart.

Câu nhớ:

```txt
containerd-shim = process giữ và theo dõi container sau khi runc thoát.
```

---

## 8. Registry

**Registry** là nơi lưu trữ Docker images.

Một số registry phổ biến:

```txt
Docker Hub
Amazon ECR
GitHub Container Registry
Private Registry
```

Docker có thể:

```txt
pull image từ registry về máy
push image đã build lên registry
```

Câu nhớ:

```txt
Registry = kho lưu trữ Docker images.
```

---

## 9. Docker Hub

**Docker Hub** là public registry phổ biến nhất của Docker.

Khi chạy:

```bash
docker run nginx
```

nếu máy chưa có image `nginx`, Docker sẽ pull image này từ Docker Hub theo mặc định.

Câu nhớ:

```txt
Docker Hub = registry mặc định và phổ biến nhất của Docker.
```

---

## 10. Docker Desktop Linux VM

Trên Windows/macOS, Docker Desktop tạo một Linux VM nhẹ để chạy Linux containers.

Lý do là Linux container cần Linux kernel để chạy, còn Windows/macOS không có Linux kernel trực tiếp.

Mô hình đơn giản:

```txt
Windows/macOS
  docker client
      ↓
  Linux VM của Docker Desktop
      dockerd → containerd → runc
      containers chạy trong VM
```

Điều này giải thích vì sao:

```txt
Container filesystem thực chất nằm trong Linux VM.
Bind mount trên Windows/macOS có thể chậm hơn Linux.
CPU/RAM container phụ thuộc vào cấu hình Docker Desktop VM.
```

Câu nhớ:

```txt
Docker Desktop trên Windows/macOS cần Linux VM để chạy Linux containers.
```

---

## 11. Docker Architecture

Docker không phải một khối duy nhất. Nó gồm nhiều tầng phối hợp với nhau.

Luồng tổng quát:

```txt
docker client
→ dockerd
→ containerd
→ runc
→ containerd-shim
→ process trong container
```

Ý nghĩa từng tầng:

```txt
docker client     = nơi người dùng gõ lệnh
dockerd           = daemon quản lý Docker objects
containerd        = quản lý image và lifecycle container
runc              = tạo container bằng Linux kernel features
containerd-shim   = theo dõi container sau khi runc thoát
container process = process thật đang chạy trong container
```

Câu nhớ:

```txt
Docker CLI chỉ gửi lệnh. dockerd quản lý cấp cao. containerd quản lý lifecycle. runc tạo container. shim giữ container sống.
```

---

## 12. Luồng xử lý khi chạy docker run

Khi chạy:

```bash
docker run nginx
```

Docker xử lý theo luồng:

```txt
1. Docker Client nhận lệnh docker run nginx.
2. Client gửi request đến Docker Daemon.
3. Docker Daemon kiểm tra image nginx đã có local chưa.
4. Nếu chưa có, Docker Daemon yêu cầu containerd pull image từ registry.
5. containerd tải image layers và chuẩn bị filesystem.
6. containerd gọi runc để tạo container.
7. runc tạo namespaces, cgroups, mount filesystem và start process nginx.
8. runc thoát.
9. containerd-shim ở lại theo dõi process nginx.
10. Container bắt đầu chạy.
```

Tóm tắt ngắn:

```txt
docker run nginx
→ client
→ dockerd
→ containerd
→ runc
→ shim
→ nginx process
```

---
# Docker Internals — Important Definitions

## 1. Container là gì ở tầng Linux?

Container không phải là một virtual machine nhỏ.

Container thực chất là một hoặc một vài Linux process bình thường, nhưng được Linux kernel cấp cho một môi trường bị cô lập và giới hạn.

Container được tạo ra nhờ 3 cơ chế chính:

```txt
Namespaces        = cô lập những gì process nhìn thấy
Cgroups           = giới hạn tài nguyên process được dùng
Union filesystem  = tạo filesystem dạng layers cho container
```

Câu nhớ:

```txt
Container = Linux process + namespaces + cgroups + union filesystem
```

---

## 2. Namespaces là gì?

**Namespaces** là cơ chế của Linux kernel dùng để cô lập những gì một process nhìn thấy.

Một process trong container chỉ nhìn thấy tài nguyên thuộc namespace của nó, không nhìn thấy toàn bộ host.

Namespaces trả lời câu hỏi:

```txt
Container thấy được những gì?
```

Ví dụ:

* Container chỉ thấy process của chính nó.
* Container có hostname riêng.
* Container có network interface/IP riêng.
* Container có filesystem mount riêng.

Câu nhớ:

```txt
Namespaces isolate what a container can see.
```

---

## 3. PID Namespace

**PID namespace** cô lập cây process.

Bên trong container, process đầu tiên thường thấy chính nó là PID 1.

Ví dụ khi chạy:

```bash
docker run --rm alpine ps aux
```

bạn có thể chỉ thấy một vài process trong container, không thấy toàn bộ process trên host.

Ý nghĩa:

```txt
Container không thấy process bên ngoài nó.
```

---

## 4. NET Namespace

**NET namespace** cô lập network stack.

Mỗi container có thể có:

```txt
network interface riêng
IP riêng
routing table riêng
port riêng trong namespace của nó
```

Ý nghĩa:

```txt
Container có môi trường network riêng, tách biệt với container khác và host.
```

---

## 5. MNT Namespace

**MNT namespace** cô lập mount points và filesystem view.

Container có thể nhìn thấy một filesystem riêng, khác với host.

Ý nghĩa:

```txt
Container nghĩ rằng nó có filesystem riêng, dù thực tế đang dùng layers từ image và writable layer.
```

---

## 6. UTS Namespace

**UTS namespace** cô lập hostname.

Nhờ UTS namespace, container có thể có hostname riêng.

Ý nghĩa:

```txt
Container có thể có tên máy riêng bên trong môi trường của nó.
```

---

## 7. IPC Namespace

**IPC namespace** cô lập inter-process communication.

Nó tách các cơ chế giao tiếp giữa process như shared memory hoặc message queue.

Ý nghĩa:

```txt
Process trong container không tự do giao tiếp IPC với process ngoài container.
```

---

## 8. USER Namespace

**USER namespace** cô lập user và group ID.

Nó cho phép user root trong container không nhất thiết là root thật trên host.

Ý nghĩa:

```txt
Root trong container có thể được map thành user không phải root trên host.
```

Đây là cơ chế quan trọng cho bảo mật container.

---

## 9. Cgroups là gì?

**Cgroups**, viết đầy đủ là control groups, là cơ chế của Linux kernel dùng để giới hạn và theo dõi tài nguyên mà process/container được sử dụng.

Cgroups trả lời câu hỏi:

```txt
Container được dùng bao nhiêu tài nguyên?
```

Cgroups có thể giới hạn:

```txt
CPU
RAM
Disk I/O
Process count
```

Ví dụ:

```bash
docker run --rm --memory=50m alpine cat /sys/fs/cgroup/memory.max
```

Lệnh trên chạy container với giới hạn RAM 50 MB.

Câu nhớ:

```txt
Cgroups limit how much resource a container can use.
```

---

## 10. Union Filesystem là gì?

**Union filesystem** là cơ chế xếp nhiều filesystem layers thành một filesystem thống nhất mà container nhìn thấy.

Docker image được tạo từ nhiều read-only layers.

Khi container chạy, Docker thêm một writable layer lên trên image layers.

Mô hình:

```txt
Writable layer          ← thay đổi của container nằm ở đây
Read-only image layer
Read-only image layer
Read-only base layer
```

Câu nhớ:

```txt
Union filesystem makes image layers look like one filesystem.
```

---

## 11. Image Layers là gì?

**Image layers** là các lớp read-only tạo nên Docker image.

Mỗi instruction trong Dockerfile thường tạo ra một layer hoặc metadata.

Ví dụ:

```dockerfile
FROM alpine
RUN apk add nginx
COPY . /app
CMD ["nginx"]
```

Một số instruction như `RUN`, `COPY` thường tạo layer có dữ liệu. Một số instruction như `CMD`, `ENV`, `EXPOSE` thường là metadata và có thể có size 0B.

Có thể xem layers bằng:

```bash
docker image inspect nginx:alpine --format '{{range .RootFS.Layers}}{{println .}}{{end}}'
```

Hoặc xem lịch sử image:

```bash
docker history nginx:alpine
```

---

## 12. Writable Layer là gì?

**Writable layer** là layer ghi được mà Docker thêm lên trên các image layers khi container chạy.

Mọi thay đổi trong container sẽ nằm ở writable layer.

Ví dụ:

* Tạo file mới trong container
* Sửa file trong container
* Xóa file trong container

Các thay đổi này không làm thay đổi image gốc.

Điểm quan trọng:

```txt
Khi container bị xóa, writable layer cũng bị xóa.
```

Vì vậy dữ liệu quan trọng không nên lưu trực tiếp trong container.

---

## 13. Copy-on-Write là gì?

**Copy-on-write**, viết tắt là CoW, là cơ chế khi container muốn sửa một file nằm trong read-only image layer.

Quy trình:

```txt
1. File gốc nằm ở read-only layer.
2. Container muốn sửa file đó.
3. Docker copy file lên writable layer.
4. Container sửa bản copy trong writable layer.
5. File gốc trong image layer không đổi.
```

Câu nhớ:

```txt
Copy-on-write means Docker copies a file to the writable layer only when the container modifies it.
```

---

## 14. Vì sao container nhẹ và nhanh?

Container nhẹ và khởi động nhanh vì:

```txt
Không boot một hệ điều hành riêng như VM.
Chia sẻ Linux kernel với host.
Chỉ tạo namespaces, cgroups và mount filesystem cho process.
Image layers được dùng chung giữa nhiều container.
Mỗi container chỉ có writable layer riêng.
```

Nếu chạy nhiều container từ cùng một image, chúng dùng chung read-only layers.

---

## 15. Vì sao cần Docker Volume?

Vì dữ liệu trong writable layer sẽ mất khi container bị xóa.

Do đó dữ liệu cần lưu lâu dài như database, uploaded files hoặc logs quan trọng nên dùng:

```txt
Docker volume
Bind mount
External storage
```

Câu nhớ:

```txt
Container writable layer is temporary. Use volumes for persistent data.
```

---

## 16. Tổng kết Docker Internals

Container được tạo bởi 3 cơ chế chính của Linux kernel và filesystem:

```txt
Namespaces:
Cô lập những gì container nhìn thấy.

Cgroups:
Giới hạn tài nguyên container được dùng.

Union filesystem:
Tạo filesystem dạng layers cho container.
```

Định nghĩa đầy đủ:

```txt
Container là một Linux process được cô lập bằng namespaces, giới hạn tài nguyên bằng cgroups, và chạy trên union filesystem gồm read-only image layers cùng một writable layer riêng.
```

---

