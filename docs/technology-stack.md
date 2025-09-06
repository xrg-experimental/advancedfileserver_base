# AdvancedFileServer Technology Stack and Bill of Materials

## Backend Stack

### Core Technology
- Java 17 LTS
- Spring Boot 3.2.x
- Spring Security 6.x

### Database
- PostgreSQL 15.x
- Spring Data JPA
- Hibernate ORM

### Security
- JWT Authentication
- Spring Security
- BCrypt Password Encoding

### API Documentation
- SpringDoc OpenAPI 2.3.x
- Swagger UI

### Testing
- JUnit 5
- Mockito
- Spring Boot Test
- H2 Database (for testing)

## Frontend Stack

### Core Technology
- Angular 18.2.0
- TypeScript 5.5.2
- Node.js 20.x LTS

### UI Components
- Angular Material 18.2.13
- Angular CDK 18.2.13

### Core Dependencies
- RxJS 7.8.0
- Zone.js 0.14.10

### Development Tools
- Angular CLI 18.2.12
- Angular DevKit 18.2.12
- Karma 6.4.0 (Testing)
- Jasmine 5.2.0 (Testing)

## Development & Build Tools

### Backend Build
- Maven 3.9.x
- Spring Boot Maven Plugin
- Maven Compiler Plugin (Java 17)

### Frontend Build
- npm/Node Package Manager
- Angular CLI
- TypeScript Compiler

### IDE Support
- IntelliJ IDEA configurations
- VSCode settings

## Integration & Deployment

### Synology Integration
- DSM 7.2+ API Support
- File Station API Integration
- Authentication API Integration

### Package Building
- Shell Scripts for package creation
- Synology Package Tools

## Version Compatibility Matrix

| Component              | Version       | Notes                           |
|-----------------------|---------------|--------------------------------|
| Java                  | 17            | LTS Version                    |
| Spring Boot           | 3.2.x         | Latest stable                  |
| PostgreSQL            | 15.x          | Production database            |
| Angular               | 18.2.0        | Frontend framework             |
| Node.js               | 20.x          | LTS Version                    |
| TypeScript            | 5.5.2         | Angular compatibility          |
| DSM                   | 7.2+          | Minimum supported version      |

## Installation Requirements

### Development Environment
1. JDK 17
2. Node.js 20.x LTS
3. PostgreSQL 15.x
4. Maven 3.9.x
5. Angular CLI 18.2.12
6. Git

### Production Environment
1. Synology DSM 7.2 or higher
2. x86_64 or ARM64 architecture
3. Minimum 1GB RAM for package
4. PostgreSQL database (included in package)
5. Java Runtime (bundled in package)

## Notes
- All frontend dependency versions are locked as specified in package.json
- Backend dependencies should be managed through Maven BOM
- Development tools versions are recommended minimums
- Package deployment includes bundled dependencies
