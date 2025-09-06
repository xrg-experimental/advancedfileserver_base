# Aider Reference Guide - AdvancedFileServer Development

## Package Structure Reference
```
AdvancedFileServer/
├── conf/
│   └── resource
├── package/
│   ├── opt/
│   │   └── advancedfileserver/
│   ├── ui/
│   │   └── index.html
│   └── var/
│       └── log/
└── scripts/
    ├── postinst
    ├── preinst
    ├── start-stop-status
    └── preremove
```

## Standard Commands and Paths

### Package Commands
```bash
# Build package
./build-package.sh

# Install package on test system
synopkg install advancedfileserver.spk

# Start/stop service
synosystemctl start pkguser-advancedfileserver
synosystemctl stop pkguser-advancedfileserver

# View logs
tail -f /var/log/packages/advancedfileserver/app.log
```

### Development Paths
- Working Directory: `/volume1/@appstore/advancedfileserver`
- Config Directory: `/var/packages/advancedfileserver/conf`
- Log Directory: `/var/log/packages/advancedfileserver`
- Web UI Directory: `/var/packages/advancedfileserver/target/ui`

### Database
```sql
-- SQLite database location
/var/packages/advancedfileserver/var/advancedfileserver.db
```

## Spring Boot Configuration Standards
```properties
# Server configuration
server.port=8581
server.servlet.context-path=/webapi

# Logging configuration
logging.file.path=/var/log/packages/advancedfileserver
logging.file.name=${logging.file.path}/app.log
logging.level.root=INFO

# Database configuration
spring.datasource.url=jdbc:sqlite:/var/packages/advancedfileserver/var/advancedfileserver.db
```

## Package Info Template
```yaml
package: advancedfileserver
version: 1.0.0
maintainer: Development Team
arch: x86_64
firmware: 7.0-40000
startable: yes
support_conf_folder: yes
```

## Common DSM API Endpoints
```
# File Station API
/webapi/entry.cgi/FileStation/file_share
/webapi/entry.cgi/FileStation/create_folder
/webapi/entry.cgi/FileStation/rename
/webapi/entry.cgi/FileStation/delete

# Auth API
/webapi/auth.cgi/login
/webapi/auth.cgi/logout
```

## Testing Commands
```bash
# Run unit tests
mvm test

# Run integration tests
TBD

# Build and test package
TDB
```

## Security Standards
- All endpoints must be secured with JWT
- File access requires DSM permissions
- Passwords must be hashed using BCrypt
- HTTPS required for all communications

## Implementation Documentation Template
```markdown
## Feature: [Feature Name] - US-[Number]

### Implementation Details
- Key components implemented
- Design decisions
- Security considerations

### Configuration
```yaml
# Relevant configuration
```

### Testing Notes
- Test cases covered
- Special considerations

### Known Limitations
- Current limitations
- Future improvements
```
