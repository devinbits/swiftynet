# SwiftyNet

A lightweight macOS menu bar app for monitoring network connectivity, interfaces, and live upload/download speeds.

SwiftyNet runs in the background with no Dock icon. Click the menu bar icon to see connection status at a glance, or open the dashboard for detailed controls and preferences.

## Features

- **Menu bar status** — Dynamic icon reflects connectivity (Wi-Fi, Ethernet, offline, monitoring off)
- **Live speed tracking** — Real-time upload and download rates for the active or preferred interface
- **Connectivity states** — Online, local network only, no internet, or monitoring disabled
- **Interface discovery** — Lists all network interfaces with localized names and IPv4/IPv6 addresses
- **Configurable monitoring** — Toggle monitoring on/off to balance visibility with resource usage
- **Preferences**
  - Choose a preferred network interface
  - Set speed poll interval (1s, 2s, 3s, or 5s)
  - Show IPv6 instead of IPv4 in the menu bar

## Requirements

- macOS 26.0 or later
- Xcode 26.0 or later (for building from source)

## Getting Started

### Build and run

1. Clone the repository:

   ```bash
   git clone https://github.com/devinbits/swiftynet.git
   cd swiftynet
   ```

2. Open the project in Xcode:

   ```bash
   open SwiftyNet.xcodeproj
   ```

3. Select the **SwiftyNet** scheme and press **⌘R** to build and run.

The app launches directly to the menu bar. Use **Open Dashboard** from the menu to configure monitoring and preferences.

## Usage

### Menu bar

Click the SwiftyNet icon to view:

- Monitoring status (active or off)
- Current connection state
- Active network interface and IP address
- Live download/upload speeds (when monitoring is enabled)

All status rows open the dashboard when clicked.

### Dashboard

The dashboard is organized into four sections:

| Section | Description |
|---|---|
| **Monitoring** | Enable or disable monitoring; view connectivity badge, network name, and IP |
| **Speed** | Live download and upload rates |
| **Interfaces** | All discovered interfaces with addresses and active-state indicator |
| **Preferences** | IPv6 display, preferred interface, and speed poll interval |

When monitoring is off, SwiftyNet uses a lightweight path monitor for basic connectivity only — speed polling and full path monitoring are paused.

## Architecture

```
SwiftyNet/
├── App/              # App entry point and scene configuration
├── Design/           # Colors, typography, glass cards, design tokens
├── Models/           # NetworkInterface, ConnectivityState, preferences
├── Services/         # NetworkMonitorService, InterfaceDiscovery, SpeedCalculator
├── Utilities/        # Formatters and window helpers
└── Views/
    ├── Components/   # Reusable UI (badges, rows, speed display)
    ├── Dashboard/    # Main dashboard cards and layout
    └── StatusBar/    # Menu bar dropdown content
```

**NetworkMonitorService** is the central coordinator. It uses Apple's `NWPathMonitor` for connectivity, `getifaddrs` for interface and traffic discovery, and **SpeedCalculator** for byte-delta speed sampling. Preferences are persisted via `UserDefaults` through **MonitoringPreferences**.

## License

Licensed under the [Apache License 2.0](LICENSE).
