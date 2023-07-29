# ChangeLog

## 1.0.0 - 2023-07-29

No breaking change with last versions.

### Added

- Create package.json file, for project infos and simplify versionning with npm version.

### Removed

- Remove .drone.yml because is not used. Deploying manually.

## 0.2.8 - 2023-07-28

### Fixed

- Remove the quotes from the `BACKUP_CRON_TIME` variable. Sometimes you will
  need to add quotes so that the "\*" is not interpreted by bash.
