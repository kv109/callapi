### 0.9.1 (NEXT RELEASE)

- Remove Memoist dependency
- Instead of `call.response.data` `call.data` can be used

### 0.9

- Remove activesupport dependency
- URI pattern can be a `Symbol` (before only `String`s were accepted)
- Bugfix: #1
- Backward compatibility fix for `#api_path_prefix`
- Changelog added

### 0.8.3

- API path prefix taken from `Config.api_host` (no need to set `Config.api_path_prefix`)
- Added Ruby dependency (>= 2.0)
- Code Climate refactor

### 0.8.2

- Bugfix: Critical issue fix (undefined method `#api_path_prefix`)

### 0.8.1

- Dependencies
- Documentation update

### 0.8

- Initial release, after long internal usage
