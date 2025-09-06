# AdvancedFileServer Authentication Documentation

## Overview
The AdvancedFileServer implements a secure authentication system with support for Two-Factor Authentication (2FA). 
This document describes the authentication flow and API endpoints for frontend integration.

## Authentication Endpoints

### 1. Initial Login
**Endpoint:** `POST /auth/login`
**Purpose:** Initial user authentication with username and password

**Request Body:**
```json
{
    "username": "string",
    "password": "string"
}
```

**Responses:**
- **200 OK**: Authentication successful (no OTP required)
  ```json
  {
      "token": "string",
      "username": "string",
      "userType": "string",
      "refreshWindowStart": "number",
      "refreshWindowEnd": "number",
      "otpRequired": "boolean"
  }
  ```
- **201 OK**: OTP required (partial authentication)
  ```json
  {
      "username": "string",
      "userType": "string",
      "otpRequired": true
  }
  ```
- **401 Unauthorized**: Invalid credentials
- **400 Bad Request**: Invalid request format

### 2. OTP Verification
**Endpoint:** `POST /auth/otp-login`
**Purpose:** Complete authentication with OTP code

Authenticate administrators through Synology DSM with username, password and OTP code.
Other users may have activated OTP and will be authenticated locally.   

**Request Body:**
```json
{
    "username": "string",
    "password": "string",
    "otpCode": "string"
}
```

**Responses:**
- **200 OK**: Authentication successful
  ```json
  {
      "token": "string",
      "username": "string",
      "userType": "string",
      "refreshWindowStart": "number",
      "refreshWindowEnd": "number",
      "otpRequired": false
  }
  ```
- **401 Unauthorized**: Invalid OTP code or credentials
- **400 Bad Request**: Invalid request format

## Authentication Flow

1. Frontend calls `/auth/login` with username/password
2. If OTP is required:
   - Backend returns 201 with otpRequired=true
   - Frontend stores credentials temporarily
   - Frontend redirects to OTP page
   - User enters OTP code
   - Frontend calls `/auth/otp-login` with stored credentials + OTP
3. If OTP not required:
   - Backend returns JWT token and user info directly
   - Frontend stores token and redirects to dashboard

## Implementation Notes

### Frontend Requirements
1. Handle otpRequired flag in login response
2. Securely store credentials during OTP flow
3. Clear stored credentials after OTP verification
4. Store JWT token for subsequent API calls
5. Include token in Authorization header

### Security Considerations
1. Credentials only stored temporarily during OTP flow
2. OTP codes are time-based (TOTP)
3. JWT tokens include user info and expiration
4. Failed attempts are logged
5. Rate limiting on auth endpoints

## Error Handling
- Invalid credentials: 401 Unauthorized
- Invalid OTP: 401 Unauthorized
- Missing fields: 400 Bad Request
- Server errors: 500 Internal Server Error

## Session Management
- JWT tokens valid for configured period
- Token refresh window before expiration
- Refresh endpoint for new token
- Session revocation supported

## API Security
- HTTPS required in production
- JWT tokens in Authorization header
- Token blacklisting on logout
- Rate limiting on auth endpoints
