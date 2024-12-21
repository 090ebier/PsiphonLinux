# Psiphon Control Script

This script provides a convenient way to control and configure the Psiphon service on Linux systems. With this script, you can manage the Psiphon service (start, stop, check status), change configurations like proxy ports and egress region, and restart the service to apply changes.

## Prerequisites

- A Linux system with Psiphon installed.
- `systemd` must be available to manage the Psiphon service.
- Psiphon binary and configuration files must be correctly set up in the appropriate locations (e.g., `/etc/psiphon/psiphon-tunnel-core-x86_64` and `/etc/psiphon/psiphon.config`).

## Features

- **Start** Psiphon service.
- **Stop** Psiphon service.
- **Check the status** of the Psiphon service.
- **Change the egress region** (e.g., `US`, `GB`, `CA`).
- **Change the HTTP proxy port** (e.g., `8081`).
- **Change the SOCKS proxy port** (e.g., `1081`).
- **Restart** the Psiphon service to apply any changes.
- **Uninstall** the Psiphon service and remove associated files.

## Installation

To install the Psiphon service and control script, execute the following command:

```bash
curl -s https://raw.githubusercontent.com/090ebier/PsiphonLinux/refs/heads/main/plinstaller2.sh | sudo bash
```

This command will:

- Download and install the Psiphon binary and configuration files.
- Create the necessary systemd service for managing Psiphon.
- Install the control script to `/usr/bin/psiphon` for easy management.

## Uninstalling Psiphon

If you want to uninstall the Psiphon service and remove all associated files, run the following command:

```bash
sudo psiphon uninstall
```

This command will:

- Stop the Psiphon service if it is running.
- Remove the Psiphon binary from `/etc/psiphon/psiphon-tunnel-core-x86_64`.
- Delete the Psiphon configuration file from `/etc/psiphon/psiphon.config`.
- Remove the control script from `/usr/bin/psiphon`.
- Disable and remove the Psiphon service from `systemd`.

**Note**: After running the uninstall command, Psiphon will be completely removed from your system.

## Usage

After installation, you can use the `psiphon` command to manage the service and configure settings. The basic syntax is:

```bash
psiphon [command] [arguments]
```

### Available Commands:

- **start** - Start the Psiphon service.
- **stop** - Stop the Psiphon service.
- **status** - Show the status of the Psiphon service.
- **region [REGION]** - Change the egress region. Replace `[REGION]` with one of the supported regions (e.g., `US`, `GB`, `CA`).
- **httpport [PORT]** - Change the HTTP proxy port. Replace `[PORT]` with the desired port number (e.g., `8081`).
- **socksport [PORT]** - Change the SOCKS proxy port. Replace `[PORT]` with the desired port number (e.g., `1081`).
- **restart** - Restart the Psiphon service to apply any changes.
- **-h** or **--help** - Display the help message.

### Example Usage:

Start the Psiphon service:

```bash
sudo psiphon start
```

Stop the Psiphon service:

```bash
sudo psiphon stop
```

Check the status of the Psiphon service:

```bash
sudo psiphon status
```

Change the egress region to `US` (United States):

```bash
sudo psiphon region US
```

Change the HTTP proxy port to `8081`:

```bash
sudo psiphon httpport 8081
```

Change the SOCKS proxy port to `1081`:

```bash
sudo psiphon socksport 1081
```

Restart the Psiphon service to apply changes:

```bash
sudo psiphon restart
```

Display the help message to see all available commands:

```bash
sudo psiphon --help
