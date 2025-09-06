# AdvancedFileServer Architecture Design

## 1. Introduction
AdvancedFileServer is a web-based file exchange application for Synology DSM 7.2.2
designed by SME to facilitate secure document exchange with customers, without involving 
third-party cloud storage providers. The system allows three types of users: 
External users, Users with accounts, and Administrators. 

## 2. User Roles and Permissions
### 2.1 External Users
- **Features**:
  - Access password-protected links to files/folders.
  - View and download multiple files within a shared folder.
  - Upload files to the shared folder.
  - Links have expiration dates.

### 2.2 Users with Account
- **Features**:
  - Self-register for an account (approval by administrators required).
  - Internal users are marked by administrators.
  - Only internal users can create shareable links.
  - Access folder structure similar to Windows Explorer.
  - Client separation by user group.

### 2.3 Administrators
- **Features**:
  - Approve or block users.
  - Create new user groups and base directories.
  - Configure external mail server and other system settings.

## 3. High-Level Architecture

### 3.1 Components
1. **Frontend (Angular)**
   - User interfaces for different types of users.
   - Secure upload and download mechanisms.
   - Link creation and management.
   
2. **Backend (Java Spring Boot)**
   - RESTful API service.
   - User authentication and authorization.
   - Business logic for file/folder sharing, uploads, and downloads.
   - Account management and approval workflows.
   - Link expiration handling.
   
3. **Storage Layer**
   - Synology NAS for file storage.
   - Data management and file operations.
   - Leveraging Synology APIs for integration.

### 3.2 Data Flow
1. **User Registration**
   - User submits registration form.
   - Backend processes and awaits administrator approval.
   - Approved users are notified via email.

2. **Link Creation (Internal Users)**
   - Internal user creates a password-protected link with an expiration date.
   - Link details are stored in the backend.
   - External user is notified with link details.

3. **File Upload/Download**
   - External user accesses the shared link.
   - Backend verifies link, password, and expiration status.
   - Allowed actions (upload/download) are performed via frontend, interfacing with the Synology NAS storage layer through backend APIs.

4. **Administrator Actions**
   - Administrators manage users, groups, and configuration settings through a dedicated interface.
   - Backend applies changes to user status and configurations.

## 4. Technical Stack

### 4.1 Frontend
- **Framework**: Angular
- **Authentication**: JWT-based authentication for users with accounts.
- **UX**: Responsive design for different devices.

### 4.2 Backend
- **Framework**: Spring Boot
- **Database**: PostgreSQL or MySQL for user and link management.
- **Security**: OAuth2/JWT for secure API access.
- **Email Service**: Integration with an external mail server.

### 4.3 Storage
- **Platform**: Synology NAS
- **APIs**: Synology File Station APIs for file operations.
- **Backup and Recovery**: Synology Hyper Backup for data protection.

## 5. Key Design Considerations
- **Scalability**: Designed to handle additional user groups as the company grows.
- **Security**: Strong encryption for stored data and secure communication channels (HTTPS).
- **User Experience**: Intuitive UI for all types of users.
- **Extendability**: Modular architecture to add new features with minimal impact.

## 6. Technology Workflow
1. **Frontend**: User actions (registration, login, file operations) trigger Angular services.
2. **Backend**: Spring Boot services process requests, interact with database and NAS storage.
3. **Database**: Stores user account information, link metadata, audit logs.
4. **Storage**: Synology NAS handles physical file storage and retrieval.

---

This document outlines the high-level structure and flow of the `AdvancedFileServer` application. Each component and flow mentioned here will be expanded into detailed specifications in subsequent stages.

