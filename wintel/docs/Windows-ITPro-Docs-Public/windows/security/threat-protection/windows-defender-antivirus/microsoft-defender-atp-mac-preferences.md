---
title: Set preferences for Microsoft Defender ATP for Mac
ms.reviewer: 
description: Describes how to configure Microsoft Defender ATP for Mac in enterprises.
keywords: microsoft, defender, atp, mac, management, preferences, enterprise, intune, jamf, macos, mojave, high sierra, sierra
search.product: eADQiWindows 10XVcnh
search.appverid: met150
ms.prod: w10
ms.mktglfcycl: deploy
ms.sitesec: library
ms.pagetype: security
ms.author: dansimp
author: dansimp
ms.localizationpriority: medium
manager: dansimp
audience: ITPro
ms.collection: M365-security-compliance 
ms.topic: conceptual
---

# Set preferences for Microsoft Defender ATP for Mac

**Applies to:**

- [Microsoft Defender Advanced Threat Protection (Microsoft Defender ATP) for Mac](microsoft-defender-atp-mac.md)

>[!IMPORTANT]
>This topic contains instructions for how to set preferences for Microsoft Defender ATP for Mac in enterprise environments. If you are interested in configuring the product on a device from the command-line, please refer to the [Resources](microsoft-defender-atp-mac-resources.md#configuring-from-the-command-line) page.

In enterprise environments, Microsoft Defender ATP for Mac can be managed through a configuration profile. This profile is deployed from management tool of your choice. Preferences managed by the enterprise take precedence over the ones set locally on the device. In other words, users in your enterprise are not able to change preferences that are set through this configuration profile.

This topic describes the structure of this profile (including a recommended profile that you can use to get started) and instructions for how to deploy the profile.

## Configuration profile structure

The configuration profile is a .plist file that consists of entries identified by a key (which denotes the name of the preference), followed by a value, which depends on the nature of the preference. Values can either be simple (such as a numerical value) or complex, such as a nested list of preferences.

>[!CAUTION]
>The layout of the configuration profile depends on the management console that you are using. The following sections contain examples of configuration profiles for JAMF and Intune.

The top level of the configuration profile includes product-wide preferences and entries for subareas of the product, which are explained in more detail in the next sections.

### Antivirus engine preferences

The *antivirusEngine* section of the configuration profile is used to manage the preferences of the antivirus component of the product.

|||
|:---|:---|
| **Domain** | com.microsoft.wdav |
| **Key** | antivirusEngine |
| **Data type** | Dictionary (nested preference) |
| **Comments** | See the following sections for a description of the dictionary contents. |

#### Enable / disable real-time protection

Whether real-time protection (scan files as they are accessed) is enabled or not.

|||
|:---|:---|
| **Domain** | com.microsoft.wdav |
| **Key** | enableRealTimeProtection |
| **Data type** | Boolean |
| **Possible values** | true (default) <br/> false |

#### Enable / disable passive mode

Whether the antivirus engine runs in passive mode or not. In passive mode:
- Real-time protection is turned off
- On-demand scanning is turned on
- Automatic threat remediation is turned off
- Security intelligence updates are turned on
- Status menu icon is hidden

|||
|:---|:---|
| **Domain** | com.microsoft.wdav |
| **Key** | passiveMode |
| **Data type** | Boolean |
| **Possible values** | false (default) <br/> true |
| **Comments** | Available in Microsoft Defender ATP version 100.67.60 or higher. |

#### Scan exclusions

Entities that have been excluded from the scan. Exclusions can be specified by full paths, extensions, or file names.

|||
|:---|:---|
| **Domain** | com.microsoft.wdav |
| **Key** | exclusions |
| **Data type** | Dictionary (nested preference) |
| **Comments** | See the following sections for a description of the dictionary contents. |

**Type of exclusion**

Specifies the type of content excluded from the scan.

|||
|:---|:---|
| **Domain** | com.microsoft.wdav |
| **Key** | $type |
| **Data type** | String |
| **Possible values** | excludedPath <br/> excludedFileExtension <br/> excludedFileName |

**Path to excluded content**

Used to exclude content from the scan by full file path.

|||
|:---|:---|
| **Domain** | com.microsoft.wdav |
| **Key** | path |
| **Data type** | String |
| **Possible values** | valid paths |
| **Comments** | Applicable only if *$type* is *excludedPath* |

**Path type (file / directory)**

Indicates if the *path* property refers to a file or directory. 

|||
|:---|:---|
| **Domain** | com.microsoft.wdav |
| **Key** | isDirectory |
| **Data type** | Boolean |
| **Possible values** | false (default) <br/> true |
| **Comments** | Applicable only if *$type* is *excludedPath* |

**File extension excluded from the scan**

Used to exclude content from the scan by file extension.

|||
|:---|:---|
| **Domain** | com.microsoft.wdav |
| **Key** | extension |
| **Data type** | String |
| **Possible values** | valid file extensions |
| **Comments** | Applicable only if *$type* is *excludedFileExtension* |

**Name of excluded content**

Used to exclude content from the scan by file name.

|||
|:---|:---|
| **Domain** | com.microsoft.wdav |
| **Key** | name |
| **Data type** | String |
| **Possible values** | any string |
| **Comments** | Applicable only if *$type* is *excludedFileName* |

#### Allowed threats

List of threats (identified by their name) that are not blocked by the product and are instead allowed to run.

|||
|:---|:---|
| **Domain** | com.microsoft.wdav |
| **Key** | allowedThreats |
| **Data type** | Array of strings |

#### Threat type settings

The *threatTypeSettings* preference in the antivirus engine is used to control how certain threat types are handled by the product.

|||
|:---|:---|
| **Domain** | com.microsoft.wdav |
| **Key** | threatTypeSettings |
| **Data type** | Dictionary (nested preference) |
| **Comments** | See the following sections for a description of the dictionary contents. |

**Threat type**

Type of the threat for which the behavior is configured.

|||
|:---|:---|
| **Domain** | com.microsoft.wdav |
| **Key** | key |
| **Data type** | String |
| **Possible values** | potentially_unwanted_application <br/> archive_bomb |

**Action to take**

Action to take when coming across a threat of the type specified in the preceding section. Can be:

- **Audit**: your device is not protected against this type of threat, but an entry about the threat is logged.
- **Block**: your device is protected against this type of threat and you are notified in the user interface and the security console.
- **Off**: your device is not protected against this type of threat and nothing is logged.

|||
|:---|:---|
| **Domain** | com.microsoft.wdav |
| **Key** | value |
| **Data type** | String |
| **Possible values** | audit (default) <br/> block <br/> off |

### Cloud delivered protection preferences

The *cloudService* entry in the configuration profile is used to configure the cloud driven protection feature of the product.

|||
|:---|:---|
| **Domain** | com.microsoft.wdav |
| **Key** | cloudService |
| **Data type** | Dictionary (nested preference) |
| **Comments** | See the following sections for a description of the dictionary contents. |

#### Enable / disable cloud delivered protection

Whether cloud delivered protection is enabled on the device or not. To improve the security of your services, we recommend keeping this feature turned on.

|||
|:---|:---|
| **Domain** | com.microsoft.wdav |
| **Key** | enabled |
| **Data type** | Boolean |
| **Possible values** | true (default) <br/> false |

#### Diagnostic collection level

Diagnostic data is used to keep Microsoft Defender ATP secure and up-to-date, detect, diagnose and fix problems, and also make product improvements. This setting determines the level of diagnostics sent by the product to Microsoft.

|||
|:---|:---|
| **Domain** | com.microsoft.wdav |
| **Key** | diagnosticLevel |
| **Data type** | String |
| **Possible values** | optional (default) <br/> required |

#### Enable / disable automatic sample submissions

Determines whether suspicious samples (that are likely to contain threats) are sent to Microsoft. You are prompted if the submitted file is likely to contain personal information.

|||
|:---|:---|
| **Domain** | com.microsoft.wdav |
| **Key** | automaticSampleSubmission |
| **Data type** | Boolean |
| **Possible values** | true (default) <br/> false |

### User interface preferences

The *userInterface* section of the configuration profile is used to manage the preferences of the user interface of the product.

|||
|:---|:---|
| **Domain** | com.microsoft.wdav |
| **Key** | userInterface |
| **Data type** | Dictionary (nested preference) |
| **Comments** | See the following sections for a description of the dictionary contents. |

#### Show / hide status menu icon

Whether the status menu icon (shown in the top-right corner of the screen) is hidden or not.

|||
|:---|:---|
| **Domain** | com.microsoft.wdav |
| **Key** | hideStatusMenuIcon |
| **Data type** | Boolean |
| **Possible values** | false (default) <br/> true |

## Recommended configuration profile

To get started, we recommend the following configuration profile for your enterprise to take advantage of all protection features that Microsoft Defender ATP provides.

The following configuration profile will:
- Enable real-time protection (RTP)
- Specify how the following threat types are handled:
  - **Potentially unwanted applications (PUA)** are blocked
  - **Archive bombs** (file with a high compression rate) are audited to the product logs
- Enable cloud delivered protection
- Enable automatic sample submission

### JAMF profile

```XML
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>antivirusEngine</key>
    <dict>
        <key>enableRealTimeProtection</key>
        <true/>
        <key>threatTypeSettings</key>
        <array>
            <dict>
                <key>key</key>
                <string>potentially_unwanted_application</string>
                <key>value</key>
                <string>block</string>
            </dict>
            <dict>
                <key>key</key>
                <string>archive_bomb</string>
                <key>value</key>
                <string>audit</string>
            </dict>
        </array>
    </dict>
    <key>cloudService</key>
    <dict>
        <key>enabled</key>
        <true/>
        <key>automaticSampleSubmission</key>
        <true/>
    </dict>
</dict>
</plist>
```

### Intune profile

```XML
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1">
    <dict>
        <key>PayloadUUID</key>
        <string>C4E6A782-0C8D-44AB-A025-EB893987A295</string>
        <key>PayloadType</key>
        <string>Configuration</string>
        <key>PayloadOrganization</key>
        <string>Microsoft</string>
        <key>PayloadIdentifier</key>
        <string>com.microsoft.wdav</string>
        <key>PayloadDisplayName</key>
        <string>Microsoft Defender ATP settings</string>
        <key>PayloadDescription</key>
        <string>Microsoft Defender ATP configuration settings</string>
        <key>PayloadVersion</key>
        <integer>1</integer>
        <key>PayloadEnabled</key>
        <true/>
        <key>PayloadRemovalDisallowed</key>
        <true/>
        <key>PayloadScope</key>
        <string>System</string>
        <key>PayloadContent</key>
        <array>
            <dict>
                <key>PayloadUUID</key>
                <string>99DBC2BC-3B3A-46A2-A413-C8F9BB9A7295</string>
                <key>PayloadType</key>
                <string>com.microsoft.wdav</string>
                <key>PayloadOrganization</key>
                <string>Microsoft</string>
                <key>PayloadIdentifier</key>
                <string>com.microsoft.wdav</string>
                <key>PayloadDisplayName</key>
                <string>Microsoft Defender ATP configuration settings</string>
                <key>PayloadDescription</key>
                <string/>
                <key>PayloadVersion</key>
                <integer>1</integer>
                <key>PayloadEnabled</key>
                <true/>
                <key>antivirusEngine</key>
                <dict>
                    <key>enableRealTimeProtection</key>
                    <true/>
                    <key>threatTypeSettings</key>
                    <array>
                        <dict>
                            <key>key</key>
                            <string>potentially_unwanted_application</string>
                            <key>value</key>
                            <string>block</string>
                        </dict>
                        <dict>
                            <key>key</key>
                            <string>archive_bomb</string>
                            <key>value</key>
                            <string>audit</string>
                        </dict>
                    </array>
                </dict>
                <key>cloudService</key>
                <dict>
                    <key>enabled</key>
                    <true/>
                    <key>automaticSampleSubmission</key>
                    <true/>
                </dict>
            </dict>
        </array>
    </dict>
</plist>
```

## Full configuration profile example

The following configuration profile contains entries for all settings described in this document and can be used for more advanced scenarios where you want more control over the product.

### JAMF profile

```XML
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>antivirusEngine</key>
    <dict>
        <key>enableRealTimeProtection</key>
        <true/>
        <key>passiveMode</key>
        <false/>
        <key>exclusions</key>
        <array>
            <dict>
                <key>$type</key>
                <string>excludedPath</string>
                <key>isDirectory</key>
                <false/>
                <key>path</key>
                <string>/var/log/system.log</string>
            </dict>
            <dict>
                <key>$type</key>
                <string>excludedPath</string>
                <key>isDirectory</key>
                <true/>
                <key>path</key>
                <string>/home</string>
            </dict>
            <dict>
                <key>$type</key>
                <string>excludedFileExtension</string>
                <key>extension</key>
                <string>pdf</string>
            </dict>
        </array>
        <key>allowedThreats</key>
        <array>
            <string>EICAR-Test-File (not a virus)</string>
        </array>
        <key>threatTypeSettings</key>
        <array>
            <dict>
                <key>key</key>
                <string>potentially_unwanted_application</string>
                <key>value</key>
                <string>block</string>
            </dict>
            <dict>
                <key>key</key>
                <string>archive_bomb</string>
                <key>value</key>
                <string>audit</string>
            </dict>
        </array>
    </dict>
    <key>cloudService</key>
    <dict>
        <key>enabled</key>
        <true/>
        <key>diagnosticLevel</key>
        <string>optional</string>
        <key>automaticSampleSubmission</key>
        <true/>
    </dict>
    <key>userInterface</key>
    <dict>
        <key>hideStatusMenuIcon</key>
        <false/>
    </dict>
</dict>
</plist>
```

### Intune profile

```XML
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1">
    <dict>
        <key>PayloadUUID</key>
        <string>C4E6A782-0C8D-44AB-A025-EB893987A295</string>
        <key>PayloadType</key>
        <string>Configuration</string>
        <key>PayloadOrganization</key>
        <string>Microsoft</string>
        <key>PayloadIdentifier</key>
        <string>C4E6A782-0C8D-44AB-A025-EB893987A295</string>
        <key>PayloadDisplayName</key>
        <string>Microsoft Defender ATP settings</string>
        <key>PayloadDescription</key>
        <string>Microsoft Defender ATP configuration settings</string>
        <key>PayloadVersion</key>
        <integer>1</integer>
        <key>PayloadEnabled</key>
        <true/>
        <key>PayloadRemovalDisallowed</key>
        <true/>
        <key>PayloadScope</key>
        <string>System</string>
        <key>PayloadContent</key>
        <array>
            <dict>
                <key>PayloadUUID</key>
                <string>99DBC2BC-3B3A-46A2-A413-C8F9BB9A7295</string>
                <key>PayloadType</key>
                <string>com.microsoft.wdav</string>
                <key>PayloadOrganization</key>
                <string>Microsoft</string>
                <key>PayloadIdentifier</key>
                <string>99DBC2BC-3B3A-46A2-A413-C8F9BB9A7295</string>
                <key>PayloadDisplayName</key>
                <string>Microsoft Defender ATP configuration settings</string>
                <key>PayloadDescription</key>
                <string/>
                <key>PayloadVersion</key>
                <integer>1</integer>
                <key>PayloadEnabled</key>
                <true/>
                <key>antivirusEngine</key>
                <dict>
                    <key>enableRealTimeProtection</key>
                    <true/>
                    <key>passiveMode</key>
                    <false/>
                    <key>exclusions</key>
                    <array>
                        <dict>
                            <key>$type</key>
                            <string>excludedPath</string>
                            <key>isDirectory</key>
                            <false/>
                            <key>path</key>
                            <string>/var/log/system.log</string>
                        </dict>
                        <dict>
                            <key>$type</key>
                            <string>excludedPath</string>
                            <key>isDirectory</key>
                            <true/>
                            <key>path</key>
                            <string>/home</string>
                        </dict>
                        <dict>
                            <key>$type</key>
                            <string>excludedFileExtension</string>
                            <key>extension</key>
                            <string>pdf</string>
                        </dict>
                    </array>
                    <key>allowedThreats</key>
                    <array>
                        <string>EICAR-Test-File (not a virus)</string>
                    </array>
                    <key>threatTypeSettings</key>
                    <array>
                        <dict>
                            <key>key</key>
                            <string>potentially_unwanted_application</string>
                            <key>value</key>
                            <string>block</string>
                        </dict>
                        <dict>
                            <key>key</key>
                            <string>archive_bomb</string>
                            <key>value</key>
                            <string>audit</string>
                        </dict>
                    </array>
                </dict>
                <key>cloudService</key>
                <dict>
                    <key>enabled</key>
                    <true/>
                    <key>diagnosticLevel</key>
                    <string>optional</string>
                    <key>automaticSampleSubmission</key>
                    <true/>
                </dict>
                <key>userInterface</key>
                <dict>
                    <key>hideStatusMenuIcon</key>
                    <false/>
                </dict>
            </dict>
        </array>
    </dict>
</plist>
```

## Configuration profile deployment

Once you've built the configuration profile for your enterprise, you can deploy it through the management console that your enterprise is using. The following sections provide instructions on how to deploy this profile using JAMF and Intune.

### JAMF deployment

From the JAMF console, open **Computers** > **Configuration Profiles**, navigate to the configuration profile you'd like to use, then select **Custom Settings**. Create an entry with *com.microsoft.wdav* as the preference domain and upload the .plist produced earlier.

>[!CAUTION]
>You must enter the correct preference domain (*com.microsoft.wdav*), otherwise the preferences will not be recognized by the product.

### Intune deployment

1. Open **Manage** > **Device configuration**. Select **Manage** > **Profiles** > **Create Profile**.

2. Choose a name for the profile. Change **Platform=macOS** to **Profile type=Custom**. Select Configure.

3. Save the .plist produced earlier as **com.microsoft.wdav.xml**.

4. Enter **com.microsoft.wdav** as the **custom configuration profile name**.

5. Open the configuration profile and upload **com.microsoft.wdav.xml**. This file was created in step 3.

6. Select **OK**.

7. Select **Manage** > **Assignments**. In the **Include** tab, select **Assign to All Users & All devices**.

>[!CAUTION]
>You must enter the correct custom configuration profile name, otherwise these preferences will not be recognized by the product.

## Resources

- [Configuration Profile Reference (Apple developer documentation)](https://developer.apple.com/business/documentation/Configuration-Profile-Reference.pdf)
