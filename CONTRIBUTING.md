# Contributing to CutifyPets

Thank you for your interest in contributing to CutifyPets! We welcome contributions from the community and are excited to see what you'll bring to this project.

## 🎯 Code of Conduct

This project and everyone participating in it is governed by our Code of Conduct. By participating, you are expected to uphold this code. Please report unacceptable behavior to [conduct@cutifypets.com](mailto:conduct@cutifypets.com).

## 🤔 How Can I Contribute?

### 🐛 Reporting Bugs

Before creating bug reports, please check the existing issues to avoid duplicates. When you create a bug report, include as many details as possible:

- **Use a clear and descriptive title**
- **Describe the exact steps to reproduce the problem**
- **Provide specific examples** with sample input files if possible
- **Describe the behavior you observed** and what you expected
- **Include Azure Batch logs** and error messages
- **Specify your environment**: OS, .NET version, Azure region

### 💡 Suggesting Enhancements

Enhancement suggestions are welcome! When suggesting an enhancement:

- **Use a clear and descriptive title**
- **Provide a detailed description** of the suggested enhancement
- **Explain why this enhancement would be useful**
- **List any alternative solutions** you've considered

### 🔧 Pull Requests

We actively welcome pull requests! Here's how to contribute code:

#### Development Setup

1. **Fork the repository** and clone your fork
   ```bash
   git clone https://github.com/yourusername/cutifypets.git
   cd cutifypets
   ```

2. **Install dependencies**
   ```bash
   dotnet restore
   ```

3. **Set up your development environment**
   - Follow the Azure setup instructions in the README
   - Create a test Azure Batch account for development
   - Use environment variables for configuration

4. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

#### Making Changes

1. **Write tests** for your changes when applicable
2. **Follow the existing code style** and conventions
3. **Update documentation** if you're changing functionality
4. **Test your changes** with actual Azure Batch processing

#### Code Style Guidelines

- **Use meaningful variable names** and follow C# naming conventions
- **Add XML documentation** for public methods and classes
- **Keep methods focused** and maintain single responsibility
- **Handle exceptions appropriately** with proper logging
- **Use async/await** patterns consistently

Example:
```csharp
/// <summary>
/// Uploads a single file to the specified blob container and returns a ResourceFile.
/// </summary>
/// <param name="blobClient">The CloudBlobClient instance</param>
/// <param name="containerName">Name of the target container</param>
/// <param name="filePath">Local path to the file to upload</param>
/// <returns>ResourceFile instance for use in Batch tasks</returns>
private static async Task<ResourceFile> UploadResourceFileToContainerAsync(
    CloudBlobClient blobClient, 
    string containerName, 
    string filePath)
{
    // Implementation
}
```

#### Submitting Your Pull Request

1. **Push your changes** to your fork
   ```bash
   git push origin feature/your-feature-name
   ```

2. **Create a pull request** with:
   - Clear title describing the change
   - Detailed description of what you changed and why
   - References to any related issues
   - Screenshots or GIFs for UI changes

3. **Respond to feedback** and make requested changes

## 🏗️ Project Structure

Understanding the project structure will help you contribute effectively:

```
cutifypets/
├── Program.cs              # Main application logic
│   ├── Azure credentials setup
│   ├── Blob storage operations
│   ├── Batch pool management
│   ├── Job and task creation
│   └── Monitoring and cleanup
├── CutifyPets.csproj      # Project dependencies
├── setup-azure.sh         # Azure resource provisioning
└── scripts/               # Utility scripts
```

### Key Components

- **Credential Management**: Environment variable handling and Azure authentication
- **Storage Operations**: Blob upload/download and SAS token generation  
- **Batch Operations**: Pool creation, job submission, and task monitoring
- **FFmpeg Integration**: Command construction and parameter handling
- **Error Handling**: Batch exceptions and retry logic

## 🧪 Testing

### Manual Testing

1. **Test with sample files**: Use small MP4 files (< 10MB) for quick iteration
2. **Verify different scenarios**:
   - Single file processing
   - Multiple file batch processing
   - Error conditions (invalid files, network issues)
   - Resource cleanup

### Test Environment

- Use a separate Azure subscription or resource group for testing
- Consider using Azure Batch's free tier for development
- Test with both dedicated and low-priority VMs

## 📝 Documentation

When contributing, please update relevant documentation:

- **README.md**: If you're adding new features or changing setup
- **Code comments**: For complex logic or Azure-specific implementations  
- **Architecture docs**: For significant structural changes

## 🐞 Issue Labels

We use these labels to categorize issues:

- `bug`: Something isn't working
- `enhancement`: New feature or request
- `documentation`: Improvements or additions to documentation
- `good first issue`: Good for newcomers
- `help wanted`: Extra attention is needed
- `azure`: Azure-specific issues
- `ffmpeg`: FFmpeg-related issues

## 💬 Getting Help

If you need help while contributing:

- 💬 **Discord**: Join our [community server](https://discord.gg/cutifypets)
- 📧 **Email**: Reach out to [developers@cutifypets.com](mailto:developers@cutifypets.com)
- 🐛 **Issues**: Create an issue with the `help wanted` label

## 🏆 Recognition

Contributors will be recognized in:

- The project README
- Release notes for significant contributions
- Our contributors wall of fame

## 📋 Development Checklist

Before submitting your pull request, make sure:

- [ ] Code follows the project's style guidelines
- [ ] You have tested your changes locally
- [ ] Documentation has been updated if necessary
- [ ] Your commits have clear, descriptive messages
- [ ] You have added tests for new functionality
- [ ] All existing tests still pass
- [ ] You have cleaned up any debugging code or comments

## 🚀 Release Process

1. **Feature branches** are merged into `develop`
2. **Release candidates** are created from `develop`
3. **Stable releases** are tagged and merged to `main`
4. **Hotfixes** go directly to `main` and are backported

Thank you for contributing to CutifyPets! Your efforts help make video processing more accessible to everyone. 🎬✨
