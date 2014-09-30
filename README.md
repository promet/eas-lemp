# eas-lemp-cookbook

This cookbook sets up a generic LEMP (Linux Nginx Mysql Php) Stack and implements some generic settings. 

## Supported Platforms

Ubuntu 14.04 (may work on other versions of Ubuntu, but target release is 14.04).

## Attributes
PHP configuration parameter and default setting:

```
# php related
default['eas_lemp']['fpm_dir'] = '/etc/php5/fpm'
default['eas_lemp']['realpath_cache_size'] = '16k'
default['eas_lemp']['realpath_cache_ttl']	= '120'
default['eas_lemp']['expose_php']	= 'Off'
default['eas_lemp']['max_execution_time']	= '30'
default['eas_lemp']['max_input_time']	= '60'
default['eas_lemp']['max_input_nesting_level'] = '64'
default['eas_lemp']['memory_limit']	= '128M'
default['eas_lemp']['error_reporting'] = 'E_ALL & ~E_DEPRECATED'
default['eas_lemp']['display_errors']	= 'Off'
default['eas_lemp']['display_startup_errors']	= 'Off'
default['eas_lemp']['log_errors']	= 'On'
default['eas_lemp']['log_errors_max_len'] = '1024'
default['eas_lemp']['ignore_repeated_errors'] = 'Off'
default['eas_lemp']['ignore_repeated_source'] = 'Off'
default['eas_lemp']['safe_mode'] = 'Off'
default['eas_lemp']['sql_safe_mode'] = 'On'
default['eas_lemp']['allow_url_fopen'] = 'Off'
default['eas_lemp']['cgi_force_redirect'] = '1'
default['eas_lemp']['track_errors'] = 'Off'
default['eas_lemp']['xmlrpc_errors'] = '0'
default['eas_lemp']['xmlrpc_error_number'] = '0'
default['eas_lemp']['post_max_size'] = '8M'
default['eas_lemp']['magic_quotes_gpc'] = 'Off'
default['eas_lemp']['magic_quotes_runtime'] = 'Off'
default['eas_lemp']['magic_quotes_sybase'] = 'Off'
default['eas_lemp']['file_uploads']	= 'On'
default['eas_lemp']['upload_tmp_dir']	= ''
default['eas_lemp']['upload_max_filesize'] = '2M'
default['eas_lemp']['max_file_uploads'] = '20'
default['eas_lemp']['date_timezone'] = ''
default['eas_lemp']['date_default_latitude'] = '31.7667'
default['eas_lemp']['date_default_longitude']	= '35.2333'
default['eas_lemp']['date_sunrise_zenith'] = '90.583333'
default['eas_lemp']['date_sunset_zenith'] = '90.583333'
default['eas_lemp']['apc']['apc_rfc1867'] = '1'
default['eas_lemp']['apc']['apc_enabled'] = '1'
default['eas_lemp']['apc']['shm_segments'] = '1'
default['eas_lemp']['apc']['ttl'] = '3600'
default['eas_lemp']['apc']['user_ttl'] = '3600'
default['eas_lemp']['apc']['num_files_hint'] = '1024'
default['eas_lemp']['apc']['enable_cli'] = '0'
default['eas_lemp']['apc']['shm_size'] = '96'
```
Mysql attributes overwritten by eas-lemp:
```
normal['mysql']['server_root_password'] = 'easmysql'
normal['mysql']['server_repl_password'] = 'replpass'
normal['mysql']['server_debian_password'] = 'debianpass'
```
Nginx attributes overwritten by eas-lemp:
```
normal['nginx']['server_tokens'] = 'off'
normal['nginx']['default_site_enabled'] = false
normal['nginx']['keepalive_timeout'] = 15
normal['nginx']['proxy_read_timeout'] = 20
normal['nginx']['worker_connections'] = 5000
normal['nginx']['client_max_body_size'] = '50M'
```

## Usage
As it relies heavily on services provided by `eas-base` it is therefore included. 

To bootstrap a LEMP server on AWS you may run a knife command like:

```
knife ec2  server create --flavor t2.micro --image  ami-864d84ee --associate-public-ip --subnet "SUBNET" --ssh-key KEYPAIR_NAME --run-list "recipe[eas-lemp::default]" --security-group-ids SECURITY_GROUP_ID -x ubuntu -i PATH_TO_KEY_PAIR_FILE
```
 
### eas-lemp::default

Include `eas-lemp` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[eas-lemp::default]"
  ]
}
```

## License and Authors

Author:: opscale (<cookbooks@opscale.com>)
