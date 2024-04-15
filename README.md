# Security Operations Center (SOC) Setup Script

This script automates the installation and configuration of components typically found in a Security Operations Center (SOC) environment. It is designed to run on Linux-based systems.

## Components Installed and Configured

1. Firewall (iptables)
2. IPS/IDS (Snort)
3. Breach Detection Solution (OSSEC)
4. Security Probe (Suricata)
5. SIEM (ELK Stack)

## Usage

1. Clone the repository:
   ```bash
   git clone https://github.com/CypherHippie/SecurityOperationsCenter-builder.git
   ```

2. Navigate to the directory containing the script:
   ```bash
   cd soc-setup-script
   ```

3. Run the script:
   ```bash
   ./soc_setup.sh
   ```

4. Follow the on-screen instructions to choose the component you want to install and configure.

## Pre-requisites

- This script is intended to run on Linux-based systems only.
- Ensure you have sudo privileges to install packages and modify system configurations.
- Internet connectivity is required to download and install packages.

## Disclaimer

This script is provided as-is, without any warranty or guarantee of any kind. Use it at your own risk.

## Contribution

Contributions are welcome! If you find any issues or have suggestions for improvements, please create an issue or a pull request on GitHub.

## License

This project is licensed under the [GNU License](LICENSE).
