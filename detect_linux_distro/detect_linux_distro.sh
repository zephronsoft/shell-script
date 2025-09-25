#!/bin/bash

# Linux Distribution Detection Script
# Detects version and flavor of Linux operating systems
# Supports major distributions, specialized distros, and legacy systems
# Compatible with older servers and minimal Linux environments

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${BLUE}================================${NC}"
    echo -e "${WHITE}$1${NC}"
    echo -e "${BLUE}================================${NC}"
}

# Function to detect distribution from /etc/os-release
detect_from_os_release() {
    if [ -f /etc/os-release ]; then
        # Use safer sourcing method for older systems
        if command -v grep >/dev/null 2>&1; then
            DISTRO_NAME=$(grep "^NAME=" /etc/os-release 2>/dev/null | cut -d'=' -f2- | tr -d '"' | head -1)
            DISTRO_ID=$(grep "^ID=" /etc/os-release 2>/dev/null | cut -d'=' -f2- | tr -d '"' | head -1)
            DISTRO_VERSION=$(grep "^VERSION_ID=" /etc/os-release 2>/dev/null | cut -d'=' -f2- | tr -d '"' | head -1)
            DISTRO_PRETTY=$(grep "^PRETTY_NAME=" /etc/os-release 2>/dev/null | cut -d'=' -f2- | tr -d '"' | head -1)
            DISTRO_VERSION_CODENAME=$(grep "^VERSION_CODENAME=" /etc/os-release 2>/dev/null | cut -d'=' -f2- | tr -d '"' | head -1)
        else
            # Fallback for systems without grep
            . /etc/os-release
            DISTRO_NAME="$NAME"
            DISTRO_ID="$ID"
            DISTRO_VERSION="$VERSION_ID"
            DISTRO_PRETTY="$PRETTY_NAME"
            DISTRO_VERSION_CODENAME="$VERSION_CODENAME"
        fi
        return 0
    fi
    return 1
}

# Function to detect distribution from /etc/lsb-release
detect_from_lsb_release() {
    if [ -f /etc/lsb-release ]; then
        # Use safer sourcing method for older systems
        if command -v grep >/dev/null 2>&1; then
            DISTRO_NAME=$(grep "^DISTRIB_ID=" /etc/lsb-release 2>/dev/null | cut -d'=' -f2- | tr -d '"' | head -1)
            DISTRO_VERSION=$(grep "^DISTRIB_RELEASE=" /etc/lsb-release 2>/dev/null | cut -d'=' -f2- | tr -d '"' | head -1)
            DISTRO_CODENAME=$(grep "^DISTRIB_CODENAME=" /etc/lsb-release 2>/dev/null | cut -d'=' -f2- | tr -d '"' | head -1)
            DISTRO_DESCRIPTION=$(grep "^DISTRIB_DESCRIPTION=" /etc/lsb-release 2>/dev/null | cut -d'=' -f2- | tr -d '"' | head -1)
        else
            # Fallback for systems without grep
            . /etc/lsb-release
            DISTRO_NAME="$DISTRIB_ID"
            DISTRO_VERSION="$DISTRIB_RELEASE"
            DISTRO_CODENAME="$DISTRIB_CODENAME"
            DISTRO_DESCRIPTION="$DISTRIB_DESCRIPTION"
        fi
        return 0
    fi
    return 1
}

# Function to detect distribution from /etc/redhat-release
detect_from_redhat_release() {
    if [ -f /etc/redhat-release ]; then
        local redhat_content=$(cat /etc/redhat-release 2>/dev/null)
        
        # Detect RHEL variants and versions
        if echo "$redhat_content" | grep -qi "red hat enterprise linux"; then
            DISTRO_NAME="Red Hat Enterprise Linux"
            
            # Extract version with comprehensive pattern matching
            if command -v grep >/dev/null 2>&1; then
                # Try different version patterns for all RHEL versions
                DISTRO_VERSION=$(echo "$redhat_content" | grep -oE '[0-9]+(\.[0-9]+)?' | head -1)
                
                # Handle specific RHEL version patterns
                if echo "$redhat_content" | grep -qi "release 2\."; then
                    DISTRO_VERSION=$(echo "$redhat_content" | grep -oE '2\.[0-9]+' | head -1)
                elif echo "$redhat_content" | grep -qi "release [3-9]"; then
                    DISTRO_VERSION=$(echo "$redhat_content" | grep -oE '[3-9](\.[0-9]+)?' | head -1)
                elif echo "$redhat_content" | grep -qi "release 10"; then
                    DISTRO_VERSION="10"
                fi
            else
                # Fallback for systems without grep
                DISTRO_VERSION=$(echo "$redhat_content" | sed 's/[^0-9.]*\([0-9.]*\).*/\1/' | head -1)
            fi
            
            # Detect RHEL variant (Server, Workstation, etc.)
            if echo "$redhat_content" | grep -qi "server"; then
                DISTRO_NAME="Red Hat Enterprise Linux Server"
            elif echo "$redhat_content" | grep -qi "workstation"; then
                DISTRO_NAME="Red Hat Enterprise Linux Workstation"
            elif echo "$redhat_content" | grep -qi "desktop"; then
                DISTRO_NAME="Red Hat Enterprise Linux Desktop"
            elif echo "$redhat_content" | grep -qi "client"; then
                DISTRO_NAME="Red Hat Enterprise Linux Client"
            fi
            
        elif echo "$redhat_content" | grep -qi "centos"; then
            DISTRO_NAME="CentOS"
            DISTRO_VERSION=$(echo "$redhat_content" | grep -oE '[0-9]+(\.[0-9]+)?' | head -1)
            
        elif echo "$redhat_content" | grep -qi "scientific"; then
            DISTRO_NAME="Scientific Linux"
            DISTRO_VERSION=$(echo "$redhat_content" | grep -oE '[0-9]+(\.[0-9]+)?' | head -1)
            
        elif echo "$redhat_content" | grep -qi "oracle"; then
            DISTRO_NAME="Oracle Linux"
            DISTRO_VERSION=$(echo "$redhat_content" | grep -oE '[0-9]+(\.[0-9]+)?' | head -1)
            
        elif echo "$redhat_content" | grep -qi "rocky"; then
            DISTRO_NAME="Rocky Linux"
            DISTRO_VERSION=$(echo "$redhat_content" | grep -oE '[0-9]+(\.[0-9]+)?' | head -1)
            
        elif echo "$redhat_content" | grep -qi "alma"; then
            DISTRO_NAME="AlmaLinux"
            DISTRO_VERSION=$(echo "$redhat_content" | grep -oE '[0-9]+(\.[0-9]+)?' | head -1)
            
        elif echo "$redhat_content" | grep -qi "amazon"; then
            DISTRO_NAME="Amazon Linux"
            DISTRO_VERSION=$(echo "$redhat_content" | grep -oE '[0-9]+(\.[0-9]+)?' | head -1)
            
        else
            # Generic Red Hat family detection
            if command -v awk >/dev/null 2>&1; then
                DISTRO_NAME=$(awk '{print $1}' /etc/redhat-release 2>/dev/null)
            else
                DISTRO_NAME=$(head -1 /etc/redhat-release 2>/dev/null | cut -d' ' -f1)
            fi
            DISTRO_VERSION=$(echo "$redhat_content" | grep -oE '[0-9]+(\.[0-9]+)?' | head -1)
        fi
        
        DISTRO_FULL="$redhat_content"
        return 0
    fi
    return 1
}

# Function to detect distribution from /etc/debian_version
detect_from_debian_version() {
    if [ -f /etc/debian_version ]; then
        DISTRO_NAME="Debian"
        DISTRO_VERSION=$(cat /etc/debian_version)
        return 0
    fi
    return 1
}

# Function to detect Arch Linux
detect_arch() {
    if [ -f /etc/arch-release ]; then
        DISTRO_NAME="Arch Linux"
        DISTRO_VERSION=$(uname -r | cut -d. -f1-2)
        return 0
    fi
    return 1
}

# Function to detect Gentoo
detect_gentoo() {
    if [ -f /etc/gentoo-release ]; then
        DISTRO_NAME="Gentoo"
        DISTRO_VERSION=$(cat /etc/gentoo-release | grep -oE '[0-9]+\.[0-9]+' | head -1)
        return 0
    fi
    return 1
}

# Function to detect Alpine Linux
detect_alpine() {
    if [ -f /etc/alpine-release ]; then
        DISTRO_NAME="Alpine Linux"
        DISTRO_VERSION=$(cat /etc/alpine-release)
        return 0
    fi
    return 1
}

# Function to detect Slackware
detect_slackware() {
    if [ -f /etc/slackware-version ]; then
        DISTRO_NAME="Slackware"
        DISTRO_VERSION=$(cat /etc/slackware-version | awk '{print $2}')
        return 0
    fi
    return 1
}

# Function to detect Void Linux
detect_void() {
    if [ -f /etc/void-release ]; then
        DISTRO_NAME="Void Linux"
        DISTRO_VERSION=$(cat /etc/void-release)
        return 0
    fi
    return 1
}

# Function to detect Puppy Linux
detect_puppy() {
    if [ -f /etc/puppyversion ]; then
        DISTRO_NAME="Puppy Linux"
        DISTRO_VERSION=$(cat /etc/puppyversion)
        return 0
    fi
    return 1
}

# Function to detect Kali Linux
detect_kali() {
    if [ -f /etc/debian_version ] && grep -q "kali" /etc/os-release 2>/dev/null; then
        DISTRO_NAME="Kali Linux"
        DISTRO_VERSION=$(cat /etc/debian_version)
        return 0
    fi
    return 1
}

# Function to detect Parrot OS
detect_parrot() {
    if [ -f /etc/debian_version ] && grep -q "parrot" /etc/os-release 2>/dev/null; then
        DISTRO_NAME="Parrot OS"
        DISTRO_VERSION=$(cat /etc/debian_version)
        return 0
    fi
    return 1
}

# Function to detect Tails
detect_tails() {
    if [ -f /etc/debian_version ] && grep -q "tails" /etc/os-release 2>/dev/null; then
        DISTRO_NAME="Tails"
        DISTRO_VERSION=$(cat /etc/debian_version)
        return 0
    fi
    return 1
}

# Function to detect Qubes OS
detect_qubes() {
    if [ -f /etc/qubes-release ]; then
        DISTRO_NAME="Qubes OS"
        DISTRO_VERSION=$(cat /etc/qubes-release | grep -oE '[0-9]+\.[0-9]+' | head -1)
        return 0
    fi
    return 1
}

# Function to detect elementary OS
detect_elementary() {
    if [ -f /etc/os-release ] && grep -q "elementary" /etc/os-release; then
        DISTRO_NAME="elementary OS"
        DISTRO_VERSION=$(grep VERSION_ID /etc/os-release | cut -d= -f2 | tr -d '"')
        return 0
    fi
    return 1
}

# Function to detect Zorin OS
detect_zorin() {
    if [ -f /etc/os-release ] && grep -q "zorin" /etc/os-release; then
        DISTRO_NAME="Zorin OS"
        DISTRO_VERSION=$(grep VERSION_ID /etc/os-release | cut -d= -f2 | tr -d '"')
        return 0
    fi
    return 1
}

# Function to detect Pop!_OS
detect_popos() {
    if [ -f /etc/os-release ] && grep -q "pop" /etc/os-release; then
        DISTRO_NAME="Pop!_OS"
        DISTRO_VERSION=$(grep VERSION_ID /etc/os-release | cut -d= -f2 | tr -d '"')
        return 0
    fi
    return 1
}

# Function to detect Manjaro
detect_manjaro() {
    if [ -f /etc/os-release ] && grep -q "manjaro" /etc/os-release; then
        DISTRO_NAME="Manjaro"
        DISTRO_VERSION=$(grep VERSION_ID /etc/os-release | cut -d= -f2 | tr -d '"')
        return 0
    fi
    return 1
}

# Function to detect EndeavourOS
detect_endeavour() {
    if [ -f /etc/os-release ] && grep -q "endeavour" /etc/os-release; then
        DISTRO_NAME="EndeavourOS"
        DISTRO_VERSION=$(grep VERSION_ID /etc/os-release | cut -d= -f2 | tr -d '"')
        return 0
    fi
    return 1
}

# Function to detect Rocky Linux
detect_rocky() {
    if [ -f /etc/os-release ] && grep -q "rocky" /etc/os-release; then
        DISTRO_NAME="Rocky Linux"
        DISTRO_VERSION=$(grep VERSION_ID /etc/os-release | cut -d= -f2 | tr -d '"')
        return 0
    fi
    return 1
}

# Function to detect AlmaLinux
detect_alma() {
    if [ -f /etc/os-release ] && grep -q "alma" /etc/os-release; then
        DISTRO_NAME="AlmaLinux"
        DISTRO_VERSION=$(grep VERSION_ID /etc/os-release | cut -d= -f2 | tr -d '"')
        return 0
    fi
    return 1
}

# Function to detect Oracle Linux
detect_oracle() {
    if [ -f /etc/os-release ] && grep -q "oracle" /etc/os-release; then
        DISTRO_NAME="Oracle Linux"
        DISTRO_VERSION=$(grep VERSION_ID /etc/os-release | cut -d= -f2 | tr -d '"')
        return 0
    fi
    return 1
}

# Function to detect CentOS Stream
detect_centos_stream() {
    if [ -f /etc/os-release ] && grep -q "centos" /etc/os-release && grep -q "stream" /etc/os-release; then
        DISTRO_NAME="CentOS Stream"
        DISTRO_VERSION=$(grep VERSION_ID /etc/os-release | cut -d= -f2 | tr -d '"')
        return 0
    fi
    return 1
}

# Function to detect antiX
detect_antix() {
    if [ -f /etc/os-release ] && grep -q "antix" /etc/os-release; then
        DISTRO_NAME="antiX"
        DISTRO_VERSION=$(grep VERSION_ID /etc/os-release | cut -d= -f2 | tr -d '"')
        return 0
    fi
    return 1
}

# Function to detect Tiny Core Linux
detect_tinycore() {
    if [ -f /etc/tinycore-release ]; then
        DISTRO_NAME="Tiny Core Linux"
        DISTRO_VERSION=$(cat /etc/tinycore-release)
        return 0
    fi
    return 1
}

# Function to detect Lubuntu
detect_lubuntu() {
    if [ -f /etc/os-release ] && grep -q "lubuntu" /etc/os-release; then
        DISTRO_NAME="Lubuntu"
        DISTRO_VERSION=$(grep VERSION_ID /etc/os-release | cut -d= -f2 | tr -d '"')
        return 0
    fi
    return 1
}

# Function to detect Xubuntu
detect_xubuntu() {
    if [ -f /etc/os-release ] && grep -q "xubuntu" /etc/os-release; then
        DISTRO_NAME="Xubuntu"
        DISTRO_VERSION=$(grep VERSION_ID /etc/os-release | cut -d= -f2 | tr -d '"')
        return 0
    fi
    return 1
}

# Function to detect Kubuntu
detect_kubuntu() {
    if [ -f /etc/os-release ] && grep -q "kubuntu" /etc/os-release; then
        DISTRO_NAME="Kubuntu"
        DISTRO_VERSION=$(grep VERSION_ID /etc/os-release | cut -d= -f2 | tr -d '"')
        return 0
    fi
    return 1
}

# Function to detect KDE neon
detect_kde_neon() {
    if [ -f /etc/os-release ] && grep -q "neon" /etc/os-release; then
        DISTRO_NAME="KDE neon"
        DISTRO_VERSION=$(grep VERSION_ID /etc/os-release | cut -d= -f2 | tr -d '"')
        return 0
    fi
    return 1
}

# Function to detect 4MLinux
detect_4mlinux() {
    if [ -f /etc/os-release ] && grep -q "4mlinux" /etc/os-release; then
        DISTRO_NAME="4MLinux"
        DISTRO_VERSION=$(grep VERSION_ID /etc/os-release | cut -d= -f2 | tr -d '"')
        return 0
    fi
    return 1
}

# Function to detect Asahi Linux
detect_asahi() {
    if [ -f /etc/os-release ] && grep -q "asahi" /etc/os-release; then
        DISTRO_NAME="Asahi Linux"
        DISTRO_VERSION=$(grep VERSION_ID /etc/os-release | cut -d= -f2 | tr -d '"')
        return 0
    fi
    return 1
}

# Function to detect RHEL from legacy files
detect_rhel_legacy() {
    # Check for legacy RHEL files
    if [ -f /etc/redhat-release ]; then
        local redhat_content=$(cat /etc/redhat-release 2>/dev/null)
        
        # Enhanced RHEL detection for all versions
        if echo "$redhat_content" | grep -qi "red hat enterprise linux"; then
            DISTRO_NAME="Red Hat Enterprise Linux"
            
            # Comprehensive version detection for all RHEL versions
            if echo "$redhat_content" | grep -qi "release 2\.[0-9]"; then
                DISTRO_VERSION=$(echo "$redhat_content" | grep -oE '2\.[0-9]+' | head -1)
            elif echo "$redhat_content" | grep -qi "release 3"; then
                DISTRO_VERSION="3"
            elif echo "$redhat_content" | grep -qi "release 4"; then
                DISTRO_VERSION="4"
            elif echo "$redhat_content" | grep -qi "release 5"; then
                DISTRO_VERSION="5"
            elif echo "$redhat_content" | grep -qi "release 6"; then
                DISTRO_VERSION="6"
            elif echo "$redhat_content" | grep -qi "release 7"; then
                DISTRO_VERSION="7"
            elif echo "$redhat_content" | grep -qi "release 8"; then
                DISTRO_VERSION="8"
            elif echo "$redhat_content" | grep -qi "release 9"; then
                DISTRO_VERSION="9"
            elif echo "$redhat_content" | grep -qi "release 10"; then
                DISTRO_VERSION="10"
            else
                DISTRO_VERSION=$(echo "$redhat_content" | grep -oE '[0-9]+(\.[0-9]+)?' | head -1)
            fi
            
            # Detect RHEL variant
            if echo "$redhat_content" | grep -qi "server"; then
                DISTRO_NAME="Red Hat Enterprise Linux Server"
            elif echo "$redhat_content" | grep -qi "workstation"; then
                DISTRO_NAME="Red Hat Enterprise Linux Workstation"
            elif echo "$redhat_content" | grep -qi "desktop"; then
                DISTRO_NAME="Red Hat Enterprise Linux Desktop"
            elif echo "$redhat_content" | grep -qi "client"; then
                DISTRO_NAME="Red Hat Enterprise Linux Client"
            fi
            
            DISTRO_FULL="$redhat_content"
            return 0
        fi
    fi
    
    # Check for legacy RHEL kernel patterns
    if [ -f /proc/version ]; then
        local proc_version=$(cat /proc/version 2>/dev/null)
        if echo "$proc_version" | grep -qi "redhat.*el[0-9]"; then
            DISTRO_NAME="Red Hat Enterprise Linux"
            
            # Extract RHEL version from kernel (el2, el3, etc.)
            if echo "$proc_version" | grep -qi "el2"; then
                DISTRO_VERSION="2"
            elif echo "$proc_version" | grep -qi "el3"; then
                DISTRO_VERSION="3"
            elif echo "$proc_version" | grep -qi "el4"; then
                DISTRO_VERSION="4"
            elif echo "$proc_version" | grep -qi "el5"; then
                DISTRO_VERSION="5"
            elif echo "$proc_version" | grep -qi "el6"; then
                DISTRO_VERSION="6"
            elif echo "$proc_version" | grep -qi "el7"; then
                DISTRO_VERSION="7"
            elif echo "$proc_version" | grep -qi "el8"; then
                DISTRO_VERSION="8"
            elif echo "$proc_version" | grep -qi "el9"; then
                DISTRO_VERSION="9"
            elif echo "$proc_version" | grep -qi "el10"; then
                DISTRO_VERSION="10"
            fi
            
            DISTRO_FULL="$proc_version"
            return 0
        fi
    fi
    
    return 1
}

# Legacy detection methods for older systems

# Function to detect from /etc/issue (legacy method)
detect_from_issue() {
    if [ -f /etc/issue ]; then
        local issue_content=$(cat /etc/issue 2>/dev/null)
        if echo "$issue_content" | grep -qi "ubuntu"; then
            DISTRO_NAME="Ubuntu"
            DISTRO_VERSION=$(echo "$issue_content" | grep -oE '[0-9]+\.[0-9]+' | head -1)
        elif echo "$issue_content" | grep -qi "debian"; then
            DISTRO_NAME="Debian"
            DISTRO_VERSION=$(echo "$issue_content" | grep -oE '[0-9]+\.[0-9]+' | head -1)
        elif echo "$issue_content" | grep -qi "centos"; then
            DISTRO_NAME="CentOS"
            DISTRO_VERSION=$(echo "$issue_content" | grep -oE '[0-9]+(\.[0-9]+)?' | head -1)
        elif echo "$issue_content" | grep -qi "red hat enterprise linux"; then
            DISTRO_NAME="Red Hat Enterprise Linux"
            # Enhanced RHEL version detection from issue file
            if echo "$issue_content" | grep -qi "release 2\."; then
                DISTRO_VERSION=$(echo "$issue_content" | grep -oE '2\.[0-9]+' | head -1)
            elif echo "$issue_content" | grep -qi "release [3-9]"; then
                DISTRO_VERSION=$(echo "$issue_content" | grep -oE '[3-9](\.[0-9]+)?' | head -1)
            elif echo "$issue_content" | grep -qi "release 10"; then
                DISTRO_VERSION="10"
            else
                DISTRO_VERSION=$(echo "$issue_content" | grep -oE '[0-9]+(\.[0-9]+)?' | head -1)
            fi
        elif echo "$issue_content" | grep -qi "red hat"; then
            DISTRO_NAME="Red Hat Enterprise Linux"
            DISTRO_VERSION=$(echo "$issue_content" | grep -oE '[0-9]+(\.[0-9]+)?' | head -1)
        elif echo "$issue_content" | grep -qi "fedora"; then
            DISTRO_NAME="Fedora"
            DISTRO_VERSION=$(echo "$issue_content" | grep -oE '[0-9]+' | head -1)
        elif echo "$issue_content" | grep -qi "suse"; then
            DISTRO_NAME="SUSE"
            DISTRO_VERSION=$(echo "$issue_content" | grep -oE '[0-9]+(\.[0-9]+)?' | head -1)
        elif echo "$issue_content" | grep -qi "slackware"; then
            DISTRO_NAME="Slackware"
            DISTRO_VERSION=$(echo "$issue_content" | grep -oE '[0-9]+(\.[0-9]+)?' | head -1)
        elif echo "$issue_content" | grep -qi "scientific"; then
            DISTRO_NAME="Scientific Linux"
            DISTRO_VERSION=$(echo "$issue_content" | grep -oE '[0-9]+(\.[0-9]+)?' | head -1)
        elif echo "$issue_content" | grep -qi "oracle"; then
            DISTRO_NAME="Oracle Linux"
            DISTRO_VERSION=$(echo "$issue_content" | grep -oE '[0-9]+(\.[0-9]+)?' | head -1)
        fi
        DISTRO_FULL="$issue_content"
        return 0
    fi
    return 1
}

# Function to detect from /proc/version (kernel-based detection)
detect_from_proc_version() {
    if [ -f /proc/version ]; then
        local proc_version=$(cat /proc/version 2>/dev/null)
        if echo "$proc_version" | grep -qi "ubuntu"; then
            DISTRO_NAME="Ubuntu"
            DISTRO_VERSION=$(echo "$proc_version" | grep -oE '[0-9]+\.[0-9]+' | head -1)
        elif echo "$proc_version" | grep -qi "debian"; then
            DISTRO_NAME="Debian"
            DISTRO_VERSION=$(echo "$proc_version" | grep -oE '[0-9]+\.[0-9]+' | head -1)
        elif echo "$proc_version" | grep -qi "centos"; then
            DISTRO_NAME="CentOS"
            DISTRO_VERSION=$(echo "$proc_version" | grep -oE '[0-9]+(\.[0-9]+)?' | head -1)
        elif echo "$proc_version" | grep -qi "redhat"; then
            DISTRO_NAME="Red Hat Enterprise Linux"
            # Enhanced RHEL version detection from kernel
            if echo "$proc_version" | grep -qi "el2"; then
                DISTRO_VERSION="2"
            elif echo "$proc_version" | grep -qi "el3"; then
                DISTRO_VERSION="3"
            elif echo "$proc_version" | grep -qi "el4"; then
                DISTRO_VERSION="4"
            elif echo "$proc_version" | grep -qi "el5"; then
                DISTRO_VERSION="5"
            elif echo "$proc_version" | grep -qi "el6"; then
                DISTRO_VERSION="6"
            elif echo "$proc_version" | grep -qi "el7"; then
                DISTRO_VERSION="7"
            elif echo "$proc_version" | grep -qi "el8"; then
                DISTRO_VERSION="8"
            elif echo "$proc_version" | grep -qi "el9"; then
                DISTRO_VERSION="9"
            elif echo "$proc_version" | grep -qi "el10"; then
                DISTRO_VERSION="10"
            else
                DISTRO_VERSION=$(echo "$proc_version" | grep -oE '[0-9]+(\.[0-9]+)?' | head -1)
            fi
        elif echo "$proc_version" | grep -qi "fedora"; then
            DISTRO_NAME="Fedora"
            DISTRO_VERSION=$(echo "$proc_version" | grep -oE '[0-9]+' | head -1)
        elif echo "$proc_version" | grep -qi "suse"; then
            DISTRO_NAME="SUSE"
            DISTRO_VERSION=$(echo "$proc_version" | grep -oE '[0-9]+(\.[0-9]+)?' | head -1)
        elif echo "$proc_version" | grep -qi "slackware"; then
            DISTRO_NAME="Slackware"
            DISTRO_VERSION=$(echo "$proc_version" | grep -oE '[0-9]+(\.[0-9]+)?' | head -1)
        elif echo "$proc_version" | grep -qi "gentoo"; then
            DISTRO_NAME="Gentoo"
            DISTRO_VERSION=$(echo "$proc_version" | grep -oE '[0-9]+(\.[0-9]+)?' | head -1)
        elif echo "$proc_version" | grep -qi "scientific"; then
            DISTRO_NAME="Scientific Linux"
            DISTRO_VERSION=$(echo "$proc_version" | grep -oE '[0-9]+(\.[0-9]+)?' | head -1)
        elif echo "$proc_version" | grep -qi "oracle"; then
            DISTRO_NAME="Oracle Linux"
            DISTRO_VERSION=$(echo "$proc_version" | grep -oE '[0-9]+(\.[0-9]+)?' | head -1)
        fi
        DISTRO_FULL="$proc_version"
        return 0
    fi
    return 1
}

# Function to detect from /etc/system-release (Amazon Linux, etc.)
detect_from_system_release() {
    if [ -f /etc/system-release ]; then
        local system_release=$(cat /etc/system-release 2>/dev/null)
        if echo "$system_release" | grep -qi "amazon"; then
            DISTRO_NAME="Amazon Linux"
            DISTRO_VERSION=$(echo "$system_release" | grep -oE '[0-9]+\.[0-9]+' | head -1)
        elif echo "$system_release" | grep -qi "centos"; then
            DISTRO_NAME="CentOS"
            DISTRO_VERSION=$(echo "$system_release" | grep -oE '[0-9]+\.[0-9]+' | head -1)
        elif echo "$system_release" | grep -qi "red hat"; then
            DISTRO_NAME="Red Hat Enterprise Linux"
            DISTRO_VERSION=$(echo "$system_release" | grep -oE '[0-9]+\.[0-9]+' | head -1)
        else
            DISTRO_NAME=$(echo "$system_release" | awk '{print $1}')
            DISTRO_VERSION=$(echo "$system_release" | grep -oE '[0-9]+\.[0-9]+' | head -1)
        fi
        DISTRO_FULL="$system_release"
        return 0
    fi
    return 1
}

# Function to detect from /etc/release (Solaris-like systems)
detect_from_release() {
    if [ -f /etc/release ]; then
        local release_content=$(cat /etc/release 2>/dev/null)
        if echo "$release_content" | grep -qi "oracle"; then
            DISTRO_NAME="Oracle Linux"
            DISTRO_VERSION=$(echo "$release_content" | grep -oE '[0-9]+\.[0-9]+' | head -1)
        elif echo "$release_content" | grep -qi "centos"; then
            DISTRO_NAME="CentOS"
            DISTRO_VERSION=$(echo "$release_content" | grep -oE '[0-9]+\.[0-9]+' | head -1)
        else
            DISTRO_NAME=$(echo "$release_content" | awk '{print $1}')
            DISTRO_VERSION=$(echo "$release_content" | grep -oE '[0-9]+\.[0-9]+' | head -1)
        fi
        DISTRO_FULL="$release_content"
        return 0
    fi
    return 1
}

# Function to detect from uname -a (last resort)
detect_from_uname() {
    if command -v uname >/dev/null 2>&1; then
        local uname_output=$(uname -a 2>/dev/null)
        if echo "$uname_output" | grep -qi "ubuntu"; then
            DISTRO_NAME="Ubuntu"
            DISTRO_VERSION="Unknown"
        elif echo "$uname_output" | grep -qi "debian"; then
            DISTRO_NAME="Debian"
            DISTRO_VERSION="Unknown"
        elif echo "$uname_output" | grep -qi "centos"; then
            DISTRO_NAME="CentOS"
            DISTRO_VERSION="Unknown"
        elif echo "$uname_output" | grep -qi "redhat"; then
            DISTRO_NAME="Red Hat Enterprise Linux"
            DISTRO_VERSION="Unknown"
        elif echo "$uname_output" | grep -qi "fedora"; then
            DISTRO_NAME="Fedora"
            DISTRO_VERSION="Unknown"
        elif echo "$uname_output" | grep -qi "suse"; then
            DISTRO_NAME="SUSE"
            DISTRO_VERSION="Unknown"
        elif echo "$uname_output" | grep -qi "slackware"; then
            DISTRO_NAME="Slackware"
            DISTRO_VERSION="Unknown"
        elif echo "$uname_output" | grep -qi "gentoo"; then
            DISTRO_NAME="Gentoo"
            DISTRO_VERSION="Unknown"
        elif echo "$uname_output" | grep -qi "arch"; then
            DISTRO_NAME="Arch Linux"
            DISTRO_VERSION="Unknown"
        else
            DISTRO_NAME="Linux"
            DISTRO_VERSION="Unknown"
        fi
        DISTRO_FULL="$uname_output"
        return 0
    fi
    return 1
}

# Function to detect embedded systems
detect_embedded() {
    # Check for embedded Linux indicators
    if [ -f /proc/cpuinfo ]; then
        local cpuinfo=$(cat /proc/cpuinfo 2>/dev/null)
        if echo "$cpuinfo" | grep -qi "arm"; then
            DISTRO_NAME="Embedded Linux (ARM)"
            DISTRO_VERSION="Unknown"
            return 0
        elif echo "$cpuinfo" | grep -qi "mips"; then
            DISTRO_NAME="Embedded Linux (MIPS)"
            DISTRO_VERSION="Unknown"
            return 0
        fi
    fi
    
    # Check for minimal systems
    if [ -f /etc/init.d/rcS ] || [ -f /etc/inittab ]; then
        if [ ! -f /etc/os-release ] && [ ! -f /etc/lsb-release ]; then
            DISTRO_NAME="Minimal Linux"
            DISTRO_VERSION="Unknown"
            return 0
        fi
    fi
    
    return 1
}

# Function to get additional system information
get_system_info() {
    if [ "$JSON_OUTPUT" = "true" ]; then
        return 0  # Skip colored output for JSON
    fi
    
    print_header "System Information"
    
    # Kernel information with fallbacks
    if command -v uname >/dev/null 2>&1; then
        echo -e "${CYAN}Kernel:${NC} $(uname -r 2>/dev/null || echo 'Unknown')"
        echo -e "${CYAN}Architecture:${NC} $(uname -m 2>/dev/null || echo 'Unknown')"
    else
        echo -e "${CYAN}Kernel:${NC} Unknown"
        echo -e "${CYAN}Architecture:${NC} Unknown"
    fi
    
    # Hostname with fallbacks
    if command -v hostname >/dev/null 2>&1; then
        echo -e "${CYAN}Hostname:${NC} $(hostname 2>/dev/null || echo 'Unknown')"
    elif [ -f /proc/sys/kernel/hostname ]; then
        echo -e "${CYAN}Hostname:${NC} $(cat /proc/sys/kernel/hostname 2>/dev/null || echo 'Unknown')"
    else
        echo -e "${CYAN}Hostname:${NC} Unknown"
    fi
    
    # Uptime with fallbacks
    if command -v uptime >/dev/null 2>&1; then
        if uptime -p >/dev/null 2>&1; then
            echo -e "${CYAN}Uptime:${NC} $(uptime -p 2>/dev/null)"
        else
            echo -e "${CYAN}Uptime:${NC} $(uptime 2>/dev/null)"
        fi
    elif [ -f /proc/uptime ]; then
        local uptime_seconds=$(cat /proc/uptime 2>/dev/null | cut -d' ' -f1)
        if [ -n "$uptime_seconds" ]; then
            local days=$((uptime_seconds / 86400))
            local hours=$(((uptime_seconds % 86400) / 3600))
            local minutes=$(((uptime_seconds % 3600) / 60))
            echo -e "${CYAN}Uptime:${NC} up ${days} days, ${hours} hours, ${minutes} minutes"
        else
            echo -e "${CYAN}Uptime:${NC} Unknown"
        fi
    else
        echo -e "${CYAN}Uptime:${NC} Unknown"
    fi
    
    # Get desktop environment
    if [ -n "$XDG_CURRENT_DESKTOP" ]; then
        echo -e "${CYAN}Desktop Environment:${NC} $XDG_CURRENT_DESKTOP"
    elif [ -n "$DESKTOP_SESSION" ]; then
        echo -e "${CYAN}Desktop Environment:${NC} $DESKTOP_SESSION"
    elif [ -n "$GNOME_DESKTOP_SESSION_ID" ]; then
        echo -e "${CYAN}Desktop Environment:${NC} GNOME"
    elif [ -n "$KDE_FULL_SESSION" ]; then
        echo -e "${CYAN}Desktop Environment:${NC} KDE"
    elif [ -n "$XFCE_DESKTOP" ]; then
        echo -e "${CYAN}Desktop Environment:${NC} XFCE"
    fi
    
    # Get package manager with more comprehensive detection
    if command -v apt >/dev/null 2>&1; then
        echo -e "${CYAN}Package Manager:${NC} APT (Advanced Package Tool)"
    elif command -v yum >/dev/null 2>&1; then
        echo -e "${CYAN}Package Manager:${NC} YUM (Yellowdog Updater Modified)"
    elif command -v dnf >/dev/null 2>&1; then
        echo -e "${CYAN}Package Manager:${NC} DNF (Dandified YUM)"
    elif command -v pacman >/dev/null 2>&1; then
        echo -e "${CYAN}Package Manager:${NC} Pacman"
    elif command -v zypper >/dev/null 2>&1; then
        echo -e "${CYAN}Package Manager:${NC} Zypper"
    elif command -v emerge >/dev/null 2>&1; then
        echo -e "${CYAN}Package Manager:${NC} Portage (Gentoo)"
    elif command -v apk >/dev/null 2>&1; then
        echo -e "${CYAN}Package Manager:${NC} APK (Alpine)"
    elif command -v xbps-install >/dev/null 2>&1; then
        echo -e "${CYAN}Package Manager:${NC} XBPS (Void)"
    elif command -v rpm >/dev/null 2>&1; then
        echo -e "${CYAN}Package Manager:${NC} RPM (Red Hat Package Manager)"
    elif command -v dpkg >/dev/null 2>&1; then
        echo -e "${CYAN}Package Manager:${NC} DPKG (Debian Package Manager)"
    elif command -v pkg >/dev/null 2>&1; then
        echo -e "${CYAN}Package Manager:${NC} PKG (Generic Package Manager)"
    fi
    
    # Additional legacy system information
    if [ -f /proc/cpuinfo ]; then
        local cpu_count=$(grep -c "^processor" /proc/cpuinfo 2>/dev/null)
        if [ -n "$cpu_count" ] && [ "$cpu_count" -gt 0 ]; then
            echo -e "${CYAN}CPU Cores:${NC} $cpu_count"
        fi
    fi
    
    if [ -f /proc/meminfo ]; then
        local total_mem=$(grep "^MemTotal:" /proc/meminfo 2>/dev/null | awk '{print $2}')
        if [ -n "$total_mem" ]; then
            local mem_gb=$((total_mem / 1024 / 1024))
            echo -e "${CYAN}Total Memory:${NC} ${mem_gb}GB"
        fi
    fi
}

# Function to categorize distribution
categorize_distro() {
    local distro="$1"
    local category=""
    
    case "$distro" in
        "Ubuntu"|"Debian"|"Linux Mint"|"Fedora"|"openSUSE"|"elementary OS"|"Zorin OS"|"Pop!_OS"|"Lubuntu"|"Xubuntu"|"Kubuntu"|"KDE neon")
            category="General Purpose / Desktop"
            ;;
        "Red Hat Enterprise Linux"|"Red Hat Enterprise Linux Server"|"Red Hat Enterprise Linux Workstation"|"Red Hat Enterprise Linux Desktop"|"Red Hat Enterprise Linux Client"|"CentOS Stream"|"CentOS"|"Oracle Linux"|"Rocky Linux"|"AlmaLinux"|"Amazon Linux"|"Scientific Linux")
            category="Enterprise / Server"
            ;;
        "Puppy Linux"|"antiX"|"Tiny Core Linux"|"4MLinux")
            category="Lightweight / Older Hardware"
            ;;
        "Kali Linux"|"Parrot OS"|"Tails"|"Qubes OS")
            category="Specialized / Security / Privacy"
            ;;
        "Arch Linux"|"Manjaro"|"EndeavourOS"|"Gentoo"|"Void Linux")
            category="Rolling Release / Bleeding Edge"
            ;;
        "Alpine Linux"|"Slackware"|"SUSE")
            category="Minimal / Specialized"
            ;;
        "Asahi Linux")
            category="Specialized / ARM"
            ;;
        "Embedded Linux (ARM)"|"Embedded Linux (MIPS)"|"Minimal Linux")
            category="Embedded / Minimal"
            ;;
        "Linux")
            category="Generic / Unknown"
            ;;
        *)
            category="Other / Unknown"
            ;;
    esac
    
    echo "$category"
}

# Function to get package manager info
get_package_manager() {
    if command -v apt >/dev/null 2>&1; then
        echo "APT"
    elif command -v yum >/dev/null 2>&1; then
        echo "YUM"
    elif command -v dnf >/dev/null 2>&1; then
        echo "DNF"
    elif command -v pacman >/dev/null 2>&1; then
        echo "Pacman"
    elif command -v zypper >/dev/null 2>&1; then
        echo "Zypper"
    elif command -v emerge >/dev/null 2>&1; then
        echo "Portage"
    elif command -v apk >/dev/null 2>&1; then
        echo "APK"
    elif command -v xbps-install >/dev/null 2>&1; then
        echo "XBPS"
    else
        echo "Unknown"
    fi
}

# Function to get desktop environment
get_desktop_environment() {
    if [ -n "$XDG_CURRENT_DESKTOP" ]; then
        echo "$XDG_CURRENT_DESKTOP"
    elif [ -n "$DESKTOP_SESSION" ]; then
        echo "$DESKTOP_SESSION"
    else
        echo "Unknown"
    fi
}

# Function to output JSON
output_json() {
    local category=$(categorize_distro "$DISTRO_NAME")
    local package_manager=$(get_package_manager)
    local desktop_env=$(get_desktop_environment)
    
    # Handle empty values by using null or empty string
    local distro_name="${DISTRO_NAME:-Unknown}"
    local distro_version="${DISTRO_VERSION:-Unknown}"
    local distro_id="${DISTRO_ID:-}"
    local distro_pretty="${DISTRO_PRETTY:-}"
    local distro_codename="${DISTRO_VERSION_CODENAME:-}${DISTRO_CODENAME:-}"
    local distro_description="${DISTRO_DESCRIPTION:-}"
    local distro_full="${DISTRO_FULL:-}"
    
    # Get system information with fallbacks
    local kernel="Unknown"
    local architecture="Unknown"
    local hostname="Unknown"
    local uptime="Unknown"
    local cpu_cores="Unknown"
    local total_memory="Unknown"
    
    if command -v uname >/dev/null 2>&1; then
        kernel=$(uname -r 2>/dev/null || echo "Unknown")
        architecture=$(uname -m 2>/dev/null || echo "Unknown")
    fi
    
    if command -v hostname >/dev/null 2>&1; then
        hostname=$(hostname 2>/dev/null || echo "Unknown")
    elif [ -f /proc/sys/kernel/hostname ]; then
        hostname=$(cat /proc/sys/kernel/hostname 2>/dev/null || echo "Unknown")
    fi
    
    if command -v uptime >/dev/null 2>&1; then
        if uptime -p >/dev/null 2>&1; then
            uptime=$(uptime -p 2>/dev/null || echo "Unknown")
        else
            uptime=$(uptime 2>/dev/null || echo "Unknown")
        fi
    elif [ -f /proc/uptime ]; then
        local uptime_seconds=$(cat /proc/uptime 2>/dev/null | cut -d' ' -f1)
        if [ -n "$uptime_seconds" ]; then
            local days=$((uptime_seconds / 86400))
            local hours=$(((uptime_seconds % 86400) / 3600))
            local minutes=$(((uptime_seconds % 3600) / 60))
            uptime="up ${days} days, ${hours} hours, ${minutes} minutes"
        fi
    fi
    
    if [ -f /proc/cpuinfo ]; then
        cpu_cores=$(grep -c "^processor" /proc/cpuinfo 2>/dev/null || echo "Unknown")
    fi
    
    if [ -f /proc/meminfo ]; then
        local total_mem=$(grep "^MemTotal:" /proc/meminfo 2>/dev/null | awk '{print $2}')
        if [ -n "$total_mem" ]; then
            local mem_gb=$((total_mem / 1024 / 1024))
            total_memory="${mem_gb}GB"
        fi
    fi
    
    cat << EOF
{
  "distribution": {
    "name": "$distro_name",
    "version": "$distro_version",
    "id": "$distro_id",
    "pretty_name": "$distro_pretty",
    "codename": "$distro_codename",
    "description": "$distro_description",
    "full_info": "$distro_full",
    "category": "$category"
  },
  "system": {
    "kernel": "$kernel",
    "architecture": "$architecture",
    "hostname": "$hostname",
    "uptime": "$uptime",
    "desktop_environment": "$desktop_env",
    "package_manager": "$package_manager",
    "cpu_cores": "$cpu_cores",
    "total_memory": "$total_memory"
  },
  "detection": {
    "timestamp": "$(date -u +"%Y-%m-%dT%H:%M:%SZ" 2>/dev/null || echo "Unknown")",
    "method": "shell_script",
    "script_version": "1.1",
    "legacy_compatible": true
  }
}
EOF
}

# Main detection function
detect_distribution() {
    if [ "$JSON_OUTPUT" != "true" ]; then
        print_header "Linux Distribution Detection"
    fi
    
    # Initialize variables
    DISTRO_NAME=""
    DISTRO_VERSION=""
    DISTRO_ID=""
    DISTRO_PRETTY=""
    DISTRO_VERSION_CODENAME=""
    DISTRO_CODENAME=""
    DISTRO_DESCRIPTION=""
    DISTRO_FULL=""
    
    # Try different detection methods in order of preference
    if detect_from_os_release; then
        if [ "$JSON_OUTPUT" != "true" ]; then
            print_info "Detected from /etc/os-release"
        fi
    elif detect_from_lsb_release; then
        if [ "$JSON_OUTPUT" != "true" ]; then
            print_info "Detected from /etc/lsb-release"
        fi
    elif detect_from_redhat_release; then
        if [ "$JSON_OUTPUT" != "true" ]; then
            print_info "Detected from /etc/redhat-release"
        fi
    elif detect_from_system_release; then
        if [ "$JSON_OUTPUT" != "true" ]; then
            print_info "Detected from /etc/system-release"
        fi
    elif detect_from_release; then
        if [ "$JSON_OUTPUT" != "true" ]; then
            print_info "Detected from /etc/release"
        fi
    elif detect_from_debian_version; then
        if [ "$JSON_OUTPUT" != "true" ]; then
            print_info "Detected from /etc/debian_version"
        fi
    elif detect_arch; then
        if [ "$JSON_OUTPUT" != "true" ]; then
            print_info "Detected from /etc/arch-release"
        fi
    elif detect_gentoo; then
        if [ "$JSON_OUTPUT" != "true" ]; then
            print_info "Detected from /etc/gentoo-release"
        fi
    elif detect_alpine; then
        if [ "$JSON_OUTPUT" != "true" ]; then
            print_info "Detected from /etc/alpine-release"
        fi
    elif detect_slackware; then
        if [ "$JSON_OUTPUT" != "true" ]; then
            print_info "Detected from /etc/slackware-version"
        fi
    elif detect_void; then
        if [ "$JSON_OUTPUT" != "true" ]; then
            print_info "Detected from /etc/void-release"
        fi
    elif detect_puppy; then
        if [ "$JSON_OUTPUT" != "true" ]; then
            print_info "Detected from /etc/puppyversion"
        fi
    elif detect_tinycore; then
        if [ "$JSON_OUTPUT" != "true" ]; then
            print_info "Detected from /etc/tinycore-release"
        fi
    elif detect_from_issue; then
        if [ "$JSON_OUTPUT" != "true" ]; then
            print_info "Detected from /etc/issue (legacy)"
        fi
    elif detect_from_proc_version; then
        if [ "$JSON_OUTPUT" != "true" ]; then
            print_info "Detected from /proc/version (kernel-based)"
        fi
    elif detect_embedded; then
        if [ "$JSON_OUTPUT" != "true" ]; then
            print_info "Detected embedded/minimal system"
        fi
    elif detect_from_uname; then
        if [ "$JSON_OUTPUT" != "true" ]; then
            print_info "Detected from uname (last resort)"
        fi
    else
        if [ "$JSON_OUTPUT" != "true" ]; then
            print_warning "Could not detect distribution from any available method"
        fi
        DISTRO_NAME="Unknown"
        DISTRO_VERSION="Unknown"
    fi
    
    # Try specialized detection methods
    if [ -z "$DISTRO_NAME" ] || [ "$DISTRO_NAME" = "Unknown" ]; then
        if detect_rhel_legacy; then
            if [ "$JSON_OUTPUT" != "true" ]; then
                print_info "Detected RHEL legacy system"
            fi
        elif detect_kali; then
            if [ "$JSON_OUTPUT" != "true" ]; then
                print_info "Detected specialized distribution: Kali Linux"
            fi
        elif detect_parrot; then
            if [ "$JSON_OUTPUT" != "true" ]; then
                print_info "Detected specialized distribution: Parrot OS"
            fi
        elif detect_tails; then
            if [ "$JSON_OUTPUT" != "true" ]; then
                print_info "Detected specialized distribution: Tails"
            fi
        elif detect_qubes; then
            if [ "$JSON_OUTPUT" != "true" ]; then
                print_info "Detected specialized distribution: Qubes OS"
            fi
        elif detect_elementary; then
            if [ "$JSON_OUTPUT" != "true" ]; then
                print_info "Detected specialized distribution: elementary OS"
            fi
        elif detect_zorin; then
            if [ "$JSON_OUTPUT" != "true" ]; then
                print_info "Detected specialized distribution: Zorin OS"
            fi
        elif detect_popos; then
            if [ "$JSON_OUTPUT" != "true" ]; then
                print_info "Detected specialized distribution: Pop!_OS"
            fi
        elif detect_manjaro; then
            if [ "$JSON_OUTPUT" != "true" ]; then
                print_info "Detected specialized distribution: Manjaro"
            fi
        elif detect_endeavour; then
            if [ "$JSON_OUTPUT" != "true" ]; then
                print_info "Detected specialized distribution: EndeavourOS"
            fi
        elif detect_rocky; then
            if [ "$JSON_OUTPUT" != "true" ]; then
                print_info "Detected specialized distribution: Rocky Linux"
            fi
        elif detect_alma; then
            if [ "$JSON_OUTPUT" != "true" ]; then
                print_info "Detected specialized distribution: AlmaLinux"
            fi
        elif detect_oracle; then
            if [ "$JSON_OUTPUT" != "true" ]; then
                print_info "Detected specialized distribution: Oracle Linux"
            fi
        elif detect_centos_stream; then
            if [ "$JSON_OUTPUT" != "true" ]; then
                print_info "Detected specialized distribution: CentOS Stream"
            fi
        elif detect_antix; then
            if [ "$JSON_OUTPUT" != "true" ]; then
                print_info "Detected specialized distribution: antiX"
            fi
        elif detect_lubuntu; then
            if [ "$JSON_OUTPUT" != "true" ]; then
                print_info "Detected specialized distribution: Lubuntu"
            fi
        elif detect_xubuntu; then
            if [ "$JSON_OUTPUT" != "true" ]; then
                print_info "Detected specialized distribution: Xubuntu"
            fi
        elif detect_kubuntu; then
            if [ "$JSON_OUTPUT" != "true" ]; then
                print_info "Detected specialized distribution: Kubuntu"
            fi
        elif detect_kde_neon; then
            if [ "$JSON_OUTPUT" != "true" ]; then
                print_info "Detected specialized distribution: KDE neon"
            fi
        elif detect_4mlinux; then
            if [ "$JSON_OUTPUT" != "true" ]; then
                print_info "Detected specialized distribution: 4MLinux"
            fi
        elif detect_asahi; then
            if [ "$JSON_OUTPUT" != "true" ]; then
                print_info "Detected specialized distribution: Asahi Linux"
            fi
        fi
    fi
    
    # Display results
    if [ "$JSON_OUTPUT" = "true" ]; then
        output_json
    else
        echo
        print_header "Distribution Information"
        
        if [ -n "$DISTRO_PRETTY" ]; then
            echo -e "${GREEN}Distribution:${NC} $DISTRO_PRETTY"
        elif [ -n "$DISTRO_NAME" ]; then
            echo -e "${GREEN}Distribution:${NC} $DISTRO_NAME"
        fi
        
        if [ -n "$DISTRO_VERSION" ]; then
            echo -e "${GREEN}Version:${NC} $DISTRO_VERSION"
        fi
        
        if [ -n "$DISTRO_VERSION_CODENAME" ]; then
            echo -e "${GREEN}Codename:${NC} $DISTRO_VERSION_CODENAME"
        elif [ -n "$DISTRO_CODENAME" ]; then
            echo -e "${GREEN}Codename:${NC} $DISTRO_CODENAME"
        fi
        
        if [ -n "$DISTRO_ID" ]; then
            echo -e "${GREEN}ID:${NC} $DISTRO_ID"
        fi
        
        if [ -n "$DISTRO_DESCRIPTION" ]; then
            echo -e "${GREEN}Description:${NC} $DISTRO_DESCRIPTION"
        fi
        
        if [ -n "$DISTRO_FULL" ]; then
            echo -e "${GREEN}Full Info:${NC} $DISTRO_FULL"
        fi
        
        # Categorize the distribution
        if [ -n "$DISTRO_NAME" ] && [ "$DISTRO_NAME" != "Unknown" ]; then
            local category=$(categorize_distro "$DISTRO_NAME")
            echo -e "${GREEN}Category:${NC} $category"
        fi
        
        echo
    fi
}

# Function to show help
show_help() {
    echo "Linux Distribution Detection Script"
    echo
    echo "Usage: $0 [OPTIONS]"
    echo
    echo "Options:"
    echo "  -h, --help     Show this help message"
    echo "  -s, --simple   Show only distribution name and version"
    echo "  -f, --full     Show full system information (default)"
    echo "  -c, --category Show only distribution category"
    echo "  -j, --json     Output results in JSON format"
    echo
    echo "Examples:"
    echo "  $0              # Show full information"
    echo "  $0 --simple     # Show only distro name and version"
    echo "  $0 --category   # Show only distribution category"
    echo "  $0 --json       # Output in JSON format"
}

# Main script execution
main() {
    # Initialize JSON_OUTPUT variable
    JSON_OUTPUT="false"
    
    # Parse command line arguments
    case "${1:-}" in
        -h|--help)
            show_help
            exit 0
            ;;
        -s|--simple)
            detect_distribution
            if [ -n "$DISTRO_NAME" ] && [ "$DISTRO_NAME" != "Unknown" ]; then
                echo "$DISTRO_NAME $DISTRO_VERSION"
            else
                echo "Unknown Distribution"
            fi
            ;;
        -c|--category)
            detect_distribution >/dev/null 2>&1
            if [ -n "$DISTRO_NAME" ] && [ "$DISTRO_NAME" != "Unknown" ]; then
                categorize_distro "$DISTRO_NAME"
            else
                echo "Unknown Category"
            fi
            ;;
        -j|--json)
            JSON_OUTPUT="true"
            detect_distribution
            ;;
        -f|--full|"")
            detect_distribution
            get_system_info
            ;;
        *)
            print_error "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
}

# Run the main function
main "$@"
