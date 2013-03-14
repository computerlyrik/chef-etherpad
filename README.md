etherpad-lite Cookbook
======================

#### etherpad-lite::default
installs etherpad-lite

Requirements
------------
#### cookbooks
- `nodejs` - etherpad-lite runs on javascript
- `postgresql` - we use postgres
- `npm` - pg gem needs to be installed
- `nginx` - Might not be the optimal way to run it

Attributes
----------

The following attributes should be set based on your specific deployment, see the
`attributes/default.rb` file for default values. All values should be strings unless otherwise specified.

* `node['etherpad-lite']['title']` - Name your instance!
* `node['etherpad-lite']['favicon_url']` - favicon_url favicon default name, alternatively, set up a fully specified Url to your own favicon
* `node['etherpad-lite']['ip_address']` - IP address to bind
* `node['etherpad-lite']['port_number']` - (number) port number to bind
* `node['etherpad-lite']['ssl_enabled']` - (boolean) make sure to have the minimum and correct file access permissions set so that the Etherpad server can access them
* `node['etherpad-lite']['ssl_key_path']` - ssl key path
* `node['etherpad-lite']['ssl_cert_path']` - ssl cert path
* `node['etherpad-lite']['db_type']` - postgres, sqlite or mysql
* `node['etherpad-lite']['db_user']` - db user
* `node['etherpad-lite']['db_host']` - db host
* `node['etherpad-lite']['db_password']` - db password
* `node['etherpad-lite']['db_name']` - db name
* `node['etherpad-lite']['default_text']` - the default text of a pad
* `node['etherpad-lite']['require_session']` - (boolean) Users must have a session to access pads. This effectively allows only group pads to be accessed.
* `node['etherpad-lite']['edit_only']` -  (boolean) Users may edit pads but not create new ones. Pad creation is only via the API. This applies both to group pads and regular pads. 
* `node['etherpad-lite']['minify']` - if true, all css & js will be minified before sending to the client. This will improve the loading performance massivly, but makes it impossible to debug the javascript/css
* `node['etherpad-lite']['max_age']` - How long may clients use served javascript code (in seconds)? Without versioning this may cause problems during deployment. Set to 0 to disable caching
* `node['etherpad-lite']['abiword_path']` - This is the path to the Abiword executable. Setting it to null, disables abiword. Abiword is needed to advanced import/export features of pads
* `node['etherpad-lite']['require_authentication']` - This setting is used if you require authentication of all users. Note: /admin always requires authentication.
* `node['etherpad-lite']['require_authorization']` - Require authorization by a module, or a user with is_admin set, see below.
* `node['etherpad-lite']['admin_enabled']` - Enable the admin interface
* `node['etherpad-lite']['admin_password']` - Password for "admin" user.
* `node['etherpad-lite']['log_level']` - The log level we are using, can be: DEBUG, INFO, WARN, ERROR
* `node['etherpad-lite']['service_user']` - user to run etherpad
* `node['etherpad-lite']['service_user_gid']` - group to run etherpad
* `node['etherpad-lite']['service_user_home']`- home dir
* `node['etherpad-lite']['etherpad_git_repo_url']` = set this to the git repo of your fork of etherpad-lite, or leave as default
* `node['etherpad-lite']['etherpad_api_key']` = sets the API key for the HTTP API (APIKEY.txt), if you leave it blank it will be generated for you by the app on first launch
* `node['etherpad-lite']['service_name']` = Name of service
* `node['etherpad-lite']['logs_dir']` = Path to logs directory
* `node['etherpad-lite']['domain']` = Domain where it is running

Usage
-----
#### etherpad-lite::default

Override any defaults and then include the recipe in your run list or cookbook.

e.g.
Just include `etherpad-lite` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[etherpad-lite]"
  ]
}
```

Contributing
------------

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------

License: Apache 2.0

Authors: 

* OpenWatch FPC
* computerlyrik original version (https://github.com/computerlyrik/chef-etherpad)
