# Changelog
## Version 2
### 2.0.2
* Update Oj to 3.11
* Fix some documentation mistakes
* Fix unclosed parentheses in MojangError message
* Fix NoMethodError when running `Mojang.name_history` on an invalid uuid
* Fix NameErrors and undefined method errors in `Mojang.userid`

### 2.0.1
* Update Oj to 3.10

### 2.0.0
* Update Oj to 3.9
* Remove `Mojang.username` as this is no longer possible with the Mojang API
* Remove `Mojang.has_paid?` as this is no longer available with the Mojang API.
* Fix `Mojang.userid` when used on users who have changed their names in the past. This fix will cause a slight hit to the performance of the function.

## Version 1
### 1.0.3
* Update Oj to 3.8

### 1.0.2
* Update Oj

### 1.0.1
* Add runtime dependencies to gemspec.

### 1.0.0
* Initial release.
