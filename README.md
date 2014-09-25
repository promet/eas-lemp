# eas-lemp-cookbook

Base cookbook sets up users, enables sudo for specific groups. User information is stored in data bags. Installs postfix and configures rsyslog for log transport to logstash server - uses encryption for transport.

## Supported Platforms

Ubuntu 14.04 (may work on other versions of Ubuntu, but target release is 14.04).

## Attributes
```
```
## Usage
Although this cookbook can be deployed standalone, it is meant to be combined with other cookbooks such as eas-jenkins eas-lemp.

To bootstrap a jenkins server on AWS you may run a knife command like:

```
knife ec2  server create --flavor t2.micro --image  ami-864d84ee --associate-public-ip --subnet "SUBNET" --ssh-key KEYPAIR_NAME --run-list "recipe[eas-base::default],recipe[eas-lemp::default]" --security-group-ids SECURITY_GROUP_ID -x ubuntu -i PATH_TO_KEY_PAIR_FILE
```

## Security

Currently the certificate and the key necessary for the encrypted communication between the logstash host and the rsyslog clients are part of this repository. This is acceptable for testing, but will be changed for production. 
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
