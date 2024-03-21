## 内存分布修改工具

memory_edit 是用于修改 BM1684X 系统内存与 TPU 内存的工具，用于针对开发者需要调整整机内存分布

### 安装内存修改工具 memory_edit（系统出厂自带）
```bash
wget https://github.com/radxa-edge/TPU-Edge-AI/releases/download/v0.1.0/memory_edit_V1.6.1.deb
sudo apt install ./memory_edit_V1.6.1.deb
```
### 使用方法
检查当前 TPU 内存分配状态
```bash
memory_edit.sh -p bm1684x_sm7m_v1.0.dtb # 检查当前 TPU 内存分配状态
```
修改 TPU 内存
```bash
memory_edit.sh -c -npu 7360 -vpu 2360 -vpp 4096 bm1684x_sm7m_v1.0.dtb 
sudo cp /opt/sophon/memory_edit/emmcboot.itb /boot/emmcboot.itb && sync
sudo reboot
```

### 参数解析

- `-p [dts name]` 查看当前设备 TPU 内存分布状态

- `-c [dts name]` 修改 TPU 内存 

	- `-npu `修改 npu 内存

	- `-vpp` 修改 vpp 内存

	- `-vpu` 修改 vpu 内存

### 使用例子

```bash
/opt/sophon/memory_edit/memory_edit.sh -p [dts name] # 打印当前 TPU 内存分配状态
/opt/sophon/memory_edit/memory_edit.sh -c -npu 2048 -vpu 2048 -vpp 2048 [dts name] # 分配各硬件加速处理器内存，单位为 M
```

### 常见问题
**如何确定当前设备 dts name ?**

利用串口工具  [minicom](https://wiki.emacinc.com/wiki/Getting_Started_With_Minicom) 监听开机日志，下载方式请参考[官方文档](https://wiki.emacinc.com/wiki/Getting_Started_With_Minicom)

```bash
sudo minicom -D /dev/ttyUSB0 
```

在开机日志开头里找 dtb（本案例即 bm1684x_sm7m_v1.0.dtb）

```bash
found dtb@139: bitmain-bm1684x-sm7m-v1.0                                        
Selecting config 'bitmain-bm1684x-sm7m-v1.0' 