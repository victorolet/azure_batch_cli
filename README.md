# 🎬 CutifyPets - Azure Batch Video Processing

[![.NET](https://img.shields.io/badge/.NET-512BD4?style=for-the-badge&logo=dotnet&logoColor=white)](https://dotnet.microsoft.com/)
[![Azure](https://img.shields.io/badge/Microsoft_Azure-0089D0?style=for-the-badge&logo=microsoft-azure&logoColor=white)](https://azure.microsoft.com/)
[![FFmpeg](https://img.shields.io/badge/FFmpeg-007808?style=for-the-badge&logo=ffmpeg&logoColor=white)](https://ffmpeg.org/)

A powerful Azure Batch application that converts MP4 videos to GIF format using distributed cloud computing. Perfect for creating adorable pet GIFs at scale! 🐱🐶

## 🌟 Features

- **Scalable Processing**: Leverages Azure Batch for parallel video conversion
- **Cost Effective**: Uses low-priority VM instances to minimize costs
- **Automated Workflow**: End-to-end pipeline from upload to processed output
- **FFmpeg Integration**: High-quality video-to-GIF conversion using industry-standard tools
- **Cloud Storage**: Seamless integration with Azure Blob Storage
- **Monitoring**: Real-time task monitoring and error handling

## 🏗️ Architecture

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Input Files   │───▶│   Azure Batch    │───▶│  Output GIFs    │
│   (MP4 Videos)  │    │  Processing Pool │    │ (Blob Storage)  │
└─────────────────┘    └──────────────────┘    └─────────────────┘
         │                       │                       │
         │              ┌─────────────────┐              │
         └──────────────▶│ Azure Storage   │◀─────────────┘
                        │   Containers    │
                        └─────────────────┘
```

## 🚀 Quick Start

### Prerequisites

- [.NET 6.0 SDK](https://dotnet.microsoft.com/download) or later
- [Azure CLI](https://docs.microsoft.com/cli/azure/install-azure-cli)
- Active Azure subscription with:
  - Azure Batch account
  - Azure Storage account
  - FFmpeg application package configured in Batch

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/cutifypets.git
   cd cutifypets
   ```

2. **Restore dependencies**
   ```bash
   dotnet restore
   ```

3. **Set up Azure resources** (see [Setup Guide](#-azure-setup))

4. **Configure environment variables**
   ```bash
   export BATCH_URL="https://yourbatchaccount.region.batch.azure.com"
   export BATCH_NAME="yourbatchaccount"
   export BATCH_KEY="your-batch-account-key"
   export STORAGE_NAME="yourstorageaccount"
   export STORAGE_KEY="your-storage-account-key"
   ```

5. **Add your MP4 files**
   ```bash
   mkdir InputFiles
   # Copy your .mp4 files to the InputFiles directory
   ```

6. **Run the application**
   ```bash
   dotnet run
   ```

## ⚙️ Azure Setup

### Automated Setup Script

Use the provided setup script to configure your Azure resources:

```bash
# Set your subscription
az account set --subscription 'Your Subscription Name'

# Run the setup script
chmod +x setup-azure.sh
./setup-azure.sh
```

### Manual Setup

<details>
<summary>Click to expand manual setup instructions</summary>

1. **Create Resource Group**
   ```bash
   az group create --name MLSA-demo --location eastus
   ```

2. **Create Batch Account**
   ```bash
   az batch account create \
     --name yourbatchaccount \
     --resource-group MLSA-demo \
     --location eastus
   ```

3. **Create Storage Account**
   ```bash
   az storage account create \
     --name yourstorageaccount \
     --resource-group MLSA-demo \
     --location eastus \
     --sku Standard_LRS
   ```

4. **Upload FFmpeg Application Package**
   - Download FFmpeg from [official website](https://ffmpeg.org/download.html)
   - Upload as application package to your Batch account
   - Set Application ID: `ffmpeg`, Version: `3.4`

</details>

## 📁 Project Structure

```
cutifypets/
├── Program.cs              # Main application logic
├── CutifyPets.csproj      # Project configuration
├── setup-azure.sh         # Azure resource setup script
├── InputFiles/            # Directory for input MP4 files
├── docs/                  # Additional documentation
│   ├── ARCHITECTURE.md    # Detailed architecture guide
│   ├── TROUBLESHOOTING.md # Common issues and solutions
│   └── API_REFERENCE.md   # Code documentation
├── scripts/               # Utility scripts
│   └── cleanup-azure.sh   # Resource cleanup script
└── README.md              # This file
```

## 🔧 Configuration

The application uses the following environment variables:

| Variable | Description | Example |
|----------|-------------|---------|
| `BATCH_URL` | Azure Batch account endpoint | `https://mybatch.eastus.batch.azure.com` |
| `BATCH_NAME` | Batch account name | `mybatchaccount` |
| `BATCH_KEY` | Batch account access key | `abc123...` |
| `STORAGE_NAME` | Storage account name | `mystorageaccount` |
| `STORAGE_KEY` | Storage account access key | `def456...` |

### Pool Configuration

The application creates a processing pool with the following default settings:

- **VM Size**: `STANDARD_D2_v2` (2 cores, 7GB RAM)
- **Low Priority Nodes**: 3 (cost-effective)
- **Dedicated Nodes**: 0
- **OS**: Windows Server 2012 R2

You can modify these settings in the `Program.cs` file:

```csharp
private const int LOW_PRIORITY_NODE_COUNT = 3;  // Adjust based on workload
private const string POOL_VM_SIZE = "STANDARD_D2_v2";  // Change VM size as needed
```

## 💰 Cost Optimization

- **Low Priority VMs**: Uses low-priority instances for up to 80% cost savings
- **Auto-scaling**: Pool scales based on workload
- **Automatic Cleanup**: Resources are cleaned up after job completion
- **Efficient Processing**: Parallel processing reduces overall runtime

## 📊 Monitoring and Logging

The application provides comprehensive logging:

- Pool creation and status
- Job submission and progress
- Task execution monitoring
- Resource cleanup confirmation

Example output:
```
Creating pool [WinFFmpegPool]...
Creating job [WinFFmpegJob]...
Adding 5 tasks to job [WinFFmpegJob]...
Monitoring all tasks for 'Completed' state, timeout in 00:30:00...
All tasks reached state Completed.
Success! All tasks completed successfully. Output files uploaded to output container.
```

## 🛠️ Customization

### Adding New Video Formats

To support additional input formats, modify the file filtering in `UploadInputFilesAsync`:

```csharp
List<string> inputFilePaths = new List<string>(Directory.GetFiles(inputPath, "*.mov")); // Add .mov support
```

### Changing Output Format

To convert to different formats, update the FFmpeg command in `AddTasksAsync`:

```csharp
string taskCommandLine = $"cmd /c {appPath}\\ffmpeg-3.4-win64-static\\bin\\ffmpeg.exe -i {inputMediaFile} -vf scale=480:-1 {outputMediaFile}";
```

### Custom Processing Parameters

Add quality settings, resolution changes, or filters:

```csharp
// High quality GIF with custom palette
string taskCommandLine = $"cmd /c {appPath}\\ffmpeg-3.4-win64-static\\bin\\ffmpeg.exe -i {inputMediaFile} -vf \"fps=15,scale=320:-1:flags=lanczos,palettegen\" palette.png && {appPath}\\ffmpeg-3.4-win64-static\\bin\\ffmpeg.exe -i {inputMediaFile} -i palette.png -lavfi \"fps=15,scale=320:-1:flags=lanczos [x]; [x][1:v] paletteuse\" {outputMediaFile}";
```

## 🔍 Troubleshooting

### Common Issues

**Issue**: Pool creation fails
```
Solution: Verify your Batch account quotas and ensure the VM size is available in your region
```

**Issue**: Tasks fail with FFmpeg errors
```
Solution: Check that the FFmpeg application package is correctly uploaded and accessible
```

**Issue**: Storage access denied
```
Solution: Verify storage account keys and ensure containers have proper permissions
```

For more detailed troubleshooting, see [TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md).

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Azure Batch Documentation](https://docs.microsoft.com/azure/batch/)
- [FFmpeg Project](https://ffmpeg.org/)
- [Microsoft Learn Training Modules](https://learn.microsoft.com/training/modules/create-an-app-to-run-parallel-compute-jobs-in-azure-batch/)

---

<div align="center">
  <strong>Made with ❤️ for pet lovers everywhere</strong><br>
  <sub>Transform your pet videos into shareable GIFs with the power of Azure!</sub>
</div>
