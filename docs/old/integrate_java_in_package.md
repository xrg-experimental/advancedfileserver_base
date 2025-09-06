Yes, you can include the JRE runtime in your package! Here's how to properly package a Java application with its own JRE for Synology:

1. First, modify your package `INFO` file to remove the JavaRuntime dependency since you'll be bundling your own:

```ini
package="YourJavaPackage"
version="1.0"
os_min_ver="7.0-40000"
description="Your Java package description"
maintainer="Your Name"
arch="x86_64 aarch64"  # Specify both architectures
startable="yes"
support_conf_folder="yes"
```

2. Structure your package directory to include the JRE:
```
YourPackage/
├── INFO
├── PACKAGE_ICON.PNG
├── conf/
├── scripts/
│   ├── start-stop-status
│   └── installer
└── package/
    └── target/
        ├── jre/            # Custom JRE directory
        │   ├── bin/
        │   ├── lib/
        │   └── ...
        └── lib/
            └── your-java-app.jar
```

3. Create a minimal JRE using `jlink` (significantly reduces size):

```bash
# From your development environment
$JAVA_HOME/bin/jlink \
  --add-modules java.base,java.logging,java.xml,java.sql,java.desktop \
  --strip-debug \
  --no-man-pages \
  --no-header-files \
  --compress=2 \
  --output minimal-jre
```

4. Modify your start-stop-status script to use the bundled JRE:

```bash
#!/bin/sh

# Package
PACKAGE="YourPackage"
DNAME="Your Package Name"

# Others
INSTALL_DIR="/var/packages/${PACKAGE}/target"
JAR_FILE="${INSTALL_DIR}/lib/your-java-app.jar"
JRE_PATH="${INSTALL_DIR}/jre"
PID_FILE="/var/run/${PACKAGE}.pid"

start_daemon() {
    if [ -f ${PID_FILE} ] && kill -0 $(cat ${PID_FILE}) > /dev/null 2>&1; then
        return 0
    fi
    
    # Use bundled JRE
    ${JRE_PATH}/bin/java \
        -Duser.home=${INSTALL_DIR} \
        -jar ${JAR_FILE} > /dev/null 2>&1 &
    echo $! > ${PID_FILE}
}

stop_daemon() {
    if [ -f ${PID_FILE} ] && kill -0 $(cat ${PID_FILE}) > /dev/null 2>&1; then
        kill $(cat ${PID_FILE})
        rm -f ${PID_FILE}
    fi
}

daemon_status() {
    if [ -f ${PID_FILE} ] && kill -0 $(cat ${PID_FILE}) > /dev/null 2>&1; then
        return 0
    fi
    return 1
}

case $1 in
    start)
        if daemon_status; then
            echo ${DNAME} is already running
            exit 0
        else
            echo Starting ${DNAME} ...
            start_daemon
            exit $?
        fi
        ;;
    stop)
        if daemon_status; then
            echo Stopping ${DNAME} ...
            stop_daemon
            exit $?
        else
            echo ${DNAME} is not running
            exit 0
        fi
        ;;
    status)
        if daemon_status; then
            echo ${DNAME} is running
            exit 0
        else
            echo ${DNAME} is not running
            exit 1
        fi
        ;;
    *)
        exit 1
        ;;
esac
```

5. Include architecture-specific JREs in your build process:
```
YourPackage/
└── spk/
    ├── x86_64/
    │   └── jre/     # x86_64 JRE
    └── aarch64/
        └── jre/     # arm64 JRE
```

6. In your package build script, copy the appropriate JRE based on architecture:

```bash
#!/bin/sh

# Assuming $ARCH is set to either x86_64 or aarch64
PACKAGE_DIR="package/target"

# Copy architecture-specific JRE
cp -r "spk/${ARCH}/jre" "${PACKAGE_DIR}/"

# Continue with rest of package build...
```

This approach:
- Makes your package self-contained
- Works without root access
- Supports multiple architectures
- Minimizes package size by using jlink
- Follows Synology's security guidelines

Would you like me to explain any specific part in more detail or help with optimizing the JRE modules for your specific application?