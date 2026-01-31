# Mono Release Monitoring

This workflow automatically monitors the [WineHQ Mono GitLab repository](https://gitlab.winehq.org/mono/mono) for new releases and creates GitHub issues when new versions are detected.

## How It Works

1. **Scheduled Execution**: The workflow runs weekly every Monday at 9:00 AM UTC
2. **RSS Feed Monitoring**: Fetches the releases feed from `https://gitlab.winehq.org/mono/mono/-/releases.atom`
3. **Duplicate Prevention**: Maintains a list of notified releases in `.github/notified-releases/releases.txt`
4. **Issue Creation**: Creates a GitHub issue for each new release with configurable title, body, and labels
5. **State Persistence**: Commits the updated tracking file to the repository to maintain state between runs

## Configuration

All configuration is done within the workflow file at `.github/workflows/check-releases.yml`. No secrets or variables are required.

### Customizing the Schedule

To change the schedule, edit the `cron` expression in the workflow:

```yaml
on:
  schedule:
    - cron: '0 9 * * 1'  # Every Monday at 9:00 AM UTC
```

[Cron expression syntax reference](https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows#schedule)

### Customizing Issue Messages

Edit the following environment variables in the workflow file:

- **ISSUE_TITLE_TEMPLATE**: Template for the issue title
  - Use `{version}` placeholder for the release version
  - Example: `"New Mono Release: {version}"`

- **ISSUE_BODY_TEMPLATE**: Template for the issue body
  - Available placeholders: `{version}`, `{date}`, `{url}`
  - Supports multi-line markdown

Example:
```yaml
ISSUE_TITLE_TEMPLATE: "New Mono Release: {version}"
ISSUE_BODY_TEMPLATE: |
  A new release of Mono has been detected from the WineHQ GitLab repository.
  
  **Release Version:** {version}
  **Release Date:** {date}
  **Release URL:** {url}
  
  Please review and consider updating the Dockerfile to support this new version.
```

### Customizing Issue Labels

Edit the `ISSUE_LABELS` environment variable with comma-separated label names:

```yaml
ISSUE_LABELS: "enhancement,upstream-release"
```

**Note**: Labels must already exist in your repository. You can:
- Create them manually via Repository Settings → Labels
- Run the setup script: `.github/scripts/setup-labels.sh` (requires `gh` CLI authentication)

### Configuring Maximum Releases

To prevent overwhelming the system if many releases accumulate, you can configure the maximum number of releases to process in a single run:

```yaml
MAX_RELEASES: "20"
```

This limits the workflow to processing the 20 most recent releases from the RSS feed. If more releases exist, they will be processed in subsequent runs.

## Manual Execution

The workflow can be triggered manually via the Actions tab:

1. Go to Actions → Check for New Mono Releases
2. Click "Run workflow"
3. Select the branch and click "Run workflow"

## Troubleshooting

### No Issues Being Created

1. Check that the RSS feed is accessible: `https://gitlab.winehq.org/mono/mono/-/releases.atom`
2. Review the workflow logs in the Actions tab
3. Verify that the labels specified in `ISSUE_LABELS` exist in your repository
4. Ensure the workflow has the required permissions (already configured in the workflow file)

### Duplicate Issues

The workflow maintains state in `.github/notified-releases/releases.txt`. If this file is deleted or rolled back, duplicate issues may be created. To prevent duplicates:

1. Do not manually edit or delete the tracking file
2. Do not force-push changes that remove the tracking file
3. If you need to reset the state, manually populate the file with existing release titles

### Testing the Workflow

To test without waiting for the schedule:

1. Use the manual trigger option described above
2. Or temporarily modify the schedule to run more frequently
3. Check the Actions tab for execution logs

## Permissions

The workflow requires the following permissions (already configured):

- `contents: write` - To commit the tracking file
- `issues: write` - To create issues

These are automatically provided via the `GITHUB_TOKEN`.
