Beanstalkd
========

An Ansible role for the installation of the Beanstalkd network work queue, http://kr.github.io/beanstalkd/

Requirements
------------

Currently only runs against Ubuntu hosts.

Role Variables
--------------

In the current version, you can specify the following variables:

| Name                                | Default             |                                                    |
|-------------------------------------|---------------------|----------------------------------------------------|
| beanstalkdPersistentStorageLocation | /var/lib/beanstalkd | The location to place beanstalkd's binlog          |
| beanstalkdListenAddress             | 0.0.0.0             | Address to listen for connections (all is 0.0.0.0) |
| beanstalkdListenPort                | 11300               | Port to listen on                                  |


Dependencies
------------

This package has no dependencies on modules not included with Ansible by default.

License
-------

MIT

Author Information
------------------

Created by Jason Johnson
https://www.twitter.com/jasonj
https://github.com/jasonj

Examples
--------

```
---
- name: Beanstalkd test
  hosts: all
  roles:
    - jasonj.beanstalkd
```
