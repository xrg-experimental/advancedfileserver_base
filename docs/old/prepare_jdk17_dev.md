Since you have access to the `/usr/lib/jvm` directory and want to use OpenJDK-17, here are the steps to add it:

1. You can download OpenJDK 17 from the official adoptium site. For your architectures:

For x86_64:
```bash
wget https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.10%2B7/OpenJDK17U-jdk_x64_linux_hotspot_17.0.10_7.tar.gz
```

For arm64:
```bash
wget https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.10%2B7/OpenJDK17U-jdk_aarch64_linux_hotspot_17.0.10_7.tar.gz
```

2. Extract it to the JVM directory:
```bash
# For x86_64
tar xzf OpenJDK17U-jdk_x64_linux_hotspot_17.0.10_7.tar.gz
mv jdk-17.0.10+7 /usr/lib/jvm/java-17-openjdk

# For arm64
tar xzf OpenJDK17U-jdk_aarch64_linux_hotspot_17.0.10_7.tar.gz
mv jdk-17.0.10+7 /usr/lib/jvm/java-17-openjdk
```

3. Set up your environment variables:
```bash
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk
export PATH=$JAVA_HOME/bin:$PATH
```

4. Verify the installation:
```bash
java -version
javac -version
```

To make these settings permanent, you can add them to your `.bashrc` or create a script in your development environment:

```bash
# Create a script like 'setjava17.sh'
cat > setjava17.sh << 'EOF'
#!/bin/bash
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk
export PATH=$JAVA_HOME/bin:$PATH
EOF

# Make it executable
chmod +x setjava17.sh

# Source it when needed
source setjava17.sh
```

Would you like me to explain any part in more detail or help with something specific about the Java 17 setup?