---
title: NetworkCommunicationEvents table in the Advanced hunting schema
description: Learn about network connection events you can query from the NetworkCommunicationEvents table of the Advanced hunting schema
keywords: advanced hunting, threat hunting, cyber threat hunting, search, query, telemetry, schema reference, kusto, table, column, data type, networkcommunicationevents, network connection, remote ip, local ip
search.product: eADQiWindows 10XVcnh
search.appverid: met150
ms.prod: w10
ms.mktglfcycl: deploy
ms.sitesec: library
ms.pagetype: security
ms.author: lomayor
author: lomayor
ms.localizationpriority: medium
manager: dansimp
audience: ITPro
ms.collection: M365-security-compliance 
ms.topic: article
ms.date: 10/08/2019
---

# NetworkCommunicationEvents

**Applies to:**

- [Microsoft Defender Advanced Threat Protection (Microsoft Defender ATP)](https://go.microsoft.com/fwlink/p/?linkid=2069559)

>Want to experience Microsoft Defender ATP? [Sign up for a free trial.](https://www.microsoft.com/microsoft-365/windows/microsoft-defender-atp?ocid=docs-wdatp-advancedhuntingref-abovefoldlink)

The NetworkCommunicationEvents table in the [Advanced hunting](advanced-hunting-overview.md) schema contains information about network connections and related events. Use this reference to construct queries that return information from the table.

For information on other tables in the Advanced hunting schema, see [the Advanced hunting schema reference](advanced-hunting-schema-reference.md).

| Column name | Data type | Description |
|-------------|-----------|-------------|
| EventTime | datetime | Date and time when the event was recorded |
| MachineId | string | Unique identifier for the machine in the service |
| ComputerName | string | Fully qualified domain name (FQDN) of the machine |
| ActionType | string | Type of activity that triggered the event |
| RemoteIP | string | IP address that was being connected to |
| RemotePort | int | TCP port on the remote device that was being connected to |
| RemoteUrl | string | URL or fully qualified domain name (FQDN) that was being connected to |
| LocalIP | string | IP address assigned to the local machine used during communication |
| LocalPort | int | TCP port on the local machine used during communication |
| Protocol | string | IP protocol used, whether TCP or UDP |
| LocalIPType | string | Type of IP address, for example Public, Private, Reserved, Loopback, Teredo, FourToSixMapping, and Broadcast |
| RemoteIPType | string | Type of IP address, for example Public, Private, Reserved, Loopback, Teredo, FourToSixMapping, and Broadcast |
| InitiatingProcessSHA1 | string | SHA-1 of the process (image file) that initiated the event |
| InitiatingProcessMD5 | string | MD5 hash of the process (image file) that initiated the event |
| InitiatingProcessFileName | string | Name of the process that initiated the event |
| InitiatingProcessId | int | Process ID (PID) of the process that initiated the event |
| InitiatingProcessCommandLine | string | Command line used to run the process that initiated the event |
| InitiatingProcessCreationTime | datetime | Date and time when the process that initiated the event was started |
| InitiatingProcessFolderPath | string | Folder containing the process (image file) that initiated the event |
| InitiatingProcessParentFileName | string | Name of the parent process that spawned the process responsible for the event |
| InitiatingProcessParentId | int | Process ID (PID) of the parent process that spawned the process responsible for the event |
| InitiatingProcessParentCreationTime | datetime | Date and time when the parent of the process responsible for the event was started |
| InitiatingProcessAccountDomain | string | Domain of the account that ran the process responsible for the event |
| InitiatingProcessAccountName | string | User name of the account that ran the process responsible for the event |
| InitiatingProcessAccountSid | string | Security Identifier (SID) of the account that ran the process responsible for the event |
| InitiatingProcessIntegrityLevel | string | Integrity level of the process that initiated the event. Windows assigns integrity levels to processes based on certain characteristics, such as if they were launched from an internet download. These integrity levels influence permissions to resources |
| InitiatingProcessTokenElevation | string | Token type indicating the presence or absence of User Access Control (UAC) privilege elevation applied to the process that initiated the event |
| ReportId | long | Event identifier based on a repeating counter. To identify unique events, this column must be used in conjunction with the ComputerName and EventTime columns |
| AppGuardContainerId | string | Identifier for the virtualized container used by Application Guard to isolate browser activity |

## Related topics
- [Advanced hunting overview](advanced-hunting-overview.md)
- [Learn the query language](advanced-hunting-query-language.md)
- [Understand the schema](advanced-hunting-schema-reference.md)