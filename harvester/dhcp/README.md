# Harvester DHCP IPPool: `net-10-9`

This repo contains a configuration for setting up a **DHCP-managed IP pool** in Harvester.  
The goal is to install a pool of IP addresses that **Harvester virtual machines can automatically use** via DHCP on boot.

It uses the `vm-dhcp-controller` add-on and defines a range of addresses that Harvester will lease to VMs connected to the `default/net-10-9` network.

---

---

## 🔗 Official Documentation

📖 https://docs.harvesterhci.io/v1.3/advanced/addons/managed-dhcp/

---

## ✅ Prerequisites

Before applying the `net-10-9` IPPool, complete the following steps in your Harvester cluster:

---

### 1. **Install and Enable the `vm-dhcp-controller` Add-On**

The DHCP controller is not included in the Harvester ISO by default. You must install it manually from the [experimental-addons repo](https://github.com/harvester/experimental-addons).

Run the following command:

```bash
kubectl apply -f https://raw.githubusercontent.com/harvester/experimental-addons/main/harvester-vm-dhcp
```

> This deploys the DHCP controller required to manage IP pools and leases.

---

### 2. **Enable the Add-On via the Dashboard**

After installing the controller:
- Go to **Advanced > Addons**
- Enable the `vm-dhcp-controller` add-on
- Optionally, enable the **Dashboard** addon to visualize DHCP leases and allocations

### 3. **Apply IP Pool**

Example Pool
---
```
  ipv4Config:
    serverIP: 10.9.0.100
    cidr: 10.9.0.0/24
    pool:
      start: 10.9.0.101
      end: 10.9.0.120
      exclude:
      - 10.9.0.100
    router: 10.9.0.1
    dns:
    - 10.9.0.250
    leaseTime: 300
  networkName: default/backbone-vla
```

## 📦 IP Pool Configuration

Once the DHCP controller is installed and running, apply the IP pool config:

```bash
kubectl apply -f dhcp-ip-pool.yaml
```

This creates a managed DHCP IP pool under the network `default/net-10-9`.

The key configuration values used in this pool are:

| Field         | Value                    |
|---------------|--------------------------|
| **CIDR**      | `10.9.0.0/24`            |
| **Server IP** | `10.9.0.100`             |
| **IP Range**  | `10.9.0.101 – 10.9.0.120`|
| **Router**    | `10.9.0.1`               |
| **DNS**       | `10.9.0.250`             |
| **Lease Time**| `300s (5 minutes)`       |

**Note:** `serverIP` must be within the same subnet as the CIDR, outside the pool range, and must not conflict with any existing devices.

## 🧪 Test the Pool

After applying the pool:
1. Create a VM using the `default/backbone-vlan` network.
2. Ensure DHCP is selected in the VM network settings.
3. Boot the VM and confirm it receives an IP from the range (`10.9.0.101`–`10.9.0.120`).

You can verify by SSHing into the VM or viewing DHCP leases in the Harvester dashboard (if enabled).

---

## 📂 Files in This Repo

- `dhcp-ip-pool.yaml`: IPPool manifest for the `net-10-9` network

---

This setup enables dynamic, managed IP assignment in Harvester environments using DHCP-backed custom networks. 🚀
