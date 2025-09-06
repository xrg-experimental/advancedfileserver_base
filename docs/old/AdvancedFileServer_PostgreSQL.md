# Database Integration Guide for AdvancedFileServer

## Current SQLite Limitations
1. **ALTER TABLE Restrictions**
   - Cannot add constraints to existing columns
   - Limited support for schema modifications
   - No proper foreign key modifications
   - Schema migrations become complex

## Alternative Solutions Analysis

### Option 2: PostgreSQL from Synology
#### Advantages
- More advanced features than MySQL
- Better JSON support
- More strict SQL compliance
- Advanced indexing options

#### Integration Approach
```bash
# Package dependencies in INFO
dependencies="PostgreSQL"
```

#### Implementation Steps
Similar to MySQL but with PostgreSQL-specific commands:
```bash
#!/bin/bash
# preinst

# Check PostgreSQL
if ! synoservice --status postgresql | grep -q running; then
    synoservice --start postgresql
    sleep 5
    
    if ! synoservice --status postgresql | grep -q running; then
        echo "PostgreSQL is required but not running."
        exit 1
    fi
fi

# Setup database and user
su - postgres -c "psql <<EOF
CREATE DATABASE advancedfileserver;
CREATE USER afs_user WITH ENCRYPTED PASSWORD '${GENERATED_PASSWORD}';
GRANT ALL PRIVILEGES ON DATABASE advancedfileserver TO afs_user;
EOF"
```

## Recommended Approach: PostgreSQL

### Rationale
1. Better schema migration support
2. Superior JSON handling for future features
3. More advanced features if needed later
4. Better concurrent performance
5. Stricter SQL compliance

### Implementation Details

1. **Package Configuration**
```yaml
# INFO file
maintainer: "Development Team"
arch: "x86_64"
firmware: "7.0-40000"
dependencies: "PostgreSQL"
startable: "yes"
description: "Advanced File Server with PostgreSQL backend"
```

2. **Database Security**
```java
// PasswordGenerator.java
public class PasswordGenerator {
    public static String generateSecurePassword() {
        // Generate strong random password
        return SecureRandom.generatePassword(32);
    }
}
```

3. **Installation Flow**
```bash
#!/bin/bash
# postinst

# Generate secure password
DB_PASSWORD=$(generate_secure_password)

# Store password securely
echo "db.password=${DB_PASSWORD}" > "${SYNOPKG_PKGDEST}/etc/database.properties"
chmod 600 "${SYNOPKG_PKGDEST}/etc/database.properties"

# Setup database
setup_postgresql_database "${DB_PASSWORD}"
```

4. **Application Properties**
```properties
# application.properties
spring.datasource.url=jdbc:postgresql://localhost:5432/advancedfileserver
spring.datasource.username=afs_user
spring.datasource.password=${DB_PASSWORD}
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.PostgreSQLDialect
spring.jpa.hibernate.ddl-auto=validate
spring.flyway.enabled=true
spring.flyway.locations=classpath:db/migration
```

5. **Schema Migration**
```sql
-- V1__initial_schema.sql
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    -- Additional fields
    CONSTRAINT proper_username CHECK (username ~ '^[a-zA-Z0-9_-]+$')
);

-- Additional tables with proper constraints
```

6. **Error Handling**
```java
@ControllerAdvice
public class DatabaseExceptionHandler {
    @ExceptionHandler(DataIntegrityViolationException.class)
    public ResponseEntity<ErrorResponse> handleDbError(DataIntegrityViolationException ex) {
        // Handle database errors gracefully
        return ResponseEntity.status(500)
            .body(new ErrorResponse("Database error occurred"));
    }
}
```

### Backup Integration
```bash
# Backup script
#!/bin/bash
backup_db() {
    pg_dump -U afs_user advancedfileserver > "${BACKUP_DIR}/db_backup_$(date +%Y%m%d).sql"
}
```
