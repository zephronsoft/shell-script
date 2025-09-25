#!/bin/bash

# Linux Distribution Detection Script
# Detects version and flavor of Linux operating systems
# Supports major distributions and specialized distros

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
        . /etc/os-release
        DISTRO_NAME="$NAME"
        DISTRO_ID="$ID"
        DISTRO_VERSION="$VERSION_ID"
        DISTRO_PRETTY="$PRETTY_NAME"
        DISTRO_VERSION_CODENAME="$VERSION_CODENAME"
        return 0
    fi
    return 1
}

# Function to detect distribution from /etc/lsb-release
detect_from_lsb_release() {
    if [ -f /etc/lsb-release ]; then
        . /etc/lsb-release
        DISTRO_NAME="$DISTRIB_ID"
        DISTRO_VERSION="$DISTRIB_RELEASE"
        DISTRO_CODENAME="$DISTRIB_CODENAME"
        DISTRO_DESCRIPTION="$DISTRIB_DESCRIPTION"
        return 0
    fi
    return 1
}

# Function to detect distribution from /etc/redhat-release
detect_from_redhat_release() {
    if [ -f /etc/redhat-release ]; then
        DISTRO_NAME=$(cat /etc/redhat-release | awk '{print $1}')
        DISTRO_VERSION=$(cat /etc/redhat-release | grep -oE '[0-9]+\.[0-9]+' | head -1)
        DISTRO_FULL=$(cat /etc/redhat-release)
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

# Function to get additional system information
get_system_info() {
    if [ "$JSON_OUTPUT" = "true" ]; then
        return 0  # Skip colored output for JSON
    fi
    
    print_header "System Information"
    
    echo -e "${CYAN}Kernel:${NC} $(uname -r)"
    echo -e "${CYAN}Architecture:${NC} $(uname -m)"
    echo -e "${CYAN}Hostname:${NC} $(hostname)"
    echo -e "${CYAN}Uptime:${NC} $(uptime -p 2>/dev/null || uptime)"
    
    # Get desktop environment
    if [ -n "$XDG_CURRENT_DESKTOP" ]; then
        echo -e "${CYAN}Desktop Environment:${NC} $XDG_CURRENT_DESKTOP"
    elif [ -n "$DESKTOP_SESSION" ]; then
        echo -e "${CYAN}Desktop Environment:${NC} $DESKTOP_SESSION"
    fi
    
    # Get package manager
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
        "Red Hat Enterprise Linux"|"CentOS Stream"|"Oracle Linux"|"Rocky Linux"|"AlmaLinux")
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
        "Alpine Linux"|"Slackware")
            category="Minimal / Specialized"
            ;;
        "Asahi Linux")
            category="Specialized / ARM"
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
    "kernel": "$(uname -r)",
    "architecture": "$(uname -m)",
    "hostname": "$(hostname)",
    "uptime": "$(uptime -p 2>/dev/null || uptime)",
    "desktop_environment": "$desktop_env",
    "package_manager": "$package_manager"
  },
  "detection": {
    "timestamp": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
    "method": "shell_script",
    "script_version": "1.0"
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
    else
        if [ "$JSON_OUTPUT" != "true" ]; then
            print_warning "Could not detect distribution from standard files"
        fi
        DISTRO_NAME="Unknown"
        DISTRO_VERSION="Unknown"
    fi
    
    # Try specialized detection methods
    if [ -z "$DISTRO_NAME" ] || [ "$DISTRO_NAME" = "Unknown" ]; then
        if detect_kali; then
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
