# Linux Distribution Detection Script

A comprehensive shell script that detects Linux distribution versions and flavors across various Linux distributions. The script supports both human-readable and JSON output formats.

## Features

### 🐧 **Supported Distributions**

#### General Purpose / Desktop
- **Ubuntu** - Beginner-friendly, widely used for desktops and servers
- **Debian** - Stable and community-driven, base for many other distros
- **Linux Mint** - User-friendly desktop, based on Ubuntu/Debian
- **Fedora** - Cutting-edge, sponsored by Red Hat
- **openSUSE** - Strong desktop and enterprise features
- **elementary OS** - macOS-like design, built on Ubuntu
- **Zorin OS** - Windows-like interface, good for newcomers
- **Pop!_OS** - Ubuntu-based with gaming and productivity focus
- **Lubuntu** - Lightweight Ubuntu flavor using LXQt
- **Xubuntu** - Lightweight Ubuntu flavor using XFCE
- **Kubuntu** - Ubuntu flavor using KDE Plasma
- **KDE neon** - Latest KDE software on Ubuntu base

#### Enterprise / Server
- **Red Hat Enterprise Linux (RHEL)** - Commercial, enterprise support
- **CentOS Stream** - Rolling-release, community version of RHEL
- **Oracle Linux** - RHEL-compatible, optimized for Oracle workloads
- **Rocky Linux** - Community-driven RHEL clone
- **AlmaLinux** - Another RHEL-compatible community distribution

#### Lightweight / Older Hardware
- **Puppy Linux** - Super lightweight, runs entirely in RAM
- **antiX** - Debian-based, very minimal
- **Tiny Core Linux** - Extremely small footprint (as low as 15 MB)
- **4MLinux** - Minimal Linux distribution

#### Specialized / Security / Privacy
- **Kali Linux** - Security testing and penetration testing
- **Parrot OS** - Security, privacy, and forensics
- **Tails** - Privacy-focused, runs from USB, leaves no trace
- **Qubes OS** - Security through isolation (VM-based)

#### Rolling Release / Bleeding Edge
- **Arch Linux** - Minimal, highly customizable, DIY approach
- **Manjaro** - User-friendly Arch-based distro
- **EndeavourOS** - Community-driven Arch alternative
- **Gentoo** - Source-based, fully customizable
- **Void Linux** - Independent, rolling release

#### Minimal / Specialized
- **Alpine Linux** - Security-oriented, lightweight Linux distribution
- **Slackware** - One of the oldest Linux distributions
- **Asahi Linux** - Linux distribution for Apple Silicon Macs

### 🔍 **Detection Methods**

The script uses multiple detection methods in order of preference:

1. **`/etc/os-release`** - Primary method (LSB standard)
2. **`/etc/lsb-release`** - Legacy LSB information
3. **`/etc/redhat-release`** - Red Hat family distributions
4. **`/etc/debian_version`** - Debian-based distributions
5. **Distribution-specific files** - Arch, Gentoo, Alpine, etc.
6. **Specialized detection** - Security distributions and variants

### 📊 **Output Formats**

- **Default**: Full colored output with system information
- **Simple**: Just distribution name and version
- **Category**: Distribution category only
- **JSON**: Structured JSON output with all information

## Installation

1. Download the script:
```bash
wget https://raw.githubusercontent.com/your-repo/detect_linux_distro.sh/main/detect_linux_distro.sh
```

2. Make it executable:
```bash
chmod +x detect_linux_distro.sh
```

3. Run the script:
```bash
./detect_linux_distro.sh
```

## Usage

### Command Line Options

```bash
./detect_linux_distro.sh [OPTIONS]
```

| Option | Description |
|--------|-------------|
| `-h, --help` | Show help message |
| `-s, --simple` | Show only distribution name and version |
| `-f, --full` | Show full system information (default) |
| `-c, --category` | Show only distribution category |
| `-j, --json` | Output results in JSON format |

### Examples

#### Default Output (Full Information)
```bash
./detect_linux_distro.sh
```

**Sample Output:**
```
================================
Linux Distribution Detection
================================
[INFO] Detected from /etc/os-release

================================
Distribution Information
================================
Distribution: Ubuntu 22.04.3 LTS
Version: 22.04
Codename: jammy
ID: ubuntu
Description: Ubuntu 22.04.3 LTS
Category: General Purpose / Desktop

================================
System Information
================================
Kernel: 5.15.0-91-generic
Architecture: x86_64
Hostname: ubuntu-server
Uptime: up 2 days, 3 hours, 15 minutes
Desktop Environment: GNOME
Package Manager: APT (Advanced Package Tool)
```

#### Simple Output
```bash
./detect_linux_distro.sh --simple
```

**Sample Output:**
```
Ubuntu 22.04
```

#### Category Only
```bash
./detect_linux_distro.sh --category
```

**Sample Output:**
```
General Purpose / Desktop
```

#### JSON Output
```bash
./detect_linux_distro.sh --json
```

**Sample Output:**
```json
{
  "distribution": {
    "name": "Ubuntu",
    "version": "22.04",
    "id": "ubuntu",
    "pretty_name": "Ubuntu 22.04.3 LTS",
    "codename": "jammy",
    "description": "Ubuntu 22.04.3 LTS",
    "full_info": "",
    "category": "General Purpose / Desktop"
  },
  "system": {
    "kernel": "5.15.0-91-generic",
    "architecture": "x86_64",
    "hostname": "ubuntu-server",
    "uptime": "up 2 days, 3 hours, 15 minutes",
    "desktop_environment": "GNOME",
    "package_manager": "APT"
  },
  "detection": {
    "timestamp": "2024-01-15T10:30:00Z",
    "method": "shell_script",
    "script_version": "1.0"
  }
}
```

## JSON Output Structure

The JSON output contains three main sections:

### Distribution Information
- `name`: Distribution name
- `version`: Version number
- `id`: Distribution ID
- `pretty_name`: Human-readable name
- `codename`: Version codename
- `description`: Full description
- `full_info`: Additional information
- `category`: Distribution category

### System Information
- `kernel`: Kernel version
- `architecture`: System architecture
- `hostname`: System hostname
- `uptime`: System uptime
- `desktop_environment`: Desktop environment
- `package_manager`: Package manager

### Detection Information
- `timestamp`: Detection timestamp (ISO 8601)
- `method`: Detection method used
- `script_version`: Script version

## Use Cases

### System Administration
- **Inventory Management**: Identify Linux distributions across multiple servers
- **Automation Scripts**: Use JSON output for automated system configuration
- **Documentation**: Generate system documentation with distribution details

### Development
- **CI/CD Pipelines**: Detect target environment for deployment
- **Testing**: Verify expected distribution in test environments
- **Monitoring**: Track distribution versions across environments

### Security
- **Compliance**: Verify distribution versions for security policies
- **Auditing**: Document system configurations
- **Vulnerability Assessment**: Identify systems requiring updates

## Integration Examples

### Bash Script Integration
```bash
#!/bin/bash
DISTRO_INFO=$(./detect_linux_distro.sh --json)
DISTRO_NAME=$(echo "$DISTRO_INFO" | jq -r '.distribution.name')
DISTRO_VERSION=$(echo "$DISTRO_INFO" | jq -r '.distribution.version')

echo "Running on $DISTRO_NAME $DISTRO_VERSION"
```

### Python Integration
```python
import subprocess
import json

def get_distro_info():
    result = subprocess.run(['./detect_linux_distro.sh', '--json'], 
                          capture_output=True, text=True)
    return json.loads(result.stdout)

distro_info = get_distro_info()
print(f"Distribution: {distro_info['distribution']['name']}")
print(f"Version: {distro_info['distribution']['version']}")
print(f"Category: {distro_info['distribution']['category']}")
```

### Ansible Integration
```yaml
- name: Detect Linux distribution
  shell: ./detect_linux_distro.sh --json
  register: distro_info

- name: Parse distribution information
  set_fact:
    distro_name: "{{ (distro_info.stdout | from_json).distribution.name }}"
    distro_version: "{{ (distro_info.stdout | from_json).distribution.version }}"
```

## Requirements

- **Bash**: Version 3.0 or higher
- **Standard Unix Tools**: `grep`, `awk`, `cat`, `uname`, `hostname`, `uptime`, `date`
- **No External Dependencies**: Pure shell script implementation

## Compatibility

- **Linux**: All major Linux distributions
- **macOS**: Limited support (detects as Unix-like)
- **BSD**: Limited support
- **WSL**: Full support on Windows Subsystem for Linux

## Contributing

Contributions are welcome! Please feel free to submit:

- **New Distribution Support**: Add detection for additional distributions
- **Bug Fixes**: Report and fix issues
- **Feature Enhancements**: Suggest new features
- **Documentation**: Improve documentation and examples

### Adding New Distributions

To add support for a new distribution:

1. Create a detection function following the naming pattern `detect_[distro_name]()`
2. Add the distribution to the appropriate category in `categorize_distro()`
3. Include the detection function in the main detection logic
4. Update this README with the new distribution

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Changelog

### Version 1.0
- Initial release
- Support for 30+ Linux distributions
- Multiple output formats (default, simple, category, JSON)
- Comprehensive system information
- Cross-platform compatibility

## Support

For support, questions, or feature requests:

- **Issues**: [GitHub Issues](https://github.com/your-repo/detect_linux_distro.sh/issues)
- **Discussions**: [GitHub Discussions](https://github.com/your-repo/detect_linux_distro.sh/discussions)
- **Email**: your-email@example.com

## Acknowledgments

- Linux distribution maintainers and communities
- LSB (Linux Standard Base) specification
- Contributors and testers

---

**Made with ❤️ for the Linux community**
