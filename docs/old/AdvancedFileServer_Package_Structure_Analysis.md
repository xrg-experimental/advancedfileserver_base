# AdvancedFileServer Package Structure Analysis

## Option 1: Single Combined Package
### Advantages
1. **Simpler Installation**
   - Single package to install and manage
   - Guaranteed version compatibility
   - One-step upgrade process
   - Single service management entry

2. **Resource Efficiency**
   - Shared JRE instance
   - Combined logging infrastructure
   - Single configuration management
   - Unified package permissions

3. **Easier Integration**
   - Direct communication between frontend and backend
   - Shared session management
   - Simplified CORS configuration
   - Integrated error handling

4. **User Experience**
   - One-click installation
   - Single entry in Package Center
   - Unified version numbering
   - Consistent upgrade path

### Disadvantages
1. **Package Size**
   - Larger single download
   - More storage space per installation
   - Longer initial installation time

2. **Update Frequency**
   - Must update entire package for any change
   - Larger upgrade downloads
   - Both components must be versioned together

## Option 2: Split Packages
### Advantages
1. **Independent Updates**
   - Can update UI without backend changes
   - Smaller individual updates
   - More frequent UI improvements possible
   - Selective component upgrades

2. **Resource Management**
   - Optional frontend installation
   - Smaller individual footprints
   - Separate resource allocation

3. **Development Workflow**
   - Independent development cycles
   - Separate version management
   - Easier component testing
   - Clear separation of concerns

### Disadvantages
1. **Complexity**
   - Complex dependency management
   - Version compatibility challenges
   - Multiple service configurations
   - Additional error scenarios

2. **User Experience**
   - Multiple installation steps
   - More complex troubleshooting
   - Multiple Package Center entries
   - Potential version mismatches

## Recommendation
**Recommend Option 1: Single Combined Package** for the following reasons:

1. **Synology Package Best Practices**
   - Synology's ecosystem favors integrated packages
   - Better integration with Package Center
   - Simplified management for users
   - Consistent with most Synology applications

2. **Implementation Advantages**
```plaintext
AdvancedFileServer/
├── package/
│   ├── opt/
│   │   └── advancedfileserver/
│   │       ├── lib/          # JRE and backend dependencies
│   │       ├── backend/      # Spring Boot application
│   │       └── frontend/     # Angular static files
│   ├── ui/                   # DSM UI integration
│   └── var/
│       └── log/             # Combined logging
├── conf/                    # Single configuration directory
└── scripts/
    └── start-stop-status   # Single service management
```

3. **Security Benefits**
   - Single security context
   - Unified permission model
   - Simplified firewall rules
   - Integrated authentication

4. **Maintenance Benefits**
   - Single backup configuration
   - One set of logs to monitor
   - Unified troubleshooting
   - Consistent deployment process

## Implementation Strategy

1. **Package Structure**
```bash
# Package identifier
PACKAGE="AdvancedFileServer"
VERSION="1.0.0"
ARCHITECTURE="x86_64"

# Combined service name
SERVICE_NAME="pkguser-advancedfileserver"

# Unified configuration
CONFIG_DIR="/var/packages/advancedfileserver/conf"
```

2. **Version Management**
```json
{
  "package_version": "1.0.0",
  "backend_version": "1.0.0",
  "frontend_version": "1.0.0",
  "min_dsm_version": "7.0-40000"
}
```

3. **Resource Management**
```properties
# Combined resource allocation
java.heap.size=512m
frontend.cache.size=128m
maximum.file.uploads=1000
```

4. **Update Process**
```bash
# Single update command
synopkg upgrade advancedfileserver

# Preserves both components' data
PRESERVE_PATHS="/var/packages/advancedfileserver/var"
```

## Future Considerations

1. **Component Updates**
   - Implement internal version checks
   - Support partial updates if needed
   - Maintain backward compatibility
   - Version migration paths

2. **Scaling**
   - Monitor package size growth
   - Implement efficient resource sharing
   - Optimize update process
   - Consider modular loading

3. **Integration**
   - Single integration point with DSM
   - Unified API documentation
   - Combined health monitoring
   - Integrated backup solution
