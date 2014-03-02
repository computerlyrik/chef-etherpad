ld Status](https://travis-ci.org/computerlyrik/chef-etherpad.png?branch=master)](https://tr
avis-ci.org/computerlyrik/chef-etherpad)

etherpad Cookbook
======================

Code repo: https://github.com/computerlyrik/chef-etherpad

#### etherpad::default
installs ol' fat etherpad

#### etherpad::lite
installs newer etherpad-lite

TODO:
* implement etherpad::default
* fix fedora, centos
* attributize and template settings.json

Requirements
------------
#### recipes
- `nodejs` - etherpad-lite runs on javascript

Attributes
----------
TODO: Add attributes

e.g.
#### etherpad::default
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
#### etherpad::lite
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
TODO: (optional) If this is a public cookbook, detail the process for contributing. If this is a private cookbook, remove this section.

e.g.
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write you change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors: TODO: List authors
