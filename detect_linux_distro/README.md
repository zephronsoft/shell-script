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
- **Red Hat Enterprise Linux (RHEL)** - Commercial, enterprise support (versions 2.1-10)
- **Red Hat Enterprise Linux Server** - Server edition with enterprise features
- **Red Hat Enterprise Linux Workstation** - Workstation edition for developers
- **Red Hat Enterprise Linux Desktop** - Desktop edition for end users
- **Red Hat Enterprise Linux Client** - Client edition for workstations
- **CentOS Stream** - Rolling-release, community version of RHEL
- **CentOS** - Traditional CentOS (legacy versions 5/6/7)
- **Oracle Linux** - RHEL-compatible, optimized for Oracle workloads
- **Rocky Linux** - Community-driven RHEL clone
- **AlmaLinux** - Another RHEL-compatible community distribution
- **Amazon Linux** - AWS-optimized enterprise distribution
- **Scientific Linux** - RHEL-based distribution for scientific computing

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
- **SUSE** - Enterprise and community Linux distribution
- **Asahi Linux** - Linux distribution for Apple Silicon Macs

#### Embedded / Minimal
- **Embedded Linux (ARM)** - ARM-based embedded systems
- **Embedded Linux (MIPS)** - MIPS-based embedded systems
- **Minimal Linux** - Systems with basic init and minimal tools

### 🔍 **Detection Methods**

The script uses multiple detection methods in order of preference for maximum compatibility:

1. **`/etc/os-release`** - Primary method (LSB standard)
2. **`/etc/lsb-release`** - Legacy LSB information
3. **`/etc/redhat-release`** - Red Hat family distributions (enhanced RHEL detection)
4. **`/etc/system-release`** - Amazon Linux and similar systems
5. **`/etc/release`** - Solaris-like systems
6. **`/etc/debian_version`** - Debian-based distributions
7. **Distribution-specific files** - Arch, Gentoo, Alpine, etc.
8. **`/etc/issue`** - Legacy login banner detection
9. **`/proc/version`** - Kernel-based distribution detection (EL patterns)
10. **Embedded system detection** - ARM/MIPS systems
11. **`uname -a`** - Last resort detection method
12. **RHEL legacy detection** - Specialized RHEL detection for all versions

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
CPU Cores: 4
Total Memory: 8GB
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

#### RHEL Detection Example
```bash
./detect_linux_distro.sh --json
```

**Sample RHEL Output:**
```json
{
  "distribution": {
    "name": "Red Hat Enterprise Linux Server",
    "version": "7.9",
    "id": "rhel",
    "pretty_name": "Red Hat Enterprise Linux Server 7.9 (Maipo)",
    "codename": "Maipo",
    "description": "Red Hat Enterprise Linux Server 7.9 (Maipo)",
    "full_info": "Red Hat Enterprise Linux Server release 7.9 (Maipo)",
    "category": "Enterprise / Server"
  },
  "system": {
    "kernel": "3.10.0-1160.el7.x86_64",
    "architecture": "x86_64",
    "hostname": "rhel-server",
    "uptime": "up 45 days, 12 hours, 30 minutes",
    "desktop_environment": "Unknown",
    "package_manager": "YUM",
    "cpu_cores": "8",
    "total_memory": "32GB"
  },
  "detection": {
    "timestamp": "2024-01-15T10:30:00Z",
    "method": "shell_script",
    "script_version": "1.2",
    "legacy_compatible": true
  }
}
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
    "package_manager": "APT",
    "cpu_cores": "4",
    "total_memory": "8GB"
  },
  "detection": {
    "timestamp": "2024-01-15T10:30:00Z",
    "method": "shell_script",
    "script_version": "1.1",
    "legacy_compatible": true
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
- `cpu_cores`: Number of CPU cores
- `total_memory`: Total system memory

### Detection Information
- `timestamp`: Detection timestamp (ISO 8601)
- `method`: Detection method used
- `script_version`: Script version
- `legacy_compatible`: Legacy compatibility flag

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
- **Legacy Compatible**: Works on systems with minimal tools

## RHEL Support

### 🔴 **Complete Red Hat Enterprise Linux Detection**

The script provides comprehensive support for all RHEL versions and variants:

#### **Supported RHEL Versions**
- **RHEL 2.1** - Legacy enterprise Linux (2002)
- **RHEL 3** - Enterprise Linux 3 (2003)
- **RHEL 4** - Enterprise Linux 4 (2005)
- **RHEL 5** - Enterprise Linux 5 (2007)
- **RHEL 6** - Enterprise Linux 6 (2010)
- **RHEL 7** - Enterprise Linux 7 (2014)
- **RHEL 8** - Enterprise Linux 8 (2019)
- **RHEL 9** - Enterprise Linux 9 (2022)
- **RHEL 10** - Enterprise Linux 10 (future)

#### **RHEL Variants Detected**
- **Red Hat Enterprise Linux Server** - Server edition
- **Red Hat Enterprise Linux Workstation** - Developer workstation
- **Red Hat Enterprise Linux Desktop** - End-user desktop
- **Red Hat Enterprise Linux Client** - Client workstation

#### **Detection Methods for RHEL**
1. **`/etc/redhat-release`** - Primary RHEL detection
2. **`/etc/issue`** - Legacy login banner parsing
3. **`/proc/version`** - Kernel-based EL pattern detection
4. **RHEL legacy detection** - Specialized RHEL functions
5. **Kernel patterns** - EL2, EL3, EL4, EL5, EL6, EL7, EL8, EL9, EL10

## Legacy Compatibility

### 🛡️ **Legacy Server Support**

The script is specifically designed for maximum compatibility with legacy systems:

- **RHEL 2.1-10**: Complete support for all RHEL versions including legacy 2.1
- **RHEL Variants**: Server, Workstation, Desktop, Client editions
- **CentOS 5/6/7**: Complete backward compatibility
- **Ubuntu 10.04+**: Support for very old Ubuntu versions
- **Debian 6+**: Legacy Debian system support
- **SUSE 10+**: Enterprise and legacy SUSE support
- **Embedded systems**: ARM/MIPS IoT devices
- **Minimal systems**: Containers, chroots, basic init

### **Robust Fallback Methods**

- **Command availability checks**: Tests for tool existence before use
- **Multiple detection paths**: 12 different detection methods
- **Error handling**: Graceful degradation with fallback values
- **Legacy file support**: `/etc/issue`, `/proc/version`, etc.
- **Minimal dependencies**: Works with basic shell tools only
- **RHEL-specific detection**: Enhanced patterns for all RHEL versions
- **Kernel pattern matching**: EL (Enterprise Linux) kernel detection

## Compatibility

- **Linux**: All major Linux distributions (including legacy versions)
- **macOS**: Limited support (detects as Unix-like)
- **BSD**: Limited support
- **WSL**: Full support on Windows Subsystem for Linux
- **Embedded**: ARM, MIPS, and other embedded Linux systems
- **Containers**: Docker, LXC, and other containerized environments

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

### Version 1.2
- **Complete RHEL support**: Added comprehensive detection for RHEL 2.1-10
- **RHEL variants**: Server, Workstation, Desktop, Client edition detection
- **Enhanced RHEL detection**: Multiple detection methods for all RHEL versions
- **Kernel pattern matching**: EL (Enterprise Linux) kernel detection (el2-el10)
- **Scientific Linux**: Added support for RHEL-based scientific distribution
- **Legacy RHEL files**: Enhanced `/etc/redhat-release` and `/etc/issue` parsing
- **RHEL-specific functions**: Dedicated RHEL legacy detection methods

### Version 1.1
- **Legacy compatibility**: Added support for legacy servers and systems
- **Enhanced detection**: 12 detection methods for maximum compatibility
- **Embedded systems**: ARM/MIPS detection for IoT devices
- **Improved system info**: CPU cores, memory, robust fallbacks
- **Amazon Linux**: Added support for AWS distributions
- **Legacy distributions**: CentOS, SUSE, minimal systems
- **Robust error handling**: Graceful degradation on minimal systems

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
