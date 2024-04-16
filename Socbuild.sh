#!/bin/bash

# Function to check if the component is already installed
check_component_installed() {
    if [ "$(dpkg-query -W -f='${Status}' "$1" 2>/dev/null | grep -c "ok installed")" -eq 0 ]; then
        return 1
    else
        return 0
    fi
}

# Function to verify if the system is Linux-based
check_linux_system() {
    if [ "$(uname -s)" != "Linux" ]; then
        echo "This script is intended to run on Linux-based systems only."
        exit 1
    fi
}

# Function to install and configure the firewall (iptables)
install_configure_firewall() {
    echo "Installing and configuring firewall (iptables)..."
    if check_component_installed iptables; then
        echo "iptables is already installed."
    else
        sudo apt-get update
        sudo apt-get install -y iptables
    fi
    sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT
    sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
    sudo iptables -A INPUT -j DROP
}

# Function to install and configure the IPS/IDS (Snort)
install_configure_ips_ids() {
    echo "Installing and configuring IPS/IDS (Snort)..."
    if check_component_installed snort; then
        echo "Snort is already installed."
    else
        sudo apt-get install -y snort
    fi
    sudo sed -i 's/^#output alert_syslog: LOG_AUTH LOG_ALERT/output alert_syslog: LOG_AUTH LOG_ALERT/' /etc/snort/snort.conf
    sudo systemctl restart snort
}

# Function to install and configure the breach detection solution (OSSEC)
install_configure_breach_detection() {
    echo "Installing and configuring breach detection solution (OSSEC)..."
    if check_component_installed ossec-hids; then
        echo "OSSEC is already installed."
    else
        sudo apt-get install -y ossec-hids
    fi
    sudo /var/ossec/bin/ossec-control start
}

# Function to install and configure the security probe (Suricata)
install_configure_security_probe() {
    echo "Installing and configuring security probe (Suricata)..."
    if check_component_installed suricata; then
        echo "Suricata is already installed."
    else
        sudo apt-get install -y suricata
        sudo suricata-update enable-source oisf/trafficid
    fi
    sudo systemctl enable suricata
    sudo systemctl start suricata
}

# Function to install and configure the SIEM (ELK Stack)
install_configure_siem() {
    echo "Installing and configuring SIEM (ELK Stack)..."
    if check_component_installed elasticsearch && check_component_installed logstash && check_component_installed kibana; then
        echo "ELK Stack is already installed."
    else
        sudo apt-get install -y openjdk-8-jdk elasticsearch logstash kibana
    fi
    sudo systemctl start elasticsearch logstash kibana
    sudo systemctl enable elasticsearch logstash kibana
}

# Main function
main() {
    check_linux_system

    echo "Select your installation method:"
    echo "1. Quick Install (All components with default configurations)"
    echo "2. Custom Install (Choose individual components and configurations)"
    read -p "Enter your choice: " choice

    case $choice in
        1)
            install_configure_firewall
            install_configure_ips_ids
            install_configure_breach_detection
            install_configure_security_probe
            install_configure_siem
            ;;
        2)
            echo "Enter the component you want to install and configure:"
            echo "1. Firewall (iptables)"
            echo "2. IPS/IDS (Snort)"
            echo "3. Breach detection solution (OSSEC)"
            echo "4. Security probe (Suricata)"
            echo "5. SIEM (ELK Stack)"
            echo "6. Exit"
            read -p "Enter the component number (or 'done' to finish): " component_choice

            while [[ ! $component_choice =~ ^(done|6)$ ]]; do
                case $component_choice in
                    1)
                        install_configure_firewall
                        ;;
                    2)
                        install_configure_ips_ids
                        ;;
                    3)
                        install_configure_breach_detection
                        ;;
                    4)
                        install_configure_security_probe
                        ;;
                    5)
                        install_configure_siem
                        ;;
                    *)
                        echo "Invalid choice. Please try again."
                        ;;
                esac

                echo "Select the next component to install or enter 'done' to finish."
                read -p "Enter the component number: " component_choice
            done
            ;;
        *)
            echo "Invalid choice. Exiting."
            exit 1
            ;;
    esac
}

# Call the main function
main
