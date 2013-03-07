etherpad-lite Cookbook
======================

#### etherpad-lite::default
installs etherpad-lite

Requirements
------------
#### recipes
- `nodejs` - etherpad-lite runs on javascript
- `postgres` - we use postgres

Attributes
----------
TODO: Add attributes

e.g.
#### etherpad-lite::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['etherpad-lite']['bacon']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>

Usage
-----
#### etherpad-lite::default
TODO: Write usage instructions for each cookbook.

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
