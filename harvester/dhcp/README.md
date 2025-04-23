# Harvester DHCP IP Pool Configuration: net-10-9

The goal is to provide a range of IP addresses that Harvester virtual machines can automatically obtain via DHCP at boot time.

It uses the `vm-dhcp-controller` add-on and defines a range of addresses that Harvester will lease to VMs connected to the `default/backbone-vlan` network.

## 🔗 Official Documentation

📖 https://docs.harvesterhci.io/v1.3/advanced/addons/managed-dhcp/

## 🛠️ Prerequisites

Before applying the `net-10-9` IPPool, complete the following steps in your Harvester cluster:

### 1. **Install and Enable the `vm-dhcp-controller` Add-On**

The `vm-dhcp-controller` is not included in Harvester by default. Install it from the [experimental-addons repo](https://github.com/harvester/experimental-addons) using:

```bash
kubectl apply -f https://raw.githubusercontent.com/harvester/experimental-addons/main/harvester-vm-dhcp
```

> This deploys the DHCP controller required to manage IP pools and leases.

### 2. **Enable the Add-On in the Harvester Dashboard**

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
  networkName: default/backbone-vlan
```

## ❓ What is `serverIP`?

The `serverIP` is the IP address used by the Harvester **DHCP server** itself to respond to DHCP requests.  
It must:
- Be inside the same subnet as the `cidr`
- Be **outside** the pool of assignable IPs
- Not conflict with your router or other devices

Example in this setup:
- The pool ranges from `10.9.0.101` to `10.9.0.120`
- `serverIP` is `10.9.0.100` → this is the DHCP server’s identity on the network

## 📦 Apply the IPPool Config

Once the controller is installed and running, apply the IPPool config:

```bash
kubectl apply -f dhcp-ip-pool.yaml
```

This creates a managed DHCP IP pool under the network `default/net-10-9`.



## 🧪 Test the Pool

After applying the pool:
1. Create a VM using the `default/backbone-vlan` network.
2. Ensure DHCP is selected in the VM network settings.
3. Boot the VM and confirm it receives an IP from the range (`10.9.0.101`–`10.9.0.120`).

You can verify by SSHing into the VM or viewing DHCP leases in the Harvester dashboard (if enabled).

## 📂 Files in This Repo

- `dhcp-ip-pool.yaml`: IPPool manifest for the `net-10-9` network

This configuration enables dynamic IP address assignment in Harvester using DHCP-managed custom networks. 🚀
