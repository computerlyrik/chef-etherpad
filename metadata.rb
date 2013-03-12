name             'etherpad-lite'
maintainer       'OpenWatch FPC'
maintainer_email 'chris@openwatch.net'
license          'Apache 2.0'
description      'Installs etherpad-lite'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.1'

depends         'nodejs'
depends         'postgresql'
depends         'npm'
depends         'nginx'

# Check README.md for attributes
