## Memory Allocation Modification Tool

`memory_edit` is a tool designed for modifying the system memory and TPU memory on the BM1684X. It is intended for developers who need to adjust the overall memory distribution.

### Install Memory Modification Tool (`memory_edit`) - Comes pre-installed with the system

```bash
wget https://github.com/radxa-edge/TPU-Edge-AI/releases/download/v0.1.0/memory_edit_V1.6.1.deb
sudo apt install ./memory_edit_V1.6.1.deb
```

### Usage

Check the current TPU memory allocation status:

```bash
memory_edit.sh -p bm1684x_sm7m_v1.0.dtb # Check the current TPU memory allocation status
```

Modify TPU memory:

```bash
memory_edit.sh -c -npu 7360 -vpu 2360 -vpp 4096 bm1684x_sm7m_v1.0.dtb 
sudo cp /opt/sophon/memory_edit/emmcboot.itb /boot/emmcboot.itb && sync
sudo reboot
```

### Parameter Analysis

- `-p [dts name]`: Check the current device's TPU memory distribution status.
- `-c [dts name]`: Modify TPU memory.
  - `-npu`: Modify npu memory.
  - `-vpp`: Modify vpp memory.
  - `-vpu`: Modify vpu memory.

### Examples

```bash
/opt/sophon/memory_edit/memory_edit.sh -p [dts name] # Print the current TPU memory allocation status
/opt/sophon/memory_edit/memory_edit.sh -c -npu 2048 -vpu 2048 -vpp 2048 [dts name] # Allocate memory for each hardware accelerator, unit is M
```

### Common Issues

**How to determine the current device's dts name?**

Use a serial port tool like [minicom](https://wiki.emacinc.com/wiki/Getting_Started_With_Minicom) to monitor the boot log. For downloading minicom, refer to the [official documentation](https://wiki.emacinc.com/wiki/Getting_Started_With_Minicom).

```bash
sudo minicom -D /dev/ttyUSB0 
```

Look for the dtb (in this case, `bm1684x_sm7m_v1.0.dtb`) at the beginning of the boot log:

```bash
found dtb@139: bitmain-bm1684x-sm7m-v1.0                                        
Selecting config 'bitmain-bm1684x-sm7m-v1.0' 
```