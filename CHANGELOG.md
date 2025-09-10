## [1.0.0] - 2025-09-10

### Added
- Version bump to 1.0.0

## [0.1.2] - 2025-09-10

### Added
- Version bump to 0.1.2

## [0.1.1] - 2025-09-10

### Added

- Version bump to 0.1.1

### Fixed

- **WASM Compatibility**: Implemented platform-specific imports to support WebAssembly runtime
- **Conditional Dependencies**: Added platform-aware storage initialization for Web/WASM platforms
- **Removed dart:io Dependencies**: Eliminated WASM-incompatible imports for web compatibility

### Technical Changes

- Added platform-specific implementations (io.dart, web.dart, stub.dart)
- Implemented conditional imports for Hive storage backends
- Maintained full functionality across all platforms (Android, iOS, macOS, Windows, Linux, Web, WASM)

## [0.1.0] - 2024-09-10 - Initial Release### 📦 Dependencies

- `hive: ^2.2.3` - High-perf### 🔒 Security Features

- **AES Encryption**: Industry-standard encryption for sensitive dataance NoSQL databasease

### 🚀 Core Features

- **High-Performance Caching** with Hive NoSQL storage backend
- **Clean Architecture** following Domain-Driven Design principles
- **Multiple User Levels**: Beginner, Intermediate, Advanced, Expert configurations
- **Flexible Expiration Management**: Time-based, DateTime-based, and natural boundaries
- **Security Features**: Optional AES encryption for sensitive data
- **HTTP Client Integration** with Dio and automatic response caching
- **Background Cleanup** with automatic expired entry removal
- **Multi-Platform Support**: iOS, Android, Web, Windows, macOS, Linux

### 🎯 User Level System

- **Beginner Level**: Simple operations with automatic configuration
- **Intermediate Level**: Batch operations and optional encryption
- **Advanced Level**: Custom policies and real-time monitoring
- **Expert Level**: Full customization and enterprise-grade features

### 🕒 Advanced Expiration Management

- **Time-Based Methods**: `putForMinutes()`, `putForHours()`, `putForDays()`
- **Natural Boundaries**: `putUntilEndOfDay()`, `putUntilEndOfWeek()`, `putUntilEndOfMonth()`
- **Custom Expiration**: `putWithExpirationTime()`, `putWithDuration()`
- **Real-Time Monitoring**: `getEntryInfo()`, `getRemainingTime()`, `extendExpiration()`
- **Permanent Storage**: `putPermanent()` for data without expiration

### 🏗️ Architecture Components

- **Domain Layer**: Entities, repositories, and use cases
- **Data Layer**: Hive data source and repository implementations
- **Application Layer**: Providers and dependency injection
- **Utils Layer**: Encryption and background cleanup utilities

### 📦 Dependencies

- `hive: ^2.2.3` - High-performance NoSQL database
- `hive_flutter: ^1.1.0` - Flutter integration for Hive
- `dio: ^5.7.0` - Powerful HTTP client for API requests
- `encrypt: ^5.0.3` - AES encryption for data security
- `flutter_riverpod: ^2.6.1` - State management and dependency injection

### 🔧 API Features

**Core Cache Operations:**

- `put()` / `get()` - Basic cache operations with full customization
- `exists()` - Check cache key existence and validity
- `delete()` / `clear()` - Remove specific entries or clear all cache
- `getJson()` / `getBytes()` - Network request caching with automatic storage

**Advanced Cache Management:**

- Custom `CachePolicy` with flexible expiration and encryption
- `CacheEntryInfo` for detailed cache status monitoring
- Background cleanup and memory optimization
- Batch operations for efficient bulk processing

**Factory Constructors:**

- `CacheManagerLite.small()` - For lightweight applications (10-25MB)
- `CacheManagerLite.medium()` - For standard applications (25-75MB)
- `CacheManagerLite.large()` - For enterprise applications (75-200MB+)
- `CacheManagerLite.enterprise()` - For high-security applications (200MB+)

### 🌐 Internationalization

- **Multi-Language Documentation**: English, Thai, Chinese, Myanmar, Singapore Malay, Lao
- **Comprehensive Examples**: Available in multiple languages
- **Cultural Adaptation**: Examples tailored for different markets

### 🧪 Examples and Testing

- **Basic Caching**: Simple put/get operations
- **Network Caching**: HTTP request caching with Dio integration
- **Encrypted Storage**: Secure data storage examples
- **Real-Time Monitoring**: Live cache status tracking
- **Gaming Applications**: Tournament and player data caching
- **E-commerce Applications**: Product and cart data management
- **Enterprise Security**: Banking and medical data examples

### 🔒 Security Features

- **AES Encryption**: Industry-standard encryption for sensitive data
- **Key Management**: Flexible encryption key handling
- **Data Integrity**: Built-in validation and error handling
- **Secure Defaults**: Safe configuration options for all user levels
