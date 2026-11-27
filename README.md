# cPanel to SmarterMail Email Migration Using IMAPSync

## Overview

This project documents the process of migrating email services from a cPanel mail server (old domain) to a SmarterMail mail server (new domain) using IMAPSync.

The migration process includes domain mail forwarding, bulk mailbox migration, email transition, and final decommissioning of the old mail service.

### Migration Example

- **Source:** `user@domain1.com`
- **Destination:** `user@domain2.com`
- **Source Server:** cPanel
- **Destination Server:** SmarterMail
- **Migration Tool:** IMAPSync

## Migration Steps

### 1. Prepare the New Mail Server

- Configure the new domain in SmarterMail.
- Create all required user mailboxes.
- Verify mailbox access and authentication.
- Configure DNS records for the new mail service.

### 2. Configure Old Domain Mail Forwarding

- Configure the old domain to forward incoming emails to the new mail server.
- Ensure incoming emails are delivered to the corresponding new-domain mailboxes.
- Verify mail delivery before starting migration.

### 3. Migrate Existing Emails Using IMAPSync

- Install and configure IMAPSync on the migration server.
- Prepare a list of source and destination mailbox credentials.
- Execute the Bash migration script.
- Monitor migration logs and identify failed mailboxes.
- Verify migrated emails, folders, and attachments.

### 4. Transition to the New Email Domain

- Ask users to configure their email clients with the new email addresses and server settings.
- Communicate the migration completion and provide necessary login instructions.
- Temporarily restrict outgoing email from the old mail server to prevent users from continuing to send emails using the old domain.
- Keep the old mail service available for incoming mail forwarding during the transition period.

### 5. Finalize Migration and Decommission Old Domain

After the transition period:

- Confirm that all users are using the new email domain.
- Verify that no important emails remain on the old server.
- Confirm that incoming and outgoing email services are working correctly.
- Remove the old domain forwarding configuration when no longer required.
- Decommission the old mail service and remove the old domain after final verification.

## Repository Contents

| File | Description |
|---|---|
| `migration.sh` | Bash script for automated mailbox migration using IMAPSync |
| `README.md` | Migration overview and implementation steps |

## Important Notes

- Always maintain a backup before migration.
- Keep the old mail server active during the transition period.
- Never upload real mailbox passwords or sensitive server information to GitHub.
- Test the migration with sample mailboxes before processing all users.
- Perform final verification before decommissioning the old mail service.

## Disclaimer

This project is intended for authorized email migration and infrastructure administration.
