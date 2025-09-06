ExamplePackage

I have created my first package for a Synology NAS, the official example "ExamplePackage".  On manual install the installer asks for a password and a port. For what are these used?



The port and password fields in Synology packages serve a few purposes:

For the official "ExamplePackage" specifically, these fields are primarily demonstrating how package configuration works, but they don't have any functional purpose since it's just a template.

In real Synology packages, these fields are typically used for:

1. Port:
- Allows users to specify which network port the package's service will run on
- Helps avoid port conflicts with other services
- Lets users configure access through their firewall
- Often used for web interfaces or network services the package provides

2. Password:
- Used for basic authentication to access the package's services
- Can be used to set up initial admin credentials
- Provides a basic security layer for package configuration
- May be used to generate encryption keys or secure tokens

If you're developing your own package, you can use these fields to:
- Configure your service's listening port
- Set up initial security credentials
- Store configuration values that your package needs during runtime

Would you like me to explain more about how to implement these fields functionally in your own package?



I'll explain how to implement and use these configuration fields in a Synology package.

The configuration is primarily handled through two files:

1. In your `PACKAGE_DIR/INFO` file, you define the wizard fields:

```ini
package="YourPackage"
...
support_conf_folder="yes"
configure_cmd="configure.sh"
...
wizard_password="1234"   # Default password
wizard_port="8080"       # Default port
```

2. Create a configuration script (usually `configure.sh`):

```bash
#!/bin/sh

# Get the package installation path
PACKAGE_PATH="/var/packages/YourPackage"
INSTALL_PATH="${PACKAGE_PATH}/target"
CONFIG_PATH="${PACKAGE_PATH}/etc"

# These variables will contain the user input
# $wizard_password and $wizard_port are automatically set from the wizard
PASSWORD=$wizard_password
PORT=$wizard_port

# Create config directory if it doesn't exist
mkdir -p $CONFIG_PATH

# Save configuration to a file
cat > "${CONFIG_PATH}/config.json" << EOF
{
    "password": "${PASSWORD}",
    "port": ${PORT}
}
EOF

# You can also save individual files if preferred
echo "$PASSWORD" > "${CONFIG_PATH}/password"
echo "$PORT" > "${CONFIG_PATH}/port"

# Set proper permissions
chmod 600 "${CONFIG_PATH}/config.json"
```

3. Then in your package's main script (e.g., `start-stop-status`), you can use these values:

```bash
#!/bin/sh

# Source configuration
CONFIG_PATH="/var/packages/YourPackage/etc"
PORT=$(cat "${CONFIG_PATH}/port")
PASSWORD=$(cat "${CONFIG_PATH}/config.json" | grep -o '"port": [0-9]*' | awk '{print $2}')

case $1 in
    start)
        # Start your service using the configured port and password
        ### Example: start-service --port "$PORT" --password "$PASSWORD"
        ;;
    stop)
        # Stop your service
        ;;
    status)
        # Check service status
        ;;
esac
```

Some important points:
1. Always validate the input values in your configure script
2. Store sensitive data like passwords securely (proper permissions)
3. You can add custom validation to the wizard by using `wizard_validate="validate.sh"`
4. Configuration can be updated through the package's web interface if you implement one

Here's an example validation script (`validate.sh`):

```bash
#!/bin/sh

# Validate port number
if ! echo "$wizard_port" | grep -q '^[0-9]\+$' || [ "$wizard_port" -lt 1024 ] || [ "$wizard_port" -gt 65535 ]; then
    echo "Invalid port number. Must be between 1024 and 65535"
    exit 1
fi

# Validate password length
if [ ${#wizard_password} -lt 8 ]; then
    echo "Password must be at least 8 characters long"
    exit 1
fi

exit 0
```

Would you like me to explain any specific part in more detail or show you how to implement additional configuration options?


This file (`install_uifile.txt`) is a Synology package UI definition file that creates the installation wizard interface. It's written in a combination of JavaScript and Vue.js, and it's responsible for rendering the password and port input form during package installation.

Let's break down the key parts:

1. The file defines a Vue.js component that creates a form with three inputs:
    - New Password field
    - Confirm Password field
    - Port number field

2. Important validation rules:
    - Password must be at least 10 characters long
    - Port field is restricted to numbers only (`number-only` attribute)
    - The form validates these inputs before allowing the "Next" button to be enabled

3. The UI includes translations for two languages:
    - English (enu)
    - Traditional Chinese (cht)

4. Key UI labels are defined:
```javascript
ui: {
    db_new_password: "Password",
    db_confirm_password: "Confirm Password",
    invalid_user_password: "Password Invalid!! The minimum password length is 10 characters"
}
```

5. The component uses Synology's design system components:
    - `v-form`
    - `v-form-item`
    - `v-input`

6. The form's data is collected in the `getValues()` function which returns:
```javascript
{
    pkgwizard_new_root_password: password,
    pkgwizard_port: port
}
```

These values are what get passed to your package's configuration scripts (like `configure.sh`) as `$wizard_password` and `$wizard_port`.

This is a typical example of Synology's package installation UI system, which uses their custom JSON-P loader to render package configuration forms. The values entered here will be used to configure your package during installation.

Would you like me to explain any specific part in more detail, such as the validation logic or how to modify the form fields?
